-- MobileUIBagSwap.lua - Bag swap menu on hold (Phase 8)
--
-- Problem: stock right-click on a bag item only equips into a FREE bag slot.
-- When all 4 bag slots are occupied and full, right-clicking a bag item fails
-- with "This item cannot be equipped" — and the mobile layout hides the bags
-- bar, so there is no per-slot button to drag the bag onto either. The player
-- can never replace an old small bag with a new bigger one.
--
-- Fix: when a bag item is held (right-click, Artemis hold gesture) we own
-- the gesture and swap it into a chosen bag slot. With exactly one empty
-- bag slot the swap runs immediately; otherwise a small menu lists the
-- empty bag slots (name, size, free slots) and tapping one swaps there.
-- The swap is PickupContainerItem + PickupInventoryItem (the exchange),
-- with the old bag auto-placed back into the source slot.
--
-- Trigger scope (intentional): we always own the hold-of-bag gesture —
-- stock right-click never equips bags in this client (verified in-game:
-- "This item cannot be equipped" even with a free slot), so there is no
-- fast path to preserve. While a merchant is open we defer entirely (the
-- tap=sell wrapper owns bag clicks there — hold still sells, per its docs).
--
-- Taint safety: the stock container-item handler can reach the protected
-- UseContainerItem (right-click "Use:" items, e.g. hearthstone/potions), so
-- MobileUI code must never sit on that call stack. Every pass-through runs
-- through securecall() in a clean protected stack. The wrapper is installed
-- once and stays for the session; disabling the feature (MobileDB.bagSwap)
-- only turns interception off, so it stays robust against MobileUISell
-- wrapping/unwrapping the same global on merchant open/close.
--
-- Controls: default on. Toggle: /mui bagswap. Interface Options -> MobileUI
-- -> "Bag Swap Menu". Saved var: MobileDB.bagSwap.

local ADDON = "MobileUI"

MobileUIBagSwap = {}

-- Wrapper state (installed once at Apply, kept for the session)
local installed = false
local enabled   = false
local origClick -- the handler we replaced (stock, or whatever was current)

-- Menu state
local menu, menuTitle, clickCatcher
local menuRows = {}
local source   -- { container = containerID, slot = slotIndex } of the held bag

-- ============================================================================
-- Helpers
-- ============================================================================

-- Is the item in this container slot a bag? 3.3.5's GetItemInfo returns
-- class as a LOCALIZED STRING ("Container"), not the numeric id — so we
-- accept the string, the numeric id (some clients), and the locale-
-- independent equipSlot token ("INVTYPE_BAG") as three independent signals.
local function IsBagItem(container, slot)
    local link = GetContainerItemLink(container, slot)
    if not link then return false end
    local _, _, _, _, _, class, _, _, equipSlot = GetItemInfo(link)
    if not class then return false end
    return class == "Container" or class == 1 or equipSlot == "INVTYPE_BAG"
end

-- Per-slot state for the debug log: "1:0/16 2:3/16 ..." = free/slots per
-- bag slot. Used to diagnose why stock right-click equip fails.
local function BagSlotState()
    local parts = {}
    for i = 1, 4 do
        local slots = GetContainerNumSlots(i)
        local free = slots > 0 and select(1, GetContainerNumFreeSlots(i)) or 0
        table.insert(parts, string.format("%d:%d/%d", i, free, slots))
    end
    return table.concat(parts, " ")
end

-- Slot indices that are valid swap targets: an unequipped slot, or a slot
-- whose current bag is empty (this client refuses to swap a bag that has
-- items in it). Ascending order — the menu packs valid rows contiguously.
local function EmptyBagSlots()
    local slots = {}
    for i = 1, 4 do
        local name = GetBagName(i)
        local valid
        if name then
            local size = GetContainerNumSlots(i)
            local free = select(1, GetContainerNumFreeSlots(i)) or 0
            valid = free >= size
        else
            valid = true
        end
        if valid then table.insert(slots, i) end
    end
    return slots
