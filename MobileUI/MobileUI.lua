-- MobileUI - Mobile-optimized UI for Ascension WoW (3.3.5a)
--
-- Core module: saved variables, fixed UI scale, mouse-look speed, slash
-- commands, options-panel handlers, and init dispatch to chat + layout modules.
--
-- Phase 1: Fixed Global UI Scale (1.2x; minimap 1.25x)
-- Phase 3: Chat Toggle (code in MobileUIChat.lua)
-- Phase 4: Mouse Look Speed
-- Phase 5: Mobile Layout Revamp (code in MobileUILayout.lua)

local ADDON = "MobileUI"

-- ============================================================================
-- Saved Variables & Defaults
-- ============================================================================

local DEFAULTS = {
    chatHidden   = false, -- true = entire chat UI reparented onto hidden frame
    lookSpeed    = 90,    -- cameraYawMoveSpeed; 90 = WoW min; lower = less sensitive
    layoutEnabled = true, -- true = apply the 5-point mobile layout revamp
    debug        = false, -- true = also print MobileUI_Debug entries to chat
}

-- ============================================================================
-- Debug Logging System
-- Saves to MobileUIDebugLog (SavedVariable), written to disk on logout/reload.
-- File: WTF/Account/<account>/SavedVariables/MobileUI.lua
-- ============================================================================

function MobileUI_Debug(msg)
    if not MobileUIDebugLog then MobileUIDebugLog = {} end
    local time = date("%H:%M:%S")
    local entry = string.format("[%s] %s", time, tostring(msg))
    table.insert(MobileUIDebugLog, entry)
    -- Keep only last 500 entries to prevent SV file bloat
    while #MobileUIDebugLog > 500 do
        table.remove(MobileUIDebugLog, 1)
    end
    -- Also print to chat (only when debug is enabled; the ring buffer is
    -- always written so it stays available on disk for dev use)
    if MobileDB and MobileDB.debug then
        print("|cff888888[MobileUI]|r " .. msg)
    end
end

function MobileUI_DebugClear()
    MobileUIDebugLog = {}
    print("|cff00ccff[MobileUI]|r Debug log cleared.")
end

function MobileUI_DebugShow()
    local count = MobileUIDebugLog and #MobileUIDebugLog or 0
    print("|cff00ccff[MobileUI]|r Debug log: " .. count .. " entries")
    print("|cff00ccff[MobileUI]|r File: WTF/Account/<account>/SavedVariables/MobileUI.lua")
    print("|cff00ccff[MobileUI]|r Open it in a text editor after /reload or logout.")
    -- Print last 10 entries to chat as a quick preview
    if MobileUIDebugLog and count > 0 then
        print("|cff888888--- Last 10 entries ---|r")
        local start = math.max(1, count - 9)
        for i = start, count do
            print("  " .. MobileUIDebugLog[i])
        end
    end
end

-- ============================================================================
-- Core Frame
-- ============================================================================

local core = CreateFrame("Frame")
core:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
core:RegisterEvent("ADDON_LOADED")

function core:ADDON_LOADED(name)
    if name ~= ADDON then return end

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
    if MobileDB.layoutEnabled then
        MobileUILayout:Apply()
    end
end

-- ============================================================================
-- Scale (fixed — no user option)
-- ============================================================================
-- The whole UI is scaled 1.2x via UIParent. One exception: the minimap is
-- scaled to an effective 1.25x (1.25/1.2 relative to the 1.2 parent), so it's
-- slightly bigger than the rest and readable on a phone.
-- Applied on every PLAYER_ENTERING_WORLD; idempotent.

MobileUI = {}

local UI_SCALE      = 1.2
local MINIMAP_SCALE = 1.25

function MobileUI:ApplyScale()
    UIParent:SetScale(UI_SCALE)
    local mc = _G["MinimapCluster"]
    if mc then
        mc:SetScale(MINIMAP_SCALE / UI_SCALE)
    end
end

-- ============================================================================
-- Mouse Look Speed (Phase 4)
-- ============================================================================
-- WoW's "Mouse Look Speed" slider controls `cameraYawMoveSpeed` (range 90-270).
-- 90 is both default and minimum — you can't go below it in-game.
-- SetCVar() accepts values below 90, so we expose 10-90 here.
-- Lower values = swipe a longer distance to turn the same amount.

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
    local slider = _G["MobileUIOptionsPanelLookSpeedSlider"]
    if slider and slider:IsVisible() then slider:SetValue(value) end
end

-- ============================================================================
-- Slash Commands
-- ============================================================================

SLASH_MOBILEUI1 = "/mui"
SlashCmdList["MOBILEUI"] = function(msg)
    msg = msg and strtrim(msg) or ""
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
            print("|cff00ccff[MobileUI]|r Look speed must be 10-90.  Lower = less sensitive.")
        end

    elseif cmd == "debug" then
        MobileUI_DebugShow()
    elseif cmd == "debugclear" then
        MobileUI_DebugClear()
    elseif cmd == "layout" then
        MobileDB.layoutEnabled = not MobileDB.layoutEnabled
        if MobileDB.layoutEnabled then
            MobileUILayout:Apply()
            print("|cff00ccff[MobileUI]|r Mobile layout enabled.")
        else
            MobileUILayout:Revert()
            print("|cff00ccff[MobileUI]|r Mobile layout disabled (default restored).")
        end

    else
        print("|cff00ccff[MobileUI]|r Scale: 1.2 (fixed; minimap 1.25)" ..
            " | chat: " .. (MobileDB.chatHidden and "hidden" or "shown") ..
            " | look: " .. tostring(MobileDB.lookSpeed or 90) ..
            " | layout: " .. (MobileDB.layoutEnabled and "on" or "off"))
        print("|cff00ccff[MobileUI]|r Usage: /mui chat | /mui look <10-90> | /mui layout | /mui debug | /mui debugclear")
    end
end

-- ============================================================================
-- Options Panel Handlers (called from XML)
-- ============================================================================

function MobileUI_OptionsOnShow(panel)
    local name = panel:GetName()
    local lookSlider = _G[name .. "LookSpeedSlider"]
    if lookSlider then lookSlider:SetValue(MobileDB.lookSpeed or 90) end
    local layoutCheck = _G[name .. "LayoutCheck"]
    if layoutCheck then layoutCheck:SetChecked(MobileDB.layoutEnabled) end
end

function MobileUI_OptionsOnLookSpeedChanged(value)
    if not MobileDB then return end
    if value == MobileDB.lookSpeed then return end
    MobileUI:SetLookSpeed(value)
end

function MobileUI_OptionsOnLayoutChanged(checked)
    if not MobileDB then return end
    MobileDB.layoutEnabled = checked and true or false
    if MobileDB.layoutEnabled then
        MobileUILayout:Apply()
    else
        MobileUILayout:Revert()
    end
end