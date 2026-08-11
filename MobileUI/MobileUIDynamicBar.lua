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
--   Hold (right click) -> assign: an OnMouseDown script installed on the
--                         stock button (same way the layout installs OnEnter
--                         on the arc buttons) opens the picker on right-down:
--                         usable bag items (GetItemSpell ~= nil) + known
--                         non-passive spells, active player buffs sorted
--                         first. Tapping an entry assigns it to the button's
--                         action slot via PickupContainerItem/PickupSpell +
--                         PlaceAction — not on the taint-protected use path.
--                         The stock right-click pickup on release puts the
--                         slot's item on the cursor; ClosePicker / AssignEntry
--                         re-place it (PlaceAction) so nothing is lost.
--
-- Why no catcher overlay: a Button with RegisterForClicks(right-only) got
-- NO mouse events on this client (verified in-game via the debug ring), and
-- a plain Frame overlay would also eat left taps (no pass-through here). A
-- direct OnMouseDown script is the minimal proven mechanic — the layout
-- already installs scripts on the arc buttons and casting stays clean.
--
-- Assignments live in the client's action-bar save data (slots 66-70), so
-- they persist across reload/logout for free. Revert re-parks the tail
-- buttons exactly as the layout left them (off-screen) but leaves the slot
-- contents in place (they are the player's own action slots).
--
-- In-game verification notes (first session):
--   1. The OnMouseDown script on the stock button does not taint the
--      left-click use path (no 'UseAction()' taint error on tap).
--   2. PickupContainerItem -> PlaceAction assigns cleanly on this client.
--   3. PickupSpellBookItem vs PickupSpell — both are tried; log which exists.
--   4. The right-up stock pickup is re-placed by ClosePicker (no cursor
--      item left dangling when the picker is dismissed).

local FIRST_BTN = 6      -- MultiBarBottomLeftButton6..10
local MAX_BTN   = 5      -- up to 5 buttons (6-10)
local function SlotForButton(i) return 60 + i end -- Ascension: bar2 attached => slots 61-72

local PITCH_GAP      = 4
local STRIP_MARGIN   = 8   -- gap after the bag button
local STRIP_END_MARG = 8   -- gap before the player frame

local COLS, ROWS, CELL = 4, 3, 52
local PER_PAGE = COLS * ROWS

MobileUIDynamicBar = {}

local usedButtons = {}   -- [btnIndex] = true while the strip is active
local active     = false
local pendingDefer = nil

local menu, clickCatcher, menuTitle, menuHint
local menuCells, prevBtn, nextBtn, pageLabel
local pickerButton, entries, curPage, pages
-- Forward refs: assigned below; referenced by the menu cells' OnClick and by
-- ClosePicker (which runs before they are defined).
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
-- 3.3.5 has no spell-duration API, so buff durations come from the tooltip
-- ("Duration: X min/sec") — the standard addon technique. Cached per spell id.
local durTip   = CreateFrame("GameTooltip", "MobileUIDynamicBarTip", UIParent, "GameTooltipTemplate")
durTip:SetOwner(UIParent, "ANCHOR_NONE")
local durCache = {}

local function SpellDuration(spellID)
    if durCache[spellID] ~= nil then return durCache[spellID] end
    local dur
    if spellID and durTip then
        local ok = pcall(durTip.SetSpellByID, durTip, spellID)
        if ok then
            for line = 1, durTip:GetNumTooltipLines() do
                local fs = _G["MobileUIDynamicBarTipTextLeft" .. line]
                local text = fs and fs:GetText() or ""
                local n, unit = text:match("^Duration: (%d+) ?(min|sec|hr)")
                if n then
                    n = tonumber(n)
                    if unit == "min" then dur = n * 60
                    elseif unit == "sec" then dur = n
                    else dur = n * 3600 end
                    break
                end
            end
        end
    end
    durCache[spellID] = dur or false
    return dur
end

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
    -- --- Buff spells: long friendly buffs (>= 10 min) or active buffs --------
    -- Candidates: helpful (usable on player/friendly) minus attack spells
    -- minus passives. Then a duration filter: keep spells whose tooltip says
    -- "Duration: X min" with X >= 10, plus spells currently active on the
    -- player that show no tooltip duration (custom buffs that are up).
    -- Everything else (mounts, racials, toggles, resurrections, teleports,
    -- heals, short buffs) is dropped. Safety: if the duration filter keeps
    -- nothing, fall back to the candidate list so the picker never goes empty.
    local buffSet = {}
    for i = 1, 40 do
        local name, _, _, _, dur = UnitBuff("player", i)
        if not name then break end
        buffSet[name] = dur or 0
    end
    local candidates = {}
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
                    local keep    = true
                    if passive then keep = false end
                    if attack  then keep = false end
                    -- Restrict to friendly-target spells only when the API exists.
                    if IsHelpfulSpell and not IsHelpfulSpell(i, "spell") then keep = false end
                    if keep then
                        table.insert(candidates, {
                            kind = "spell", spellbookID = i, name = sname,
                            icon = GetSpellTexture and GetSpellTexture(i, "spell"),
                            buff = buffSet[sname] ~= nil,
                            dur  = buffSet[sname] or 0,
                        })
                    end
                end
            end
        end
    end
    local spells, keptNames, droppedNames = {}, {}, {}
    for _, sp in ipairs(candidates) do
        local sid = select(7, GetSpellInfo(sp.spellbookID, "spell"))
        local total = SpellDuration(sid) or 0
        local src = total > 0 and "tooltip" or "none"
        -- 600s = 10 min. Active custom buffs with no tooltip duration are
        -- kept (they are clearly buffs — we can see them on the player).
        local long = total >= 600 or (sp.buff and total == 0)
        if long then
            table.insert(spells, sp)
            table.insert(keptNames, sp.name)
        else
            table.insert(droppedNames, string.format("%s(%s:%ds)", sp.name, src, total))
        end
    end
    if #spells == 0 and #candidates > 0 then
        spells = candidates
        MobileUI_Debug("DynamicBar: duration filter kept 0 — falling back to candidates")
    end
    MobileUI_Debug(string.format(
        "DynamicBar: spell scan (bookname=%s bookinfo=%s) %d checked -> %d candidates -> %d kept: %s",
        tostring(GetSpellBookItemName ~= nil), tostring(GetSpellBookItemInfo ~= nil),
        checked, #candidates, #spells, table.concat(keptNames, ", ")))
    if #droppedNames > 0 then
        MobileUI_Debug("DynamicBar: dropped: " .. table.concat(droppedNames, ", "))
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
            local txt = ""
            if entry.kind == "item" then
                if entry.count and entry.count > 1 then txt = tostring(entry.count) end
            elseif entry.kind == "spell" and entry.dur and entry.dur > 0 then
                txt = string.format("%dm", math.ceil(entry.dur / 60))
            end
            cell.count:SetText(txt)
            cell.name:SetText(entry.name or "")
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
    -- The hold's right-UP fires the stock ActionButton_OnClick, which does
    -- PickupAction on the slot — so the slot's item can be sitting on the
    -- cursor when the picker closes without an assignment. Put it back.
    if pickerButton and GetCursorInfo() then
        local slot = SlotForButton(pickerButton)
        if PlaceAction then PlaceAction(slot) end
        if GetCursorInfo() then ReturnCursorContent() end -- place failed
    end
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
        cell.name = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cell.name:SetPoint("BOTTOM", cell, "BOTTOM", 0, 2)
        cell.name:SetWidth(CELL - 4)
        cell.name:SetJustifyH("CENTER")
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
    MobileUI_Debug(string.format("DynamicBar: picker opened btn=%d entries=%d pages=%d",
        btnIndex, #entries, pages))
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
    -- Hold detection: right-down opens the picker (works for empty and
    -- filled slots). The left path is untouched — the stock OnClick still
    -- fires UseAction on left-up with no addon on the stack. The stock
    -- right-click pickup on release lands on the cursor; ClosePicker and
    -- AssignEntry re-place it.
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
