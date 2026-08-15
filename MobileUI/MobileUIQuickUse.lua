-- ============================================================================
-- MobileUIQuickUse.lua — quick-use launcher + secure picker
-- ============================================================================
-- A circular launcher that REPLACES the rightmost button of the dynamic bar
-- strip (the strip's 6th slot; the strip itself drops to 5 stock buttons).
-- Tapping it opens a picker whose rows are addon-created
-- SecureActionButtonTemplate buttons, populated on open with the SAME
-- entries as the dynamic bar picker (items / spells / mounts / professions /
-- macros — MobileUIDynamicBar.BuildEntries). Tapping a row fires it natively
-- and closes the picker: Blizzard's own SecureActionButton_OnClick runs with
-- zero addon code on the stack (mechanism "A", proven by the
-- MobileUISecureSpike click test: spell / item / macro rows all fired).
--
-- OUT OF COMBAT ONLY: the left thumb is on the movement stick; this is a
-- right-thumb interaction. Opening is gated on not InCombatLockdown() and
-- the picker closes when combat starts (PLAYER_REGEN_DISABLED). Setting
-- secure attributes on open is legal out of combat (the flip bridge's
-- mid-combat block does not apply).
-- ============================================================================

local launcher, picker, catcher
local rows = {}          -- pooled secure row buttons, [n]
local open = false
local active = false
local DumpState          -- forward ref (defined after BuildPicker)

MobileUIQuickUse = {}

-- The launcher occupies the strip's 6th slot (0-based index 5): it replaces
-- the rightmost stock button. Size/pitch/x0/y come from the dynamic bar's
-- StripGeometry() at apply time.
local LAUNCH_SLOT = 5

-- Grid constants (mirror the dynamic bar picker's column layout).
local MENU_H_MAX   = 460
local COL_W        = 200
local COL_GAP      = 8
local CELL_W       = 96
local CELL_H       = 36
local CELL_GAP     = 4
local ROW_GAP      = 2
local HEADER_H     = 22
local COLS_PER_CAT = 2
local GROUP_NAMES = {
    item  = "Items",
    spell = "Spells",
    mount = "Mounts",
    prof  = "Professions",
    macro = "Macros",
}
local GROUP_ORDER = { "item", "spell", "mount", "prof", "macro" }

local function Log(fmt, ...)
    MobileUI_Debug(string.format("QuickUse: " .. fmt, ...))
end

-- ============================================================================
-- Picker
-- ============================================================================
local function ClosePicker()
    if picker then picker:Hide() end
end

-- One-shot OnUpdate defer: close the picker one frame after a row tap so
-- the secure OnClick (the fire) has definitely run first. C_Timer does not
-- exist on this client; this is the codebase's standard defer pattern.
local deferFrame
local function DeferClosePicker()
    if not deferFrame then
        deferFrame = CreateFrame("Frame")
        deferFrame:SetScript("OnUpdate", function(self)
            self:Hide()
            ClosePicker()
        end)
    end
    deferFrame:Show()
end

local function BuildPicker()
    picker = CreateFrame("Frame", "MobileUIQuickUseMenu", UIParent)
    picker:SetSize(COL_W * #GROUP_ORDER + COL_GAP * (#GROUP_ORDER - 1) + 28, 200)
    picker:SetFrameStrata("DIALOG")
    picker:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    picker:SetClampedToScreen(true)
    picker:Hide()
    picker:SetScript("OnHide", function()
        open = false
        if catcher then catcher:Hide() end
        Log("picker closed")
        DumpState("closed")
    end)

    local title = picker:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", picker, "TOPLEFT", 14, -10)
    title:SetText("Quick use — tap to use")

    local close = CreateFrame("Button", nil, picker)
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", picker, "TOPRIGHT", -8, -8)
    close:SetNormalFontObject(GameFontNormal)
    close:SetText("X")
    close:SetScript("OnClick", ClosePicker)

    -- Category headers.
    for ci, kind in ipairs(GROUP_ORDER) do
        local h = picker:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        h:SetPoint("TOPLEFT", picker, "TOPLEFT",
            14 + (ci - 1) * (COL_W + COL_GAP), -44)
        h:SetText(GROUP_NAMES[kind])
    end

    -- Full-screen catcher below the menu: outside tap dismisses. The menu
    -- is raised above it afterwards (same pattern as the dynamic bar picker).
    catcher = CreateFrame("Frame", "MobileUIQuickUseCatcher", UIParent)
    catcher:SetAllPoints(UIParent)
    catcher:SetFrameStrata("DIALOG")
    catcher:EnableMouse(true)
    catcher:SetScript("OnMouseDown", ClosePicker)
    picker:SetFrameLevel(catcher:GetFrameLevel() + 2)
end

-- Get (or lazily create) the n-th secure row. Rows are pooled so repeated
-- opens don't churn frame creation.
local function GetRow(n)
    local row = rows[n]
    if not row then
        row = CreateFrame("Button", nil, picker, "SecureActionButtonTemplate")
        row:SetSize(CELL_W, CELL_H)
        row.icon = row:CreateTexture(nil, "ARTWORK")
        row.icon:SetSize(32, 32)
        row.icon:SetPoint("LEFT", row, "LEFT", 3, 0)
        row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        row.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        row.label:SetPoint("LEFT", row.icon, "RIGHT", 4, 0)
        row.label:SetPoint("RIGHT", row, "RIGHT", -2, 0)
        row.label:SetJustifyH("LEFT")
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Buttons\\WHITE8X8",
            edgeSize = 1,
        })
        row:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        row:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)
        -- Log the click landing (the spike's make-or-break check: the click
        -- must reach the row for the secure fire to run).
        row:SetScript("OnMouseDown", function(self, button)
            Log("row '%s' mousedown button=%s",
                tostring(self.entryName), tostring(button))
        end)
        -- Close after the row fires: the secure OnClick (fire) runs before
        -- OnMouseUp, and the one-frame defer makes the ordering bulletproof.
        row:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" then
                Log("row '%s' mouseup -> close", tostring(self.entryName))
                DeferClosePicker()
            end
        end)
        rows[n] = row
    end
    return row
