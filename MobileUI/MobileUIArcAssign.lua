-- MobileUIArcAssign.lua - Quick-assign picker for the right thumb arc buttons
--
-- Installs hold-to-assign on all 15 arc buttons (ActionButton1-10 +
-- MultiBarBottomLeftButton1-5). The picker shows class specialization spell
-- tabs (skipping General/tab 1) plus a Macros category — 4 columns total.
-- For the 10 main bar buttons, the action slot is resolved via
-- ResolveScatterAction to respect stance/stealth flipping — assigning to
-- whichever page is currently active (stealth bar if in stealth, main bar
-- if not). After assignment, RefreshScatterButtons redraws the icon (these
-- buttons have OnEvent cleared so the client won't update them).
--
-- Cast block: same Disable() approach as the DynamicBar. On hold
-- (RightButton), Disable() the button so the stock OnClick (UseAction) from
-- the left-up at finger lift is swallowed. Re-enable on picker close.
--
-- Assignment path: PickupSpellBookItem / PickupMacro + PlaceAction — not on
-- the taint-protected use path, same as the DynamicBar.
--
-- All spells from the specialization tabs are shown (no filtering for
-- passive/attack/harmful — the user wants every class spell available).

MobileUIArcAssign = {}

-- ============================================================================
-- Constants
-- ============================================================================
local COL_W       = 160
local COL_GAP      = 8
local PADDING      = 14
local CELL_W       = 76
local CELL_H       = 26
local CELL_GAP     = 4
local ROW_GAP      = 2
local HEADER_H     = 22
local COLS_PER_CAT = 2
local MENU_H_MAX   = 460
local MAX_COLS     = 6   -- max spell tabs + macros

-- Keybind labels for the menu title.
local SCATTER_KEYS = { "1","2","3","4","5","6","7","8","9","0" }
local BAR2_KEYS    = { "Q","E","R","T","F" }

-- ============================================================================
-- State
-- ============================================================================
local menu, clickCatcher, menuTitle, menuHint, closeBtn
local columns = {}           -- pre-created column slots [ci] = { header, cells={} }
local pickerCtx = nil        -- { btn, slot, isScatter, keyLabel }
local armedCell = nil
local menuReady = false
local arcEntries = {}        -- categories built by BuildArcEntries
local active = false

-- Forward refs (assigned below; referenced by cell OnClick and menu OnHide)
local AssignArcEntry, ReturnCursorContent

-- ============================================================================
-- Helpers
-- ============================================================================

-- Resolve a scatter button's action slot exactly as
-- ActionButton_CalculateAction will at click time (actionpage attribute
-- first, then GetActionBarPage). Duplicate of MobileUIActionFlip's local
-- (kept here to avoid modifying that module).
local function ResolveScatterAction(btn, fallbackId)
    local id = btn:GetID()
    if not id or id < 1 then id = fallbackId end
    local attrPage = tonumber(SecureButton_GetModifiedAttribute(btn, "actionpage"))
    local page = attrPage or (GetActionBarPage() or 1)
    local action = id + (page - 1) * (NUM_ACTIONBAR_BUTTONS or 12)
    return action
end

local function CloseArcPicker()
    if menu then menu:Hide() end
end

-- Returns whatever is on the cursor: items to a free bag slot, anything
-- else (spell / macro) dropped. Same as DynamicBar's ReturnCursorContent.
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

-- ============================================================================
-- Entry building
-- ============================================================================
-- Scans spellbook tabs, skipping General (tab 1) and the "Ascension Vanity
-- Items" tab. Groups all spells by their tab name and deduplicates by spell
-- name, keeping only the highest rank. Adds a Macros category at the end.
-- No passive/attack/harmful filtering — every class spell is shown.
local function BuildArcEntries()
    local cats = {}
    local spellNameFn = GetSpellBookItemName or GetSpellName
    local nt = GetNumSpellTabs() or 0
    for tab = 1, nt do
        local tname, _, offset, num = GetSpellTabInfo(tab)
        if tname and offset and num and num > 0 then
            -- Skip General (always tab 1) and vanity/item tabs (e.g.
            -- "Ascension Vanity Items") — these are not class specializations.
            local lower = tname:lower()
            if tab ~= 1 and not lower:find("vanity") then
                local entries = {}
                -- Deduplicate by spell name: keep only the highest rank.
                -- GetSpellBookItemName returns name, rank; rank is like
                -- "Rank 1", "Rank 2". Spells with no rank get rankNum 0.
                local best = {}  -- [spellName] = { entry, rankNum }
                for i = offset + 1, offset + num do
                    local sname, srank = spellNameFn and spellNameFn(i, "spell")
                    if not sname and GetSpellBookItemInfo then
                        local stype, sid = GetSpellBookItemInfo(i, "spell")
                        if stype == "SPELL" and sid then
                            sname, srank = GetSpellInfo(sid)
                        end
                    end
                    if sname then
                        local rankNum = 0
                        if srank then
                            local r = tonumber(srank:match("Rank%s*(%d+)"))
                            if r then rankNum = r end
                        end
                        local prev = best[sname]
                        if not prev or rankNum > prev.rankNum then
                            best[sname] = {
                                rankNum = rankNum,
                                entry = {
                                    kind = "spell",
                                    spellbookID = i,
                                    name = sname,
                                    icon = GetSpellTexture and GetSpellTexture(i, "spell") or nil,
                                },
                            }
                        end
                    end
                end
                for _, info in pairs(best) do
                    table.insert(entries, info.entry)
                end
                table.sort(entries, function(a, b) return a.name < b.name end)
                table.insert(cats, { name = tname, entries = entries })
            end
        end
    end
    -- Macros
    local macroEntries = {}
    local numAccount, numChar = GetNumMacros()
    numAccount = numAccount or 0
    numChar = numChar or 0
    for i = 1, numAccount + numChar do
        local mname, micon = GetMacroInfo(i)
        if mname then
            table.insert(macroEntries, {
                kind = "macro",
                macroIndex = i,
                name = mname,
                icon = micon,
            })
        end
    end
    table.sort(macroEntries, function(a, b) return a.name < b.name end)
    table.insert(cats, { name = "Macros", entries = macroEntries })
    local totalSpells = 0
    for _, c in ipairs(cats) do totalSpells = totalSpells + #c.entries end
    MobileUI_Debug(string.format("ArcAssign: %d categories, %d spells, %d macros",
        #cats, totalSpells - #macroEntries, #macroEntries))
    return cats
end

-- ============================================================================
-- Tooltip
-- ============================================================================
local function ShowEntryTooltip(cell, entry)
    if not entry then return end
    if entry.kind == "macro" then return end -- no macro tooltip API in 3.3.5a
    local ok, err = pcall(function()
        GameTooltip:SetOwner(cell or menu, "ANCHOR_RIGHT")
        if entry.spellbookID and GameTooltip.SetSpell then
            GameTooltip:SetSpell(entry.spellbookID, "spell")
        elseif entry.spellbookID and GameTooltip.SetSpellBookItem then
            GameTooltip:SetSpellBookItem(entry.spellbookID, "spell")
        end
        GameTooltip:Show()
    end)
    if not ok then
        MobileUI_Debug("ArcAssign: tooltip ERROR: " .. tostring(err))
    end
end

local function HideEntryTooltip()
    if GameTooltip then GameTooltip:Hide() end
end

-- ============================================================================
-- Menu (created once, reused)
-- ============================================================================
local function CreateMenu()
    if menu then menu:Hide() end
    menu = CreateFrame("Frame", "MobileUIArcAssignMenu", UIParent)
    menu:SetSize(692, MENU_H_MAX)
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
        if key == "ESCAPE" then CloseArcPicker() end
    end)
    table.insert(UISpecialFrames, "MobileUIArcAssignMenu")

    menu:SetScript("OnHide", function()
        if armedCell then
            armedCell:SetBackdropBorderColor(1, 0.82, 0, 0)
            armedCell = nil
        end
        HideEntryTooltip()
        if pickerCtx and GetCursorInfo() then
            if PlaceAction then PlaceAction(pickerCtx.slot) end
            if GetCursorInfo() then ReturnCursorContent() end
        end
        if pickerCtx and pickerCtx.btn then
            pcall(function() pickerCtx.btn:Enable() end)
        end
        pickerCtx = nil
        if clickCatcher then clickCatcher:Hide() end
    end)
    menu:Hide()

    menuTitle = menu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    menuTitle:SetPoint("TOPLEFT", menu, "TOPLEFT", PADDING, -10)
    menuTitle:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -34, -10)

    menuHint = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    menuHint:SetPoint("TOPLEFT", menu, "TOPLEFT", PADDING, -26)
    menuHint:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -34, -26)
    menuHint:SetTextColor(0.6, 0.6, 0.6)

    closeBtn = CreateFrame("Button", nil, menu)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -8, -8)
    closeBtn:SetNormalFontObject(GameFontNormal)
    closeBtn:SetText("X")
    closeBtn:SetScript("OnClick", CloseArcPicker)

    -- Pre-create MAX_COLS column slots (headers + pooled cells)
    for ci = 1, MAX_COLS do
        local col = { cells = {} }
        col.header = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        col.header:SetTextColor(1, 0.82, 0)
        columns[ci] = col
    end

    -- Full-screen catcher: a tap anywhere outside dismisses
    clickCatcher = CreateFrame("Frame", "MobileUIArcAssignCatcher", UIParent)
    clickCatcher:SetAllPoints(UIParent)
    clickCatcher:SetFrameStrata("DIALOG")
    clickCatcher:EnableMouse(true)
    clickCatcher:SetScript("OnMouseDown", CloseArcPicker)
    menuReady = true
