-- MobileUIFrames.lua - Frame repositioning: map, menu bar, bags, player frame,
-- party frames, spell book, talent frame, chat frame.
-- Each function reads saved state from MobileUILayout.saved and config from
-- MobileUILayout's exposed tables. Exposed as MobileUIFrames.ApplyXxx() /
-- MobileUIFrames.RevertXxx() and called in sequence by MobileUILayout:Apply().

MobileUIFrames = {}

local saved           = MobileUILayout.saved
local SavePoints      = MobileUILayout.SavePoints
local RestorePoints   = MobileUILayout.RestorePoints
local MICRO_BUTTONS   = MobileUILayout.MICRO_BUTTONS
local BAG_BUTTONS     = MobileUILayout.BAG_BUTTONS
local HIDE_FRAMES     = MobileUILayout.HIDE_FRAMES  -- not used here but kept for reference
local PLAYER_HIDE     = MobileUILayout.PLAYER_HIDE
local PLAYER_OVERLAY  = MobileUILayout.PLAYER_OVERLAY
local PLAYER_TEXT     = MobileUILayout.PLAYER_TEXT
local PARTY_MEMBER_FRAMES = MobileUILayout.PARTY_MEMBER_FRAMES
local PARTY_SCALE     = MobileUILayout.PARTY_SCALE
local UnskinButton    = MobileUILayout.UnskinButton

-- Module-local state (created on first apply, reused on re-apply)
local menuBar, bagButton, bagHooked, partyFrame, spellBookTimer, talentTimer

-- 1. Map
-- Stock 3.3.5a fires Minimap_OnClick on ANY mouse-up over the minimap, which
-- calls Minimap:PingLocation() (the yellow pulse other players see). We don't
-- need that on mobile, so while the layout is active a click opens the full
-- world map instead (same as the M key: ToggleFrame(WorldMapFrame)). The whole
-- minimap square becomes the hit area (no radius check) = bigger touch target.
local function MinimapClick_OpenMap()
    ToggleFrame(WorldMapFrame)
end
function MobileUIFrames.ApplyMap()
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
function MobileUIFrames.RevertMap()
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
function MobileUIFrames.ApplyMenuBar()
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
function MobileUIFrames.RevertMenuBar()
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
-- Exposed so other modules (e.g. bag-swap) can re-snap the container
-- frames back to the mobile column after the client re-lays them out.
-- Also keep the backward-compat alias on MobileUILayout for external callers.
MobileUIFrames.RepositionContainerFrames = RepositionContainerFrames
MobileUILayout.RepositionContainerFrames = RepositionContainerFrames

function MobileUIFrames.ApplyBags()
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
function MobileUIFrames.RevertBags()
    if bagButton then bagButton:Hide() end
    for _, name in ipairs(BAG_BUTTONS) do
        local btn, sv = _G[name], saved.bags and saved.bags[name]
        if btn and sv and sv.shown then btn:Show() end
    end
end

-- 5. Player HP / Mana
function MobileUIFrames.ApplyPlayerFrame()
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
function MobileUIFrames.RevertPlayerFrame()
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

-- 5b. Party Frames → right edge, scaled into the strip below the menu bar
-- Reparents the four PartyMemberFrame buttons into a container we position
-- and scale. Only frame 1 is re-anchored (TOPLEFT of the container); frames
-- 2-4 keep their stock pet-frame-relative anchors, so a member's pet still
-- pushes the members below it down correctly, and everything (pet frame,
-- debuff row, fonts, portrait) scales uniformly with the container.
-- The frames are SecureUnitButtonTemplate (protected): all reparent/point/
-- scale calls run out of combat (Apply defers during lockdown), and the
-- client's own Show/Hide on PARTY_MEMBERS_CHANGED keeps working because
-- reparenting does not taint. The client never re-anchors the frames
-- (PartyMemberFrame.lua only touches internal art textures), so no guard
-- re-assert is needed.
function MobileUIFrames.ApplyPartyFrames()
    MobileUI_Debug("ApplyPartyFrames: starting")
    if not partyFrame then
        partyFrame = CreateFrame("Frame", "MobileUIPartyFrame", UIParent)
        partyFrame:SetFrameStrata("LOW")
    end
    for i, name in ipairs(PARTY_MEMBER_FRAMES) do
        local f = _G[name]
        if f then
            f:SetParent(partyFrame)
            if i == 1 then
                f:ClearAllPoints()
                f:SetPoint("TOPLEFT", partyFrame, "TOPLEFT", 0, 0)
            end
        else
            MobileUI_Debug("ApplyPartyFrames: " .. name .. " NOT FOUND")
        end
    end
    partyFrame:ClearAllPoints()
    -- TOPRIGHT -20,-80: right edge aligned with button 15's column (right
    -- edge at -20), top 2 units below the menu bar's bottom edge (y=78).
    partyFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -80)
    partyFrame:SetScale(PARTY_SCALE)
    partyFrame:Show()
    MobileUI_Debug("ApplyPartyFrames: done (scale=" .. PARTY_SCALE .. ")")
