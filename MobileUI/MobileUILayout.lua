-- MobileUILayout.lua - 5-Point Mobile UI Revamp
MobileUILayout = {}

-- Config
local ACTION_BUTTONS = {
    [1]  = { size = 96, x = -29, y = 29  }, [2]  = { size = 77, x = -35,  y = 144 },
    [3]  = { size = 77, x = -144, y = 35  }, [4]  = { size = 77, x = -115, y = 115 },
    [5]  = { size = 64, x = -20,  y = 240 }, [6]  = { size = 64, x = -97,  y = 214 },
    [7]  = { size = 64, x = -190, y = 193 }, [8]  = { size = 64, x = -215, y = 101 },
    [9]  = { size = 64, x = -248, y = 29  }, [10] = { size = 51, x = -336, y = 29  },
    [11] = { size = 51, x = -299, y = 89  }, [12] = { size = 51, x = -271, y = 170 },
    [13] = { size = 51, x = -161, y = 277 }, [14] = { size = 51, x = -86,  y = 298 },
    [15] = { size = 51, x = -20,  y = 316 },
}
-- Scatter spots fed from MultiBarBottomLeft (bottom-left bar; slots 61-65 on
-- this Ascension client while the buttons stay attached to it).
-- Artemis cannot create virtual keys for "-" and "=", so scatter spots 11/12
-- (where ActionButton11/12 would sit) are filled by bottom-left bar buttons.
-- The five outermost spots (11-15) are fed by bar buttons 1-5 in order, so
-- the arc reads left-to-right 1-2-3-4-5 (keybinds Q/E/R/T/F).
local ACTION2_BUTTONS = {
    { scatter = 11, src = 1 },  -- keybind Q
    { scatter = 12, src = 2 },  -- keybind E
    { scatter = 13, src = 3 },  -- keybind R
    { scatter = 14, src = 4 },  -- keybind T
    { scatter = 15, src = 5 },  -- keybind F
}
local MICRO_BUTTONS = {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton",
    "AchievementMicroButton", "QuestLogMicroButton", "SocialsMicroButton",
    "PVPMicroButton", "LFDMicroButton", "MainMenuMicroButton", "HelpMicroButton",
}
local BAG_BUTTONS = {
    "MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot",
    "CharacterBag2Slot", "CharacterBag3Slot", "KeyRingButton",
}
local HIDE_FRAMES = {
    "MainMenuBar", "MainMenuBarArtFrame", "MainMenuExpBar",
    "ReputationWatchBar", "ActionBarUpButton", "ActionBarDownButton",
    "MainMenuBarPageNumber", "MultiBarBottomRight",
    "MultiBarLeft", "MultiBarRight",
}
-- Frames hidden outright at apply (static player-frame parts Blizzard never
-- re-shows). Condition-shown overlays live in PLAYER_OVERLAY instead — they
-- are parked off-screen, not hidden, so the two lists are disjoint and the
-- hide-only vs hide+park intent is explicit.
local PLAYER_HIDE = {
    "PlayerPortrait", "PlayerFrameTexture", "PlayerFrameBackground",
    "PlayerName", "PlayerRestStateGlow",
    "PlayerFrameLeaderIcon", "PlayerFrameMasterIcon", "PlayerFrameVehicleFeedback",
    "PlayerLevelText",
}
-- Condition-shown overlay frames (combat red flicker, resting zzz, pvp flag,
-- damage flash). Blizzard re-shows these itself on PLAYER_ENTER_COMBAT /
-- PLAYER_REGEN_DISABLED / PLAYER_UPDATE_RESTING / UNIT_FACTION, etc., but
-- never re-anchors them (only Show/SetVertexColor/SetAlpha). So instead of
-- fighting the re-show, park them 3000px below the frame: when the game shows
-- them they render off-screen and stay invisible. Original points AND shown
-- state are saved and restored so revert puts them back exactly where they
-- were. They are deliberately NOT in PLAYER_HIDE: hiding them at apply would
-- be redundant with the park (the park is the stronger guarantee — it also
-- covers Blizzard's re-show).
local PLAYER_OVERLAY = {
    "PlayerStatusTexture", "PlayerAttackIcon", "PlayerAttackGlow",
    "PlayerStatusGlow", "PlayerAttackBackground",
    "PlayerRestIcon", "PlayerRestGlow", "PlayerPVPIcon", "PlayerFrameFlash",
}
local PLAYER_TEXT = {
    "PlayerFrameHealthBarText", "PlayerFrameManaBarText",
    "PlayerFrameHealthBarTextLeft", "PlayerFrameHealthBarTextRight",
    "PlayerFrameManaBarTextLeft", "PlayerFrameManaBarTextRight",
}

-- LibButtonFacade for circular button skinning (embedded, no external addon needed)
local LBF = LibStub and LibStub("LibButtonFacade", true)
if not LBF then
    print("|cffff0000[MobileUI] LibButtonFacade not found in MobileUILayout!|r")
end
local lbfActionBar, lbfMenuBar

-- State
local saved = {}
local menuBar, bagButton, combatFrame, guardFrame, pendingAction, bagHooked
local HOTKEY_FRAMES = {}  -- populated in ApplyActionBar, hidden by guard OnUpdate

-- No tooltip over the thumb-zone action buttons: GameTooltip would cover the
-- scatter arc. Installed as OnEnter while the layout is active; the original
-- OnEnter is saved in SaveOriginals and restored on revert (layout toggle).
local function NoActionTooltipOnEnter()
    if GameTooltip then GameTooltip:Hide() end
end

-- Helpers
local function SavePoints(frame)
    local pts = {}
    for i = 1, frame:GetNumPoints() do
        local pt, relTo, relPt, x, y = frame:GetPoint(i)
        pts[i] = { pt, relTo, relPt, x, y }
    end
    return pts
end
local function RestorePoints(frame, pts)
    frame:ClearAllPoints()
    for i = 1, #pts do
        frame:SetPoint(pts[i][1], pts[i][2], pts[i][3], pts[i][4], pts[i][5])
    end
end

-- Skin a button using LibButtonFacade (embedded library, exact same code as ButtonFacade addon)
local function SkinButton(btn, buttonData)
    if not LBF then
        MobileUI_Debug("  SkinButton: LibButtonFacade NOT found!")
        return false
    end
    if btn:GetObjectType() == "CheckButton" then
        if not lbfActionBar then
            lbfActionBar = LBF:Group("MobileUI", "ActionBar")
            lbfActionBar:Skin("MobileUI-Circle", false, true)
        end
        lbfActionBar:AddButton(btn, buttonData or {})
    else
        if not lbfMenuBar then
            lbfMenuBar = LBF:Group("MobileUI", "MenuBar")
            lbfMenuBar:Skin("MobileUI-Circle", false, true)
        end
        lbfMenuBar:AddButton(btn, buttonData or {})
    end
    MobileUI_Debug("  SkinButton: " .. (btn:GetName() or "?") .. " skinned via LibButtonFacade")
    return true
end

local function UnskinButton(btn)
    if lbfActionBar then lbfActionBar:RemoveButton(btn) end
    if lbfMenuBar then lbfMenuBar:RemoveButton(btn) end
end

-- Save Originals (once)
local function SaveOriginals()
    if saved.init then return end
    saved.init = true
    local mc = _G["MinimapCluster"]
    if mc then
        saved.minimap = { points = SavePoints(mc) }
        local mm = _G["Minimap"]
        if mm then saved.minimap.onMouseUp = mm:GetScript("OnMouseUp") end
    end
    saved.micros = {}
    for _, name in ipairs(MICRO_BUTTONS) do
        local btn = _G[name]
        if btn then
            local nt = btn:GetNormalTexture()
            saved.micros[name] = {
                shown = btn:IsShown(),
                parent = btn:GetParent(),
                points = SavePoints(btn),
                w = btn:GetWidth(),
                h = btn:GetHeight(),
                normalTex = nt and nt:GetTexture(),
            }
        end
    end
    saved.bags = {}
    for _, name in ipairs(BAG_BUTTONS) do
        local btn = _G[name]
        if btn then saved.bags[name] = { shown = btn:IsShown() } end
    end
    saved.actions = {}
    for i = 1, 12 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local hotkey = _G["ActionButton" .. i .. "HotKey"]
            local nm = _G["ActionButton" .. i .. "Name"]
            local nt, pt = btn:GetNormalTexture(), btn:GetPushedTexture()
            saved.actions[i] = {
                parent = btn:GetParent(), points = SavePoints(btn),
                w = btn:GetWidth(), h = btn:GetHeight(),
                hotkeyShown = hotkey and hotkey:IsShown() or false,
                nameShown = nm and nm:IsShown() or false,
                normalTex = nt and nt:GetTexture(),
                pushedTex = pt and pt:GetTexture(),
                onEnter = btn:GetScript("OnEnter"),
                onEvent = btn:GetScript("OnEvent"),
            }
        end
    end
    -- Save MultiBarBottomLeft buttons (action bar 2) that feed scatter spots
    saved.actions2 = {}
    for _, pair in ipairs(ACTION2_BUTTONS) do
        local i, src = pair.scatter, pair.src
        local btn = _G["MultiBarBottomLeftButton" .. src]
        if btn then
            local hotkey = _G["MultiBarBottomLeftButton" .. src .. "HotKey"]
            local nm = _G["MultiBarBottomLeftButton" .. src .. "Name"]
            local nt, pt = btn:GetNormalTexture(), btn:GetPushedTexture()
            saved.actions2[i] = {
                parent = btn:GetParent(), points = SavePoints(btn),
                w = btn:GetWidth(), h = btn:GetHeight(),
                hotkeyShown = hotkey and hotkey:IsShown() or false,
                nameShown = nm and nm:IsShown() or false,
                normalTex = nt and nt:GetTexture(),
                pushedTex = pt and pt:GetTexture(),
                onEnter = btn:GetScript("OnEnter"),
            }
        end
    end
    local pf = _G["PlayerFrame"]
    if pf then
        saved.player = { points = SavePoints(pf), w = pf:GetWidth(), h = pf:GetHeight(), hidden = {} }
        for _, name in ipairs(PLAYER_HIDE) do
            local f = _G[name]
            if f then saved.player.hidden[name] = f:IsShown() end
        end
        local hb, mb = _G["PlayerFrameHealthBar"], _G["PlayerFrameManaBar"]
        if hb then saved.player.health = { points = SavePoints(hb), w = hb:GetWidth(), h = hb:GetHeight(), bd = hb:GetBackdrop() } end
        if mb then saved.player.mana = { points = SavePoints(mb), w = mb:GetWidth(), h = mb:GetHeight(), bd = mb:GetBackdrop() } end
        saved.player.text = {}
        for _, name in ipairs(PLAYER_TEXT) do
            local f = _G[name]
            if f then saved.player.text[name] = { points = SavePoints(f), shown = f:IsShown() } end
        end
        saved.player.overlay = {}
        for _, name in ipairs(PLAYER_OVERLAY) do
            local f = _G[name]
            if f then saved.player.overlay[name] = { points = SavePoints(f), shown = f:IsShown() } end
        end
    end
    saved.hides = {}
    for _, name in ipairs(HIDE_FRAMES) do
        local f = _G[name]
        if f then saved.hides[name] = f:IsShown() end
    end
    -- ChatFrame1: original position, so layout revert restores it exactly
    local cf = _G["ChatFrame1"]
    if cf then saved.chatFrame = { points = SavePoints(cf) } end
    -- Save shown state + anchor points of the bottom-left bar's tail buttons
    -- (6-12). The bar is horizontal and its buttons are anchor-chained (each
    -- LEFT of the previous button's RIGHT), so buttons 6-12 chain off the
    -- last scatter button and would render on screen; the layout hides them
    -- and parks them off-screen (combat re-show), revert restores both.
    saved.bar2tail = {}
    for i = 6, 12 do
        local b = _G["MultiBarBottomLeftButton" .. i]
        if b then saved.bar2tail[i] = { shown = b:IsShown(), points = SavePoints(b) } end
    end
end

-- 1. Map
-- Stock 3.3.5a fires Minimap_OnClick on ANY mouse-up over the minimap, which
-- calls Minimap:PingLocation() (the yellow pulse other players see). We don't
-- need that on mobile, so while the layout is active a click opens the full
-- world map instead (same as the M key: ToggleFrame(WorldMapFrame)). The whole
-- minimap square becomes the hit area (no radius check) = bigger touch target.
local function MinimapClick_OpenMap()
    ToggleFrame(WorldMapFrame)
end
local function ApplyMap()
    local mc = _G["MinimapCluster"]
    if not mc then MobileUI_Debug("ApplyMap: MinimapCluster NOT FOUND") return end
    mc:ClearAllPoints()
    mc:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
    local mm = _G["Minimap"]
    if mm then
        mm:SetScript("OnMouseUp", MinimapClick_OpenMap)
        MobileUI_Debug("ApplyMap: minimap click -> full map (ping disabled)")
    end
    MobileUI_Debug("ApplyMap: minimap moved to TOPLEFT")
end
local function RevertMap()
    local mc = _G["MinimapCluster"]
    if mc and saved.minimap then RestorePoints(mc, saved.minimap.points) end
    local mm = _G["Minimap"]
    if mm and saved.minimap and saved.minimap.onMouseUp then
        mm:SetScript("OnMouseUp", saved.minimap.onMouseUp)
        MobileUI_Debug("RevertMap: minimap click restored (ping enabled)")
    end
end

-- 2. Menu Bar → Top Right, Horizontal Circular Buttons
--    REPARENT existing micro buttons + apply standalone circular skin
local function ApplyMenuBar()
    MobileUI_Debug("ApplyMenuBar: starting")
    if not menuBar then
        menuBar = CreateFrame("Frame", "MobileUIMenuBar", UIParent)
        menuBar:SetFrameStrata("HIGH")
    end
    menuBar:ClearAllPoints()
    menuBar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -8, -8)
    menuBar:SetSize(180, 70)
    menuBar:Show()

    -- 2 rows: first 5 buttons in top row, last 5 in bottom row
    local xOffset = 0
    local yOffset = 0
    local count = 0
    for i = #MICRO_BUTTONS, 1, -1 do
        local name = MICRO_BUTTONS[i]
        local btn = _G[name]
        if btn then
            -- Reparent to menu bar (no skinning, keep default appearance)
            btn:SetParent(menuBar)
            btn:ClearAllPoints()
            btn:SetPoint("TOPRIGHT", menuBar, "TOPRIGHT", -xOffset, -yOffset)
            btn:SetFrameStrata("HIGH")
            btn:Show()

            -- PVPMicroButton has an internal icon texture positioned lower than others.
            -- Log and reposition the PVPMicroButtonTexture to align with the button center.
            if name == "PVPMicroButton" then
                for _, region in ipairs({btn:GetRegions()}) do
                    if region:GetObjectType() == "Texture" then
                        local rName = region:GetName() or ""
                        if rName ~= "" then
                            local pt, rel, relPt, x, y = region:GetPoint()
                            MobileUI_Debug(string.format("  PVP %s: pt=%s rel=%s relPt=%s x=%s y=%s",
                                rName, tostring(pt), tostring(rel and rel:GetName()), tostring(relPt), tostring(x), tostring(y)))
                        end
                        if rName == "PVPMicroButtonTexture" then
                            region:ClearAllPoints()
                            region:SetPoint("TOP", btn, "TOP", 6, -12)
                        end
                    end
                end
            end

            xOffset = xOffset + 30
            count = count + 1
            -- After 5 buttons, wrap to second row
            if count == 5 then
                xOffset = 0
                yOffset = 32
            end
            MobileUI_Debug("  " .. name .. " -> x=" .. xOffset .. " row=" .. (count > 5 and 2 or 1))
        else
            MobileUI_Debug("  " .. name .. " NOT FOUND")
        end
    end
    MobileUI_Debug("ApplyMenuBar: done")
end
local function RevertMenuBar()
    if menuBar then menuBar:Hide() end
    for _, name in ipairs(MICRO_BUTTONS) do
        local btn, sv = _G[name], saved.micros and saved.micros[name]
        if btn and sv then
            UnskinButton(btn)
            if btn._menuIcon then btn._menuIcon:Hide() end
            if sv.normalTex then
                btn:SetNormalTexture(sv.normalTex)
                local nt = btn:GetNormalTexture()
                if nt then nt:SetTexCoord(0, 1, 0, 1); nt:Show() end
            end
            local pt = btn:GetPushedTexture()
            if pt then pt:Show() end
            btn:SetParent(sv.parent)
            btn:SetSize(sv.w, sv.h)
            RestorePoints(btn, sv.points)
            if sv.shown then btn:Show() else btn:Hide() end
        end
    end
end

-- 3. Bags
local function RepositionContainerFrames()
    local x, y = 10, 70
    local screenH = UIParent:GetHeight()
    local colW = 170
    for i = 1, (NUM_BAG_SLOTS or 4) + 1 do
        local frame = _G["ContainerFrame" .. i]
        if frame and frame:IsShown() then
            local h = frame:GetHeight()
            if y + h > screenH - 10 then
                x = x + colW + 4
                y = 70
            end
            frame:ClearAllPoints()
            frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
            y = y + h + 4
            if frame:GetWidth() > colW then colW = frame:GetWidth() end
        end
    end
end
local function ApplyBags()
    for _, name in ipairs(BAG_BUTTONS) do
        local btn = _G[name]
        if btn then btn:Hide() end
    end
    if not bagButton then
        bagButton = CreateFrame("Button", "MobileUIBagButton", UIParent)
        bagButton:SetSize(48, 48)
        bagButton:SetFrameStrata("MEDIUM")
        bagButton:SetClampedToScreen(true)
        bagButton:SetNormalTexture("Interface\\Buttons\\Button-Backpack-Up")
        bagButton:SetPushedTexture("Interface\\Buttons\\Button-Backpack-Down")
        bagButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        bagButton:SetScript("OnClick", function()
            OpenAllBags()
            if IsBagOpen(0) then RepositionContainerFrames() end
        end)
        bagButton:SetScript("OnEnter", function(self)
            if GameTooltip then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText("|cff00ccffBags|r", 1, 1, 1)
                GameTooltip:AddLine("Click to open all bags.", 0.6, 0.6, 0.6)
                GameTooltip:Show()
            end
        end)
        bagButton:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    end
    bagButton:ClearAllPoints()
    bagButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
    bagButton:Show()
    if not bagHooked then
        bagHooked = true
        hooksecurefunc("OpenAllBags", function()
            if MobileDB.layoutEnabled and IsBagOpen(0) then RepositionContainerFrames() end
        end)
        hooksecurefunc("ToggleBackpack", function()
            if MobileDB.layoutEnabled and IsBagOpen(0) then RepositionContainerFrames() end
        end)
    end
end
local function RevertBags()
    if bagButton then bagButton:Hide() end
    for _, name in ipairs(BAG_BUTTONS) do
        local btn, sv = _G[name], saved.bags and saved.bags[name]
        if btn and sv and sv.shown then btn:Show() end
    end
end

-- 4. Action Bar → circular (via embedded LibButtonFacade)
local function ApplyActionBar()
    MobileUI_Debug("ApplyActionBar: starting")
    HOTKEY_FRAMES = {}  -- reset list
    -- Main bar buttons 1-10 (keys 1-0). ActionButton11/12 ("-" and "=") are
    -- intentionally NOT scattered: Artemis has no "-"/"=" virtual keys, so
    -- those two spots are filled by bottom-left bar buttons 1/2 below.
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local cfg = ACTION_BUTTONS[i]
            btn:SetParent(UIParent)
            btn:ClearAllPoints()
            btn:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", cfg.x, cfg.y)
            btn:SetSize(cfg.size, cfg.size)
            btn:SetFrameStrata("MEDIUM")
            btn:Show()
            -- Skin via embedded LibButtonFacade
            SkinButton(btn, {
                Icon = _G["ActionButton" .. i .. "Icon"],
                Cooldown = _G["ActionButton" .. i .. "Cooldown"],
                HotKey = _G["ActionButton" .. i .. "HotKey"],
                Count = _G["ActionButton" .. i .. "Count"],
                Flash = _G["ActionButton" .. i .. "Flash"],
                AutoCast = _G["ActionButton" .. i .. "Shine"],
                AutoCastable = _G["ActionButton" .. i .. "AutoCastable"],
            })
            local hotkey = _G["ActionButton" .. i .. "HotKey"]
            if hotkey then hotkey:Hide() end
            local nm = _G["ActionButton" .. i .. "Name"]
            if nm then nm:Hide() end
            if hotkey then HOTKEY_FRAMES[#HOTKEY_FRAMES+1] = hotkey end
            if nm then HOTKEY_FRAMES[#HOTKEY_FRAMES+1] = nm end
            -- showgrid: left at the client default. We no longer force
            -- showgrid=1 — the client manages button visibility normally
            -- now that OnEvent is intact (no per-frame redraw to keep
            -- buttons visible for).
            btn:SetScript("OnEnter", NoActionTooltipOnEnter)
            -- OnEvent: left intact. The client's own ActionButton_Update
            -- resolves the action via the bridge's actionpage attribute and
            -- renders icon/tint/cooldown/flash correctly. Confirmed in-game
            -- (phase 3): with OnEvent intact and no field writes on the
            -- secure buttons, there is NO taint — the taint that forced the
            -- old OnEvent-clearing was caused by field writes (self.action /
            -- isBonus) since removed. We no longer clear OnEvent or run a
            -- per-frame combat redraw.
            MobileUI_Debug("  ActionButton" .. i .. " skinned")
        else
            MobileUI_Debug("  ActionButton" .. i .. " NOT FOUND")
        end
    end
    -- Action bar 2 (MultiBarBottomLeft): scatter spots 11-15
    -- Spots 11/12 are NOT ActionButton11/12 ("-" and "="): Artemis has no
    -- virtual keys for "-"/"=", so all five outermost spots are filled by
    -- bottom-left bar buttons 1-5 in order (keybinds Q/E/R/T/F), making the
    -- arc read 1-2-3-4-5 left to right.
    -- IMPORTANT: do NOT reparent these buttons. This Ascension client resolves
    -- a button's slot from the bar it is attached to (MultiBarBottomLeft =
    -- slots 61-65 here). Reparenting to UIParent makes them fall back to their
    -- id (1-5) and collide with the main bar. Reposition via UIParent anchors
    -- instead; the bar frame itself is parked off-screen by ApplyHideFrames.
    for _, pair in ipairs(ACTION2_BUTTONS) do
        local i, src = pair.scatter, pair.src
        local btn = _G["MultiBarBottomLeftButton" .. src]
        if btn then
            local cfg = ACTION_BUTTONS[i]
            btn:ClearAllPoints()
            btn:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", cfg.x, cfg.y)
            btn:SetSize(cfg.size, cfg.size)
            btn:SetFrameStrata("MEDIUM")
            btn:Show()
            SkinButton(btn, {
                Icon = _G["MultiBarBottomLeftButton" .. src .. "Icon"],
                Cooldown = _G["MultiBarBottomLeftButton" .. src .. "Cooldown"],
                HotKey = _G["MultiBarBottomLeftButton" .. src .. "HotKey"],
                Count = _G["MultiBarBottomLeftButton" .. src .. "Count"],
                Flash = _G["MultiBarBottomLeftButton" .. src .. "Flash"],
                AutoCast = _G["MultiBarBottomLeftButton" .. src .. "Shine"],
                AutoCastable = _G["MultiBarBottomLeftButton" .. src .. "AutoCastable"],
            })
            local hotkey = _G["MultiBarBottomLeftButton" .. src .. "HotKey"]
            if hotkey then hotkey:Hide() end
            local nm = _G["MultiBarBottomLeftButton" .. src .. "Name"]
            if nm then nm:Hide() end
            if hotkey then HOTKEY_FRAMES[#HOTKEY_FRAMES+1] = hotkey end
            if nm then HOTKEY_FRAMES[#HOTKEY_FRAMES+1] = nm end
            btn:SetScript("OnEnter", NoActionTooltipOnEnter)
            MobileUI_Debug("  MultiBarBottomLeftButton" .. src .. " (as btn" .. i .. ") skinned")
        else
            MobileUI_Debug("  MultiBarBottomLeftButton" .. src .. " NOT FOUND")
        end
    end
    MobileUILayout.EnsureFlipWatcher()
    MobileUILayout.InstallFlipBridge()
    MobileUILayout.ApplyFlip()
end
local function RevertActionBar()
    HOTKEY_FRAMES = {}  -- stop guard from hiding hotkeys/names
    -- Clear the actionpage mirror so the stock bar is left exactly as the
    -- client manages it (attribute channel; revert runs out of combat).
    for i = 1, 12 do
        local btn = _G["ActionButton" .. i]
        if btn then pcall(function() btn:SetAttribute("actionpage", nil) end) end
    end
    for i = 1, 12 do
        local btn = _G["ActionButton" .. i]
        local sv = saved.actions and saved.actions[i]
        if btn and sv then
            UnskinButton(btn)
            btn:SetParent(sv.parent)
            btn:SetSize(sv.w, sv.h)
            RestorePoints(btn, sv.points)
            if sv.normalTex then
                btn:SetNormalTexture(sv.normalTex)
                local nt = btn:GetNormalTexture()
                if nt then nt:SetTexCoord(0, 1, 0, 1); nt:Show() end
            end
            if sv.pushedTex then
                btn:SetPushedTexture(sv.pushedTex)
                local pt = btn:GetPushedTexture()
                if pt then pt:SetTexCoord(0, 1, 0, 1); pt:Show() end
            end
            local icon = _G["ActionButton" .. i .. "Icon"]
            if icon then icon:SetTexCoord(0, 1, 0, 1) end
            local hotkey = _G["ActionButton" .. i .. "HotKey"]
            if hotkey and sv.hotkeyShown then hotkey:Show() end
            local nm = _G["ActionButton" .. i .. "Name"]
            if nm and sv.nameShown then nm:Show() end
            btn:SetScript("OnEnter", sv.onEnter)
            btn:SetScript("OnEvent", sv.onEvent)
        end
    end
    -- Revert MultiBarBottomLeft buttons (spots 11-15)
    for _, pair in ipairs(ACTION2_BUTTONS) do
        local i, src = pair.scatter, pair.src
        local btn = _G["MultiBarBottomLeftButton" .. src]
        local sv = saved.actions2 and saved.actions2[i]
        if btn and sv then
            UnskinButton(btn)
            btn:SetParent(sv.parent)
            btn:SetSize(sv.w, sv.h)
            RestorePoints(btn, sv.points)
            if sv.normalTex then
                btn:SetNormalTexture(sv.normalTex)
                local nt = btn:GetNormalTexture()
                if nt then nt:SetTexCoord(0, 1, 0, 1); nt:Show() end
            end
            if sv.pushedTex then
                btn:SetPushedTexture(sv.pushedTex)
                local pt = btn:GetPushedTexture()
                if pt then pt:SetTexCoord(0, 1, 0, 1); pt:Show() end
            end
            local icon = _G["MultiBarBottomLeftButton" .. src .. "Icon"]
            if icon then icon:SetTexCoord(0, 1, 0, 1) end
            local hotkey = _G["MultiBarBottomLeftButton" .. src .. "HotKey"]
            if hotkey and sv.hotkeyShown then hotkey:Show() end
            local nm = _G["MultiBarBottomLeftButton" .. src .. "Name"]
            if nm and sv.nameShown then nm:Show() end
            btn:SetScript("OnEnter", sv.onEnter)
        end
    end
    -- Drop the SecureStateDriver bridge (the buttons were reparented back
    -- to their stock parents above, so the handler frames are childless).
    MobileUILayout.UninstallFlipBridge()
end

-- 4b. Stance/stealth flip follower — mirror the bar the client targets
-- The Ascension client resolves keypresses internally (C-side): in stealth
-- '-' hits the stealth bar, which on this client is the BONUS bar
-- (GetBonusBarOffset() = 1 -> page 7, slots 73-84) — NOT an action-bar page.
-- GetActionBarPage() stays pinned at 1 and pages 2-5 are empty; the default
-- UI's "stealth bar" is BonusActionBarFrame. The reparented scatter buttons
-- never recompute on their own, so display and click stay on page 1 while
-- keypresses go elsewhere. Driven by a 0.25s state poll in guardFrame's
-- OnUpdate (this client fires no page/shapeshift events), the follower
-- mirrors the client's choice via the 'actionpage' ATTRIBUTE — the secure
-- channel for configuring secure buttons.
-- TAINT RULES (learned the hard way):
--   * Writing plain Lua fields that ActionButton_CalculateAction READS
--     (e.g. isBonus) taints the secure click chain: the next click errors
--     "AddOn 'MobileUI' tainted the call of the secure function
--     'UseAction()'" and the cast is blocked. Attributes don't taint.
--   * On THIS client ANY direct field write on the secure buttons taints
--     — even self.action, which CalculateAction never reads: after the
--     write, the client's own later SetAttribute on the button errors
--     "prevented the call of the secure function 'ActionButtonN:SetAttribute()'"
--     and its page management breaks. So the display must be owned via
--     non-protected regions only (icon/cooldown textures, vertex color)
--     and the client must be prevented from hiding/re-rendering the
--     buttons from their stale self.action: the buttons' OnEvent is
--     cleared at apply (the client never dispatches their updates — which
--     also stops its Show()/Hide() from being blocked on our tainted
--     buttons), showgrid=1 keeps its Update from hiding them, and a
--     per-frame combat re-assert redraws icon/color/cooldown/flash from
--     the attr page (usability tints computed from the CORRECT action).
local flipFrame

-- The CLIENT owns the stance->bar mapping; we only mirror it. Generic rules
-- in priority order — no per-class guessing for normal cases:
--   1. Stock 3.3.5a: entering a form flips GetActionBarPage() -> follow it.
--   2. This client: entering stealth/stance shows the BONUS bar
--      (GetBonusBarOffset() > 0) — the exact condition stock
--      BonusActionBarFrame uses to show itself. We mirror it via the
--      actionpage attribute: stock ActionButton_CalculateAction resolves
--      page from the button's actionpage attribute FIRST (falling back to
--      GetActionBarPage), so setting it to NUM_ACTIONBAR_PAGES + offset
--      (7) makes display, click, and keypress all follow the bonus slots.

-- Diagnostic: map every action-bar page's slots to see where the user's
-- skills actually live (page 1 = main bar, page 6 = bar 6, page 7 = bonus).
local function SlotDump(label)
    local parts = {}
    for p = 1, 7 do
        local row = {}
        for s = 1, 12 do
            local a = (p - 1) * 12 + s
            row[#row + 1] = GetActionTexture(a) and "X" or "."
        end
        parts[#parts + 1] = p .. ":" .. table.concat(row)
    end
    MobileUI_Debug("Slots " .. label .. ": " .. table.concat(parts, " | "))
end

-- Diagnostic: per-button visible state — the icon's ACTUAL texture path and
-- the button's cached self.action (read-only; we never write fields on
-- secure buttons). Comparing a dump right after our refresh with one ~1s
-- later shows whether the client re-updates the buttons from stale
-- self.action (page-7 values) and overwrites our page-1 icon draws.
local function ButtonStateDump(label)
    local parts = {}
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local icon = _G[btn:GetName() .. "Icon"]
            local tex = icon and icon:GetTexture() or "?"
            parts[#parts + 1] = i .. ":act=" .. tostring(btn.action) .. ":tex=" .. tostring(tex)
        end
    end
    MobileUI_Debug("Btns " .. label .. ": " .. table.concat(parts, " "))
end

local function DelayedDump(seconds, label)
    local f = CreateFrame("Frame")
    local t = 0
    f:SetScript("OnUpdate", function(self, el)
        t = t + el
        if t >= seconds then
            ButtonStateDump(label)
            self:SetScript("OnUpdate", nil)
        end
    end)
end

-- Resolve a scatter button's action slot exactly as ActionButton_CalculateAction
-- will at click time (actionpage attribute first, then GetActionBarPage), so
-- display and click always agree. Returns the actionID and the icon texture.
local function ResolveScatterAction(btn, fallbackId)
    local id = btn:GetID()
    if not id or id < 1 then id = fallbackId end
    local attrPage = tonumber(SecureButton_GetModifiedAttribute(btn, "actionpage"))
    local page = attrPage or (GetActionBarPage() or 1)
    local action = id + (page - 1) * (NUM_ACTIONBAR_BUTTONS or 12)
    return action, _G[btn:GetName() .. "Icon"]
end

local function RefreshScatterButtons()
    if InCombatLockdown() then
        -- Manual refresh: the full ActionButton_UpdateAction path calls
        -- self:Show()/Hide() on the protected button (blocked in combat).
        -- Icons are plain textures, so draw the icon directly. No field
        -- writes on the secure button (that taints).
        for i = 1, 12 do
            local btn = _G["ActionButton" .. i]
            if btn then
                local action, icon = ResolveScatterAction(btn, i)
                local tex = GetActionTexture(action)
                if tex then
                    icon:SetTexture(tex)
                    icon:Show()
                else
                    icon:Hide()
                end
            end
        end
        -- Diagnostic: which page-1 slots actually have content, and which
        -- buttons drew an icon (the user sees only some buttons populated
        -- after the in-combat flip — need to know if the slots are empty or
        -- the draw is failing). Only when debug is enabled.
        if MobileDB and MobileDB.debug then
            local drawn, slots = {}, {}
            for i = 1, 10 do
                if GetActionTexture(i) then slots[#slots + 1] = i end
            end
            for i = 1, 12 do
                local btn = _G["ActionButton" .. i]
                if btn then
                    local icon = _G[btn:GetName() .. "Icon"]
                    if icon and icon:IsShown() then drawn[#drawn + 1] = i end
                end
            end
            MobileUI_Debug("Refresh: slotTex1_10={" .. table.concat(slots, ",") .. "} drawn={" .. table.concat(drawn, ",") .. "}")
            ButtonStateDump("at-refresh")
        end
    else
        for i = 1, 12 do
            local btn = _G["ActionButton" .. i]
            if btn then
                local ok, err = pcall(ActionButton_UpdateAction, btn)
                if not ok then
                    MobileUI_Debug("Flip: ActionButton" .. i .. " update failed: " .. tostring(err))
                end
            end
        end
    end
end

-- ---- SecureStateDriver bridge (combat-safe attribute writes) ----
-- Our own SetAttribute("actionpage", N) on the ActionButtons is SILENTLY
-- blocked during combat lockdown on this client (verified via readback:
-- after ApplyFlip writes 1 mid-combat, the attribute still reads 7; pcall
-- can't catch it because secure-call blocking is not a Lua error). The one
-- stock mechanism that CAN write attributes on protected frames during
-- combat is the SecureStateDriver manager (a secure frame). But the driver
-- manages 'state-<name>' attributes, which ActionButton_CalculateAction
-- does NOT read (it reads plain 'actionpage' via the useparent walk). So:
--   - each scattered ActionButton1-10 is reparented under a tiny
--     SecureHandlerStateTemplate frame (ours, created out of combat);
--   - RegisterStateDriver(handler, "actionpage", COND) makes the manager
--     re-evaluate COND every 0.2s (and immediately on bonus/stealth/page
--     events) and securely SetAttribute 'state-actionpage' on the handler
--     — even during combat lockdown;
--   - the handler's template-wired _onstate-actionpage snippet copies
--     'state-actionpage' -> 'actionpage' on the handler (restricted
--     closure: it runs in a secure context, so its SetAttribute is allowed
--     in combat too);
--   - the button's stock useparent-actionpage=true walk then reads the
--     handler's 'actionpage' -> CalculateAction, clicks, and our refresh
--     all resolve the same page, in and out of combat.
-- COND mirrors the client generically: [bonusbar:N] -> page 6+N (this
-- client's stealth/stance bonus bar), [bar:N] -> N (stock page flips),
-- else an explicit 1 (never nil — a nil-clear left the client's C-side
-- keypress resolver stuck on the bonus page after unstealth).
local flipHandlers = {}
local FLIP_HANDLER_SNIPPET = [[
    if newstate then
        self:SetAttribute("actionpage", newstate)
    else
        self:SetAttribute("actionpage", 1)
    end
]]
local flipNumPages = NUM_ACTIONBAR_PAGES or 6
local flipParts = {}
for flipOff = 1, 5 do
    flipParts[#flipParts + 1] = string.format("[bonusbar:%d] %d", flipOff, flipNumPages + flipOff)
end
for flipPage = 2, flipNumPages do
    flipParts[#flipParts + 1] = string.format("[bar:%d] %d", flipPage, flipPage)
end
flipParts[#flipParts + 1] = "1"
local FLIP_DRIVER_COND = table.concat(flipParts, "; ")

function MobileUILayout.InstallFlipBridge()
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn and not flipHandlers[i] then
            local h = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
            h:SetSize(1, 1)
            h:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
            h:Show()
            local ok, err = pcall(function()
                h:SetAttribute("_onstate-actionpage", FLIP_HANDLER_SNIPPET)
                RegisterStateDriver(h, "actionpage", FLIP_DRIVER_COND)
            end)
            if ok then
                btn:SetParent(h)
                flipHandlers[i] = h
            else
                MobileUI_Debug("Flip: bridge install failed for ActionButton" .. i .. ": " .. tostring(err))
                h:Hide()
            end
        end
    end
end

function MobileUILayout.UninstallFlipBridge()
    for i = 1, 10 do
        local h = flipHandlers[i]
        if h then
            UnregisterStateDriver(h, "actionpage")
            h:Hide()
            flipHandlers[i] = nil
        end
    end
end

-- Per-frame combat display redraw REMOVED (phase 4): the client owns the
-- scatter buttons' display now that their OnEvent is left intact. The
-- SecureStateDriver bridge (above) writes the actionpage attribute in
-- combat; the client's own ActionButton_Update (re-fired on
-- UPDATE_BONUS_ACTIONBAR / UPDATE_SHAPESHIFT_FORM, confirmed firing on
-- Ascension) resolves the correct action and renders icon/tint/cooldown/
-- flash itself — including the auto-attack blink (IsAttackAction +
-- IsAutoRepeatAction + IsCurrentAction, wider than our reimplementation).

function MobileUILayout.ApplyFlip()
    if not MobileDB or not MobileDB.layoutEnabled then return end
    -- The actionpage ATTRIBUTE is now owned by the SecureStateDriver bridge
    -- above (InstallFlipBridge): the driver's manager is a secure frame, so
    -- it can SetAttribute during combat lockdown — our own writes cannot
    -- (verified: SetAttribute on ActionButtons is SILENTLY blocked
    -- mid-combat on this client; pcall can't catch it because blocking
    -- isn't a Lua error). Display, click, and keypress all resolve through
    -- the same attribute, so they always agree, in and out of combat.
    -- ApplyFlip only mirrors the client's side-effects and re-draws the
    -- buttons to follow the attribute.
    local page = GetActionBarPage() or 1
    local fp = page
    if page == 1 then
        local off = GetBonusBarOffset() or 0
        if off > 0 then fp = (NUM_ACTIONBAR_PAGES or 6) + off end
    end
    MobileUI_Debug(string.format("Flip: page=%d off=%d fp=%d combat=%d",
        page, GetBonusBarOffset() or 0, fp, InCombatLockdown() and 1 or 0))
    RefreshScatterButtons()
    local b1 = _G["ActionButton1"]
    if b1 then
        MobileUI_Debug("Flip: attr1=" .. tostring(SecureButton_GetModifiedAttribute(b1, "actionpage")))
    end
end

function MobileUILayout.EnsureFlipWatcher()
    if flipFrame then return end
    flipFrame = CreateFrame("Frame")
    flipFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    flipFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    flipFrame:RegisterEvent("UPDATE_STEALTH")
    flipFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    flipFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    flipFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    flipFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    -- The buttons re-render from their stale self.action on these, so we
    -- redraw right after their handlers run (our registration is newer,
    -- so we dispatch after them) to kill the one-frame stale flicker at
    -- combat transitions.
    flipFrame:RegisterEvent("PLAYER_ENTER_COMBAT")
    flipFrame:RegisterEvent("PLAYER_LEAVE_COMBAT")
    flipFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
    flipFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    flipFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    flipFrame:SetScript("OnEvent", function(self, event, ...)
        -- Combat-safe: ApplyFlip only draws icon textures (plain texture
        -- regions, no secure/protected calls). The actionpage attribute is
        -- owned by the SecureStateDriver bridge above, set independently of
        -- this handler.
        MobileUI_Debug(string.format("Flip evt: %s off=%d page=%d combat=%d",
            event, GetBonusBarOffset() or 0, GetActionBarPage() or 1,
            InCombatLockdown() and 1 or 0))
        MobileUILayout.ApplyFlip()
        -- The client owns the scatter display (OnEvent intact): its own
        -- ActionButton_Update re-renders on these events via the bridge's
        -- actionpage attribute. ApplyFlip mirrors/logs the state; no
        -- per-frame redraw is needed.
    end)
end

-- 5. Player HP / Mana
local function ApplyPlayerFrame()
    local pf = _G["PlayerFrame"]
    if not pf then MobileUI_Debug("ApplyPlayerFrame: PlayerFrame NOT FOUND") return end
    MobileUI_Debug("ApplyPlayerFrame: starting")
    pf:ClearAllPoints()
    pf:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 12)
    pf:SetWidth(280)
    pf:SetHeight(34)
    pf:SetFrameStrata("MEDIUM")
    for _, name in ipairs(PLAYER_HIDE) do
        local f = _G[name]
        if f then f:Hide() end
    end
    -- Park condition-shown overlays off-screen (Blizzard never re-anchors
    -- them, so the re-show on combat/rest/pvp renders invisible)
    for _, name in ipairs(PLAYER_OVERLAY) do
        local f = _G[name]
        if f then
            f:ClearAllPoints()
            f:SetPoint("TOPLEFT", pf, "TOPLEFT", 0, -3000)
        end
    end
    local roundedBD = {
        bgFile = "Interface\Tooltips\UI-Tooltip-Background",
        edgeFile = "Interface\Tooltips\UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    }
    local hb = _G["PlayerFrameHealthBar"]
    if hb then
        hb:ClearAllPoints()
        hb:SetPoint("TOPLEFT", pf, "TOPLEFT", 4, -4)
        hb:SetWidth(272)
        hb:SetHeight(14)
        hb:SetBackdrop(roundedBD)
        hb:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
        hb:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.9)
    end
    local mb = _G["PlayerFrameManaBar"]
    if mb then
        mb:ClearAllPoints()
        mb:SetPoint("TOPLEFT", hb or pf, "BOTTOMLEFT", 0, -3)
        mb:SetWidth(272)
        mb:SetHeight(12)
        mb:SetBackdrop(roundedBD)
        mb:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
        mb:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.9)
    end
    for _, name in ipairs(PLAYER_TEXT) do
        local f = _G[name]
        if f then
            f:ClearAllPoints()
            f:SetPoint("CENTER", name:find("Health") and hb or mb, "CENTER", 0, 0)
            f:Show()
        end
    end
end
local function RevertPlayerFrame()
    local pf = _G["PlayerFrame"]
    if not pf or not saved.player then return end
    pf:SetWidth(saved.player.w)
    pf:SetHeight(saved.player.h)
    RestorePoints(pf, saved.player.points)
    for _, name in ipairs(PLAYER_HIDE) do
        local f = _G[name]
        if f and saved.player.hidden[name] then f:Show() end
    end
    -- Restore overlay frames to their original anchored positions and shown
    -- state (they were parked off-screen, not hidden, at apply).
    if saved.player.overlay then
        for name, sv in pairs(saved.player.overlay) do
            local f = _G[name]
            if f then
                RestorePoints(f, sv.points)
                if sv.shown then f:Show() else f:Hide() end
            end
        end
    end
    local hb = _G["PlayerFrameHealthBar"]
    if hb and saved.player.health then
        hb:SetWidth(saved.player.health.w)
        hb:SetHeight(saved.player.health.h)
        hb:SetBackdrop(saved.player.health.bd)
        RestorePoints(hb, saved.player.health.points)
    end
    local mb = _G["PlayerFrameManaBar"]
    if mb and saved.player.mana then
        mb:SetWidth(saved.player.mana.w)
        mb:SetHeight(saved.player.mana.h)
        mb:SetBackdrop(saved.player.mana.bd)
        RestorePoints(mb, saved.player.mana.points)
    end
    for _, name in ipairs(PLAYER_TEXT) do
        local f, sv = _G[name], saved.player.text[name]
        if f and sv then
            RestorePoints(f, sv.points)
            if sv.shown then f:Show() else f:Hide() end
        end
    end
end

-- 6. Chat Frame: lift it so its "to newest" scroll button sits just above
-- the chat bubble (which itself sits just above the bag icon).
-- 3.3.5 FrameXML geometry: the scroll-button strip (ChatFrame1ButtonFrame) is
-- anchored to the chat frame's LEFT edge at x=-4 (29px wide, full height).
-- ChatFrame1ButtonFrameBottomButton ("to newest") is 32x32, anchored BOTTOM of
-- that strip at y=-7 -> its bottom edge is 7px below the chat frame's bottom,
-- horizontally centered at chatFrameLeft - 18.5.
-- ChatFrame1 at BOTTOMLEFT (44.5, 99) => button bottom y = 99-7 = 92, x-span
-- [10, 42] = 2px below the bubble top (94) -- the SAME facing-edge offset
-- (-2) the down button uses against the "to newest" button, so the bubble
-- sits at the same visual distance as the button stack spacing.
-- The tab strip (GENERAL_CHAT_DOCK) follows automatically: FCFDock_SetPrimary
-- anchors the dock's BOTTOMLEFT to ChatFrame1's TOPLEFT (+6).  The chat-menu
-- and social buttons follow via their anchors to the button stack.
local function ApplyChatFrame()
    local cf = _G["ChatFrame1"]
    if cf then
        cf:ClearAllPoints()
        cf:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 44.5, 99)
        MobileUI_Debug("ApplyChatFrame: ChatFrame1 -> BOTTOMLEFT (44.5, 99)")
    end
    -- Keep the bubble glued just above the bag (also covers layout toggles)
    if MobileUI and MobileUI.PositionChatBubble then
        MobileUI:PositionChatBubble()
    end
end
local function RevertChatFrame()
    local cf = _G["ChatFrame1"]
    if cf and saved.chatFrame then
        RestorePoints(cf, saved.chatFrame.points)
        MobileUI_Debug("RevertChatFrame: ChatFrame1 position restored")
    end
    if MobileUI and MobileUI.PositionChatBubble then
        MobileUI:PositionChatBubble()
    end
end

-- Hide Bottom Bar Art + OnUpdate Guard
-- MultiBarBottomLeft must NOT be hidden or moved: the scatter buttons stay
-- attached to it (slot resolution comes from the attached bar), and a hidden
-- parent means children don't render. The client marks the bar container as a
-- protected frame, so ClearAllPoints()/SetPoint() on it raise a secure-call
-- error ("prevented the call of the secure function"). We leave it at its
-- stock anchor — the container has no art, so it is invisible — and only
-- ensure it stays SHOWN. Its non-scatter buttons (6-12) are hidden
-- individually instead.
local function EnsureBarShown()
    local mbl = _G["MultiBarBottomLeft"]
    if mbl and not mbl:IsShown() then mbl:Show() end
end
-- Hide the bottom-left bar's non-scatter buttons (6-12). The bar is horizontal
-- and its buttons are anchor-chained (each LEFT of the previous button's
-- RIGHT), so buttons 6-12 chain off the last scatter button
-- (MultiBarBottomLeftButton5 at scatter spot 15) and would render on screen
-- next to the arc. Hiding them individually is safe: they stay attached to the
-- bar, so slot resolution for the scatter buttons is unaffected.
local function HideBar2Tail()
    for i = 6, 12 do
        local b = _G["MultiBarBottomLeftButton" .. i]
        if b and b:IsShown() then b:Hide() end
    end
end
-- Park the tail buttons far off-screen. Hide() alone is not combat-proof: the
-- client re-shows the bar's buttons when combat starts, and the guard frame
-- pauses its per-frame HideBar2Tail() during combat lockdown (Show/Hide on
-- protected frames in combat taints them and breaks the next UseAction click).
-- Re-shows never re-anchor, so a one-shot off-screen reposition at apply time
-- (always out of combat) makes the combat re-show render invisibly — with no
-- per-frame protected-frame calls during the fight. Each button gets its own
-- independent anchor (don't rely on the chain dragging 7-12 after 6), and all
-- stay children of MultiBarBottomLeft, so slot resolution (61-72) is untouched.
local function ParkBar2Tail()
    for i = 6, 12 do
        local b = _G["MultiBarBottomLeftButton" .. i]
        if b then
            b:ClearAllPoints()
            b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
        end
    end
end
local function ApplyHideFrames()
    for _, name in ipairs(HIDE_FRAMES) do
        local f = _G[name]
        if f then f:Hide() end
    end
    EnsureBarShown()
    HideBar2Tail()
    ParkBar2Tail()
    if not guardFrame then
        guardFrame = CreateFrame("Frame")
        guardFrame:SetScript("OnUpdate", function(self, elapsed)
            if not MobileDB or not MobileDB.layoutEnabled then return end
            -- Flip state check (0.25s throttle). The stance/stealth events
            -- (UPDATE_BONUS_ACTIONBAR / UPDATE_SHAPESHIFT_FORM) DO fire on
            -- Ascension (confirmed in-game), so flip detection is event-driven
            -- via flipFrame above. This poll is kept for the unstealth
            -- BonusActionBarFrame-hide workaround below (an Ascension client
            -- quirk: it never hides the bonus bar on unstealth, sticking
            -- keys on stealth slots), which must run reliably even when the
            -- event dispatch path is mid-flight.
            self._t = (self._t or 0) + elapsed
            if self._t >= 0.25 then
                self._t = 0
                local page = GetActionBarPage() or 1
                local off = GetBonusBarOffset() or 0
                -- Include the resolved actionpage attribute: the bridge
                -- updates it asynchronously (driver 0.2s throttle / event
                -- re-eval), so re-run ApplyFlip when IT changes too, not
                -- just when page/off move.
                local b1 = _G["ActionButton1"]
                local a1 = b1 and SecureButton_GetModifiedAttribute(b1, "actionpage") or "?"
                local state = string.format("%d|%d|%s", page, off, tostring(a1))
                if state ~= self._flipState then
                    local prevOff = self._flipOff
                    self._flipState = state
                    self._flipOff = off
                    MobileUI_Debug(string.format("Flip poll: %s->%s combat=%d",
                        self._prevState or "?", state, InCombatLockdown() and 1 or 0))
                    self._prevState = state
                    -- On unstealth (bonus offset 1->0):
                    -- 1) This client shows BonusActionBarFrame on stealth but
                    --    NEVER hides it on unstealth (the stock HideBonusActionBar
                    --    slide path doesn't run), and its keypress resolver
                    --    routes ACTIONBUTTON keys to the bonus bar while that
                    --    frame is shown — so keys get stuck casting stealth
                    --    slots. Force-hide it.
                    -- 2) ChangeActionBarPage(1) here is what makes the
                    --    in-combat unstealth display flip work (cpage stays 1
                    --    and no event fires, but without it the bar froze on
                    --    stealth skills when unstealthing during combat).
                    if off == 0 and prevOff and prevOff > 0 then
                        local bf = BonusActionBarFrame
                        local shown = bf and bf:IsShown() and 1 or 0
                        if bf and shown == 1 then bf:Hide() end
                        local ok = pcall(ChangeActionBarPage, 1)
                        MobileUI_Debug(string.format("Flip unstealth: bonusShown=%d changePage=%s", shown, tostring(ok)))
                        if MobileDB and MobileDB.debug then
                            SlotDump("after-unstealth")
                            ButtonStateDump("unstealth")
                            DelayedDump(1.0, "unstealth+1s")
                        end
                    end
                    MobileUILayout.ApplyFlip()
                end
            end
            -- This client never hides BonusActionBarFrame after unstealth
            -- (the C-side keypress router targets it while shown, sticking
            -- keys on stealth slots). Keep it hidden whenever no bonus bar is
            -- active; in stealth the offset is > 0 so the real stealth bar is
            -- left alone. BonusActionBarFrame is NOT a protected frame, so
            -- hiding it is taint-safe even during combat lockdown — the
            -- client re-shows bars at combat transitions, and if it re-shows
            -- the bonus bar mid-combat after an unstealth, keys stay stuck on
            -- stealth slots for the whole fight.
            local bf = BonusActionBarFrame
            if bf and bf:IsShown() and (GetBonusBarOffset() or 0) == 0 then bf:Hide() end
            -- Everything below this line Show()/Hide()s PROTECTED frames (the
            -- stock bars and bar buttons): during combat lockdown those calls
            -- are blocked and TAINT the frames — which then surfaces as
            -- "MobileUI tainted the call of the secure function 'UseAction()'"
            -- on the next button click. Pause that enforcement during combat;
            -- the stock bar briefly showing is cosmetic, and full enforcement
            -- resumes when combat ends. (The flip poll above is pure Lua and
            -- stays active in combat.)
            if InCombatLockdown() then
                -- The client owns the scatter display (OnEvent intact); no
                -- per-frame redraw. Keep the early return so we don't enforce
                -- HIDE_FRAMES on protected frames mid-combat.
                return
            end
            for _, name in ipairs(HIDE_FRAMES) do
                local f = _G[name]
                if f and f:IsShown() then f:Hide() end
            end
            -- MultiBarBottomLeft: keep SHOWN (a hidden parent hides the
            -- scatter buttons). Never touch its points — the client marks the
            -- bar container as a protected frame.
            EnsureBarShown()
            -- Tail buttons (6-12) chain off the last scatter button's RIGHT
            -- edge; re-hide them in case the client re-shows them
            HideBar2Tail()
            -- Keep action button hotkeys/names hidden
            for _, f in ipairs(HOTKEY_FRAMES) do
                if f and f:IsShown() then f:Hide() end
            end
        end)
    end
    guardFrame:Show()
end
local function RevertHideFrames()
    if guardFrame then guardFrame:Hide() end
    -- Restore the bottom-left bar's tail buttons (6-12): un-park them (back on
    -- the anchor chain) and restore their original shown state.
    for i = 6, 12 do
        local b, sv = _G["MultiBarBottomLeftButton" .. i], saved.bar2tail and saved.bar2tail[i]
        if b and sv then
            if sv.points then RestorePoints(b, sv.points) end
            if sv.shown then b:Show() else b:Hide() end
        end
    end
    for _, name in ipairs(HIDE_FRAMES) do
        local f, sv = _G[name], saved.hides and saved.hides[name]
        if f and sv then f:Show() end
    end
end

-- Combat Lockdown
if not combatFrame then
    combatFrame = CreateFrame("Frame")
    combatFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_REGEN_ENABLED" and pendingAction then
            combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
            local action = pendingAction
            pendingAction = nil
            if action == "apply" then MobileUILayout:Apply()
            elseif action == "revert" then MobileUILayout:Revert() end
        end
    end)
end

-- Public API
function MobileUILayout:Apply()
    MobileUI_Debug("=== Apply() called, combat=" .. tostring(InCombatLockdown()) .. " ===")
    if InCombatLockdown() then
        pendingAction = "apply"
        combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        MobileUI_Debug("Layout will apply when you leave combat.")
        return
    end
    -- Wrap each step in pcall so one failure doesn't abort everything
    local function step(name, fn)
        local ok, err = pcall(fn)
        if not ok then
            MobileUI_Debug("ERROR in " .. name .. ": " .. tostring(err))
            print("|cffff0000[MobileUI] Error in " .. name .. ":|r " .. tostring(err))
        end
    end
    step("SaveOriginals", SaveOriginals)
    step("ApplyMap", ApplyMap)
    step("ApplyMenuBar", ApplyMenuBar)
    step("ApplyBags", ApplyBags)
    step("ApplyActionBar", ApplyActionBar)
    step("ApplyPlayerFrame", ApplyPlayerFrame)
    step("ApplyChatFrame", ApplyChatFrame)
    step("ApplyHideFrames", ApplyHideFrames)
    MobileUI_Debug("=== Layout applied ===")
end
function MobileUILayout:Revert()
    if InCombatLockdown() then
        pendingAction = "revert"
        combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        MobileUI_Debug("Layout will revert when you leave combat.")
        return
    end
    if not saved.init then return end
    RevertHideFrames()
    RevertMap()
    RevertMenuBar()
    RevertBags()
    RevertActionBar()
    RevertPlayerFrame()
    RevertChatFrame()
    MobileUI_Debug("Layout reverted.")
end