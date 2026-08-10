-- MobileUIWorldMapMarkers.lua - Quest marker anchoring + repositioning.
-- Stock WorldMapFrame_DisplayQuestPOI hardcodes the quest-list scale factor
-- (0.691) for every non-windowed view, so in our full-map view every marker
-- would land at 69.1% of its true offset (stock has no full-map marker mode).
-- This hook re-sets each marker's anchor with 1.0-scale math; DisplayQuestPOI
-- is the ONLY place stock anchors map markers, so this covers every quest
-- update / zone change.
--
-- The zone blobs (WorldMapBlobFrame) are client-drawn in map-texture space
-- and are ALWAYS correct: each blob renders at detail_reported + (normX*1002,
-- -normY*668). The map hierarchy is detached from UIParent, so Lua children
-- of the detail frame resolve against a stale position offset from the frames'
-- reported GetLeft/GetTop. The player arrow (child of WorldMapButton) renders
-- CORRECTLY at detail_reported + anchor, so markers are re-parented to
-- WorldMapButton too - they resolve in the same correct space, no offset
-- needed. All map components must stay at 1.0 scale: scaling the area frame
-- / chrome to 1.2 shifts the coordinate space the markers resolve in.
MobileUIWorldMapMarkers = {}

local function OnDisplayQuestPOIHook(questFrame)
    if not MobileUIWorldMap.enabled then return end
    if not WORLDMAP_SETTINGS or WORLDMAP_SETTINGS.size ~= WORLDMAP_FULLMAP_SIZE then return end
    if not WorldMapDetailFrame then return end
    local poi = questFrame and questFrame.poiIcon
    if not poi then return end
    local _, posX, posY = QuestPOIGetIconInfo(questFrame.questId)
    if not posX or not posY then return end
    local w = WorldMapDetailFrame:GetWidth()
    local h = WorldMapDetailFrame:GetHeight()
    posX = posX * w
    posY = -posY * h
    -- Same border clamping as stock, evaluated at the 1.0 scale
    -- (stock MIN_X/MIN_Y are 12/-12; MAX at size 1.0 is w+12 / -h+12).
    if posY > -12 then posY = -12
    elseif posY < -h + 12 then posY = -h + 12 end
    if posX < 12 then posX = 12
    elseif posX > w + 12 then posX = w + 12 end
    -- Markers must be children of WorldMapButton (like the player arrow, which
    -- renders correctly) so their anchors resolve in the same correct space;
    -- as children of the detail frame they resolve against its stale position.
    poi:SetParent("WorldMapButton")
    poi:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", posX, posY)
    poi:SetScale(1.0)
    -- Stock QuestPOITemplate has 8px HitRectInsets on every side, shrinking the
    -- tap target to 16x16 unscaled - too small for a phone.
    poi:SetHitRectInsets(0, 0, 0, 0)
end