end
function MobileUIFrames.RevertPartyFrames()
    if partyFrame then partyFrame:Hide() end
    for _, name in ipairs(PARTY_MEMBER_FRAMES) do
        local f, sv = _G[name], saved.party and saved.party[name]
        if f and sv then
            f:SetParent(sv.parent)
            RestorePoints(f, sv.points)
        end
    end
end

-- 5c. Spell Book → centered, scaled to fit the screen
-- The Ascension client's spell book is AscensionSpellbookFrame (540x525),
-- NOT the stock SpellBookFrame (384x512, never shown on this client). The
-- client anchors it bottom-left, mostly off-screen (pos=(22,514) on a
-- 1139x640 UIParent → bottom edge ~400 units below the screen). We center
-- it and scale to fit the screen height (min(1, (screenH-40)/h) — never
-- scales up). The frame is a plain (non-secure) movable frame, so
-- ClearAllPoints/SetPoint/SetScale are safe.
--
-- Re-assert: a persistent timer re-centers the frame every frame while it
-- is shown (the client re-anchors it when it opens), plus an OnShow
-- fast-path that preserves the original OnShow (tab update + open sound).
local SPELLBOOK_FRAME = "AscensionSpellbookFrame"
local function CenterSpellBook(sb, scale)
    sb:SetScale(scale)
    sb:ClearAllPoints()
    sb:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end
function MobileUIFrames.ApplySpellBook()
    local sb = _G[SPELLBOOK_FRAME] or _G["SpellBookFrame"]
    if not sb then
        MobileUI_Debug("ApplySpellBook: " .. SPELLBOOK_FRAME .. " NOT FOUND")
        return
    end
    local h = sb:GetHeight()
    if not h or h <= 0 then h = 525 end
    local screenH = UIParent:GetHeight() or 640
    local scale = math.min(1, (screenH - 40) / h)
    CenterSpellBook(sb, scale)
    MobileUI_Debug("ApplySpellBook: " .. (sb:GetName() or "?") .. " centered (scale=" .. scale .. ")")
    -- Persistent re-assert timer: re-center every frame while shown (the
    -- client re-anchors the book when it opens).
    if not spellBookTimer then
        spellBookTimer = CreateFrame("Frame")
        spellBookTimer:SetScript("OnUpdate", function(self)
            if not MobileDB or not MobileDB.layoutEnabled then
                self:Hide()
                return
            end
            local f = _G[SPELLBOOK_FRAME] or _G["SpellBookFrame"]
            if f and f:IsShown() then
                CenterSpellBook(f, self._scale or 1)
            end
        end)
    end
    spellBookTimer._scale = scale
    spellBookTimer:Show()
    -- OnShow fast-path: re-center in the same frame as show, preserving the
    -- original OnShow (tab update + open sound).
    local orig = saved.spellbook and saved.spellbook.onShow
    sb:SetScript("OnShow", function(self)
        if orig then pcall(orig, self) end
        if MobileDB and MobileDB.layoutEnabled then
            CenterSpellBook(self, scale)
        end
    end)
end
function MobileUIFrames.RevertSpellBook()
    if spellBookTimer then spellBookTimer:Hide() end
    local sv = saved.spellbook
    if not sv then return end
    local sb = _G[sv.name or SPELLBOOK_FRAME]
    if sb then
        sb:SetScale(sv.scale)
        RestorePoints(sb, sv.points)
        sb:SetScript("OnShow", sv.onShow)
    end
    MobileUI_Debug("RevertSpellBook: " .. (sv.name or "?") .. " restored")
