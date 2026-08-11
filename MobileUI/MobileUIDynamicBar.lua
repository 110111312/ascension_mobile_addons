-- MobileUIDynamicBar.lua
--
-- Dynamic Action Bar (bottom-left strip)
--
-- Reuses the parked MultiBarBottomLeft tail buttons 6-10 (action slots 66-70)
-- as a mobile "totem-style" bar in the empty strip between the bag button and
-- the player health/mana frame. The strip geometry is MEASURED at apply time
-- (bag right edge -> player frame left edge), so the button count adapts to
-- the actual empty space (up to 5, min 3, shrinking the buttons if needed).
--
--   Tap  (left click)  -> use: the button is a REAL stock action button, so
--                         the tap runs the stock ActionButton_OnClick ->
--                         UseAction(slot) path with zero addon code on the
--                         stack. Taint-clean by construction (same path every
--                         arc spell cast uses). The client renders icon /
--                         cooldown / stack count natively — no display code.
--   Hold (right click) -> assign: a transparent catcher over the button
--                         swallows the right-click (so the stock
--                         right-click-pickup never fires) and opens the
--                         picker: usable bag items (GetItemSpell ~= nil) +
--                         known non-passive spells, active player buffs
--                         sorted first. Tapping an entry assigns it to the
--                         button's action slot via
--                         PickupContainerItem/PickupSpell + PlaceAction —
--                         not on the taint-protected use path at all.
--
-- Assignments live in the client's action-bar save data (slots 66-70), so
-- they persist across reload/logout for free. Revert re-parks the tail
-- buttons exactly as the layout left them (off-screen) but leaves the slot
-- contents in place (they are the player's own action slots).
--
-- In-game verification notes (first session):
--   1. Left taps pass through the right-click-only catcher to the stock
--      button (standard WoW hit-testing for unregistered buttons).
--   2. PickupContainerItem -> PlaceAction assigns cleanly (no taint on the
--      next UseAction click) on this Ascension client.
--   3. PickupSpellBookItem vs PickupSpell — both are tried; log which exists.

local FIRST_BTN = 6      -- MultiBarBottomLeftButton6..10
local MAX_BTN   = 5      -- up to 5 buttons (6-10)
local function SlotForButton(i) return 60 + i end -- Ascension: bar2 attached => slots 61-72

local PITCH_GAP      = 4
local STRIP_MARGIN   = 8   -- gap after the bag button
local STRIP_END_MARG = 8   -- gap before the player frame

local COLS, ROWS, CELL = 4, 3, 52
local PER_PAGE = COLS * ROWS

MobileUIDynamicBar = {}

local catchers   = {}    -- [btnIndex] = catcher button
local usedButtons = {}   -- [btnIndex] = true while the strip is active
local active     = false
local pendingDefer = nil

local menu, clickCatcher, menuTitle, menuHint
local menuCells, prevBtn, nextBtn, pageLabel
local pickerButton, entries, curPage, pages
local AssignEntry -- assigned below; referenced by the menu cells' OnClick

-- ============================================================================
-- Combat deferral (same pattern as the layout: re-anchor/Show/Hide of
-- protected frames is only allowed out of combat)
-- ============================================================================
local deferFrame
local function EnsureDefer()
    if deferFrame then return end
    deferFrame = CreateFrame("Frame")
    deferFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    deferFrame:SetScript("OnEvent", function()
        deferFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        local action = pendingDefer
        pendingDefer = nil
        if action == "apply" then MobileUIDynamicBar:Apply()
        elseif action == "revert" then MobileUIDynamicBar:Revert() end
    end)
end

-- ============================================================================
-- Strip geometry — measured from the live frames so it adapts to whatever
-- resolution/scale the phone stream uses
-- ============================================================================
local function ComputeStrip()
    local bag = _G["MobileUIBagButton"]
    local pf  = _G["PlayerFrame"]
    local bagRight   = bag and bag:GetRight() or 66
    local playerLeft = pf and pf:GetLeft()
    if not playerLeft then
        -- Fallback: player frame is BOTTOM-centered, 280 wide, UI scaled 1.2
        playerLeft = GetScreenWidth() / 2.4 - 140
    end
    local gap = playerLeft - bagRight - STRIP_MARGIN - STRIP_END_MARG
    local btn = _G["MultiBarBottomLeftButton" .. FIRST_BTN]
    local base = btn and btn:GetWidth() or 36
    local size, pitch = base, base + PITCH_GAP
    local count = 0
    for n = MAX_BTN, 3, -1 do
        if gap >= n * pitch - PITCH_GAP then count = n break end
    end
    if count == 0 then
        -- Not enough room even for 3 at stock size: shrink to fit 3.
        count = 3
        size  = math.max(24, math.floor((gap - (count - 1) * PITCH_GAP) / count))
        pitch = size + PITCH_GAP
    end
    if gap < size then count = math.max(1, math.floor((gap + PITCH_GAP) / (size + PITCH_GAP))) end
    local y = bag and bag:GetBottom() or 10
    return count, size, pitch, bagRight + STRIP_MARGIN, y
end

-- ============================================================================
-- Picker menu
-- ============================================================================
local function BuildEntries()
    local out = {}
    -- --- Usable bag items (any item with a "Use:" effect), deduped by id ---
    local seen = {}
    for c = 0, 4 do
        local num = GetContainerNumSlots(c)
        if num and num > 0 then
            for s = 1, num do
                local link = GetContainerItemLink(c, s)
                if link and GetItemSpell(link) then
                    local id = tonumber(link:match("item:(%d+)"))
                    if id and not seen[id] then
                        seen[id] = true
                        local name  = GetItemInfo(link)
                        local icon  = GetItemIcon(link)
                        local count = GetItemCount(link)
                        table.insert(out, {
                            kind = "item", id = id, c = c, s = s,
                            name = name or link, icon = icon, count = count,
                        })
                    end
                end
            end
        end
    end
    -- --- Buff spells: known non-passive spells; active player buffs first ---
    local buffSet = {}
    for i = 1, 40 do
        local name = UnitBuff("player", i)
        if not name then break end
        buffSet[name] = true
    end
    local spells = {}
    if GetSpellBookItemInfo then
        for tab = 1, GetNumSpellTabs() do
            local _, _, offset, num = GetSpellTabInfo(tab)
            for i = offset + 1, offset + num do
                local stype, sid = GetSpellBookItemInfo(i, "spell")
                if stype == "SPELL" and sid then
                    local sname, _, sicon = GetSpellInfo(sid)
                    if sname and not IsPassiveSpell(sname) then
                        table.insert(spells, {
                            kind = "spell", spellbookID = i, name = sname,
                            icon = sicon, buff = buffSet[sname] and true or false,
                        })
                    end
                end
            end
        end
    end
    table.sort(spells, function(a, b)
        if a.buff ~= b.buff then return a.buff and not b.buff end
        return a.name < b.name
    end)
    for _, sp in ipairs(spells) do table.insert(out, sp) end
    return out
end

local function RenderPage()
    if #entries == 0 then
        for k = 1, PER_PAGE do menuCells[k]:Hide() end
        pageLabel:SetText("")
        prevBtn:Hide()
        nextBtn:Hide()
        return
    end
    local start = (curPage - 1) * PER_PAGE
    for k = 1, PER_PAGE do
        local cell = menuCells[k]
        local entry = entries[start + k]
        if entry then
            cell.entry = entry
            cell.icon:SetTexture(entry.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            cell.icon:Show()
            cell.count:SetText(entry.count and entry.count > 1 and tostring(entry.count) or "")
            cell:Show()
        else
            cell.entry = nil
            cell:Hide()
        end
    end
    pageLabel:SetText(curPage .. "/" .. pages)
    prevBtn:SetShown(curPage > 1)
    nextBtn:SetShown(curPage < pages)
end

local function ClosePicker()
    if menu then menu:Hide() end
    if clickCatcher then clickCatcher:Hide() end
    pickerButton = nil
end

local function CreateMenu()
    menu = CreateFrame("Frame", "MobileUIDynamicBarMenu", UIParent)
    menu:SetSize(COLS * CELL + (COLS - 1) * PITCH_GAP + 28, 258)
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
    menuTitle:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -10)
    menuTitle:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -14, -10)

    menuHint = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    menuHint:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -26)
    menuHint:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -14, -26)
    menuHint:SetTextColor(0.6, 0.6, 0.6)

    menuCells = {}
    for k = 1, PER_PAGE do
        local cell = CreateFrame("Button", nil, menu)
        cell:SetSize(CELL, CELL)
        cell.icon = cell:CreateTexture(nil, "BACKGROUND")
        cell.icon:SetAllPoints()
        cell.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        cell.count = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cell.count:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -2, 2)
        cell:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        cell:SetScript("OnClick", function(self)
            if self.entry then AssignEntry(self.entry) end
        end)
        local col = (k - 1) % COLS
        local row = math.floor((k - 1) / COLS)
        cell:SetPoint("TOPLEFT", menu, "TOPLEFT", 14 + col * (CELL + PITCH_GAP), -40 - row * (CELL + PITCH_GAP))
        menuCells[k] = cell
    end

    prevBtn = CreateFrame("Button", nil, menu)
    prevBtn:SetSize(40, 20)
    prevBtn:SetNormalFontObject(GameFontNormalSmall)
    prevBtn:SetText("<")
    prevBtn:SetScript("OnClick", function()
        if curPage > 1 then curPage = curPage - 1 RenderPage() end
    end)
    prevBtn:SetPoint("BOTTOMLEFT", menu, "BOTTOMLEFT", 14, 12)

    nextBtn = CreateFrame("Button", nil, menu)
    nextBtn:SetSize(40, 20)
    nextBtn:SetNormalFontObject(GameFontNormalSmall)
    nextBtn:SetText(">")
    nextBtn:SetScript("OnClick", function()
        if curPage < pages then curPage = curPage + 1 RenderPage() end
    end)
    nextBtn:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -14, 12)

    pageLabel = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    pageLabel:SetPoint("BOTTOM", menu, "BOTTOM", 0, 14)

    -- Full-screen catcher below the menu: a tap anywhere outside dismisses
    -- (same pattern as the bag-swap menu).
    clickCatcher = CreateFrame("Frame", "MobileUIDynamicBarCatcher", UIParent)
    clickCatcher:SetAllPoints(UIParent)
    clickCatcher:SetFrameStrata("DIALOG")
    clickCatcher:SetScript("OnMouseDown", ClosePicker)