end

-- ============================================================================
-- Menu
-- ============================================================================

local function HideMenu()
    if menu then menu:Hide() end
    if clickCatcher then clickCatcher:Hide() end
end

-- ============================================================================
-- Deferred container-frame reposition
-- ============================================================================
-- Equipping a bag makes the client re-layout the open container frames back
-- to their default (right-side) positions, leaving the item icons stranded at
-- the mobile column. Snap the frames back a moment after the swap so the
-- windows and their icons line up again.
local function LogFramePositions(tag)
    for i = 1, 5 do
        local f = _G["ContainerFrame" .. i]
        if f and f:IsShown() then
            local l, b = f:GetLeft(), f:GetBottom()
            local w = f:GetWidth()
            local ib = _G["ContainerFrame" .. i .. "Item1"]
            local il, ibt = -1, -1
            if ib then
                il, ibt = ib:GetLeft() or -1, ib:GetBottom() or -1
            end
            MobileUI_Debug(string.format(
                "BagSwap: %s CF%d left=%.0f bottom=%.0f w=%.0f item1 left=%.0f bottom=%.0f",
                tag, i, l or -1, b or -1, w or -1, il, ibt))
        end
    end
end

-- The client re-lays the container frames out (and closes the swapped
-- slot's window) on BAG_UPDATE events after a swap. This frame registers
-- BAG_UPDATE later than the client's frames, so our handler runs after
-- theirs in the same event pass: re-pin the frames to the mobile column
-- and re-open the swapped slot's window right there, before anything
-- renders — no flicker. A single late snap (1.2s) backstops anything that
-- happens outside a BAG_UPDATE.
local swapActiveUntil = 0
local reopenSlot -- target bag slot whose window was open at swap time
local bagEventFrame
local function OnBagUpdate()
    if GetTime() > swapActiveUntil then return end
    if not (MobileDB.layoutEnabled and MobileUILayout and MobileUILayout.RepositionContainerFrames) then return end
    MobileUILayout.RepositionContainerFrames()
    if reopenSlot and not IsBagOpen(reopenSlot) then
        OpenBag(reopenSlot)
        MobileUILayout.RepositionContainerFrames()
    end
end

local backstopFrame
local function ScheduleReposition(slotIndex, wasOpen)
    reopenSlot = wasOpen and slotIndex or nil
    swapActiveUntil = GetTime() + 2
    if not bagEventFrame then
        bagEventFrame = CreateFrame("Frame")
        bagEventFrame:RegisterEvent("BAG_UPDATE")
        bagEventFrame:SetScript("OnEvent", OnBagUpdate)
    end
    if not backstopFrame then
        backstopFrame = CreateFrame("Frame")
        backstopFrame:Hide()
        backstopFrame:SetScript("OnUpdate", function(self, elapsed)
            self.t = (self.t or 0) + elapsed
            if self.t >= 1.2 then
                self:Hide()
                self.t = nil
                if GetTime() <= swapActiveUntil then
                    OnBagUpdate()
                end
                LogFramePositions("pinned-final")
            end
        end)
    end
    backstopFrame.t = 0
    backstopFrame:Show()
end

local function SwapIntoSlot(slotIndex)
    HideMenu()
    if InCombatLockdown() then
        print("|cff00ccff[MobileUI]|r Can't swap bags in combat.")
        return
    end
    if not source then return end
    local c, s = source.container, source.slot
    local srcLink = GetContainerItemLink(c, s)
    local srcName = srcLink and select(1, GetItemInfo(srcLink)) or "?"
    MobileUI_Debug(string.format(
        "BagSwap: swap c=%d s=%d (%s) -> slot %d (%s)",
        c, s, srcName, slotIndex, tostring(GetBagName(slotIndex) or "empty")))

    -- Pick up the held bag, then equip it into bag slot slotIndex via
    -- PickupInventoryItem, which documents the exchange rule (both sides
    -- occupied -> contents exchanged) — unlike PickupBagFromSlot, which in
    -- this client only picks up and returns the cursor item to its slot.
    PickupContainerItem(c, s)
    local t1, id1 = GetCursorInfo()
    MobileUI_Debug(string.format(
        "BagSwap:   after pickup: cursor=%s %s, src=%s",
        tostring(t1), tostring(id1),
        GetContainerItemLink(c, s) and "occupied" or "empty"))

    PickupInventoryItem(ContainerIDToInventoryID(slotIndex))
    local t2, id2 = GetCursorInfo()
    MobileUI_Debug(string.format(
        "BagSwap:   after equip: cursor=%s %s, slot%d=%s",
        tostring(t2), tostring(id2), slotIndex,
        tostring(GetBagName(slotIndex) or "empty")))

    -- Clean swap: if the old bag is on the cursor and the source slot is now
    -- free, put the old bag back where the new bag came from — no invisible
    -- cursor juggling on mobile.
    if t2 == "item" and not GetContainerItemLink(c, s) then
        PickupContainerItem(c, s)
        local t3, id3 = GetCursorInfo()
        MobileUI_Debug(string.format(
            "BagSwap:   auto-placed old bag to c=%d s=%d, cursor=%s %s",
            c, s, tostring(t3), tostring(id3)))
    end
    LogFramePositions("after-swap")
    print("|cff00ccff[MobileUI]|r Bag swapped.")
    ScheduleReposition(slotIndex, IsBagOpen(slotIndex))
end

local function CreateMenu()
    menu = CreateFrame("Frame", "MobileUIBagSwapMenu", UIParent)
    menu:SetSize(240, 208)
    menu:SetFrameStrata("DIALOG")
    menu:SetClampedToScreen(true)
    menu:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    menu:Hide()

    menuTitle = menu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    menuTitle:SetPoint("TOPLEFT", menu, "TOPLEFT", 16, -12)
    menuTitle:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -16, -12)

    for i = 1, 4 do
        local row = CreateFrame("Button", "MobileUIBagSwapRow" .. i, menu)
        row:SetSize(212, 34)
        row:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight", "ADD")
        row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        row.text:SetPoint("LEFT", row, "LEFT", 8, 0)
        row.text:SetPoint("RIGHT", row, "RIGHT", -8, 0)
        row.text:SetJustifyH("LEFT")
        row.slotIndex = i
        row:SetScript("OnClick", function(self)
            if self.available then SwapIntoSlot(self.slotIndex) end
        end)
        row:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -36 - (i - 1) * 40)
        menuRows[i] = row
    end

    -- Full-screen transparent catcher below the menu: a tap anywhere outside
    -- a row dismisses the menu (and is consumed, so it can't misfire on the
    -- game world underneath).
    clickCatcher = CreateFrame("Frame", "MobileUIBagSwapCatcher", UIParent)
    clickCatcher:SetAllPoints(UIParent)
    clickCatcher:SetFrameStrata("DIALOG")
    clickCatcher:SetScript("OnMouseDown", HideMenu)
