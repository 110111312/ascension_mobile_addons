-- MobileUI - Mobile-optimized UI for Ascension WoW (3.3.5a)
--
-- A minimal addon that scales up the entire UI for mobile streaming.
-- Built from scratch; MoveAnything used only as structural reference.
--
-- Phase 1: Global UI Scale
-- Phase 3: Chat Toggle (bottom-left bubble button hides/shows the whole chat UI)
-- Phase 4: Mouse Look Speed (lower cameraYawMoveSpeed below WoW's slider min of 90 for mobile)

local ADDON = "MobileUI"

-- ============================================================================
-- Saved Variables & Defaults
-- ============================================================================

local DEFAULTS = {
    scale = 1.2,  -- default 1.2x; tested good on phone
    chatHidden = false,  -- when true the entire chat UI is reparented onto a hidden frame
    lookSpeed = 90,  -- mouse look speed (cameraYawMoveSpeed); 90 = WoW default; lower = less sensitive for mobile
}

-- ============================================================================
-- Core Frame
-- ============================================================================

local core = CreateFrame("Frame")
core:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
core:RegisterEvent("ADDON_LOADED")

function core:ADDON_LOADED(name)
    if name ~= ADDON then return end

    -- Load saved variables
    if not MobileDB then MobileDB = {} end
    for k, v in pairs(DEFAULTS) do
        if MobileDB[k] == nil then MobileDB[k] = v end
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("ADDON_LOADED")
end

function core:PLAYER_ENTERING_WORLD()
    MobileUI:ApplyScale()
    MobileUI:ApplyLookSpeed()
    MobileUI:CreateChatBubble()
    MobileUI:ApplyChatVisibility()
end

-- ============================================================================
-- Scale
-- ============================================================================

MobileUI = {}

function MobileUI:ApplyScale()
    UIParent:SetScale(MobileDB.scale)
end

function MobileUI:SetScale(value)
    value = tonumber(value)
    if not value or value < 1.0 or value > 3.0 then return end
    MobileDB.scale = value
    self:ApplyScale()
    -- sync options slider if panel is open
    local slider = _G["MobileUIOptionsPanelScaleSlider"]
    if slider and slider:IsVisible() then
        slider:SetValue(value)
    end
end

-- ============================================================================
-- Mouse Look Speed (Phase 4)
-- ============================================================================
-- WoW's Interface Options → Mouse → "Mouse Look Speed" slider controls the
-- cvar `cameraYawMoveSpeed` (and sets `cameraPitchMoveSpeed` = yaw/2).  Its
-- range is 90–270, so the minimum (90) is also the default — you cannot make
-- mouse look LESS sensitive via the in-game UI.
-- For mobile streaming (Artemis multi-touch → mouse look), 90 is too sensitive:
-- a short swipe spins the camera too far.  SetCVar() accepts values below 90,
-- so we expose a slider with range 10–90 here.  Lower values mean you must
-- swipe a longer distance to turn the same amount — much better for phone.
-- ===========================================================================

function MobileUI:ApplyLookSpeed()
    local yaw = MobileDB.lookSpeed or 90
    SetCVar("cameraYawMoveSpeed", yaw)
    SetCVar("cameraPitchMoveSpeed", yaw / 2)
end

function MobileUI:SetLookSpeed(value)
    value = tonumber(value)
    if not value or value < 10 or value > 90 then return end
    MobileDB.lookSpeed = value
    self:ApplyLookSpeed()
    -- sync options slider if panel is open
    local slider = _G["MobileUIOptionsPanelLookSpeedSlider"]
    if slider and slider:IsVisible() then
        slider:SetValue(value)
    end
end

-- ============================================================================
-- Chat Toggle (Phase 3)
-- ============================================================================
-- A dedicated "chat bubble" button sits at the bottom-left corner, just above
-- the action bar. Click it to completely hide the chat UI; click again to show
-- it. Slash command "/mui chat" also toggles.
--
-- How hiding is made bulletproof against Blizzard re-showing the chat:
--   We do NOT just :Hide() frames. On combat / relog, Blizzard re-shows the
--   chat: FloatingChatFrame_Update() reads the saved "shown" flag and calls
--   chatFrame:Show(), and FCF_FadeInChatFrame() re-fades the background. A plain
--   :Hide() loses that fight (the chat reappears, but the scroll buttons we hid
--   separately do not -> inconsistent state).
--   Instead we reparent the chat frames onto a hidden container. A frame whose
--   PARENT is hidden never renders, no matter how often Blizzard calls :Show()
--   on it. Also, chatFrame:IsShown() then returns false, so the dock's own
--   OnUpdate (FCF_OnUpdate) skips the frame entirely. No hooks needed; it
--   survives combat, relog and UI reloads cleanly.
--   Note: SetParent only changes the parent; it does NOT touch a frame's
--   `movable` flag or drag scripts, so when the chat is shown again it stays
--   movable exactly as Blizzard intended (docked chat is locked by default, as
--   usual — undock to drag it).
--
-- What gets reparented (all top-level-on-UIParent chat chrome):
--   * ChatFrame1..N        (the message frames; their background, scroll-button
--                          frame, resize button and edit box are CHILDREN, so
--                          they hide along with the parent frame)
--   * ChatFrameN..N-Tab    (the tabs)
--   * GENERAL_CHAT_DOCK    (the tab strip)
--   * FriendsMicroButton   (social menu button)
--   * ChatFrameMenuButton  (chat-menu speech-bubble button)
-- ===========================================================================

local chatHideContainer  -- never-shown frame we reparent chat onto to hide it
local chatBubble          -- the bottom-left toggle button
local CHAT_UI_FRAMES = {} -- top-level chat frames we manage (built once at setup)

local function BuildChatFrameList()
    CHAT_UI_FRAMES = {}
    local n = NUM_CHAT_WINDOWS or 10
    for i = 1, n do
        local cf = _G["ChatFrame" .. i]
        local tab = _G["ChatFrame" .. i .. "Tab"]
        if cf then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = cf end
        if tab then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = tab end
    end
    if _G["GENERAL_CHAT_DOCK"] then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = _G["GENERAL_CHAT_DOCK"] end
    if _G["FriendsMicroButton"] then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = _G["FriendsMicroButton"] end
    if _G["ChatFrameMenuButton"] then CHAT_UI_FRAMES[#CHAT_UI_FRAMES + 1] = _G["ChatFrameMenuButton"] end
end

function MobileUI:CreateChatBubble()
    if chatBubble then return end
    if not chatHideContainer then
        chatHideContainer = CreateFrame("Frame", nil, UIParent)
        chatHideContainer:Hide()       -- a hidden parent => its children never render
        chatHideContainer:SetScale(1)   -- keep the chat scale consistent when reparented
    end

    BuildChatFrameList()

    chatBubble = CreateFrame("Button", "MobileUIChatBubble", UIParent)
    chatBubble:SetSize(32, 32)
    chatBubble:SetFrameStrata("MEDIUM")
    chatBubble:SetClampedToScreen(true)
    -- Draggable: hold-and-drag with the left button moves it (a quick tap still
    -- toggles the chat). Position is saved per-account so it clears whatever
    -- action-bar height your UI uses (e.g. DragonUI's taller bar).
    chatBubble:SetMovable(true)
    chatBubble:RegisterForClicks("LeftButtonUp")
    chatBubble:RegisterForDrag("LeftButton")
    if MobileDB.bubbleX and MobileDB.bubbleY then
        chatBubble:SetPoint(MobileDB.bubblePoint or "BOTTOMLEFT",
            UIParent, MobileDB.bubbleRelPoint or "BOTTOMLEFT",
            MobileDB.bubbleX, MobileDB.bubbleY)
    else
        -- default: bottom-left, raised above the action bar (DragonUI's bar is tall)
        chatBubble:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 6, 72)
    end
    chatBubble:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Up")
    chatBubble:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Chat-Down")
    chatBubble:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
    chatBubble:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            MobileUI:ToggleChat()
        end
    end)
    chatBubble:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    chatBubble:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, x, y = self:GetPoint()
        MobileDB.bubblePoint    = point
        MobileDB.bubbleRelPoint = relPoint
        MobileDB.bubbleX        = x
        MobileDB.bubbleY        = y
    end)
    chatBubble:SetScript("OnEnter", function(self)
        if GameTooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(MobileDB.chatHidden and "|cff00ccffShow Chat|r" or "|cff00ccffHide Chat|r", 1, 1, 1)
            GameTooltip:AddLine("Drag to move.", 0.6, 0.6, 0.6)
            GameTooltip:Show()
        end
    end)
    chatBubble:SetScript("OnLeave", function()
        if GameTooltip then GameTooltip:Hide() end
    end)
    chatBubble:Show()
end

function MobileUI:ToggleChat()
    self:SetChatHidden(not MobileDB.chatHidden)
end

function MobileUI:SetChatHidden(hidden)
    MobileDB.chatHidden = hidden and true or false
    self:ApplyChatVisibility()
end

function MobileUI:ApplyChatVisibility()
    if not chatHideContainer then return end
    local hide = MobileDB.chatHidden and true or false

    if hide then
        -- Close the input box first so keystrokes aren't captured while hidden.
        local cf = _G["ChatFrame1"]
        if cf and cf.editBox and cf.editBox:IsShown() and ChatEdit_DeactivateChat then
            ChatEdit_DeactivateChat(cf.editBox)
        end
        -- Reparent each chat frame onto the hidden container. We remember the
        -- original parent so we can restore it exactly (tabs may be parented to
        -- the dock's scroll child when docked, or to UIParent when floating).
        for _, f in ipairs(CHAT_UI_FRAMES) do
            if f and not f._muiHiddenParent then
                f._muiHiddenParent = f:GetParent()
                f:SetParent(chatHideContainer)
            end
        end
    else
        -- Restore each frame to its original parent and make sure the main
        -- chat window + its tab are visible again.
        for _, f in ipairs(CHAT_UI_FRAMES) do
            if f and f._muiHiddenParent then
                f:SetParent(f._muiHiddenParent)
                f._muiHiddenParent = nil
            end
        end
        local cf = _G["ChatFrame1"]
        if cf then cf:Show() end
        local tab = _G["ChatFrame1Tab"]
        if tab then tab:Show() end
        -- Nudge the dock to re-flow its tabs if it supports that.
        if _G["GENERAL_CHAT_DOCK"] and FCFDock_SetDirty then
            FCFDock_SetDirty(_G["GENERAL_CHAT_DOCK"])
        end
    end
end

-- ============================================================================
-- Slash Commands
-- ============================================================================

SLASH_MOBILEUI1 = "/mui"
SlashCmdList["MOBILEUI"] = function(msg)
    msg = msg and strtrim(msg) or ""
    -- Split into command + argument (e.g. "look 30", "chat")
    local cmd, arg = strsplit(" ", msg, 2)
    if cmd == "chat" then
        MobileUI:ToggleChat()
        print("|cff00ccff[MobileUI]|r Chat " ..
            (MobileDB.chatHidden and "hidden" or "shown") .. ".")
    elseif cmd == "look" then
        local value = tonumber(arg)
        if value and value >= 10 and value <= 90 then
            MobileUI:SetLookSpeed(value)
            print("|cff00ccff[MobileUI]|r Mouse look speed set to " .. value ..
                " (yaw=" .. value .. ", pitch=" .. (value / 2) .. ")")
        else
            print("|cff00ccff[MobileUI]|r Look speed must be 10-90.  Lower = less sensitive (longer swipe to turn).")
        end
    else
        local value = tonumber(msg)
        if value and value >= 1.0 and value <= 3.0 then
            MobileUI:SetScale(value)
            print("|cff00ccff[MobileUI]|r Scale set to " .. value)
        else
            print("|cff00ccff[MobileUI]|r Current scale: " .. tostring(MobileDB.scale) ..
                " | chat: " .. (MobileDB.chatHidden and "hidden" or "shown") ..
                " | look: " .. tostring(MobileDB.lookSpeed or 90))
            print("|cff00ccff[MobileUI]|r Usage: /mui <1.0 - 3.0>  |  /mui chat  |  /mui look <10-90>")
        end
    end
end

-- ============================================================================
-- Options Panel Handlers (called from XML)
-- ============================================================================

function MobileUI_OptionsOnShow(panel)
    local name = panel:GetName()
    local scaleSlider = _G[name .. "ScaleSlider"]
    if scaleSlider then
        scaleSlider:SetValue(MobileDB.scale)
    end
    local lookSlider = _G[name .. "LookSpeedSlider"]
    if lookSlider then
        lookSlider:SetValue(MobileDB.lookSpeed or 90)
    end
end

function MobileUI_OptionsOnScaleChanged(value)
    -- guard: only respond to user interaction, not initial panel population
    if not MobileDB then return end
    if value == MobileDB.scale then return end
    MobileUI:SetScale(value)
end

function MobileUI_OptionsOnLookSpeedChanged(value)
    if not MobileDB then return end
    if value == MobileDB.lookSpeed then return end
    MobileUI:SetLookSpeed(value)
end