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
local ACTION2_BUTTONS = { 13, 14, 15 }
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
    "MainMenuBarPageNumber", "MultiBarBottomLeft", "MultiBarBottomRight",
    "MultiBarLeft", "MultiBarRight",
}
local PLAYER_HIDE = {
    "PlayerPortrait", "PlayerFrameTexture", "PlayerFrameBackground",
    "PlayerName", "PlayerFrameFlash", "PlayerStatusTexture",
    "PlayerRestStateGlow", "PlayerAttackGlow", "PlayerPVPIcon",
    "PlayerFrameLeaderIcon", "PlayerFrameMasterIcon", "PlayerFrameVehicleFeedback",
    "PlayerLevelText",
}
local PLAYER_TEXT = {
    "PlayerFrameHealthBarText", "PlayerFrameManaBarText",
    "PlayerFrameHealthBarTextLeft", "PlayerFrameHealthBarTextRight",
    "PlayerFrameManaBarTextLeft", "PlayerFrameManaBarTextRight",
}
local BUFF_FRAMES = { "BuffFrame" }

-- LibButtonFacade for circular button skinning (embedded, no external addon needed)
local LBF = LibStub and LibStub("LibButtonFacade", true)
if not LBF then
    print("|cffff0000[MobileUI] LibButtonFacade not found in MobileUILayout!|r")
end
local lbfActionBar, lbfMenuBar

-- State
local saved = {}
local menuBar, bagButton, combatFrame, guardFrame, pendingAction
local HOTKEY_FRAMES = {}  -- populated in ApplyActionBar, hidden by guard OnUpdate

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
            }
        end
    end
    -- Save MultiBarBottomLeft buttons (action bar 2) for buttons 13-15
    saved.actions2 = {}
    for _, i in ipairs(ACTION2_BUTTONS) do
        local src = i - 12
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
    end
    saved.hides = {}
    for _, name in ipairs(HIDE_FRAMES) do
        local f = _G[name]
        if f then saved.hides[name] = f:IsShown() end
    end
    saved.buffs = {}
    for _, name in ipairs(BUFF_FRAMES) do
        local f = _G[name]
        if f then saved.buffs[name] = { points = SavePoints(f) } end
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

-- 1b. Buff Frame → move to the RIGHT of minimap (minimap is at top-left)
-- Buffs grow right-to-left in WoW, so anchor the rightmost buff to the right of the minimap area
-- 1b. Buff Frame -> keep default position (top-right, Blizzard default)
local function ApplyBuffs()
    MobileUI_Debug("Buffs: default position (no repositioning)")
end
local function RevertBuffs()
    for _, name in ipairs(BUFF_FRAMES) do
        local f, sv = _G[name], saved.buffs and saved.buffs[name]
        if f and sv then RestorePoints(f, sv.points) end
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
    if not MobileUILayout._bagHooked then
        MobileUILayout._bagHooked = true
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
    for i = 1, 12 do
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
            MobileUI_Debug("  ActionButton" .. i .. " skinned")
        else
            MobileUI_Debug("  ActionButton" .. i .. " NOT FOUND")
        end
    end
    -- Action bar 2 (MultiBarBottomLeft): buttons 13-15
    for _, i in ipairs(ACTION2_BUTTONS) do
        local src = i - 12
        local btn = _G["MultiBarBottomLeftButton" .. src]
        if btn then
            local cfg = ACTION_BUTTONS[i]
            btn:SetParent(UIParent)
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
            MobileUI_Debug("  MultiBarBottomLeftButton" .. src .. " (as btn" .. i .. ") skinned")
        else
            MobileUI_Debug("  MultiBarBottomLeftButton" .. src .. " NOT FOUND")
        end
    end
end
local function RevertActionBar()
    HOTKEY_FRAMES = {}  -- stop guard from hiding hotkeys/names
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
        end
    end
    -- Revert MultiBarBottomLeft buttons (13-15)
    for _, i in ipairs(ACTION2_BUTTONS) do
        local src = i - 12
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
        end
    end
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

-- Hide Bottom Bar Art + OnUpdate Guard
local function ApplyHideFrames()
    for _, name in ipairs(HIDE_FRAMES) do
        local f = _G[name]
        if f then f:Hide() end
    end
    if not guardFrame then
        guardFrame = CreateFrame("Frame")
        guardFrame:SetScript("OnUpdate", function()
            if not MobileDB or not MobileDB.layoutEnabled then return end
            for _, name in ipairs(HIDE_FRAMES) do
                local f = _G[name]
                if f and f:IsShown() then f:Hide() end
            end
            -- Keep action button hotkeys/names hidden
            for _, f in ipairs(HOTKEY_FRAMES) do
                if f and f:IsShown() then f:Hide() end
            end
            -- Buffs: keep default position (no guard needed)
        end)
    end
    guardFrame:Show()
end
local function RevertHideFrames()
    if guardFrame then guardFrame:Hide() end
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
    step("ApplyBuffs", ApplyBuffs)
    step("ApplyMenuBar", ApplyMenuBar)
    step("ApplyBags", ApplyBags)
    step("ApplyActionBar", ApplyActionBar)
    step("ApplyPlayerFrame", ApplyPlayerFrame)
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
    RevertBuffs()
    RevertMap()
    RevertMenuBar()
    RevertBags()
    RevertActionBar()
    RevertPlayerFrame()
    MobileUI_Debug("Layout reverted.")
end