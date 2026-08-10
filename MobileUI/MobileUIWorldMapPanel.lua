-- MobileUIWorldMapPanel.lua - Tap-marker quest panel (log + rewards popover).
-- A small popover anchored to the world map that shows the selected quest's
-- objectives, rewards and extras when a numbered marker is tapped. Rows are
-- pooled and reused; the panel sizes itself to its content (capped).
MobileUIWorldMapPanel = {}

local panel, panelTitle, panelLevel, panelClose
local objHeader, rewHeader
local linePool = {}   -- reusable rows: { text = FontString, icon = Texture }
local MAX_OBJECTIVES = 8
local MAX_REWARDS = 6
local MAX_EXTRAS = 4
local MAX_PANEL_HEIGHT = 440   -- popover cap; taller content clips
local dragging = false         -- popover drag state
local dragX, dragY = 0, 0

local function CreatePanel()
    if panel then return end
    if not WorldMapFrame then return end

    panel = CreateFrame("Frame", "MobileUIWorldMapQuestPanel", WorldMapFrame)
    panel:SetFrameStrata("MEDIUM")
    panel:SetFrameLevel(200)
    panel:SetWidth(300)
    panel:SetScale(1.2)
    panel:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", -8, -40)
    panel:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    })
    panel:SetBackdropColor(0, 0, 0, 0.92)
    panel:SetBackdropBorderColor(1, 0.82, 0, 0.85)
    panel:EnableMouse(true)
    panel:Hide()

    panel:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        dragging = true
        local x, y = GetCursorPosition()
        local scale = self:GetEffectiveScale()
        dragX = self:GetLeft() - x / scale
        dragY = self:GetBottom() - y / scale
    end)
    panel:SetScript("OnMouseUp", function() dragging = false end)
    panel:SetScript("OnUpdate", function()
        if not dragging then return end
        local x, y = GetCursorPosition()
        local scale = panel:GetEffectiveScale()
        panel:ClearAllPoints()
        panel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / scale + dragX, y / scale + dragY)
    end)

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

local function RefreshPanel(questFrame)
    if not panel or not questFrame then return false end
    local questLogIndex = questFrame.questLogIndex
    if not questLogIndex or questLogIndex < 1 then return false end

    -- Make the "selected quest" APIs return this quest's data (idempotent).
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

    -- y cursor below the level line (GetTop/GetBottom return nil while the panel is hidden).
    local y = -(10 + (panelTitle:GetHeight() or 0) + 4 + (panelLevel:GetHeight() or 0)) - 8
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

    -- Popover: size the panel to its content (capped); `y` is the bottom of the last row.
    local height = -y + 14
    if height < 60 then height = 60 end
    if height > MAX_PANEL_HEIGHT then height = MAX_PANEL_HEIGHT end
    panel:SetHeight(height)
    return true
end

local function ShowQuestPanel(questFrame)
    if not MobileUIWorldMap.enabled then return end
    if not panel then CreatePanel() end
    if not panel or not questFrame then return end
    if RefreshPanel(questFrame) then
        panel:Show()
    end
end

MobileUIWorldMapPanel.Create = CreatePanel
MobileUIWorldMapPanel.Refresh = RefreshPanel
MobileUIWorldMapPanel.Show = ShowQuestPanel
MobileUIWorldMapPanel.Hide = function()
    if panel then panel:Hide() end
end
MobileUIWorldMapPanel.SetScale = function(s)
    if panel then panel:SetScale(s) end
end
MobileUIWorldMapPanel.IsShown = function()
    return panel and panel:IsShown() or false
end
