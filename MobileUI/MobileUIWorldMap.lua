-- MobileUIWorldMap.lua - Full-width world map + tap-marker quest panel
--
-- Stock 3.3.5a world map opens in "quest list" view: the map is scaled to
-- ~69% and parked on the left, the quest list sits on the right, and the
-- selected quest's detail + rewards sit at the bottom. On a phone that
-- wastes most of the screen.
--
-- This module forces the stock "full map" view (WorldMapFrame_SetFullMapView:
-- map at 100% scale filling the width, quest list + detail + reward hidden)
-- but keeps the numbered quest markers visible, and adds a custom right-side
-- panel that shows the quest log + rewards when a numbered marker is tapped.
--
-- Hooks (all hooksecurefunc, gated by an `enabled` flag so Revert is clean):
--   WorldMapFrame_OnShow           - re-assert the full-map layout on every open
--   WorldMapFrame_OnHide           - hide the quest panel when the map closes
--   WorldMapFrame_SetQuestMapView  - the stock code switches back to the
--                                    quest-list view whenever quests exist;
--                                    bounce straight back to full-map
--   WorldMap_ToggleSizeDown         - never let the map drop to windowed mode
--   WorldMapQuestPOI_OnClick       - after the stock handler selects the quest,
--                                    populate + show the right-side panel
--
-- Quest data comes from documented 3.3.5a quest-log APIs only
-- (reference/wowprogramming/markdown/api/g-get-q.md / g-get-n.md):
--   GetQuestLogTitle, GetNumQuestLeaderBoards, GetQuestLogLeaderBoard,
--   GetQuestLogCompletionText, GetNumQuestLogRewards, GetQuestLogRewardInfo,
--   GetQuestLogRewardMoney, GetQuestLogRewardXP, GetQuestLogRewardFactionInfo,
--   GetQuestLogRewardTitle, GetQuestLogRewardHonor, GetQuestLogRewardArenaPoints,
--   GetNumQuestLogChoices, GetQuestLogChoiceInfo, SelectQuestLogEntry

MobileUIWorldMap = {}

local enabled = false
local hooked = false

-- Panel widgets
local panel, panelTitle, panelLevel, panelClose
local objHeader, rewHeader
local linePool = {}   -- reusable rows: { text = FontString, icon = Texture }
local MAX_OBJECTIVES = 8
local MAX_REWARDS = 6
local MAX_EXTRAS = 4

-- ============================================================================
-- Panel construction
-- ============================================================================

local function CreatePanel()
    if panel then return end
    if not WorldMapFrame then return end

    panel = CreateFrame("Frame", "MobileUIWorldMapQuestPanel", WorldMapFrame)
    -- WorldMapFrame sits at frame level 87 (WorldMapFrame_ResetFrameLevels);
    -- the POI markers are children of WorldMapPOIFrame at level 100+ (effective
    -- ~188). Level 200 relative to WorldMapFrame keeps the panel above them.
    panel:SetFrameStrata("MEDIUM")
    panel:SetFrameLevel(200)
    panel:SetWidth(300)
    panel:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", -8, -8)
    panel:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -8, 8)
    panel:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    })
    panel:SetBackdropColor(0, 0, 0, 0.92)
    panel:SetBackdropBorderColor(1, 0.82, 0, 0.85)
    panel:Hide()

    -- Close button
    panelClose = CreateFrame("Button", nil, panel)
    panelClose:SetSize(26, 26)
    panelClose:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -8, -8)
    panelClose:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    panelClose:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    panelClose:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
    panelClose:SetScript("OnClick", function() panel:Hide() end)

    -- Title (wraps; right edge clears the close button)
    panelTitle = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    panelTitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, -10)
    panelTitle:SetPoint("RIGHT", panelClose, "LEFT", -6, 0)
    panelTitle:SetJustifyH("LEFT")
    panelTitle:SetWordWrap(true)

    -- Level
    panelLevel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    panelLevel:SetPoint("TOPLEFT", panelTitle, "BOTTOMLEFT", 0, -4)
    panelLevel:SetJustifyH("LEFT")

    -- Section headers
    objHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    rewHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")

    -- Reusable line rows (objectives + rewards + extras)
    for i = 1, MAX_OBJECTIVES + MAX_REWARDS + MAX_EXTRAS do
        local row = {}
        row.text = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.text:SetJustifyH("LEFT")
        row.text:SetWordWrap(true)
        row.icon = panel:CreateTexture(nil, "OVERLAY")
        row.icon:SetSize(26, 26)
        row.icon:Hide()
        row.text:Hide()
        linePool[i] = row
    end