end

-- 5d. Talent Frame → centered, scaled to 1.1
-- The Ascension client customizes the talent frame (the global 1.2 scale
-- makes it too large on mobile). Mirrors the spell-book approach: the frame
-- is loaded lazily via TalentFrame_LoadUI (it may not exist yet at apply
-- time), so we trigger the load if needed, then center it at a fixed 1.1
-- scale (smaller than the global 1.2). We try the Ascension-prefixed name
-- first (AscensionTalentFrame, mirroring AscensionSpellbookFrame), falling
-- back to the stock PlayerTalentFrame. The frame is a plain (non-secure)
-- movable frame, so ClearAllPoints/SetPoint/SetScale are safe.
--
-- Re-assert: a persistent timer re-centers the frame every frame while it
-- is shown (the client re-anchors it when it opens), plus an OnShow
-- fast-path that preserves the original OnShow.
local TALENT_SCALE = 1.1
local TALENT_FRAMES = { "AscensionTalentFrame", "PlayerTalentFrame" }
local function FindTalentFrame()
    for _, name in ipairs(TALENT_FRAMES) do
        local f = _G[name]
        if f then return f, name end
    end
    return nil
end
local function CenterTalentFrame(tf, scale)
    tf:SetScale(scale)
    tf:ClearAllPoints()
    tf:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end
function MobileUIFrames.ApplyTalentFrame()
    -- The talent frame is lazy-loaded; trigger the load so we can find it.
    if not FindTalentFrame() and TalentFrame_LoadUI then
        local ok = pcall(TalentFrame_LoadUI)
        if ok then MobileUI_Debug("ApplyTalentFrame: TalentFrame_LoadUI() called") end
    end
    local tf, name = FindTalentFrame()
    if not tf then
        MobileUI_Debug("ApplyTalentFrame: talent frame NOT FOUND")
        return
    end
    CenterTalentFrame(tf, TALENT_SCALE)
    -- If SaveOriginals ran before the frame existed, capture the stock state
    -- now so Revert can restore it.
    if not saved.talent then
        saved.talent = {
            name = name,
            points = SavePoints(tf),
            scale = tf:GetScale(),
            onShow = tf:GetScript("OnShow"),
        }
    end
    MobileUI_Debug("ApplyTalentFrame: " .. name .. " centered (scale=" .. TALENT_SCALE .. ")")
    -- Persistent re-assert timer: re-center every frame while shown (the
    -- client re-anchors the frame when it opens).
    if not talentTimer then
        talentTimer = CreateFrame("Frame")
        talentTimer:SetScript("OnUpdate", function(self)
            if not MobileDB or not MobileDB.layoutEnabled then
                self:Hide()
                return
            end
            local f = FindTalentFrame()
            if f and f:IsShown() then
                CenterTalentFrame(f, self._scale or TALENT_SCALE)
            end
        end)
    end
    talentTimer._scale = TALENT_SCALE
    talentTimer:Show()
    -- OnShow fast-path: re-center in the same frame as show, preserving the
    -- original OnShow.
    local orig = saved.talent and saved.talent.onShow
    tf:SetScript("OnShow", function(self)
        if orig then pcall(orig, self) end
        if MobileDB and MobileDB.layoutEnabled then
            CenterTalentFrame(self, TALENT_SCALE)
        end
    end)
end
function MobileUIFrames.RevertTalentFrame()
    if talentTimer then talentTimer:Hide() end
    local sv = saved.talent
    if not sv then return end
    local tf = _G[sv.name] or FindTalentFrame()
    if tf then
        tf:SetScale(sv.scale)
        RestorePoints(tf, sv.points)
        tf:SetScript("OnShow", sv.onShow)
    end
    MobileUI_Debug("RevertTalentFrame: " .. (sv.name or "?") .. " restored")
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
function MobileUIFrames.ApplyChatFrame()
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
function MobileUIFrames.RevertChatFrame()
    local cf = _G["ChatFrame1"]
    if cf and saved.chatFrame then
        RestorePoints(cf, saved.chatFrame.points)
        MobileUI_Debug("RevertChatFrame: ChatFrame1 position restored")
    end
    if MobileUI and MobileUI.PositionChatBubble then
        MobileUI:PositionChatBubble()
    end
end