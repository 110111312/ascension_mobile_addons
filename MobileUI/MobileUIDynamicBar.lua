-- MobileUIDynamicBar.lua
--
-- Dynamic Action Bar (bottom-left strip)
--
-- Reuses the parked MultiBarBottomLeft tail buttons 6-11 (action slots 66-71)
-- as a mobile "totem-style" bar in the empty strip between the bag button and
-- the player health/mana frame. The strip geometry is MEASURED at apply time
-- (bag right edge -> player frame left edge): 6 buttons spread evenly across
-- the gap, targeting the layer-3 arc size (64px) and shrinking to fit.
--
--   Tap  (left click)  -> use: the button is a REAL stock action button, so
--                         the tap runs the stock ActionButton_OnClick ->
--                         UseAction(slot) path with zero addon code on the
--                         stack. Taint-clean by construction (same path every
--                         arc spell cast uses). The client renders icon /
--                         cooldown / stack count natively — no display code.
--   Hold (right click) -> assign: an OnMouseDown script installed on the
--                         stock button opens the picker on right-down. The
--                         picker is a scrollable list grouped by category
--                         (Items / Spells / Mounts): tap a row to assign it
--                         to the button's action slot via PickupContainerItem
--                         / PickupSpell + PlaceAction (not on the taint-
--                         protected use path); hold a row to preview its
--                         tooltip. Close via the X button, ESC, or a tap
--                         outside. The stock right-click pickup on release
--                         puts the slot's item on the cursor; the menu's
--                         OnHide re-places it (PlaceAction) so nothing is
--                         lost.
--
-- Why no catcher overlay: a Button with RegisterForClicks(right-only) got
-- NO mouse events on this client (verified in-game via the debug ring), and
-- a plain Frame overlay would also eat left taps (no pass-through here). A
-- direct OnMouseDown script is the minimal proven mechanic — the layout
-- already installs scripts on the arc buttons and casting stays clean.
--
-- Assignments live in the client's action-bar save data (slots 66-71), so
-- they persist across reload/logout for free. Revert re-parks the tail
-- buttons exactly as the layout left them (off-screen) but leaves the slot
-- contents in place (they are the player's own action slots).
--
-- In-game verification notes:
--   1. The OnMouseDown script on the stock button does not taint the
--      left-click use path (no 'UseAction()' taint error on tap).
--   2. PickupContainerItem -> PlaceAction assigns cleanly on this client.
--   3. PickupSpellBookItem vs PickupSpell — both are tried; log which exists.
--   4. The right-up stock pickup is re-placed by the menu OnHide (no cursor
--      item left dangling when the picker is dismissed).
--   5. LBF circular skin on the strip buttons keeps the native icon/cooldown
--      display working (stock OnEvent kept) with no combat taint errors.
--   6. This client strips ScrollFrame:SetVerticalScroll and
--      Slider:SetObeyStepOnDrag (like GameTooltip:GetNumTooltipLines), so the
--      picker scrolls via a plain clipped viewport + manual content offset.

local FIRST_BTN = 6      -- MultiBarBottomLeftButton6..11
local MAX_BTN   = 6      -- 6 buttons (6-11)
local TARGET_SIZE = 64    -- layer-3 arc size; shrinks to fit the gap
local function SlotForButton(i) return 60 + i end -- Ascension: bar2 attached => slots 61-72

local PITCH_GAP      = 4
local STRIP_MARGIN   = 8   -- gap after the bag button
local STRIP_END_MARG = 8   -- gap before the player frame

local MENU_W, MENU_H = 340, 460
local ROW_H, HEADER_H, ICON = 34, 22, 26
local GROUP_NAMES = {
    item  = "Items",
    spell = "Spells",
    mount = "Mounts",
}

MobileUIDynamicBar = {}

local usedButtons = {}   -- [btnIndex] = true while the strip is active
local active     = false
local pendingDefer = nil

local menu, clickCatcher, menuTitle, menuHint, closeBtn
local viewport, content, scrollBar
local rowPool, headerPool = {}, {}
local pickerButton, entries
-- Forward refs: assigned below; referenced by the menu rows' OnClick and by
-- the menu OnHide (which runs before they are defined).
local AssignEntry, ReturnCursorContent

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
-- resolution/scale the phone stream uses. 6 buttons spread evenly across the
-- gap, targeting the layer-3 arc size (64px) and shrinking to fit.
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
    local span = playerLeft - bagRight - STRIP_MARGIN - STRIP_END_MARG
    local size = TARGET_SIZE
    local pitch
    if span >= MAX_BTN * TARGET_SIZE + (MAX_BTN - 1) * PITCH_GAP then
        -- Full 64px: spread the leftover space evenly between the buttons.
        pitch = (span - MAX_BTN * TARGET_SIZE) / (MAX_BTN - 1) + TARGET_SIZE
    else
        -- Not enough room for 6 at 64px: shrink to fit with min gaps.
        size  = math.max(24, math.floor((span - (MAX_BTN - 1) * PITCH_GAP) / MAX_BTN))
        pitch = size + PITCH_GAP
    end
    -- Vertically center the strip on the bag button.
    local y = bag and (bag:GetBottom() + (bag:GetHeight() - size) / 2) or 10
    return MAX_BTN, size, pitch, bagRight + STRIP_MARGIN, y
end

-- ============================================================================
-- Picker menu
-- ============================================================================
-- No keep/drop filter: every candidate (helpful, non-passive, non-attack
-- spell; mounts split out via the book type) shows, grouped by category.
-- Buff durations: 3.3.5 has no spell-duration API, and the tooltip
-- line-reading API (GetNumTooltipLines) does NOT exist on this Ascension
-- client (verified in-game on both the global and addon-created tooltips), so
-- duration can't be read at all. The picker shows remaining time only for
-- buffs currently active on the player (UnitBuff gives the exact duration).

local function BuildEntries()
    local items, spells, mounts = {}, {}, {}
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
                        table.insert(items, {
                            kind = "item", id = id, c = c, s = s,
                            name = name or link, icon = icon, count = count,
                        })
                    end
                end
            end
        end
    end
    -- --- Spells + mounts ---------------------------------------------------
    -- Candidates: helpful (usable on player/friendly) minus attack spells
    -- minus passives. Mounts are split out via GetSpellBookItemInfo's book
    -- type ("MOUNT" vs "SPELL").
    local buffSet = {}
    for i = 1, 40 do
        -- UnitBuff: name, rank, icon, count, dispelType, DURATION, ...
        -- (duration is the 6th return — the 5th is dispelType, a string)
        local name, _, _, _, _, dur = UnitBuff("player", i)
        if not name then break end
        buffSet[name] = dur or 0
    end
    local rejected   = {}
    local spellNameFn = GetSpellBookItemName or GetSpellName
    local nt = GetNumSpellTabs() or 0
    local checked = 0
    for tab = 1, nt do
        local _, _, offset, num = GetSpellTabInfo(tab)
        if offset and num then
            for i = offset + 1, offset + num do
                checked = checked + 1
                local sname = spellNameFn and spellNameFn(i, "spell")
                if not sname and GetSpellBookItemInfo then
                    -- Last resort (undocumented in the local reference, but
                    -- SpellBookFrame uses it on stock 3.3.5).
                    local stype, sid = GetSpellBookItemInfo(i, "spell")
                    if stype == "SPELL" and sid then
                        sname = select(1, GetSpellInfo(sid))
                    end
                end
                if sname then
                    local passive = IsPassiveSpell and IsPassiveSpell(i, "spell")
                    local attack  = IsAttackSpell and IsAttackSpell(i, "spell")
                    local helpful = IsHelpfulSpell and IsHelpfulSpell(i, "spell")
                    local keep    = true
                    local why     = nil
                    if passive then keep, why = false, "passive" end
                    if attack  then keep, why = false, "attack"  end
                    -- Restrict to friendly-target spells only when the API exists.
                    if helpful == false then keep, why = false, "nothelpful" end
                    if keep then
                        local btype = GetSpellBookItemInfo and select(1, GetSpellBookItemInfo(i, "spell"))
                        local kind = (btype == "MOUNT") and "mount" or "spell"
                        local entry = {
                            kind = kind, spellbookID = i, name = sname,
                            icon = GetSpellTexture and GetSpellTexture(i, "spell"),
                            dur  = buffSet[sname] or 0,
                        }
                        -- Global spellID for the tooltip (GetSpellInfo accepts
                        -- the book form on 3.3.5).
                        entry.spellID = select(7, GetSpellInfo(i, "spell"))
                        table.insert(kind == "mount" and mounts or spells, entry)
                    else
                        table.insert(rejected, string.format("%s(%s)", sname, why))
                    end
                end
            end
        end
    end
    table.sort(spells, function(a, b) return a.name < b.name end)
    table.sort(mounts, function(a, b) return a.name < b.name end)
    MobileUI_Debug(string.format(
        "DynamicBar: spell scan (bookname=%s bookinfo=%s) %d checked -> %d candidates (%d spells, %d mounts)",
        tostring(GetSpellBookItemName ~= nil), tostring(GetSpellBookItemInfo ~= nil),
        checked, #spells + #mounts, #spells, #mounts))
    if #rejected > 0 then
        MobileUI_Debug("DynamicBar: candidate-rejected: " .. table.concat(rejected, ", "))
    end
    local out = {}
    for _, t in ipairs({ items, spells, mounts }) do
        for _, e in ipairs(t) do table.insert(out, e) end
    end
    return out
end

-- Tooltip preview: hold (right button) on a row shows the entry's tooltip;
-- release hides it. Also fires on hover for desktop. Uses the global
-- GameTooltip (the addon-created one lacks template methods on this client).
local function ShowEntryTooltip(entry)
    if not entry then return end
    local ok, err = pcall(function()
        GameTooltip:SetOwner(menu, "ANCHOR_RIGHT")
        if entry.kind == "item" then
            if entry.c and entry.s then
                GameTooltip:SetBagItem(entry.c, entry.s)
            else
                GameTooltip:SetItemByID(entry.id)
            end
        elseif entry.spellID then
            GameTooltip:SetSpellByID(entry.spellID)
        end
        GameTooltip:Show()
    end)
    if not ok then
        MobileUI_Debug("DynamicBar: tooltip ERROR: " .. tostring(err))
    end
end

local function HideEntryTooltip()
    if GameTooltip then GameTooltip:Hide() end
end

local function ClosePicker()
    if menu then menu:Hide() end
end

local function CreateMenu()
    menu = CreateFrame("Frame", "MobileUIDynamicBarMenu", UIParent)
    menu:SetSize(MENU_W, MENU_H)
    menu:SetFrameStrata("DIALOG")
    menu:SetClampedToScreen(true)
    menu:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    menu:EnableKeyboard(true)
    menu:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then ClosePicker() end
    end)
    -- ESC also hides it via the stock UISpecialFrames path.
    table.insert(UISpecialFrames, "MobileUIDynamicBarMenu")
    -- All dismissal paths (X, ESC, tap-outside, assign, revert) end in
    -- menu:Hide(); the cursor cleanup lives here so nothing is lost.
    menu:SetScript("OnHide", function()
        if pickerButton and GetCursorInfo() then
            local slot = SlotForButton(pickerButton)
            if PlaceAction then PlaceAction(slot) end
            if GetCursorInfo() then ReturnCursorContent() end -- place failed
        end
        pickerButton = nil
        if clickCatcher then clickCatcher:Hide() end
    end)
    menu:Hide()

    menuTitle = menu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    menuTitle:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -10)
    menuTitle:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -34, -10)

    menuHint = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    menuHint:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -26)
    menuHint:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -34, -26)
    menuHint:SetTextColor(0.6, 0.6, 0.6)

    closeBtn = CreateFrame("Button", nil, menu)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -8, -8)
    closeBtn:SetNormalFontObject(GameFontNormal)
    closeBtn:SetText("X")
    closeBtn:SetScript("OnClick", ClosePicker)

    -- Viewport + manual scroll: this Ascension client strips ScrollFrame's
    -- SetVerticalScroll and Slider's SetObeyStepOnDrag (verified in-game), so
    -- no ScrollFrame — a plain clipped frame whose content is moved by the
    -- scrollbar instead.
    viewport = CreateFrame("Frame", nil, menu)
    viewport:SetPoint("TOPLEFT", menu, "TOPLEFT", 14, -44)
    viewport:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -30, 12)
    viewport:SetClipsChildren(true)
    content = CreateFrame("Frame", nil, viewport)
    content:SetWidth(MENU_W - 14 - 30)
    content:SetPoint("TOPLEFT", viewport, "TOPLEFT", 0, 0)

    scrollBar = CreateFrame("Slider", nil, menu, "UIPanelScrollBarTemplate")
    scrollBar:SetPoint("TOPRIGHT", viewport, "TOPRIGHT", 4, 0)
    scrollBar:SetPoint("BOTTOMRIGHT", viewport, "BOTTOMRIGHT", 4, 0)
    scrollBar:SetMinMaxValues(0, 1)
    scrollBar:SetValue(0)
    scrollBar:SetValueStep(1)
    scrollBar:SetScript("OnValueChanged", function(self, value)
        content:ClearAllPoints()
        content:SetPoint("TOPLEFT", viewport, "TOPLEFT", 0, value)
    end)
    viewport:EnableMouseWheel(true)
    viewport:SetScript("OnMouseWheel", function(self, delta)
        local _, max = scrollBar:GetMinMaxValues()
        local v = scrollBar:GetValue() - delta * 30
        if v < 0 then v = 0 elseif v > max then v = max end
        scrollBar:SetValue(v)
    end)

    -- Full-screen catcher below the menu: a tap anywhere outside dismisses
    -- (same pattern as the bag-swap menu).
    clickCatcher = CreateFrame("Frame", "MobileUIDynamicBarCatcher", UIParent)
    clickCatcher:SetAllPoints(UIParent)
    clickCatcher:SetFrameStrata("DIALOG")
    clickCatcher:SetScript("OnMouseDown", ClosePicker)