local function RepositionPOIs()
    if not MobileUIWorldMap.enabled then return end
    if not WorldMapDetailFrame then return end
    local w = WorldMapDetailFrame:GetWidth()
    local h = WorldMapDetailFrame:GetHeight()
    local maxX = w + 12
    local maxY = -h + 12
    local maxQ = MAX_NUM_QUESTS or 25
    local diag = {}
    -- Anchor every marker to the detail frame (same reference the client-drawn
    -- blobs use) with pure 1.0-scale math.
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
                poi:SetParent("WorldMapButton")
                poi:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", posX, posY)
                diag[#diag + 1] = string.format("%d@(%.0f,%.0f)", qf.questId, posX, posY)
                poi:SetScale(1.0)
                poi:SetHitRectInsets(0, 0, 0, 0)
            end
        end
    end
    -- The completed-quest swap button is anchored to its poiButton; keep it in
    -- the same (WorldMapButton) space so it tracks the marker.
    local swap = _G["poiWorldMapPOIFrame_Swap"]
    if swap and WorldMapButton then swap:SetParent("WorldMapButton") end
    MobileUI_Debug(string.format("WorldMap: RepositionPOIs w=%.0f h=%.0f [%s]",
        w, h, table.concat(diag, " ")))
end

-- Post-layout diagnostic: fires one frame after the map opens and logs where
-- every relevant frame ACTUALLY renders (same-frame GetLeft/GetTop reads are
-- one layout pass behind, so this is the only way to see the true positions).
local function LogLayout()
    local ok, err = pcall(function()
        local parts = {}
        local function add(name, f)
            local ok2, l, t, s = pcall(function()
                return f and f:GetLeft() or -999, f and f:GetTop() or -999, f and f:GetScale() or -1
            end)
            if ok2 then
                parts[#parts + 1] = string.format("%s=(%.0f,%.0f)s%.2f", name, l, t, s)
            else
                parts[#parts + 1] = name .. "=ERR"
            end
        end
        add("map", WorldMapFrame)
        add("guide", WorldMapPositioningGuide)
        add("detail", WorldMapDetailFrame)
        add("poi", WorldMapPOIFrame)
        add("blob", WorldMapBlobFrame)
        add("tile1", _G["WorldMapDetailTile1"])
        add("player", WorldMapPlayer)
        -- Player's real map position: player arrow = detail_actual + (px*1002, -py*668),
        -- so map texture origin = playerArrow - (px*1002, -py*668). That's where blobs are.
        local px, py = GetPlayerMapPosition("player")
        if px and py then
            parts[#parts + 1] = string.format("ppos=(%.3f,%.3f)", px, py)
        end
        -- The map texture itself: where does it actually render?
        -- (WorldMapFrameTexture1 is a child of WorldMapFrame, anchored to its CENTER.)
        add("tex1", _G["WorldMapFrameTexture1"])
        add("tex2", _G["WorldMapFrameTexture2"])
        -- Are the client-drawn blobs Lua-accessible children of the blob frame?
        local blobKids = {}
        if WorldMapBlobFrame then
            local kids = WorldMapBlobFrame:GetChildren()
            if kids then
                for _, child in pairs(kids) do
                    local ok2, l, t = pcall(function()
                        return child:GetLeft() or -999, child:GetTop() or -999
                    end)
                    if ok2 then
                        blobKids[#blobKids + 1] = string.format("%s=(%.0f,%.0f)", tostring(child:GetName() or "?"), l, t)
                    end
                end
            end
        end
        if #blobKids > 0 then
            parts[#parts + 1] = "blobKids=" .. table.concat(blobKids, " ")
        end
        local maxQ = MAX_NUM_QUESTS or 25
        for i = 1, maxQ do
            local qf = _G["WorldMapQuestFrame" .. i]
            if not qf then break end
            local poi = qf.poiIcon
            if poi and qf.questId and qf.questId > 0 then
                local ok2, l, t = pcall(function()
                    return poi:GetLeft() or -999, poi:GetTop() or -999
                end)
                if ok2 then
                    parts[#parts + 1] = string.format("m%d=(%.0f,%.0f)", qf.questId, l, t)
                end
            end
        end
        MobileUI_Debug("WorldMap: LAYOUT " .. table.concat(parts, " "))
    end)
    if not ok then
        MobileUI_Debug("WorldMap: LAYOUT error: " .. tostring(err))
    end
end

-- Stock lays the marker buttons out in the same frame the detail frame moves
-- (SetFullMapView), so they can resolve against the detail frame's pre-move
-- position. Re-assert the anchors one frame later, after the layout settles.
local repositionTimer = CreateFrame("Frame")
repositionTimer:Hide()
repositionTimer:SetScript("OnUpdate", function(self)
    self:Hide()
    LogLayout()
    RepositionPOIs()
end)

MobileUIWorldMapMarkers.ScheduleReposition = function()
    repositionTimer:Show()
end
MobileUIWorldMapMarkers.OnDisplayQuestPOI = OnDisplayQuestPOIHook
MobileUIWorldMapMarkers.Reset = function()
    -- No cached state to clear; markers use pure 1.0-scale math.
end