end

-- Get (or lazily create) the n-th cell of a column. Pooled.
local function GetCell(colIdx, n)
    local col = columns[colIdx]
    local cell = col.cells[n]
    if not cell then
        cell = CreateFrame("Button", nil, menu)
        cell:SetSize(CELL_W, CELL_H)
        cell.icon = cell:CreateTexture(nil, "BACKGROUND")
        cell.icon:SetSize(20, 20)
        cell.icon:SetPoint("LEFT", cell, "LEFT", 2, 0)
        cell.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        cell.name = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cell.name:SetPoint("LEFT", cell.icon, "RIGHT", 3, 0)
        cell.name:SetPoint("RIGHT", cell, "RIGHT", -2, 0)
        cell.name:SetJustifyH("LEFT")
        cell:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        cell:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        cell:SetBackdropBorderColor(1, 0.82, 0, 0)
        cell:SetScript("OnEnter", function(self)
            if self.entry then ShowEntryTooltip(self, self.entry) end
        end)
        cell:SetScript("OnClick", function(self, button)
            if not self.entry then return end
            if armedCell == self then
                armedCell = nil
                self:SetBackdropBorderColor(1, 0.82, 0, 0)
                HideEntryTooltip()
                AssignArcEntry(self.entry)
            else
                if armedCell then
                    armedCell:SetBackdropBorderColor(1, 0.82, 0, 0)
                end
                armedCell = self
                self:SetBackdropBorderColor(1, 0.82, 0, 0.9)
                ShowEntryTooltip(self, self.entry)
            end
        end)
        cell:SetScript("OnLeave", HideEntryTooltip)
        col.cells[n] = cell
    end
    return cell
