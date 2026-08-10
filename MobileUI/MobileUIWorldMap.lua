-- MobileUIWorldMap.lua - Full-width world map + tap-marker quest panel.
-- Forces the stock "full map" view (map at 100%, quest list/detail/reward
-- hidden) but keeps numbered quest markers, and adds a custom panel showing
-- the quest log + rewards when a marker is tapped. Split across three files:
--   MobileUIWorldMap.lua        - lifecycle, layout, hooks (this file)
--   MobileUIWorldMapPanel.lua   - the tap-marker quest panel
--   MobileUIWorldMapMarkers.lua - quest marker anchoring + repositioning
MobileUIWorldMap = {}
MobileUI_Debug("WorldMap: file loaded")

local enabled = false
local hooked = false
local questDiagLogged = false
local CHROME_FRAMES = {
    "WorldMapContinentDropDown",
    "WorldMapZoneDropDown",
    "WorldMapZoneMinimapDropDown",
    "WorldMapLevelDropDown",
    "WorldMapZoomOutButton",
    "WorldMapLevelUpButton",
    "WorldMapLevelDownButton",
    "WorldMapFrameCloseButton",
    "WorldMapTrackQuest",
    "WorldMapQuestShowObjectives",
}

local function ApplyFullMapLayout()
    if not enabled then return end
    if not WorldMapFrame or not WorldMapFrame:IsShown() then return end
    if not WORLDMAP_SETTINGS then return end

    if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
        WorldMap_ToggleSizeUp()
    end

    WorldMapFrame_SetFullMapView()
    -- Stock computes the POI clamp bounds from WORLDMAP_SETTINGS.size at the
    -- quest-list scale; refresh them for the 1.0 full-map view (SetFullMapView
    -- already set size = 1.0).
    if WorldMapFrame_SetPOIMaxBounds then
        WorldMapFrame_SetPOIMaxBounds()
    end
    -- The big-window map is detached from UIParent (SetParent(nil)), so the
    -- global 1.2 scale never reaches it; the texture already fills the screen
    -- at 1.0. Scale only text + interactive elements (area + chrome -> 1.0,
    -- markers -> 1.0).
    if WorldMapFrameAreaFrame then
        WorldMapFrameAreaFrame:SetScale(1.2)
    end
    for _, name in ipairs(CHROME_FRAMES) do
        local f = _G[name]
        if f then f:SetScale(1.2) end
    end

    -- "Show Objectives" gates ALL quest markers but sits off-screen; force it on.
    if WorldMapQuestShowObjectives and not WorldMapQuestShowObjectives:GetChecked() then
        WorldMapQuestShowObjectives:SetChecked(true)
        SetCVar("questPOI", 1)
        WorldMapQuestShowObjectives_Toggle()
    end

    -- Keep the numbered quest markers + blobs + track checkbox visible
    if WorldMapPOIFrame then WorldMapPOIFrame:Show() end
    if WorldMapBlobFrame then
        WorldMapBlobFrame:SetScale(1.0)
        WorldMapBlobFrame:Show()
    end
    if WorldMapTrackQuest then WorldMapTrackQuest:Show() end

    -- The size-down button would drop the map to windowed mode; hide it.
    if WorldMapFrameSizeDownButton then WorldMapFrameSizeDownButton:Hide() end
    -- Re-position the quest markers for the 1.0-scale map. Deferred one frame
    -- so the markers never resolve against the detail frame's pre-move position.
    MobileUIWorldMapMarkers.ScheduleReposition()

    -- Refresh the quest panel if it's open
    if MobileUIWorldMapPanel.IsShown() and WORLDMAP_SETTINGS.selectedQuest then
        MobileUIWorldMapPanel.Refresh(WORLDMAP_SETTINGS.selectedQuest)
    end
end

