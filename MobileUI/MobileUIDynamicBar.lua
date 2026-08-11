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
--                         picker is a COLUMN layout — one column per category
--                         (Items / Spells / Mounts), each a 2-wide grid of
--                         compact rows, frame height adapting to the tallest
--                         column. No scrolling at all. Tap a row to assign it
--                         to the button's action slot via PickupContainerItem
--                         / PickupSpell + PlaceAction (not on the taint-
--                         protected use path); tap a row once to preview its
--                         tooltip, tap it again to assign. Close via the X
--                         button, ESC, or a tap
--                         outside. The stock right-click pickup on release
--                         puts the slot's item on the cursor; the menu's
--                         OnHide re-places it (PlaceAction) so nothing is
--                         lost.
--
-- Why no overlay/catcher over the buttons: a Button with
-- RegisterForClicks(right-only) got NO mouse events on this client (verified
-- in-game via the debug ring), and a plain Frame overlay would also eat left
-- taps (no pass-through here). A direct OnMouseDown script is the minimal
-- proven mechanic — the layout already installs scripts on the arc buttons
-- and casting stays clean.
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
--   6. This client strips ScrollFrame:SetVerticalScroll, Slider:SetObeyStepOnDrag,
--      Frame:SetClipsChildren and GameTooltip:GetNumTooltipLines, so the
--      picker uses a column layout with no scrolling at all.
--   7. The stance/stealth filter (tooltip GetRegions scan for "Requires
--      Stealth/Form/Stance") drops Palm Sigil without dropping normal buffs.

local FIRST_BTN = 6      -- MultiBarBottomLeftButton6..11
local MAX_BTN   = 6      -- 6 buttons (6-11)
local TARGET_SIZE = 64    -- layer-3 arc size; shrinks to fit the gap
local function SlotForButton(i) return 60 + i end -- Ascension: bar2 attached => slots 61-72

local PITCH_GAP      = 4
local STRIP_MARGIN   = 8   -- gap after the bag button
local STRIP_END_MARG = 8   -- gap before the player frame

-- Picker: 4 category columns (Items / Spells / Mounts / Professions), each
-- a 2-wide grid of compact rows. No scrolling — the frame height adapts to
-- the tallest column (cell height shrinks if a category is long).
local MENU_W       = 692  -- 4 cols x 160 + 3 gaps x 8 + 2 x 14 padding
local MENU_H_MAX   = 460
local COL_W        = 160
local COL_GAP      = 8
local CELL_W       = 76
local CELL_H       = 26
local CELL_GAP     = 4
local ROW_GAP      = 2
local HEADER_H     = 22
local COLS_PER_CAT = 2
local GROUP_NAMES = {
    item  = "Items",
    spell = "Spells",
    mount = "Mounts",
    prof  = "Professions",
}
local GROUP_ORDER = { "item", "spell", "mount", "prof" }

MobileUIDynamicBar = {}

local usedButtons = {}   -- [btnIndex] = true while the strip is active
local active     = false
local pendingDefer = nil

local menu, clickCatcher, menuTitle, menuHint, closeBtn
local columns = {}       -- [kind] = { header = fs, cells = {} }
local pickerButton, entries
local menuReady = false  -- true only after CreateMenu fully builds the menu
local armedCell = nil    -- picker cell armed by a first tap (second tap assigns)
-- Forward refs: assigned below; referenced by the menu cells' OnClick and by
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

local stanceCache = {}
-- Detect spells that require a stance/stealth (e.g. "Requires Stealth",
-- "Requires Moonshroud" — Ascension's custom stealth skill) by scanning the
-- tooltip's font strings. The tooltip line-reading API (GetNumTooltipLines)
-- is stripped on this client, so we iterate GetRegions() instead.
--
-- A "Requires X" line is a stance/stealth requirement when X is a skill
-- name: single word (or "the <word>"), not "level N", not "a/an <item>".
-- Standard stances also match the Stealth/Form/Stance keywords. Cached by
-- name; every Requires line is logged so the heuristic can be tuned.
local function SpellRequiresStance(spellbookID, sname)
    if stanceCache[sname] ~= nil then return stanceCache[sname] end
    if not GameTooltip or not GameTooltip.SetSpell then return false end
    local requires = false
    local ok, err = pcall(function()
        GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        GameTooltip:SetSpell(spellbookID, "spell")
        for _, r in ipairs({ GameTooltip:GetRegions() }) do
            if r and r.GetText and r:GetObjectType() == "FontString" then
                local t = (r:GetText() or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("^%s+", "")
                local req = t:match("^Requires%s*:?%s*(.+)$")
                if req then
                    -- "Requires Enchanting (350)" — a profession rank
                    -- requirement, not a stance. Keep (profession spells are
                    -- handled by the profession detection, not this filter).
                    local hasRank = req:match("%(%d+%)") ~= nil
                    req = req:gsub("%s*%(.+%)%s*$", ""):gsub("[%.%s]+$", "")
                    if hasRank then
                        MobileUI_Debug(string.format("DynamicBar: stance-scan: %s requires '%s' (rank) -> keep", sname, req))
                    else
                        -- "X or Y" lists (e.g. "Runeshroud or Waveforged"): every
                        -- part must be stance-like (single word / keyword, not
                        -- "level N", not "a/an <item>").
                        local allStance = req:match("%S") ~= nil
                        for part in (req:gsub("%s+or%s+", "|")):gmatch("[^|]+") do
                            local rl = part:lower()
                            local core = part:gsub("^[Tt]he%s+", "")
                            local singleWord = not core:match("%s")
                            if rl:match("level") or rl:match("^a[n]?%s")
                               or not (rl:match("stealth") or rl:match("form") or rl:match("stance") or singleWord) then
                                allStance = false
                                break
                            end
                        end
                        if allStance then
                            requires = true
                            MobileUI_Debug(string.format("DynamicBar: stance-scan: %s requires '%s' -> FILTER", sname, req))
                            return
                        end
                        MobileUI_Debug(string.format("DynamicBar: stance-scan: %s requires '%s' -> keep", sname, req))
                    end
                end
            end
        end
    end)
    GameTooltip:Hide()
    if not ok then
        MobileUI_Debug("DynamicBar: stance-scan ERROR: " .. tostring(err))
    end
    stanceCache[sname] = requires
    return requires
end

-- Profession detection (filter, not whitelist): GetProfessions() is
-- stripped on this client, and profession spells live in the General tab
-- (not their own tab), so the names are DERIVED from the data instead:
--   * sub-skills/recipes carry a "Requires <Prof> (rank)" tooltip line
--     (e.g. Disenchant: "Requires Enchanting (1)") — that derives the
--     profession name;
--   * the profession skill itself (e.g. "Enchanting") has no such line,
--     but its NAME matches the derived profession name.
-- Two passes: first derive the profession names from every spell's tooltip,
-- then tag spells whose name matches a derived name or whose own tooltip has
-- a rank line. Cached by spellbookID (tooltip scans are the slow part).
local profNameCache = {}
local function SpellProfessionName(spellbookID)
    if profNameCache[spellbookID] ~= nil then return profNameCache[spellbookID] end
    local prof = nil
    if GameTooltip and GameTooltip.SetSpell then
        local ok = pcall(function()
            GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            GameTooltip:SetSpell(spellbookID, "spell")
            for _, r in ipairs({ GameTooltip:GetRegions() }) do
                if r and r.GetText and r:GetObjectType() == "FontString" then
                    local t = (r:GetText() or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("^%s+", "")
                    local req = t:match("^Requires%s*:?%s*(.+%(%d+%))%s*$")
                    if req then
                        prof = req:gsub("%s*%(%d+%)%s*$", ""):gsub("[%.%s]+$", "")
                        break
                    end
                end
            end
        end)
        GameTooltip:Hide()
        if not ok then
            MobileUI_Debug("DynamicBar: prof-name scan ERROR: " .. tostring(err))
        end
    end
    profNameCache[spellbookID] = prof
    return prof
end

local function BuildEntries()
    local items, spells, mounts, profs = {}, {}, {}, {}
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
    -- minus passives minus trade skills. Mounts are split out via the book
    -- type ("MOUNT") or a name heuristic (Ascension's custom mount spells
    -- report book type "SPELL").
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
    -- Pass 1: derive profession names from every spell's "Requires <Prof>
    -- (rank)" tooltip line (cached by spellbookID).
    local profByID   = {}  -- [spellbookID] = professionName (from rank line)
    local profNames  = {}  -- professionName -> professionName (derived)
    local nt0 = GetNumSpellTabs() or 0
    for tab = 1, nt0 do
        local _, _, offset, num = GetSpellTabInfo(tab)
        if offset and num then
            for i = offset + 1, offset + num do
                local pn = SpellProfessionName(i)
                if pn then
                    profByID[i] = pn
                    profNames[pn] = pn
                end
            end
        end
    end
    local profList = {}
    for pn in pairs(profNames) do table.insert(profList, pn) end
    table.sort(profList)
    MobileUI_Debug("DynamicBar: professions: " .. (#profList > 0 and table.concat(profList, ", ") or "none"))
    -- Scan ALL tabs: on Ascension the buffs live on custom tabs
    -- (Engravement / Glyphic / Riftblade), not just General. Profession
    -- spells are tagged via the derived names above and bypass the filters.
    local nt = GetNumSpellTabs() or 0
    local tabNames = {}
    for tab = 1, nt do
        local tname, _, _, tnum = GetSpellTabInfo(tab)
        table.insert(tabNames, string.format("%s(%s)", tname or "?", tostring(tnum)))
    end
    MobileUI_Debug("DynamicBar: spell tabs: " .. table.concat(tabNames, ", "))
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
                local profName = profByID[i] or profNames[sname]
                local keep    = true
                local why     = nil
                local kind    = nil
                if profName then
                    -- Profession spells are explicitly wanted: bypass the
                    -- candidate filters (the skill may read as passive, and
                    -- sub-skills carry "Requires <prof> (rank)" which the
                    -- stance filter would otherwise drop).
                    kind = "prof"
                else
                    local passive = IsPassiveSpell and IsPassiveSpell(i, "spell")
                    local attack  = IsAttackSpell and IsAttackSpell(i, "spell")
                    local harmful = IsHarmfulSpell and IsHarmfulSpell(i, "spell")
                    local trade   = IsTradeSkill and IsTradeSkill(i, "spell")
                    if passive then keep, why = false, "passive" end
                    if attack  then keep, why = false, "attack"  end
                    if harmful then keep, why = false, "harmful" end
                    -- NOTE: IsHelpfulSpell returns nil (not false) for harmful
                    -- spells AND for weapon enchants (Weapon Engraving, Palm
                    -- Sigil: Fire) on this client, so it can't be used as a
                    -- filter — IsHarmfulSpell above is the correct discriminator
                    -- (harmful spells have hrm=1, weapon enchants hrm=nil).
                    -- Profession recipes (trade skills) are not bar-worthy.
                    if trade then keep, why = false, "trade" end
                    if keep then
                        local btype = GetSpellBookItemInfo and select(1, GetSpellBookItemInfo(i, "spell"))
                        kind = (btype == "MOUNT" or sname:find("Mount", 1, true)) and "mount" or "spell"
                        -- The General tab is mostly racials/toggles/teleports;
                        -- keep only mounts and the Resurrect teleports from it.
                        if tab == 1 and kind ~= "mount" and not sname:find("Resurrect", 1, true) then
                            keep, why = false, "general"
                        end
                        -- Stance/stealth-required spells (Palm Sigil needs
                        -- Stealth) are useless on a tap bar.
                        if keep and SpellRequiresStance(i, sname) then
                            keep, why = false, "stance"
                        end
                    end
                end
                if keep then
                    local entry = {
                        kind = kind, spellbookID = i, name = sname,
                        icon = GetSpellTexture and GetSpellTexture(i, "spell"),
                        dur  = buffSet[sname] or 0,
                        prof = profName,
                    }
                    if kind == "prof" then
                        table.insert(profs, entry)
                    elseif kind == "mount" then
                        table.insert(mounts, entry)
                    else
                        table.insert(spells, entry)
                    end
                else
                    table.insert(rejected, string.format("%s(%s)", sname, why))
                end
            end
        end
    end
    end
    table.sort(spells, function(a, b) return a.name < b.name end)
    table.sort(mounts, function(a, b) return a.name < b.name end)
    table.sort(profs, function(a, b) return a.name < b.name end)
    local keptNames = {}
    for _, e in ipairs(spells) do table.insert(keptNames, e.name) end
    for _, e in ipairs(mounts) do table.insert(keptNames, e.name .. "[mount]") end
    for _, e in ipairs(profs) do table.insert(keptNames, e.name .. "[prof]") end
    MobileUI_Debug(string.format(
        "DynamicBar: spell scan (bookname=%s bookinfo=%s) %d checked -> %d candidates (%d spells, %d mounts, %d profs)",
        tostring(GetSpellBookItemName ~= nil), tostring(GetSpellBookItemInfo ~= nil),
        checked, #spells + #mounts + #profs, #spells, #mounts, #profs))
    MobileUI_Debug("DynamicBar: kept: " .. table.concat(keptNames, ", "))
    if #rejected > 0 then
        MobileUI_Debug("DynamicBar: candidate-rejected: " .. table.concat(rejected, ", "))
    end
    local out = {}
    for _, t in ipairs({ items, spells, mounts, profs }) do
        for _, e in ipairs(t) do table.insert(out, e) end
    end
    return out
end

-- Tooltip preview: hold (right button) on a cell shows the entry's tooltip;
-- release hides it. Also fires on hover for desktop. Uses the global
-- GameTooltip (the addon-created one lacks template methods on this client).
local function ShowEntryTooltip(cell, entry)
    if not entry then return end
    local ok, err = pcall(function()
        -- Anchor to the cell, not the menu: the menu is 520px wide near the
        -- left edge, so ANCHOR_RIGHT of the menu would push the tooltip
        -- off-screen on a phone.
        GameTooltip:SetOwner(cell or menu, "ANCHOR_RIGHT")
        if entry.kind == "item" then
            if entry.c and entry.s then
                GameTooltip:SetBagItem(entry.c, entry.s)
            else
                GameTooltip:SetItemByID(entry.id)
            end
        elseif entry.spellbookID then
            -- GetSpellBookItemInfo's 2nd return (spellID) is nil on this
            -- client and GetSpellInfo has no spellID return (9-value form),
            -- so SetSpellByID can't work. SetSpellBookItem is also stripped
            -- (verified in-game). SetSpell(id, "bookType") is the book-slot
            -- form that works.
            if GameTooltip.SetSpell then
                GameTooltip:SetSpell(entry.spellbookID, "spell")
            elseif GameTooltip.SetSpellBookItem then
                GameTooltip:SetSpellBookItem(entry.spellbookID, "spell")
            elseif entry.spellID then
                GameTooltip:SetSpellByID(entry.spellID)
            end
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

-- Get (or lazily create) the n-th cell of a category column. Cells are pooled
-- so repeated opens don't churn frame creation.
local function GetCell(kind, n)
    local col = columns[kind]
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
        cell.count = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        cell.count:SetPoint("BOTTOMRIGHT", cell.icon, "BOTTOMRIGHT", 0, 0)
        cell:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        -- Armed-state border: a gold outline marks the cell that will assign
        -- on the next tap.
        cell:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 2,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        cell:SetBackdropBorderColor(1, 0.82, 0, 0)
        -- Tap-tap: the first tap shows the tooltip and arms the cell (gold
        -- border); the second tap on the same cell assigns. Keyed purely on
        -- OnClick (which fires on every tap on this client — verified in the
        -- debug ring: 11 clicks logged in one open) with armedCell == self as
        -- the discriminator. OnEnter only shows the tooltip on hover; it does
        -- NOT arm, because OnEnter fires only on the first touch per open and
        -- cannot be relied on for the arm state.
        cell:SetScript("OnEnter", function(self)
            if self.entry then ShowEntryTooltip(self, self.entry) end
        end)
        cell:SetScript("OnClick", function(self, button)
            MobileUI_Debug(string.format("DynamicBar: cell click btn=%s armed=%s entry=%s",
                tostring(button), tostring(armedCell == self),
                self.entry and self.entry.name or "nil"))
            if not self.entry then return end
            if armedCell == self then
                -- second tap on the same cell: assign
                armedCell = nil
                self:SetBackdropBorderColor(1, 0.82, 0, 0)
                HideEntryTooltip()
                AssignEntry(self.entry)
            else
                -- first tap: arm it
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

local function CreateMenu()
    if menu then menu:Hide() end -- a partial menu from an aborted build
    menu = CreateFrame("Frame", "MobileUIDynamicBarMenu", UIParent)
    menu:SetSize(MENU_W, MENU_H_MAX)
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
        if armedCell then
            armedCell:SetBackdropBorderColor(1, 0.82, 0, 0)
            armedCell = nil
        end
        HideEntryTooltip()
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

    -- 4 category columns: header + pooled cells.
    for ci, kind in ipairs(GROUP_ORDER) do
        local col = { cells = {} }
        col.header = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        col.header:SetText(GROUP_NAMES[kind])
        col.header:SetTextColor(1, 0.82, 0)
        col.header:SetPoint("TOPLEFT", menu, "TOPLEFT", 14 + (ci - 1) * (COL_W + COL_GAP), -44)
        columns[kind] = col
    end

    -- Full-screen catcher below the menu: a tap anywhere outside dismisses
    -- (same pattern as the bag-swap menu).
    clickCatcher = CreateFrame("Frame", "MobileUIDynamicBarCatcher", UIParent)
    clickCatcher:SetAllPoints(UIParent)
    clickCatcher:SetFrameStrata("DIALOG")
    clickCatcher:EnableMouse(true)
    clickCatcher:SetScript("OnMouseDown", ClosePicker)
    menuReady = true
end

-- Fill the category columns from the current entries. Cell height adapts so
-- the tallest column fits the frame (no scrolling).
local function PopulateColumns()
    local byKind = { item = {}, spell = {}, mount = {}, prof = {} }
    for _, e in ipairs(entries) do
        local t = byKind[e.kind]
        if t then table.insert(t, e) end
    end
    local maxRows = 0
    for _, kind in ipairs(GROUP_ORDER) do
        local rows = math.ceil(#byKind[kind] / COLS_PER_CAT)
        if rows > maxRows then maxRows = rows end
    end
    local capH = math.min(MENU_H_MAX, UIParent:GetHeight() - 30)
    local availH = capH - 44 - HEADER_H - 12
    local cellH = math.max(20, math.min(CELL_H, math.floor(availH / math.max(1, maxRows))))
    local rowH = cellH + ROW_GAP
    for ci, kind in ipairs(GROUP_ORDER) do
        local col = columns[kind]
        local list = byKind[kind]
        local colX = 14 + (ci - 1) * (COL_W + COL_GAP)
        for n, e in ipairs(list) do
            local sc = (n - 1) % COLS_PER_CAT
            local r  = math.floor((n - 1) / COLS_PER_CAT)
            local cell = GetCell(kind, n)
            cell:ClearAllPoints()
            cell:SetPoint("TOPLEFT", menu, "TOPLEFT",
                colX + sc * (CELL_W + CELL_GAP), -44 - HEADER_H - r * rowH)
            cell:SetSize(CELL_W, cellH)
            cell.entry = e
            cell:SetBackdropBorderColor(1, 0.82, 0, 0)
            cell.icon:SetTexture(e.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            cell.icon:Show()
            cell.name:SetText(e.name or "")
            local txt = ""
            if e.kind == "item" then
                if e.count and e.count > 1 then txt = tostring(e.count) end
            elseif tonumber(e.dur) and e.dur > 0 then
                txt = string.format("%dm", math.ceil(e.dur / 60))
            end
            cell.count:SetText(txt)
            cell:Show()
        end
        for n = #list + 1, #col.cells do col.cells[n]:Hide() end
    end
    local frameH = 44 + HEADER_H + maxRows * rowH + 12
    menu:SetSize(MENU_W, math.min(capH, frameH))
end

local function OpenPicker(btnIndex)
    if not active then return end
    local created = not menuReady
    if not menuReady then CreateMenu() end
    -- pickerButton must be set AFTER CreateMenu: CreateMenu ends with
    -- menu:Hide(), whose OnHide script nils pickerButton — setting it before
    -- would leave it nil on the first open and AssignEntry would silently
    -- no-op (the first-open tap-tap bug).
    pickerButton = btnIndex
    MobileUI_Debug(string.format("DynamicBar: OpenPicker btn=%d createMenu=%s menuReady=%s",
        btnIndex, tostring(created), tostring(menuReady)))
    entries = BuildEntries()
    MobileUI_Debug(string.format("DynamicBar: picker opened btn=%d entries=%d",
        btnIndex, #entries))
    menuTitle:SetText("Assign to button " .. (btnIndex - FIRST_BTN + 1))
    if InCombatLockdown() then
        menuHint:SetText("Assigning is disabled in combat.")
    elseif #entries == 0 then
        menuHint:SetText("No usable items or buff spells found.")
    else
        menuHint:SetText("First tap: tooltip. Second tap: assign.")
    end
    PopulateColumns()
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
    MobileUI_Debug(string.format("DynamicBar: AssignEntry pickerButton=%s entry=%s",
        tostring(pickerButton), entry and entry.name or "nil"))
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
