-- MobileUIBagSwap.lua - Pickup = Action: sell / equip / bag-swap
--
-- Problem: stock right-click on a bag item only equips into a FREE bag slot
-- and in this client errors "This item cannot be equipped" even with a free
-- slot — and the mobile layout hides the bags bar, so there is no per-slot
-- button to drag the bag onto either. The player can never replace an old
-- small bag with a new bigger one. Tap = Sell and Tap = Equip also need a
-- tap gesture the stock left-click does not provide.
--
-- Fix: we NEVER touch ContainerFrameItemButton_OnClick. The stock global
-- stays pristine for the whole session — in-game testing proved this is the
-- ONLY thing that keeps hold-to-use (right-click a hearthstone/potion)
-- clean: on a fresh session the hold uses the item fine, but after ONE
-- wrapper install/remove cycle on that global the same hold errors "AddOn
-- 'MobileUI' tainted the call of the secure function 'UseItemByName()'"
-- even with the wrapper fully restored/removed at hold time. securecall()
-- does not help (meaningless from addon code) and addon-initiated :Click()
-- taints too. So the wrapper idea is dead.
--
-- Instead, taps are left to do their stock thing — a tap PICKS THE ITEM UP —
-- and a per-frame poll watches the cursor. On an empty-cursor -> item
-- transition it checks GetMouseFocus(): if the pickup came from a container
-- slot, the item's kind decides the action, all via direct API calls that
-- are clean in this client (PickupContainerItem is not taint-checked;
-- UseContainerItem's SELL path — merchant open — and EQUIP path are not
-- protected — only its USE path is, which we never touch):
--
--   * vendor open + tapSell     -> return item to its slot + UseContainerItem -> sold
--   * bag + bagSwap             -> swap menu / direct swap (bag already on cursor)
--   * equippable + tapEquip, out of combat -> return + UseContainerItem -> equipped
--   * anything else             -> nothing; item stays on the cursor (stock)
--
-- Hold-to-use is deliberately untouched: with no wrapper ever on the stack,
-- a hold on a "Use:" item runs the stock handler cleanly. The item-use
-- mechanism is built separately (docs/tap-use.md). A hold on a BAG still
-- shows the stock "This item cannot be equipped" message — tap is the bag
-- gesture now. Moving armor requires tapEquip off (tap then picks it up).
--
-- Controls: default on. Toggle: /mui bagswap, /mui equiptap, /mui sell.
-- Interface Options -> MobileUI -> "Bag Swap Menu" / "Tap = Equip".
-- Saved vars: MobileDB.bagSwap, MobileDB.tapEquip, MobileDB.tapSell.

local ADDON = "MobileUI"

MobileUIBagSwap = {}

-- Menu state
local menu, menuTitle, clickCatcher
local menuRows = {}
local source   -- { container = containerID, slot = slotIndex } of the picked-up bag

-- ============================================================================
-- Helpers
-- ============================================================================

-- Is this item a bag? 3.3.5's GetItemInfo returns class as a LOCALIZED
-- STRING ("Container"), not the numeric id — so we accept the string, the
-- numeric id (some clients), and the locale-independent equipSlot token
-- ("INVTYPE_BAG") as three independent signals.
local function IsBag(link)
    if not link then return false end
    local _, _, _, _, _, class, _, _, equipSlot = GetItemInfo(link)
    if not class then return false end
    return class == "Container" or class == 1 or equipSlot == "INVTYPE_BAG"
end

-- Per-slot state for the debug log: "1:0/16 2:3/16 ..." = free/slots per
-- bag slot. Used to diagnose swap problems.
local function BagSlotState()
    local parts = {}
    for i = 1, 4 do
        local slots = GetContainerNumSlots(i)
        local free = slots > 0 and select(1, GetContainerNumFreeSlots(i)) or 0
        table.insert(parts, string.format("%d:%d/%d", i, free, slots))
    end
    return table.concat(parts, " ")
end

-- Bag-slot indices that are valid swap targets: an unequipped slot, or a
-- slot whose current bag is empty (this client refuses to swap a bag that
-- has items in it). Ascending order — the menu packs valid rows
-- contiguously.
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

-- Does this item have a "Use:" effect (hearthstone, potions, food...)?
-- GetItemSpell returns the spell cast by the item's use effect, or nil for
-- items with none (armor, weapons, junk). This is the gate a future tap=use
-- mechanism (docs/tap-use.md) would hook into; the pickup reaction
-- deliberately leaves use-items alone.
local function IsUsableItem(link)
    if not link then return false end
    return GetItemSpell(link) ~= nil
end

-- Does this item equip into a slot (armor/weapon)? Bags are excluded here —
-- they belong to the bag-swap branch. The equip path of UseContainerItem is
-- NOT taint-checked in this client, so equipping via the pickup reaction is
-- clean.
local function IsEquippable(link)
    if not link then return false end
    local _, _, _, _, _, _, _, _, equipSlot = GetItemInfo(link)
    if not equipSlot or equipSlot == "" then return false end
    return equipSlot ~= "INVTYPE_BAG"
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