local function OnShowHook()
    if not enabled then return end
    questDiagLogged = false
    MobileUI_Debug("WorldMap: map shown -> apply full-map layout")
    ApplyFullMapLayout()
    -- Immediate fallback: log the detail frame's reported position right now.
    if WorldMapDetailFrame then
        MobileUI_Debug(string.format("WorldMap: detailNow=(%.0f,%.0f) s=%.2f",
            WorldMapDetailFrame:GetLeft() or -999, WorldMapDetailFrame:GetTop() or -999,
            WorldMapDetailFrame:GetScale() or -1))
    end
    -- Diagnostics: effective scales (marker screen positions are read in the
    -- same frame as the SetPoint, i.e. one layout pass behind — judge by eye).
    local markerEff, questCount = 0, 0
    local maxQ = MAX_NUM_QUESTS or 25
    for i = 1, maxQ do
        local qf = _G["WorldMapQuestFrame" .. i]
        if not qf then break end
        if qf.questId and qf.questId > 0 then
            questCount = questCount + 1
            local poi = qf.poiIcon
            if poi and markerEff == 0 then markerEff = poi:GetEffectiveScale() end
        end
    end
    MobileUI_Debug(string.format("WorldMap: diag ui=%.2f mapEff=%.2f areaEff=%.2f markerEff=%.2f showObj=%s quests=%d",
        UIParent:GetEffectiveScale(), WorldMapFrame and WorldMapFrame:GetEffectiveScale() or 0,
        WorldMapFrameAreaFrame and WorldMapFrameAreaFrame:GetEffectiveScale() or 0, markerEff,
        tostring(WatchFrame and WatchFrame.showObjectives), questCount))
end

local function OnHideHook()
    if not enabled then return end
    MobileUIWorldMapPanel.Hide()
end

local function OnSetQuestMapViewHook()
    -- Stock switches to quest-list view whenever quests exist; bounce back.
    if not enabled then return end
    ApplyFullMapLayout()
    -- Diagnostic: log quest-marker state once per open (frames exist here).
    if not questDiagLogged then
        questDiagLogged = true
        local maxQ = MAX_NUM_QUESTS or 25
        local count, parts = 0, {}
        for i = 1, maxQ do
            local qf = _G["WorldMapQuestFrame" .. i]
            if not qf then break end
            if qf.questId and qf.questId > 0 then
                count = count + 1
                local poi = qf.poiIcon
                local _, px, py = QuestPOIGetIconInfo(qf.questId)
                parts[#parts + 1] = string.format("%d:%s(%.2f,%.2f)@(%.0f,%.0f)", qf.questId, qf.completed and "C" or "U", px or -1, py or -1, poi and (poi:GetLeft() or -999) or -999, poi and (poi:GetTop() or -999) or -999)
            end
        end
        MobileUI_Debug("WorldMap: quests=" .. count .. " [" .. table.concat(parts, " ") .. "]")
    end
end

local function OnToggleSizeDownHook()
    if not enabled then return end
    ApplyFullMapLayout()
end

local function OnPOIClickHook()
    if not enabled then return end
    local qf = WORLDMAP_SETTINGS and WORLDMAP_SETTINGS.selectedQuest
    if qf then MobileUIWorldMapPanel.Show(qf) end
end

function MobileUIWorldMap:Apply()
    if enabled then return end
    enabled = true
    MobileUIWorldMap.enabled = true
    MobileUIWorldMapPanel.Create()
    MobileUIWorldMapPanel.SetScale(1.2)
    if not hooked then
        hooked = true
        -- hooksecurefunc on the stock global handlers; log which exist here.
        if WorldMapFrame_OnShow then
            hooksecurefunc("WorldMapFrame_OnShow", OnShowHook)
            MobileUI_Debug("WorldMap: hooked OnShow global")
        else
            MobileUI_Debug("WorldMap: OnShow global NOT FOUND")
        end
        if WorldMapFrame_OnHide then
            hooksecurefunc("WorldMapFrame_OnHide", OnHideHook)
            MobileUI_Debug("WorldMap: hooked OnHide global")
        else
            MobileUI_Debug("WorldMap: OnHide global NOT FOUND")
        end
        if WorldMapFrame_SetQuestMapView then
            hooksecurefunc("WorldMapFrame_SetQuestMapView", OnSetQuestMapViewHook)
            MobileUI_Debug("WorldMap: hooked SetQuestMapView")
        else
            MobileUI_Debug("WorldMap: SetQuestMapView NOT FOUND")
        end
        if WorldMapFrame_DisplayQuestPOI then
            hooksecurefunc("WorldMapFrame_DisplayQuestPOI", MobileUIWorldMapMarkers.OnDisplayQuestPOI)
            MobileUI_Debug("WorldMap: hooked DisplayQuestPOI")
        else
            MobileUI_Debug("WorldMap: DisplayQuestPOI NOT FOUND")
        end
        if WorldMap_ToggleSizeDown then
            hooksecurefunc("WorldMap_ToggleSizeDown", OnToggleSizeDownHook)
            MobileUI_Debug("WorldMap: hooked ToggleSizeDown")
        else
            MobileUI_Debug("WorldMap: ToggleSizeDown NOT FOUND")
        end
        if WorldMapQuestPOI_OnClick then
            hooksecurefunc("WorldMapQuestPOI_OnClick", OnPOIClickHook)
            MobileUI_Debug("WorldMap: hooked POI click")
        else
            MobileUI_Debug("WorldMap: POI click NOT FOUND")
        end
        -- Fallback: wrap the frame's OnShow/OnHide scripts directly (covers
        -- clients wiring different handlers). ApplyFullMapLayout is idempotent.
        if WorldMapFrame then
            local origShow = WorldMapFrame:GetScript("OnShow")
            if origShow then
                WorldMapFrame:SetScript("OnShow", function(...)
                    origShow(...)
                    OnShowHook()
                end)
                MobileUI_Debug("WorldMap: hooked frame OnShow script")
            else
                MobileUI_Debug("WorldMap: frame OnShow script NOT FOUND")
            end
            local origHide = WorldMapFrame:GetScript("OnHide")
            if origHide then
                WorldMapFrame:SetScript("OnHide", function(...)
                    origHide(...)
                    OnHideHook()
                end)
                MobileUI_Debug("WorldMap: hooked frame OnHide script")
            else
                MobileUI_Debug("WorldMap: frame OnHide script NOT FOUND")
            end
        end
    end
    if WorldMapFrame and WorldMapFrame:IsShown() then
        ApplyFullMapLayout()
    end
    MobileUI_Debug("WorldMap: full-map layout + quest panel enabled")