end

local function OpenPicker(btnIndex)
    if not active then return end
    pickerButton = btnIndex
    if not menu then CreateMenu() end
    entries = BuildEntries()
    curPage = 1
    pages = math.max(1, math.ceil(#entries / PER_PAGE))
    menuTitle:SetText("Assign to button " .. (btnIndex - FIRST_BTN + 1))
    if InCombatLockdown() then
        menuHint:SetText("Assigning is disabled in combat.")
    elseif #entries == 0 then
        menuHint:SetText("No usable items or buff spells found.")
    else
        menuHint:SetText("Tap an item or buff to assign it to this button.")
    end
    RenderPage()
    local btn = _G["MultiBarBottomLeftButton" .. btnIndex]
    local left, bottom, height = btn and btn:GetLeft(), btn and btn:GetBottom(), btn and btn:GetHeight()
    menu:ClearAllPoints()
    if left and bottom and height then
        menu:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom + height + 6)
    else
        menu:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
    end
    clickCatcher:Show()
    menu:SetFrameLevel(clickCatcher:GetFrameLevel() + 2)
    menu:Show()
    MobileUI_Debug(string.format("DynamicBar: picker opened for btn %d (%d entries, %d pages)",
        btnIndex, #entries, pages))
end

-- ============================================================================
-- Assignment (slot-based; never on the taint-protected use path)
-- ============================================================================
-- Returns whatever is on the cursor: items to a free bag slot (so a
-- PlaceAction exchange of a previous item assignment is never lost),
-- anything else (spell / macro) dropped.
local function ReturnCursorContent()
    local t = GetCursorInfo()
    if not t then return end
    if t == "item" then
        for bc = 0, 4 do
            local num = GetContainerNumSlots(bc)
            if num and num > 0 then
                for bs = 1, num do
                    if not GetContainerItemLink(bc, bs) then
                        PickupContainerItem(bc, bs)
                        return
                    end
                end
            end
        end
    end
    ClearCursor()
end

AssignEntry = function(entry)
    if not pickerButton then return end
    if InCombatLockdown() then
        MobileUI_Debug("DynamicBar: assign blocked during combat")
        ClosePicker()
        return
    end
    local slot = SlotForButton(pickerButton)
    if entry.kind == "item" then
        PickupContainerItem(entry.c, entry.s)
        if PlaceAction then PlaceAction(slot) end
        -- PlaceAction exchanges: if the slot held a previous item, that item
        -- is now on the cursor — put it back where this item came from.
        if GetCursorInfo() then PickupContainerItem(entry.c, entry.s) end
        MobileUI_Debug(string.format("DynamicBar: assigned item '%s' to btn %d (slot %d)",
            entry.name, pickerButton, slot))
    else
        local pickup = PickupSpellBookItem or PickupSpell
        if pickup then pickup(entry.spellbookID, "spell") end
        if PlaceAction then PlaceAction(slot) end
        if GetCursorInfo() then ReturnCursorContent() end -- exchange leftover
        MobileUI_Debug(string.format("DynamicBar: assigned spell '%s' to btn %d (slot %d)",
            entry.name, pickerButton, slot))
    end
    local t, id = GetActionInfo(slot)
    MobileUI_Debug(string.format("DynamicBar: slot %d now type=%s id=%s", slot, tostring(t), tostring(id)))
    ClosePicker()
end

-- ============================================================================
-- Strip buttons + right-click catchers
-- ============================================================================
local function ShowButton(i, size, x0, y, pitch)
    local b = _G["MultiBarBottomLeftButton" .. i]
    if not b then return false end
    b:ClearAllPoints()
    b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x0 + (i - FIRST_BTN) * pitch, y)
    if math.abs((b:GetWidth() or 0) - size) > 1 then b:SetSize(size, size) end
    -- Keep empty slots visible (the client hides empty action buttons unless
    -- showgrid=1 — same trick the scatter arc uses).
    b:SetAttribute("showgrid", 1)
    -- No hotkey/name text over the icons (the layout only covers the arc
    -- buttons with HOTKEY_FRAMES; hide these two children explicitly).
    local hk = _G["MultiBarBottomLeftButton" .. i .. "HotKey"]
    if hk then hk:Hide() end
    local nm = _G["MultiBarBottomLeftButton" .. i .. "Name"]
    if nm then nm:Hide() end
    b:Show()
    return true
end

local function CreateCatcher(i, size, x0, y, pitch)
    local c = catchers[i]
    if not c then
        c = CreateFrame("Button", nil, UIParent)
        c:SetFrameStrata("HIGH")
        c:SetScript("OnMouseDown", function(self, button)
            if button ~= "RightButton" then return end
            OpenPicker(self.btnIndex)
        end)
        catchers[i] = c
    end
    c.btnIndex = i
    c:SetSize(size, size)
    c:ClearAllPoints()
    c:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x0 + (i - FIRST_BTN) * pitch, y)
    -- Right-click only: left taps pass through the catcher to the stock
    -- button below (stock hit-testing skips frames not registered for the
    -- pressed button).
    c:RegisterForClicks("RightButtonDown")
    c:Show()
end

-- ============================================================================
-- Public API
-- ============================================================================
-- Called by the layout guard's per-frame HideBar2Tail to keep the strip
-- buttons visible.
function MobileUIDynamicBar.TailUsed(i)
    return active and usedButtons[i] or nil
end

function MobileUIDynamicBar:Apply()
    if active then return end
    if not MobileDB or not MobileDB.dynamicBar then return end
    if not MobileDB.layoutEnabled then
        MobileUI_Debug("DynamicBar: skipped (layout disabled)")
        return
    end
    if InCombatLockdown() then
        pendingDefer = "apply"
        EnsureDefer()
        MobileUI_Debug("DynamicBar: deferring apply until out of combat")
        return
    end
    local count, size, pitch, x0, y = ComputeStrip()
    if count < 1 or size < 20 then
        MobileUI_Debug(string.format("DynamicBar: no room (count=%d size=%d)", count, size))
        return
    end
    for k = 1, count do
        local i = FIRST_BTN + k - 1
        if ShowButton(i, size, x0, y, pitch) then
            CreateCatcher(i, size, x0, y, pitch)
            usedButtons[i] = true
        end
    end
    active = true
    MobileUI_Debug(string.format(
        "DynamicBar: applied %d button(s) size=%d pitch=%d x0=%.0f y=%.0f",
        count, size, pitch, x0, y))
end

function MobileUIDynamicBar:Revert()
    if InCombatLockdown() then
        pendingDefer = "revert"
        EnsureDefer()
        MobileUI_Debug("DynamicBar: deferring revert until out of combat")
        return
    end
    ClosePicker()
    for i in pairs(usedButtons) do
        local c = catchers[i]
        if c then c:Hide() end
        local b = _G["MultiBarBottomLeftButton" .. i]
        if b then
            -- Re-park exactly like the layout leaves the rest of the tail
            -- (off-screen; the client's combat re-show renders it invisible).
            b:ClearAllPoints()
            b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
            b:SetAttribute("showgrid", 0)
            b:Hide()
        end
    end
    wipe(usedButtons)
    active = false
    MobileUI_Debug("DynamicBar: reverted (strip buttons re-parked)")
end

function MobileUIDynamicBar:Toggle()
    MobileDB.dynamicBar = not MobileDB.dynamicBar
    if MobileDB.dynamicBar then self:Apply() else self:Revert() end
    return MobileDB.dynamicBar
end