end

function MobileUIBagSwap:ShowMenu(itemButton, container, slot)
    if not menu then CreateMenu() end
    source = { container = container, slot = slot }

    local link = GetContainerItemLink(container, slot)
    local bagName = link and select(1, GetItemInfo(link)) or "bag"
    menuTitle:SetText("Equip " .. bagName .. " into:")

    -- Only empty bags / empty slots are valid targets (this client refuses
    -- to swap a bag that has items in it), so list just those, packed
    -- contiguously. If none are empty, show a single notice row.
    local targets = EmptyBagSlots()
    local targetSet = {}
    for _, i in ipairs(targets) do targetSet[i] = true end
    local visible = 0
    for i = 1, 4 do
        local row = menuRows[i]
        if targetSet[i] then
            visible = visible + 1
            local name = GetBagName(i)
            if name then
                local size = GetContainerNumSlots(i)
                local free = select(1, GetContainerNumFreeSlots(i)) or 0
                row.text:SetText(string.format("%d) %s (%d slots, %d free)", i, name, size, free))
                row.text:SetTextColor(1, 1, 1)
            else
                row.text:SetText(string.format("%d) Empty bag slot", i))
                row.text:SetTextColor(0.6, 0.6, 0.6)
            end
            row.available = true
            row:Show()
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -36 - (visible - 1) * 40)
        else
            row.available = false
            row:Hide()
        end
    end
    if visible == 0 then
        local row = menuRows[1]
        row.text:SetText("No empty bag slots")
        row.text:SetTextColor(0.5, 0.5, 0.5)
        row.available = false
        row:Show()
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -36)
        menu:SetHeight(88)
    else
        menu:SetHeight(36 + visible * 40 + 12)
    end

    -- Anchor next to the held item (thumb is right there), clamped to screen
    menu:ClearAllPoints()
    local left, bottom, height = itemButton:GetLeft(), itemButton:GetBottom(), itemButton:GetHeight()
    if left and bottom and height then
        menu:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom + height + 6)
    else
        menu:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
    end

    clickCatcher:Show()
    menu:SetFrameLevel(clickCatcher:GetFrameLevel() + 2)
    menu:Show()