end

function MobileUIWorldMap:Revert()
    enabled = false
    MobileUIWorldMap.enabled = false
    MobileUIWorldMapPanel.Hide()
    if MobileUIWorldMapMarkers.Reset then MobileUIWorldMapMarkers.Reset() end
    -- Restore the stock quest-list view if the map is open
    if WorldMapFrame and WorldMapFrame:IsShown() and WorldMapFrame_SetQuestMapView then
        WorldMapFrame_SetQuestMapView()
        if WorldMapFrame_SetPOIMaxBounds then WorldMapFrame_SetPOIMaxBounds() end
        if WorldMapFrameSizeDownButton then WorldMapFrameSizeDownButton:Show() end
    end
    -- Undo the text/marker/panel/chrome scales
    if WorldMapFrameAreaFrame then WorldMapFrameAreaFrame:SetScale(1.0) end
    MobileUIWorldMapPanel.SetScale(1.0)
    for _, name in ipairs(CHROME_FRAMES) do
        local f = _G[name]
        if f then f:SetScale(1.0) end
    end
    local maxQ = MAX_NUM_QUESTS or 25
    for i = 1, maxQ do
        local qf = _G["WorldMapQuestFrame" .. i]
        if not qf then break end
        if qf.poiIcon then
            qf.poiIcon:SetScale(1.0)
            -- Restore the stock parent (WorldMapPOIFrame) so stock anchors work
            -- again in the quest-list view.
            if WorldMapPOIFrame then qf.poiIcon:SetParent(WorldMapPOIFrame) end
        end
    end
    local swap = _G["poiWorldMapPOIFrame_Swap"]
    if swap and WorldMapPOIFrame then swap:SetParent(WorldMapPOIFrame) end
    MobileUI_Debug("WorldMap: full-map layout + quest panel disabled")
end