end

-- Fill the grid from the current entries (same list as the dynamic bar
-- picker). Cell height adapts so the tallest column fits the frame.
local function PopulateRows()
    local entries = MobileUIDynamicBar.BuildEntries()
    local byKind = { item = {}, spell = {}, mount = {}, prof = {}, macro = {} }
    for _, e in ipairs(entries) do
        local t = byKind[e.kind]
        if t then table.insert(t, e) end
    end
    local maxRows = 0
    for _, kind in ipairs(GROUP_ORDER) do
        local r = math.ceil(#byKind[kind] / COLS_PER_CAT)
        if r > maxRows then maxRows = r end
    end
    local capH = math.min(MENU_H_MAX, UIParent:GetHeight() - 30)
    local availH = capH - 44 - HEADER_H - 12
    local cellH = math.max(28, math.min(CELL_H, math.floor(availH / math.max(1, maxRows))))
    local rowH = cellH + ROW_GAP
    local n = 0
    for ci, kind in ipairs(GROUP_ORDER) do
        local list = byKind[kind]
        local colX = 14 + (ci - 1) * (COL_W + COL_GAP)
        for k, e in ipairs(list) do
            local sc = (k - 1) % COLS_PER_CAT
            local r  = math.floor((k - 1) / COLS_PER_CAT)
            n = n + 1
            local row = GetRow(n)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", picker, "TOPLEFT",
                colX + sc * (CELL_W + CELL_GAP), -44 - HEADER_H - r * rowH)
            row:SetSize(CELL_W, cellH)
            row.entryName = e.name
            row.label:SetText(e.name or "")
            -- Cap the icon to the cell so a shrunk row never overflows it.
            local iconSize = math.max(16, math.min(32, cellH - 4))
            row.icon:SetSize(iconSize, iconSize)
            row.icon:SetTexture(e.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            row.icon:Show()
            -- Secure attributes: set on open (legal out of combat). The
            -- spike proved spell (name), item (link) and macrotext all fire.
            if e.kind == "item" then
                row:SetAttribute("type", "item")
                row:SetAttribute("item", e.link)
            elseif e.kind == "macro" then
                row:SetAttribute("type", "macro")
                local body = GetMacroBody and GetMacroBody(e.macroIndex)
                if body and body ~= "" then
                    row:SetAttribute("macrotext", body)
                    row:SetAttribute("macro", nil)
                else
                    row:SetAttribute("macrotext", nil)
                    row:SetAttribute("macro", e.name)
                end
            else
                -- spell / mount / prof are all spells: fire by name.
                row:SetAttribute("type", "spell")
                row:SetAttribute("spell", e.name)
            end
            row:Show()
        end
    end
    for i = n + 1, #rows do rows[i]:Hide() end
    local frameH = 44 + HEADER_H + maxRows * rowH + 12
    picker:SetSize(COL_W * #GROUP_ORDER + COL_GAP * (#GROUP_ORDER - 1) + 28,
        math.min(capH, frameH))
    return #entries
end

-- ============================================================================
-- Diagnostics (freeze hunting): dump the visibility of every full-screen
-- mouse-enabled frame so a click-eater is caught red-handed.
-- ============================================================================
DumpState = function(reason)
    local function vis(f) return f and f:IsShown() and "SHOWN" or "hidden" end
    Log("%s: combat=%s picker=%s catcher=%s dynCatcher=%s arcCatcher=%s bagCatcher=%s launcher=%s",
        reason,
        tostring(InCombatLockdown()),
        vis(picker), vis(catcher),
        vis(_G["MobileUIDynamicBarCatcher"]),
        vis(_G["MobileUIArcAssignCatcher"]),
        vis(_G["MobileUIBagSwapCatcher"]),
        vis(launcher))
end

-- Click-eater poll: if the picker is closed but any full-screen catcher is
-- still shown, taps are being swallowed — log it immediately.
local pollFrame = CreateFrame("Frame")
local pollT = 0
pollFrame:SetScript("OnUpdate", function(self, elapsed)
    pollT = pollT + elapsed
    if pollT < 3 then return end
    pollT = 0
    if not (picker and picker:IsShown()) then
        local dyn = _G["MobileUIDynamicBarCatcher"]
        local arc = _G["MobileUIArcAssignCatcher"]
        local bag = _G["MobileUIBagSwapCatcher"]
        if (catcher and catcher:IsShown())
            or (dyn and dyn:IsShown())
            or (arc and arc:IsShown())
            or (bag and bag:IsShown()) then
            DumpState("ANOMALY catcher-shown-while-closed")
        end
    end
end)

local function OpenPicker()
    if not active then return end
    if InCombatLockdown() then
        Log("open blocked (in combat)")
        return
    end
    if not picker then BuildPicker() end
    -- Close the dynamic bar picker if it's open (both use a full-screen
    -- catcher; only one picker should be up at a time).
    if MobileUIDynamicBar and MobileUIDynamicBar.ClosePicker then
        MobileUIDynamicBar.ClosePicker()
    end
    local count = PopulateRows()
    Log("picker opened entries=%d", count)
    picker:ClearAllPoints()
    -- Grow up and left from the launcher: right-thumb reach.
    picker:SetPoint("BOTTOMRIGHT", launcher, "TOPRIGHT", 0, 8)
    open = true
    catcher:Show()
    picker:Show()
    DumpState("opened")