end

-- ============================================================================
-- Panel population
-- ============================================================================

-- Returns true if the panel was populated (caller shows it only then).
local function RefreshPanel(questFrame)
    if not panel or not questFrame then return false end
    local questLogIndex = questFrame.questLogIndex
    if not questLogIndex or questLogIndex < 1 then return false end

    -- Make the "selected quest" APIs (GetQuestLogRewardInfo, GetQuestLogRewardMoney,
    -- GetQuestLogRewardXP, GetQuestLogRewardFactionInfo, ...) return this quest's
    -- data. The stock POI click handler already did this; idempotent.
    SelectQuestLogEntry(questLogIndex)

    local title, level = GetQuestLogTitle(questLogIndex)
    if not title or title == "" then return false end

    -- Title + level (title colored by quest difficulty, like the stock list)
    local r, g, b = 1, 1, 1
    if GetQuestDifficultyColor then
        local c = GetQuestDifficultyColor(level or 1)
        if c then r, g, b = c.r, c.g, c.b end
    end
    panelTitle:SetText(title)
    panelTitle:SetTextColor(r, g, b)
    panelLevel:SetText("Level " .. tostring(level or "?"))
    panelLevel:SetTextColor(1, 0.82, 0)

    -- y cursor below the level line: GetTop/GetBottom are screen-relative, so
    -- (panel top - level bottom) is the level's distance below the panel top.
    local y = -(panel:GetTop() - panelLevel:GetBottom()) - 8
    local lineIdx = 1     -- next free row in linePool

    -- Objectives
    objHeader:SetText("Objectives")
    objHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, y)
    objHeader:Show()
    y = y - 18

    if questFrame.completed then
        -- Completed quest: show the turn-in text instead of objective progress
        local completion = GetQuestLogCompletionText(questLogIndex)
        if completion and completion ~= "" then
            local row = linePool[lineIdx]
            row.text:SetText(completion)
            row.text:SetTextColor(0.2, 1, 0.2)
            row.text:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, y)
            row.text:Show()
            row.icon:Hide()
            y = y - row.text:GetHeight() - 2
            lineIdx = lineIdx + 1
        end
    else
        local numObjectives = GetNumQuestLeaderBoards(questLogIndex) or 0
        for i = 1, math.min(numObjectives, MAX_OBJECTIVES) do
            local text, _, finished = GetQuestLogLeaderBoard(i, questLogIndex)
            if text and text ~= "" then
                local row = linePool[lineIdx]
                row.text:SetText("- " .. text)
                row.text:SetTextColor(finished and 0.2 or 1, 1, finished and 0.2 or 1)
                row.text:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, y)
                row.text:Show()
                row.icon:Hide()
                y = y - row.text:GetHeight() - 2
                lineIdx = lineIdx + 1
            end
        end
    end

    -- Rewards (fixed 30px pitch so the 26px icon never overlaps the next row)
    rewHeader:SetText("Rewards")
    rewHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, y)
    rewHeader:Show()
    y = y - 18

    local numRewards = GetNumQuestLogRewards() or 0
    for i = 1, math.min(numRewards, MAX_REWARDS) do
        local name, texture, numItems, quality = GetQuestLogRewardInfo(i)
        if name and name ~= "" then
            local row = linePool[lineIdx]
            row.icon:SetTexture(texture)
            row.icon:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, y - 2)
            row.icon:Show()
            local label = name
            if numItems and numItems > 1 then label = label .. " x" .. numItems end
            row.text:SetText(label)
            local qr, qg, qb = 1, 1, 1
            if quality and quality > 1 and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality] then
                qr, qg, qb = ITEM_QUALITY_COLORS[quality].r, ITEM_QUALITY_COLORS[quality].g, ITEM_QUALITY_COLORS[quality].b
            end
            row.text:SetTextColor(qr, qg, qb)
            row.text:SetPoint("TOPLEFT", panel, "TOPLEFT", 44, y)
            row.text:Show()
            y = y - 30
            lineIdx = lineIdx + 1
        end
    end

    -- Extras: money / XP / faction / title / honor / arena / choice
    local extras = {}
    local money = GetQuestLogRewardMoney()
    if money and money > 0 then extras[#extras + 1] = "Money: " .. GetMoneyString(money) end
    local xp = GetQuestLogRewardXP()
    if xp and xp > 0 then extras[#extras + 1] = "XP: " .. xp end
    local titleReward = GetQuestLogRewardTitle()
    if titleReward and titleReward ~= "" then extras[#extras + 1] = "Title: " .. titleReward end
    local honor = GetQuestLogRewardHonor()
    if honor and honor > 0 then extras[#extras + 1] = "Honor: " .. honor end
    local arena = GetQuestLogRewardArenaPoints()
    if arena and arena > 0 then extras[#extras + 1] = "Arena Points: " .. arena end
    -- Faction reward has no documented signature; guard with pcall.
    local ok, fname, fstanding = pcall(GetQuestLogRewardFactionInfo)
    if ok and fname and fname ~= "" then
        extras[#extras + 1] = fname .. (fstanding and fstanding > 0 and " (+" .. fstanding .. ")" or "")
    end
    local numChoices = GetNumQuestLogChoices() or 0
    if numChoices > 0 then
        local choiceNames = {}
        for i = 1, math.min(numChoices, 4) do
            local ok2, cname = pcall(GetQuestLogChoiceInfo, i)
            if ok2 and cname and cname ~= "" then choiceNames[#choiceNames + 1] = cname end
        end
        if #choiceNames > 0 then extras[#extras + 1] = "Choice: " .. table.concat(choiceNames, " / ") end
    end
    for i = 1, math.min(#extras, MAX_EXTRAS) do
        local row = linePool[lineIdx]
        row.text:SetText(extras[i])
        row.text:SetTextColor(1, 0.82, 0)
        row.text:SetPoint("TOPLEFT", panel, "TOPLEFT", 12, y)
        row.text:Show()
        row.icon:Hide()
        y = y - row.text:GetHeight() - 2
        lineIdx = lineIdx + 1
    end

    -- Hide unused rows
    for i = lineIdx, #linePool do
        linePool[i].text:Hide()
        linePool[i].icon:Hide()
    end
    return true
end

local function ShowQuestPanel(questFrame)
    if not enabled then return end
    if not panel then CreatePanel() end
    if not panel or not questFrame then return end
    if RefreshPanel(questFrame) then
        panel:Show()
    end
end

-- ============================================================================
-- Full-map layout
-- ============================================================================

-- The stock POI positioning multiplies normalized map coords by
-- WORLDMAP_SETTINGS.size (0.691 in quest-list view). In our full-map view the
-- map is at 1.0, so the stock positions would cluster the markers in the
-- top-left. Recompute each marker from its quest's normalized coords at 1.0.
local function RepositionPOIs()
    if not WorldMapDetailFrame then return end
    local w = WorldMapDetailFrame:GetWidth()
    local h = WorldMapDetailFrame:GetHeight()
    local maxX = w + 12
    local maxY = -h + 12
    local maxQ = MAX_NUM_QUESTS or 25
    for i = 1, maxQ do
        local qf = _G["WorldMapQuestFrame" .. i]
        if not qf then break end
        local poi = qf.poiIcon
        if poi and qf.questId and qf.questId > 0 then
            local _, posX, posY = QuestPOIGetIconInfo(qf.questId)
            if posX and posY then
                posX = posX * w
                posY = -posY * h
                if posY > -12 then posY = -12
                elseif posY < maxY then posY = maxY end
                if posX < 12 then posX = 12
                elseif posX > maxX then posX = maxX end
                poi:SetPoint("CENTER", "WorldMapPOIFrame", "TOPLEFT", posX, posY)
            end
        end
    end
end

local function ApplyFullMapLayout()
    if not enabled then return end
    if not WorldMapFrame or not WorldMapFrame:IsShown() then return end
    if not WORLDMAP_SETTINGS then return end

    -- Never let the map sit in windowed (mini) mode
    if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
        WorldMap_ToggleSizeUp()
    end

    -- Force the stock full-map view: map at 100% scale filling the width,
    -- quest list + detail + reward hidden, patch tiles shown.
    WorldMapFrame_SetFullMapView()

    -- Keep the numbered quest markers + blobs + track checkbox visible
    if WorldMapPOIFrame then WorldMapPOIFrame:Show() end
    if WorldMapBlobFrame then
        WorldMapBlobFrame:SetScale(1.0)
        WorldMapBlobFrame:Show()
    end
    if WorldMapTrackQuest then WorldMapTrackQuest:Show() end

    -- The size-down button would drop the map to windowed mode; hide it.
    if WorldMapFrameSizeDownButton then WorldMapFrameSizeDownButton:Hide() end

    -- Re-position the quest markers for the 1.0-scale map
    RepositionPOIs()

    -- Refresh the quest panel if it's open
    if panel and panel:IsShown() and WORLDMAP_SETTINGS.selectedQuest then
        RefreshPanel(WORLDMAP_SETTINGS.selectedQuest)
    end
end

-- ============================================================================
-- Hooks (all gated by `enabled`)
-- ============================================================================

local function OnShowHook()
    if not enabled then return end
    ApplyFullMapLayout()
end

local function OnHideHook()
    if not enabled then return end
    if panel then panel:Hide() end
end

local function OnSetQuestMapViewHook()
    -- The stock code switches to the quest-list view whenever quests exist;
    -- bounce straight back to the full-map layout.
    if not enabled then return end
    ApplyFullMapLayout()
end

local function OnToggleSizeDownHook()
    if not enabled then return end
    ApplyFullMapLayout()
end

local function OnPOIClickHook()
    if not enabled then return end
    local qf = WORLDMAP_SETTINGS and WORLDMAP_SETTINGS.selectedQuest
    if qf then ShowQuestPanel(qf) end
end

-- ============================================================================
-- Public API
-- ============================================================================

function MobileUIWorldMap:Apply()
    if enabled then return end
    enabled = true
    CreatePanel()
    if not hooked then
        hooked = true
        if WorldMapFrame_OnShow then hooksecurefunc("WorldMapFrame_OnShow", OnShowHook) end
        if WorldMapFrame_OnHide then hooksecurefunc("WorldMapFrame_OnHide", OnHideHook) end
        if WorldMapFrame_SetQuestMapView then hooksecurefunc("WorldMapFrame_SetQuestMapView", OnSetQuestMapViewHook) end
        if WorldMap_ToggleSizeDown then hooksecurefunc("WorldMap_ToggleSizeDown", OnToggleSizeDownHook) end
        if WorldMapQuestPOI_OnClick then hooksecurefunc("WorldMapQuestPOI_OnClick", OnPOIClickHook) end
    end
    if WorldMapFrame and WorldMapFrame:IsShown() then
        ApplyFullMapLayout()
    end
    MobileUI_Debug("WorldMap: full-map layout + quest panel enabled")
end

function MobileUIWorldMap:Revert()
    enabled = false
    if panel then panel:Hide() end
    -- Restore the stock quest-list view if the map is open
    if WorldMapFrame and WorldMapFrame:IsShown() and WorldMapFrame_SetQuestMapView then
        WorldMapFrame_SetQuestMapView()
        if WorldMapFrameSizeDownButton then WorldMapFrameSizeDownButton:Show() end
    end
    MobileUI_Debug("WorldMap: full-map layout + quest panel disabled")
end
