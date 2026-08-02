-- MobileUISkin.lua — Registers Aquatic circular skin with LibButtonFacade
-- Uses TGA textures copied from ButtonFacade's Aquatic skin, located in MobileUI/Textures/

local LBF = LibStub and LibStub("LibButtonFacade", true)
if not LBF then print("|cffff0000[MobileUI] LibButtonFacade not found!|r") return end

local TEX = "Interface\\AddOns\\MobileUI\\Textures\\aqua-"

LBF:AddSkin("MobileUI-Circle", {
    Normal = {
        Width = 36, Height = 36,
        Texture = TEX .. "normal",
        Static = true,
        Color = {0.65, 0.65, 0.7, 1}
    },
    Pushed = {
        Width = 34, Height = 34,
        Texture = TEX .. "normal",
        Color = {0.65, 0.65, 0.7, 1}
    },
    Checked = {
        Width = 34, Height = 34,
        Texture = TEX .. "checked",
        BlendMode = "ADD"
    },
    Highlight = {
        Width = 36, Height = 36,
        Texture = TEX .. "highlight",
        BlendMode = "ADD"
    },
    Border = {
        Width = 35, Height = 35,
        Texture = TEX .. "border"
    },
    Disabled = { Hide = true },
    Icon = {
        Width = 23, Height = 23,
        TexCoords = {0.07, 0.93, 0.07, 0.93}
    },
    Cooldown = { Width = 23, Height = 23 },
    Backdrop = {
        Width = 23, Height = 23,
        Texture = TEX .. "bg"
    },
    HotKey = { Width = 0, Height = 0, OffsetX = 11, OffsetY = 11 },
    Count = { Width = 0, Height = 0, OffsetX = 0, OffsetY = -16 },
    Name = { Width = 0, Height = 0, OffsetY = -15 },
    AutoCast = { Width = 32, Height = 32 },
    AutoCastable = {
        Width = 54, Height = 54,
        Texture = [[Interface\Buttons\UI-AutoCastableOverlay]]
    },
    Flash = {
        Width = 32, Height = 32,
        Texture = [[Interface\Buttons\UI-QuickslotRed]]
    },
}, true)