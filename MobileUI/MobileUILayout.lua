-- MobileUILayout.lua - 5-Point Mobile UI Revamp (orchestrator)
-- Config, save/restore state, skinning helpers, and the public Apply/Revert
-- API. The actual layout steps live in sub-modules:
--   MobileUIActionBar  — scatter arc + skinning
--   MobileUIActionFlip — stance/stealth flip follower + SecureStateDriver
--   MobileUIFrames     — map, menu bar, bags, player, party, spell book, talent, chat
--   MobileUIGuard      — hide frames + OnUpdate guard
MobileUILayout = {}

-- Load-time diagnostic: is the world-map module present? If the file failed
-- to load, MobileUIWorldMap is nil here and the Apply step below will log it.
if MobileUI_Debug then
    MobileUI_Debug("Layout load: MobileUIWorldMap=" .. tostring(MobileUIWorldMap))
end

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
-- Party member frames. Stock 3.3.5a anchors PartyMemberFrame1 TOPLEFT of
-- UIParent at (10, -160) and chains frames 2-4 below each previous member's
-- pet frame (PartyFrame.xml) — a vertical column on the LEFT side, which on
-- this layout collides with the quest tracker under the map. The layout
-- reparents all four into a scaled container parked in the empty strip on
-- the right edge: below the 2-row menu bar (TOPRIGHT -8,-8, 200x70 -> bottom
-- at y=78 from top) and above the top of the action arc, button 15
-- (BOTTOMRIGHT -20,316, 51x51 -> top at y=367 from bottom). On the 1128x634
-- screen that strip is ~189 units tall; 4 members chain at 83 units each
-- (322 total) plus the ~73-unit content overhang, so 0.5 scale -> ~161 units
-- fits with margin. The container scale also scales the internal pet frame /
-- debuff rows / fonts uniformly.
local PARTY_MEMBER_FRAMES = {
    "PartyMemberFrame1", "PartyMemberFrame2",
    "PartyMemberFrame3", "PartyMemberFrame4",
}
local PARTY_SCALE = 0.5
local MICRO_BUTTONS = {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton",
    "AchievementMicroButton", "QuestLogMicroButton", "SocialsMicroButton",
    "PVPMicroButton", "LFDMicroButton", "MainMenuMicroButton", "HelpMicroButton",
    "ChallengesMicroButton", "PathToAscensionMicroButton",  -- Ascension custom
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

-- Expose config tables for sub-modules
MobileUILayout.ACTION_BUTTONS    = ACTION_BUTTONS
MobileUILayout.ACTION2_BUTTONS   = ACTION2_BUTTONS
MobileUILayout.PARTY_MEMBER_FRAMES = PARTY_MEMBER_FRAMES
MobileUILayout.PARTY_SCALE        = PARTY_SCALE
MobileUILayout.MICRO_BUTTONS      = MICRO_BUTTONS
MobileUILayout.BAG_BUTTONS        = BAG_BUTTONS
MobileUILayout.HIDE_FRAMES        = HIDE_FRAMES
MobileUILayout.PLAYER_HIDE        = PLAYER_HIDE
MobileUILayout.PLAYER_OVERLAY     = PLAYER_OVERLAY
MobileUILayout.PLAYER_TEXT        = PLAYER_TEXT

-- LibButtonFacade for circular button skinning (embedded, no external addon needed)
local LBF = LibStub and LibStub("LibButtonFacade", true)
if not LBF then
    print("|cffff0000[MobileUI] LibButtonFacade not found in MobileUILayout!|r")
end
local lbfActionBar, lbfMenuBar

-- State (shared with sub-modules)
MobileUILayout.saved = {}
local saved = MobileUILayout.saved

-- Helpers (exposed for sub-modules)
function MobileUILayout.SavePoints(frame)
    local pts = {}
    for i = 1, frame:GetNumPoints() do
        local pt, relTo, relPt, x, y = frame:GetPoint(i)
        pts[i] = { pt, relTo, relPt, x, y }
    end
    return pts
end
function MobileUILayout.RestorePoints(frame, pts)
    frame:ClearAllPoints()
    for i = 1, #pts do
        frame:SetPoint(pts[i][1], pts[i][2], pts[i][3], pts[i][4], pts[i][5])
    end
end

-- Skin a button using LibButtonFacade (embedded library, exact same code as ButtonFacade addon)
function MobileUILayout.SkinButton(btn, buttonData)
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

function MobileUILayout.UnskinButton(btn)
    if lbfActionBar then lbfActionBar:RemoveButton(btn) end
    if lbfMenuBar then lbfMenuBar:RemoveButton(btn) end
end

-- Save Originals (once)
function MobileUILayout.SaveOriginals()
    if saved.init then return end
    saved.init = true
    local SavePoints = MobileUILayout.SavePoints
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
                showgrid = btn:GetAttribute("showgrid") or 0,
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
    -- Party member frames: original parent + anchor points (frame 1 anchors
    -- to UIParent, frames 2-4 to the previous member's pet frame). The shown
    -- state is deliberately NOT saved here — the client owns it via
    -- PartyMemberFrame_Update on PARTY_MEMBERS_CHANGED, so revert only has to
    -- undo the reparent + re-anchor.
    saved.party = {}
    for _, name in ipairs(PARTY_MEMBER_FRAMES) do
        local f = _G[name]
        if f then saved.party[name] = { parent = f:GetParent(), points = SavePoints(f) } end
    end
    saved.hides = {}
    for _, name in ipairs(HIDE_FRAMES) do
        local f = _G[name]
        if f then saved.hides[name] = f:IsShown() end
    end
    -- ChatFrame1: original position, so layout revert restores it exactly
    local cf = _G["ChatFrame1"]
    if cf then saved.chatFrame = { points = SavePoints(cf) } end
    -- Spell book: the Ascension client's real frame is
    -- AscensionSpellbookFrame (stock SpellBookFrame is never shown on this
    -- client). Save its anchor points + scale + OnShow script, so layout
    -- revert restores the stock position/size/behavior exactly.
    local sb = _G["AscensionSpellbookFrame"] or _G["SpellBookFrame"]
    if sb then
        saved.spellbook = {
            name = sb:GetName(),
            points = SavePoints(sb),
            scale = sb:GetScale(),
            onShow = sb:GetScript("OnShow"),
        }
    end
    -- Talent frame: Ascension customizes the stock PlayerTalentFrame (the
    -- global 1.2 scale makes it overflow on mobile). We try the Ascension-prefixed
    -- name first (mirrors AscensionSpellbookFrame), falling back to the stock
    -- PlayerTalentFrame. The frame is loaded lazily via TalentFrame_LoadUI, so
    -- it may not exist yet at SaveOriginals time — the apply step handles that
    -- by triggering the load. Save anchor points + scale + OnShow so revert
    -- restores the stock position/size/behavior exactly.
    local tf = _G["AscensionTalentFrame"] or _G["PlayerTalentFrame"]
    if tf then
        saved.talent = {
            name = tf:GetName(),
            points = SavePoints(tf),
            scale = tf:GetScale(),
            onShow = tf:GetScript("OnShow"),
        }
    end
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

-- Combat Lockdown
local combatFrame, pendingAction
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
    step("SaveOriginals", function() MobileUILayout.SaveOriginals() end)
    step("ApplyMap",       function() MobileUIFrames.ApplyMap() end)
    step("ApplyMenuBar",  function() MobileUIFrames.ApplyMenuBar() end)
    step("ApplyBags",     function() MobileUIFrames.ApplyBags() end)
    step("ApplyActionBar", function() MobileUIActionBar:Apply() end)
    step("ApplyPlayerFrame", function() MobileUIFrames.ApplyPlayerFrame() end)
    step("ApplyPartyFrames", function() MobileUIFrames.ApplyPartyFrames() end)
    step("ApplySpellBook", function() MobileUIFrames.ApplySpellBook() end)
    step("ApplyTalentFrame", function() MobileUIFrames.ApplyTalentFrame() end)
    step("ApplyChatFrame", function() MobileUIFrames.ApplyChatFrame() end)
    step("ApplyHideFrames", function() MobileUIGuard:Apply() end)
    -- Dynamic action bar (bottom-left strip): runs after the tail is parked
    -- so it can re-anchor buttons 6-10 from the parked spot to the strip.
    step("ApplyDynamicBar", function() MobileUIDynamicBar:Apply() end)
    -- Wrapped in a closure so a nil MobileUIWorldMap is caught by step()'s pcall
    -- and logged as "ERROR in ApplyWorldMap" instead of aborting Apply silently.
    step("ApplyWorldMap", function() MobileUIWorldMap:Apply() end)
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
    -- Dynamic bar first: it re-parks its strip buttons (6-10), then
    -- RevertHideFrames restores the whole tail from saved.bar2tail.
    if MobileUIDynamicBar and MobileUIDynamicBar.Revert then MobileUIDynamicBar:Revert() end
    MobileUIGuard:Revert()
    MobileUIFrames.RevertMap()
    MobileUIFrames.RevertMenuBar()
    MobileUIFrames.RevertBags()
    MobileUIActionBar:Revert()
    MobileUIFrames.RevertPlayerFrame()
    MobileUIFrames.RevertPartyFrames()
    MobileUIFrames.RevertSpellBook()
    MobileUIFrames.RevertTalentFrame()
    MobileUIFrames.RevertChatFrame()
    MobileUIWorldMap:Revert()
    MobileUI_Debug("Layout reverted.")
end