-- Swap the bag on the cursor into bag slot slotIndex. The new bag is ALREADY
-- on the cursor (the stock tap picked it up — the pickup reaction never
-- moves it), so this is just the exchange: PickupInventoryItem documents the
-- exchange rule (both sides occupied -> contents exchanged) — unlike
-- PickupBagFromSlot, which in this client only picks up and returns the
-- cursor item to its slot. The old bag then lands on the cursor and is
-- auto-placed back into the source slot.
local function SwapIntoSlot(slotIndex)
    HideMenu()
    if InCombatLockdown() then
        print("|cff00ccff[MobileUI]|r Can't swap bags in combat.")
        return
    end
    if not source then return end
    local c, s = source.container, source.slot

    local t0, id0 = GetCursorInfo()
    if t0 ~= "item" then
        MobileUI_Debug(string.format(
            "BagSwap: swap into %d aborted, cursor=%s %s",
            slotIndex, tostring(t0), tostring(id0)))
        return
    end

    local srcLink = GetContainerItemLink(c, s)
    local srcName = srcLink and select(1, GetItemInfo(srcLink)) or "?"
    MobileUI_Debug(string.format(
        "BagSwap: swap cursor item -> slot %d (%s), source c=%d s=%d (%s)",
        slotIndex, tostring(GetBagName(slotIndex) or "empty"), c, s, srcName))

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
-- Pickup reaction (replaces click interception)
-- ============================================================================
-- We do not touch ContainerFrameItemButton_OnClick at all — the stock
-- handler stays pristine for the whole session, which is what keeps hold-to-
-- use clean (see the header). A tap does its stock thing (picks the item
-- up); this poll watches for the empty-cursor -> item transition and, if
-- the pickup came from a container slot, runs the action for the item. The
-- mouse action is never rewritten; every call below uses APIs proven clean
-- in this client.

local prevCursorEmpty = true -- cursor starts empty at login

-- The cursor just picked up an item from a container slot; act on it.
-- itemButton is the frame the pickup happened on (used to anchor the menu).
local function OnCursorPickup(itemButton, container, slot, link)
    local merchantOpen = MerchantFrame and MerchantFrame:IsShown()

    -- Tap = Sell: at a vendor, put the item back and sell it. The sell path
    -- of UseContainerItem is NOT protected in this client (merchant-open
    -- wins the dispatch), so this is clean — the same path a stock hold
    -- takes.
    if merchantOpen and MobileDB and MobileDB.tapSell then
        MobileUI_Debug(string.format(
            "Tap=Sell: pickup c=%s s=%s -> return+sell",
            tostring(container), tostring(slot)))
        PickupContainerItem(container, slot)
        UseContainerItem(container, slot)
        return
    end

    -- Bag swap: the bag is already on the cursor (the stock tap picked it
    -- up). With exactly one empty bag slot the choice is unambiguous — swap
    -- straight in. Otherwise show the menu. Never in combat (a swap needs
    -- PickupInventoryItem, protected there) — the bag is put back.
    if MobileDB and MobileDB.bagSwap and IsBag(link) then
        MobileUI_Debug(string.format(
            "BagSwap: pickup c=%s s=%s isBag=true [%s]",
            tostring(container), tostring(slot), BagSlotState()))
        if InCombatLockdown() then
            PickupContainerItem(container, slot) -- put the bag back
            print("|cff00ccff[MobileUI]|r Can't swap bags in combat.")
            return
        end
        local targets = EmptyBagSlots()
        if #targets == 1 then
            source = { container = container, slot = slot }
            MobileUI_Debug(string.format(
                "BagSwap:   one empty slot (%d), swapping directly", targets[1]))
            SwapIntoSlot(targets[1])
        else
            MobileUIBagSwap:ShowMenu(itemButton, container, slot)
        end
        return
    end

    -- Tap = Equip: return the item and equip it. The equip path of
    -- UseContainerItem is NOT taint-checked in this client. Never in combat
    -- — equipping is protected there; the item stays on the cursor (stock
    -- pickup behavior).
    if MobileDB and MobileDB.tapEquip and not InCombatLockdown()
        and IsEquippable(link) then
        MobileUI_Debug(string.format(
            "Tap=Equip: pickup c=%s s=%s -> return+equip",
            tostring(container), tostring(slot)))
        PickupContainerItem(container, slot)
        UseContainerItem(container, slot)
        return
    end

    -- Everything else — use-items, junk, materials — is left alone: the
    -- item stays on the cursor, exactly as stock. The tap=use mechanism is
    -- built separately (docs/tap-use.md).
end

local function HandleCursorPickup()
    local focus = GetMouseFocus()
    if not focus then return end
    local name = focus:GetName()
    if not name or not name:match("^ContainerFrame%d+Item%d+$") then return end
    local parent = focus:GetParent()
    local container = parent and parent:GetID()
    local slot = focus:GetID()
    if container == nil or slot == nil then return end
    -- The client keeps the slot's link while the item is on the cursor
    -- (locked/occupied), so the slot lookup is the primary source; fall
    -- back to the cursor item's own link.
    local link = GetContainerItemLink(container, slot)
    if not link then
        local _, id = GetCursorInfo()
        if id then
            link = select(2, GetItemInfo(id))
        end
    end
    if not link then return end
    OnCursorPickup(focus, container, slot, link)
end

local pollFrame
local function EnsurePoll()
    if pollFrame then return end
    pollFrame = CreateFrame("Frame")
    pollFrame:SetScript("OnUpdate", function()
        local hasItem = GetCursorInfo() ~= nil
        if hasItem and prevCursorEmpty then
            HandleCursorPickup()
        end
        prevCursorEmpty = not hasItem
    end)
end

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUIBagSwap:Apply()
    EnsurePoll()
end

function MobileUIBagSwap:Revert()
    HideMenu()
end

-- Called by MobileUISell:Apply() too, so tap=sell keeps working when
-- bag-swap is off (and vice versa): the poll is shared by all three
-- reactions and each checks its own MobileDB flag at pickup time.
function MobileUIBagSwap:EnsurePoll()
    EnsurePoll()
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

function MobileUIBagSwap:ToggleEquip()
    local on = not MobileDB.tapEquip
    MobileDB.tapEquip = on
    if on then
        self:Apply()
    else
        self:Revert()
    end
    return on
end