end

-- Rebuild the scrollable grouped list. Rows/headers are pooled so repeated
-- opens don't churn frame creation.
local function RebuildList()
    local usedRows, usedHeaders = 0, 0
    local function GetRow()
        usedRows = usedRows + 1
        local r = rowPool[usedRows]
        if not r then
            r = CreateFrame("Button", nil, content)
            r:SetHeight(ROW_H)
            r.icon = r:CreateTexture(nil, "BACKGROUND")
            r.icon:SetSize(ICON, ICON)
            r.icon:SetPoint("LEFT", r, "LEFT", 6, 0)
            r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            r.name:SetPoint("LEFT", r.icon, "RIGHT", 6, 0)
            r.name:SetPoint("RIGHT", r, "RIGHT", -30, 0)
            r.name:SetJustifyH("LEFT")
            r.count = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            r.count:SetPoint("RIGHT", r, "RIGHT", -6, 0)
            r:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
            r:SetScript("OnClick", function(self)
                if self.entry then AssignEntry(self.entry) end
            end)
            r:SetScript("OnMouseDown", function(self, button)
                if button == "RightButton" and self.entry then ShowEntryTooltip(self.entry) end
            end)
            r:SetScript("OnMouseUp", function(self, button)
                if button == "RightButton" then HideEntryTooltip() end
            end)
            r:SetScript("OnEnter", function(self)
                if self.entry then ShowEntryTooltip(self.entry) end
            end)
            r:SetScript("OnLeave", HideEntryTooltip)
            rowPool[usedRows] = r
        end
        r:Show()
        return r
    end
    local function GetHeader(text)
        usedHeaders = usedHeaders + 1
        local h = headerPool[usedHeaders]
        if not h then
            h = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            h:SetTextColor(1, 0.82, 0)
            headerPool[usedHeaders] = h
        end
        h:SetText(text)
        h:Show()
        return h
    end
    for k = usedRows + 1, #rowPool do rowPool[k]:Hide() end
    for k = usedHeaders + 1, #headerPool do headerPool[k]:Hide() end

    local y = 0
    local lastKind = nil
    for _, entry in ipairs(entries) do
        if entry.kind ~= lastKind then
            lastKind = entry.kind
            local h = GetHeader(GROUP_NAMES[entry.kind] or entry.kind)
            h:ClearAllPoints()
            h:SetPoint("TOPLEFT", content, "TOPLEFT", 4, -y)
            h:SetPoint("TOPRIGHT", content, "TOPRIGHT", -4, -y)
            y = y + HEADER_H
        end
        local r = GetRow()
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        r:SetWidth(content:GetWidth())
        r.entry = entry
        r.icon:SetTexture(entry.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        r.icon:Show()
        r.name:SetText(entry.name or "")
        local txt = ""
        if entry.kind == "item" then
            if entry.count and entry.count > 1 then txt = tostring(entry.count) end
        elseif tonumber(entry.dur) and entry.dur > 0 then
            txt = string.format("%dm", math.ceil(entry.dur / 60))
        end
        r.count:SetText(txt)
        y = y + ROW_H
    end
    content:SetHeight(y)
    local viewH = (menu:GetHeight() or MENU_H) - 44 - 12
    local maxScroll = math.max(0, y - viewH)
    scrollBar:SetMinMaxValues(0, maxScroll)
    scrollBar:SetValue(0)
    content:ClearAllPoints()
    content:SetPoint("TOPLEFT", viewport, "TOPLEFT", 0, 0)
end

local function OpenPicker(btnIndex)
    if not active then return end
    pickerButton = btnIndex
    if not menu then CreateMenu() end
    entries = BuildEntries()
    MobileUI_Debug(string.format("DynamicBar: picker opened btn=%d entries=%d",
        btnIndex, #entries))
    menuTitle:SetText("Assign to button " .. (btnIndex - FIRST_BTN + 1))
    if InCombatLockdown() then
        menuHint:SetText("Assigning is disabled in combat.")
    elseif #entries == 0 then
        menuHint:SetText("No usable items or buff spells found.")
    else
        menuHint:SetText("Tap to assign, hold for tooltip.")
    end
    menu:SetSize(MENU_W, math.min(MENU_H, math.max(200, UIParent:GetHeight() - 30)))
    RebuildList()
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
    MobileUI_Debug(string.format("DynamicBar: picker shown for btn %d", btnIndex))
end

-- ============================================================================
-- Assignment (slot-based; never on the taint-protected use path)
-- ============================================================================
-- Returns whatever is on the cursor: items to a free bag slot (so a
-- PlaceAction exchange of a previous item assignment is never lost),
-- anything else (spell / macro) dropped.
ReturnCursorContent = function()
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
    -- The hold's right-UP fired the stock PickupAction: the slot's previous
    -- content may be on the cursor — put it back before the new pickup.
    if GetCursorInfo() then
        if PlaceAction then PlaceAction(slot) end
        if GetCursorInfo() then ReturnCursorContent() end
    end
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
-- Strip buttons + hold detection (OnMouseDown on the stock button)
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
    -- Circular skin, same as the arc (layer-3 look).
    if MobileUILayout and MobileUILayout.SkinButton then
        MobileUILayout.SkinButton(b, {
            Icon     = _G["MultiBarBottomLeftButton" .. i .. "Icon"],
            Cooldown = _G["MultiBarBottomLeftButton" .. i .. "Cooldown"],
            Count    = _G["MultiBarBottomLeftButton" .. i .. "Count"],
            Flash    = _G["MultiBarBottomLeftButton" .. i .. "Flash"],
        })
    end
    -- Hold detection: right-down opens the picker (works for empty and
    -- filled slots). The left path is untouched — the stock OnClick still
    -- fires UseAction on left-up with no addon on the stack. The stock
    -- right-click pickup on release lands on the cursor; the menu OnHide
    -- re-places it.
    b:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            MobileUI_Debug(string.format("DynamicBar: btn %s hold", tostring(self:GetName())))
            local ok, err = pcall(OpenPicker, i)
            if not ok then
                MobileUI_Debug("DynamicBar: OpenPicker ERROR: " .. tostring(err))
            end
        elseif MobileDB and MobileDB.debug then
            MobileUI_Debug(string.format("DynamicBar: btn %s down button=%s",
                tostring(self:GetName()), tostring(button)))
        end
    end)
    b:Show()
    return true
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
        if ShowButton(i, size, x0, y, pitch) then usedButtons[i] = true end
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
        local b = _G["MultiBarBottomLeftButton" .. i]
        if b then
            b:SetScript("OnMouseDown", nil)
            if MobileUILayout and MobileUILayout.UnskinButton then
                MobileUILayout.UnskinButton(b)
            end
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