end

local function Toggle()
    Log("launcher tap (open=%s)", tostring(open))
    if open then ClosePicker() else OpenPicker() end
end

-- ============================================================================
-- Launcher button (circular, game icon, far right)
-- ============================================================================
local function BuildLauncher(size)
    launcher = CreateFrame("Button", "MobileUIQuickUseLauncher", UIParent)
    -- Size BEFORE skinning: LBF computes the skin scale from the button's
    -- size at AddButton time, so a 0x0 button gets a 36px circle / 23px icon
    -- that never grows — the launcher then renders as a small circle inside
    -- a bigger square instead of matching the strip buttons.
    launcher:SetSize(size or 55, size or 55)
    launcher.icon = launcher:CreateTexture(nil, "ARTWORK")
    launcher.icon:SetTexture("Interface\\Icons\\Spell_Nature_Lightning")
    -- No SetAllPoints: LBF sizes/centers the icon (Icon layer) itself, so
    -- the raw texture can never cover the circular skin.
    if MobileUILayout and MobileUILayout.SkinButton then
        MobileUILayout.SkinButton(launcher, { Icon = launcher.icon })
    end
    launcher:SetScript("OnClick", Toggle)
    launcher:Hide()
end

-- ============================================================================
-- Public API (called by the layout)
-- ============================================================================
function MobileUIQuickUse:Apply()
    if not MobileDB or not MobileDB.layoutEnabled then return end
    if active then return end
    if not launcher then BuildLauncher(size) end
    -- NOTE: never write `X and Y()` in a multi-return assignment — the `and`
    -- truncates the call to its first value. Call StripGeometry directly.
    local size, pitch, x0, y
    if MobileUIDynamicBar and MobileUIDynamicBar.StripGeometry then
        size, pitch, x0, y = MobileUIDynamicBar.StripGeometry()
    end
    if not (size and pitch and x0 and y) then
        Log("apply skipped (no strip geometry)")
        return
    end
    launcher:SetSize(size, size)
    launcher:ClearAllPoints()
    -- The strip's 6th slot: replaces the rightmost stock button.
    launcher:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT",
        x0 + LAUNCH_SLOT * pitch, y)
    launcher:Show()
    active = true
    Log(string.format("launcher applied at strip slot %d (x=%.0f y=%.0f size=%d icon=%.0f)",
        LAUNCH_SLOT, x0 + LAUNCH_SLOT * pitch, y, size, launcher.icon:GetWidth() or 0))
end

function MobileUIQuickUse:Revert()
    ClosePicker()
    if launcher then launcher:Hide() end
    active = false
    Log("reverted")
end

-- ============================================================================
-- Close on combat start
-- ============================================================================
local combatFrame = CreateFrame("Frame")
combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
combatFrame:SetScript("OnEvent", function()
    if open then ClosePicker() end
end)

-- ---- Slash command (test convenience) ----
SLASH_MOBILEUIQUICKUSE1 = "/muiquickuse"
SlashCmdList["MOBILEUIQUICKUSE"] = function()
    Toggle()
end

Log("loaded")