end

-- Fill columns from arcEntries. Cell height adapts so the tallest column fits.
local function PopulateColumns()
    local numCats = #arcEntries
    if numCats < 1 then numCats = 1 end -- avoid div-by-zero
    local menuW = numCats * COL_W + (numCats - 1) * COL_GAP + 2 * PADDING

    local maxRows = 0
    for ci = 1, #arcEntries do
        local rows = math.ceil(#arcEntries[ci].entries / COLS_PER_CAT)
        if rows > maxRows then maxRows = rows end
    end
    if maxRows < 1 then maxRows = 1 end

    local capH = math.min(MENU_H_MAX, UIParent:GetHeight() - 30)
    local availH = capH - 44 - HEADER_H - 12
    local cellH = math.max(20, math.min(CELL_H, math.floor(availH / maxRows)))
    local rowH = cellH + ROW_GAP

    for ci = 1, #arcEntries do
        local cat = arcEntries[ci]
        local col = columns[ci]
        col.header:SetText(cat.name)
        col.header:ClearAllPoints()
        col.header:SetPoint("TOPLEFT", menu, "TOPLEFT",
            PADDING + (ci - 1) * (COL_W + COL_GAP), -44)
        col.header:Show()

        local colX = PADDING + (ci - 1) * (COL_W + COL_GAP)
        for n, e in ipairs(cat.entries) do
            local sc = (n - 1) % COLS_PER_CAT
            local r  = math.floor((n - 1) / COLS_PER_CAT)
            local cell = GetCell(ci, n)
            cell:ClearAllPoints()
            cell:SetPoint("TOPLEFT", menu, "TOPLEFT",
                colX + sc * (CELL_W + CELL_GAP), -44 - HEADER_H - r * rowH)
            cell:SetSize(CELL_W, cellH)
            cell.entry = e
            cell:SetBackdropBorderColor(1, 0.82, 0, 0)
            cell.icon:SetTexture(e.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            cell.icon:Show()
            cell.name:SetText(e.name or "")
            cell:Show()
        end
        for n = #cat.entries + 1, #col.cells do col.cells[n]:Hide() end
    end

    -- Hide unused columns
    for ci = #arcEntries + 1, MAX_COLS do
        columns[ci].header:Hide()
        for n = 1, #columns[ci].cells do columns[ci].cells[n]:Hide() end
    end

    local frameH = 44 + HEADER_H + maxRows * rowH + 12
    menu:SetSize(menuW, math.min(capH, frameH))
end

-- ============================================================================
-- Open picker
-- ============================================================================
local function OpenArcPicker(btn, slot, isScatter, keyLabel)
    if not active then return end
    if not menuReady then CreateMenu() end
    pickerCtx = { btn = btn, slot = slot, isScatter = isScatter, keyLabel = keyLabel }
    arcEntries = BuildArcEntries()
    MobileUI_Debug(string.format("ArcAssign: open key=%s slot=%d scatter=%s cats=%d",
        tostring(keyLabel), slot, tostring(isScatter), #arcEntries))
    menuTitle:SetText("Assign to [" .. (keyLabel or "?") .. "]")
    if InCombatLockdown() then
        menuHint:SetText("Assigning is disabled in combat.")
    else
        menuHint:SetText("First tap: tooltip.  Second tap: assign.")
    end
    PopulateColumns()
    menu:ClearAllPoints()
    menu:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
    clickCatcher:Show()
    menu:SetFrameLevel(clickCatcher:GetFrameLevel() + 2)
    menu:Show()
end

-- ============================================================================
-- Assignment
-- ============================================================================
AssignArcEntry = function(entry)
    if not pickerCtx then return end
    if InCombatLockdown() then
        MobileUI_Debug("ArcAssign: assign blocked in combat")
        CloseArcPicker()
        return
    end
    local slot = pickerCtx.slot
    -- Clean cursor (edge case: something already on cursor)
    if GetCursorInfo() then
        if PlaceAction then PlaceAction(slot) end
        if GetCursorInfo() then ReturnCursorContent() end
    end
    if entry.kind == "spell" then
        local pickup = PickupSpellBookItem or PickupSpell
        if pickup then pickup(entry.spellbookID, "spell") end
        if PlaceAction then PlaceAction(slot) end
        if GetCursorInfo() then ReturnCursorContent() end
        MobileUI_Debug(string.format("ArcAssign: assigned spell '%s' to slot %d", entry.name, slot))
    elseif entry.kind == "macro" then
        if PickupMacro then PickupMacro(entry.macroIndex) end
        if PlaceAction then PlaceAction(slot) end
        if GetCursorInfo() then ReturnCursorContent() end
        MobileUI_Debug(string.format("ArcAssign: assigned macro '%s' to slot %d", entry.name, slot))
    end
    -- Refresh display for scatter buttons (OnEvent cleared — the client
    -- won't redraw the icon after assignment).
    if pickerCtx.isScatter and MobileUIActionFlip then
        pcall(MobileUIActionFlip.RefreshScatterButtons)
    end
    CloseArcPicker()
end

-- ============================================================================
-- Public API
-- ============================================================================
function MobileUIArcAssign:Apply()
    if not MobileDB or not MobileDB.layoutEnabled then return end
    if active then return end
    -- ActionButton1-10 (scatter arc; slot resolved via actionpage attribute
    -- to respect stance/stealth flipping)
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local keyLabel = SCATTER_KEYS[i]
            btn:SetScript("OnMouseDown", function(self, button)
                if button == "RightButton" then
                    MobileUI_Debug(string.format("ArcAssign: btn %s hold (key=%s)",
                        tostring(self:GetName()), tostring(keyLabel)))
                    pcall(function() self:Disable() end)
                    local slot = ResolveScatterAction(self, i)
                    OpenArcPicker(self, slot, true, keyLabel)
                end
            end)
        end
    end
    -- MultiBarBottomLeftButton1-5 (spots 11-15; fixed slots 61-65, no flip)
    for src = 1, 5 do
        local btn = _G["MultiBarBottomLeftButton" .. src]
        if btn then
            local keyLabel = BAR2_KEYS[src]
            btn:SetScript("OnMouseDown", function(self, button)
                if button == "RightButton" then
                    MobileUI_Debug(string.format("ArcAssign: btn %s hold (key=%s)",
                        tostring(self:GetName()), tostring(keyLabel)))
                    pcall(function() self:Disable() end)
                    local slot = 60 + src
                    OpenArcPicker(self, slot, false, keyLabel)
                end
            end)
        end
    end
    active = true
    MobileUI_Debug("ArcAssign: applied (15 arc buttons)")
end

function MobileUIArcAssign:Revert()
    if not active then return end
    CloseArcPicker()
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            btn:SetScript("OnMouseDown", nil)
            pcall(function() btn:Enable() end)
        end
    end
    for src = 1, 5 do
        local btn = _G["MultiBarBottomLeftButton" .. src]
        if btn then
            btn:SetScript("OnMouseDown", nil)
            pcall(function() btn:Enable() end)
        end
    end
    active = false
    MobileUI_Debug("ArcAssign: reverted")
end