end

-- ============================================================================
-- Click interception
-- ============================================================================

-- Container item buttons wire their OnClick as a string handler in
-- ContainerFrame.xml (resolved at click time), so replacing the global
-- intercepts every bag click — same mechanism as tap=sell.
local function OnContainerItemClick(self, button)
    if enabled and button == "RightButton"
       and not (MerchantFrame and MerchantFrame:IsShown()) then
        local parent = self:GetParent()
        local container = parent and parent:GetID()
        local slot = self:GetID()
        local isBag = container ~= nil and slot ~= nil and IsBagItem(container, slot)
        if isBag then
            MobileUI_Debug(string.format(
                "BagSwap: right-click c=%s s=%s isBag=true [%s]",
                tostring(container), tostring(slot), BagSlotState()))
            -- Stock right-click never equips bags in this client ("This item
            -- cannot be equipped" even with a free slot), so we always own
            -- the hold-of-bag gesture. With exactly one empty bag slot the
            -- choice is unambiguous — swap straight in, no menu.
            local targets = EmptyBagSlots()
            if #targets == 1 then
                source = { container = container, slot = slot }
                MobileUI_Debug(string.format(
                    "BagSwap:   one empty slot (%d), swapping directly", targets[1]))
                SwapIntoSlot(targets[1])
            else
                MobileUIBagSwap:ShowMenu(self, container, slot)
            end
            return
        end
    end
    -- Pass through in a clean protected stack: a plain right-click on a
    -- "Use:" item reaches the protected UseContainerItem, and MobileUI code
    -- on that stack would taint it (same reason tap=sell is merchant-scoped).
    -- While a merchant is open we defer via the chain so tap=sell owns the
    -- click; the merchant check above keeps order-independent.
    if origClick then
        securecall(origClick, self, button)
    end
end

local function InstallWrapper()
    if installed then return end
    origClick = ContainerFrameItemButton_OnClick
    ContainerFrameItemButton_OnClick = OnContainerItemClick
    installed = true
    MobileUI_Debug("BagSwap: ContainerFrameItemButton_OnClick wrapped")
end

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUIBagSwap:Apply()
    enabled = true
    InstallWrapper()
end

function MobileUIBagSwap:Revert()
    enabled = false
    HideMenu()
end

function MobileUIBagSwap:Toggle()
    local on = not MobileDB.bagSwap
    MobileDB.bagSwap = on
    if on then
        self:Apply()
    else
        self:Revert()
    end
    return on
end
