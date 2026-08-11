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
    tapInteract  = true,  -- true = left click on world acts like right click (interact)
    tapSell      = true,  -- true = tap a bag item to sell while a vendor is open
    tapBuy       = true,  -- true = tap a merchant item to buy it directly
    tapEquip     = true,  -- true = tap an equippable item (armor/weapon) to equip it
    bagSwap      = true,  -- true = tap/hold a bag to pick which slot it goes into
    dynamicBar   = true,  -- true = bottom-left dynamic action bar (tap=use, hold=assign)
}

-- ============================================================================
-- Debug Logging System
-- Saves to MobileUIDebugLog (SavedVariable), written to disk on logout/reload.
-- File: WTF/Account/<account>/SavedVariables/MobileUI.lua
-- NOTE: ring buffer only — never print debug to chat. On a phone stream chat
-- is hard to read and debug spam scrolls real messages away.
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
    if MobileDB.tapInteract then
        MobileUIClick:Apply()
    end
    if MobileDB.tapSell then
        MobileUISell:Apply()
    end
    if MobileDB.tapBuy then
        MobileUIBuy:Apply()
    end
    if MobileDB.bagSwap or MobileDB.tapEquip then
        MobileUIBagSwap:Apply()
    end
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

    elseif cmd == "tap" then
        local enabled = MobileUIClick:Toggle()
        print("|cff00ccff[MobileUI]|r Tap = Interact " ..
            (enabled and "ON" or "OFF") ..
            " (left click on world now " ..
            (enabled and "interacts like right click" or "targets normally") .. ").")

    elseif cmd == "sell" then
        local enabled = MobileUISell:Toggle()
        print("|cff00ccff[MobileUI]|r Tap = Sell " ..
            (enabled and "ON" or "OFF") ..
            " (tap a bag item to sell while a vendor is open).")

    elseif cmd == "buy" then
        local enabled = MobileUIBuy:Toggle()
        print("|cff00ccff[MobileUI]|r Tap = Buy " ..
            (enabled and "ON" or "OFF") ..
            " (tap a merchant item to buy it directly).")

    elseif cmd == "bagswap" then
        local enabled = MobileUIBagSwap:Toggle()
        print("|cff00ccff[MobileUI]|r Bag Swap Menu " ..
            (enabled and "ON" or "OFF") ..
            " (tap or hold a bag to pick which slot it goes into).")

    elseif cmd == "equiptap" then
        local enabled = MobileUIBagSwap:ToggleEquip()
        print("|cff00ccff[MobileUI]|r Tap = Equip " ..
            (enabled and "ON" or "OFF") ..
            " (tap armor/weapons to equip them out of combat).")

    elseif cmd == "dynamicbar" then
        local enabled = MobileUIDynamicBar:Toggle()
        if enabled and not MobileDB.layoutEnabled then
            print("|cff00ccff[MobileUI]|r Dynamic Action Bar ON (enable /mui layout to show it).")
        else
            print("|cff00ccff[MobileUI]|r Dynamic Action Bar " ..
                (enabled and "ON" or "OFF") ..
                " (tap = use, hold a button to assign items/buffs).")
        end

    else
        print("|cff00ccff[MobileUI]|r Scale: 1.2 (fixed; minimap 1.25)" ..
            " | chat: " .. (MobileDB.chatHidden and "hidden" or "shown") ..
            " | look: " .. tostring(MobileDB.lookSpeed or 90) ..
            " | layout: " .. (MobileDB.layoutEnabled and "on" or "off") ..
            " | tap: " .. (MobileDB.tapInteract and "on" or "off") ..
            " | sell: " .. (MobileDB.tapSell and "on" or "off") ..
            " | buy: " .. (MobileDB.tapBuy and "on" or "off") ..
            " | equiptap: " .. (MobileDB.tapEquip and "on" or "off") ..
            " | bagswap: " .. (MobileDB.bagSwap and "on" or "off") ..
            " | dynamicbar: " .. (MobileDB.dynamicBar and "on" or "off"))
        print("|cff00ccff[MobileUI]|r Usage: /mui chat | /mui look <10-90> | /mui layout | /mui tap | /mui sell | /mui buy | /mui equiptap | /mui bagswap | /mui dynamicbar | /mui debug | /mui debugclear")
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
    local tapCheck = _G[name .. "TapInteractCheck"]
    if tapCheck then tapCheck:SetChecked(MobileDB.tapInteract) end
    local sellCheck = _G[name .. "TapSellCheck"]
    if sellCheck then sellCheck:SetChecked(MobileDB.tapSell) end
    local buyCheck = _G[name .. "TapBuyCheck"]
    if buyCheck then buyCheck:SetChecked(MobileDB.tapBuy) end
    local equipCheck = _G[name .. "TapEquipCheck"]
    if equipCheck then equipCheck:SetChecked(MobileDB.tapEquip) end
    local bagSwapCheck = _G[name .. "BagSwapCheck"]
    if bagSwapCheck then bagSwapCheck:SetChecked(MobileDB.bagSwap) end
    local dynCheck = _G[name .. "DynamicBarCheck"]
    if dynCheck then dynCheck:SetChecked(MobileDB.dynamicBar) end
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

function MobileUI_OptionsOnTapInteractChanged(checked)
    if not MobileDB then return end
    MobileDB.tapInteract = checked and true or false
    if MobileDB.tapInteract then
        MobileUIClick:Apply()
    else
        MobileUIClick:Revert()
    end
end

function MobileUI_OptionsOnTapSellChanged(checked)
    if not MobileDB then return end
    MobileDB.tapSell = checked and true or false
    if MobileDB.tapSell then
        MobileUISell:Apply()
    else
        MobileUISell:Revert()
    end
end

function MobileUI_OptionsOnTapBuyChanged(checked)
    if not MobileDB then return end
    MobileDB.tapBuy = checked and true or false
    if MobileDB.tapBuy then
        MobileUIBuy:Apply()
    else
        MobileUIBuy:Revert()
    end
end

function MobileUI_OptionsOnTapEquipChanged(checked)
    if not MobileDB then return end
    MobileDB.tapEquip = checked and true or false
    if MobileDB.tapEquip then
        MobileUIBagSwap:Apply()
    else
        MobileUIBagSwap:Revert()
    end
end

function MobileUI_OptionsOnBagSwapChanged(checked)
    if not MobileDB then return end
    MobileDB.bagSwap = checked and true or false
    if MobileDB.bagSwap then
        MobileUIBagSwap:Apply()
    else
        MobileUIBagSwap:Revert()
    end
end

function MobileUI_OptionsOnDynamicBarChanged(checked)
    if not MobileDB then return end
    MobileDB.dynamicBar = checked and true or false
    if MobileDB.dynamicBar then
        MobileUIDynamicBar:Apply()
    else
        MobileUIDynamicBar:Revert()
    end
end


