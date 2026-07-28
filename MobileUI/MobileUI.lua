-- MobileUI - Mobile-optimized UI for Ascension WoW (3.3.5a)
--
-- A minimal addon that scales up the entire UI for mobile streaming.
-- Built from scratch; MoveAnything used only as structural reference.
--
-- Phase 1: Global UI Scale
-- Future:  Layout presets, chat toggle, touch-friendly controls

local ADDON = "MobileUI"

-- ============================================================================
-- Saved Variables & Defaults
-- ============================================================================

local DEFAULTS = {
    scale = 1.5,  -- default 1.5x; good starting point for 1300x900 on phone
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
-- Slash Commands
-- ============================================================================

SLASH_MOBILEUI1 = "/mui"
SlashCmdList["MOBILEUI"] = function(msg)
    msg = msg and strtrim(msg) or ""
    local value = tonumber(msg)
    if value and value >= 1.0 and value <= 3.0 then
        MobileUI:SetScale(value)
        print("|cff00ccff[MobileUI]|r Scale set to " .. value)
    else
        print("|cff00ccff[MobileUI]|r Current scale: " .. tostring(MobileDB.scale))
        print("|cff00ccff[MobileUI]|r Usage: /mui <1.0 - 3.0>")
    end
end

-- ============================================================================
-- Options Panel Handlers (called from XML)
-- ============================================================================

function MobileUI_OptionsOnShow(panel)
    local slider = _G[panel:GetName() .. "ScaleSlider"]
    if slider then
        slider:SetValue(MobileDB.scale)
    end
end

function MobileUI_OptionsOnScaleChanged(value)
    -- guard: only respond to user interaction, not initial panel population
    if not MobileDB then return end
    if value == MobileDB.scale then return end
    MobileUI:SetScale(value)
end