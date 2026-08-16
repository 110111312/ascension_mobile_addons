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
local MENU_SCALE     = MobileUILayout.MENU_SCALE
local PARTY_SCALE     = MobileUILayout.PARTY_SCALE
local UnskinButton    = MobileUILayout.UnskinButton

-- Module-local state (created on first apply, reused on re-apply)
local menuBar, bagButton, bagHooked, partyFrame, partyAssertTimer, spellBookTimer, talentTimer

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

-- Discovery scan: find ALL micro buttons on this client (standard + custom).
-- Scans _G for any frame whose name contains "MicroButton", and also scans
-- children of known micro-button container frames. Logs each found button's
-- name, parent, and size so we can identify Ascension's custom additions.
local function ScanAllMicroButtons()
    local found = {}
    -- 1. Scan _G for globals matching *MicroButton*
    for k, v in pairs(_G) do
        if type(k) == "string" and k:find("MicroButton") and type(v) == "table" and v.GetObjectType and v:GetObjectType() == "Button" then
            found[k] = v
        end
    end
    -- 2. Scan children of known container frames
    local containers = { "MicroButtonFrame", "MainMenuMicroButtonManager", "UIParent" }
    for _, cName in ipairs(containers) do
        local c = _G[cName]
        if c and c.GetChildren then
            -- In 3.3.5a, :GetChildren() returns multiple values; iterate
            local kids = { c:GetChildren() }
            for _, kid in ipairs(kids) do
                local kn = kid:GetName()
                if kn and kn:find("MicroButton") then
                    found[kn] = kid
                end
            end
        end
    end
    -- 3. Log results
    local names = {}
    for name, btn in pairs(found) do
        names[#names + 1] = name
    end
    table.sort(names)
    MobileUI_Debug(string.format("  SCAN: found %d micro buttons total", #names))
    for _, name in ipairs(names) do
        local btn = found[name]
        local parent = btn:GetParent()
        local pn = parent and parent:GetName() or "(nil)"
        local w = btn:GetWidth() or 0
        local h = btn:GetHeight() or 0
        local shown = btn:IsShown() and 1 or 0
        local pt, rel, relPt, x, y = btn:GetPoint()
        MobileUI_Debug(string.format("  SCAN: %s parent=%s w=%.0f h=%.0f shown=%d pt=%s x=%s y=%s",
            name, pn, w, h, shown, tostring(pt), tostring(x), tostring(y)))
    end
    return found
end

function MobileUIFrames.ApplyMenuBar()
    MobileUI_Debug("ApplyMenuBar: starting")
    -- Run discovery scan before layout (logs all micro buttons on this client)
    local scanned = ScanAllMicroButtons()
    -- Log which MICRO_BUTTONS entries are NOT in the scan result (missing)
    -- and which scan results are NOT in MICRO_BUTTONS (extra = custom)
    local known = {}
    for _, name in ipairs(MICRO_BUTTONS) do known[name] = true end
    for name, _ in pairs(scanned) do
        if not known[name] then
            MobileUI_Debug(string.format("  SCAN: EXTRA (not in MICRO_BUTTONS): %s", name))
        end
    end
    for _, name in ipairs(MICRO_BUTTONS) do
        if not scanned[name] then
            MobileUI_Debug(string.format("  SCAN: MISSING (in MICRO_BUTTONS but not found): %s", name))
        end
    end
    if not menuBar then
        menuBar = CreateFrame("Frame", "MobileUIMenuBar", UIParent)
        menuBar:SetFrameStrata("HIGH")
    end
    menuBar:ClearAllPoints()
    menuBar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -8, -8)
    menuBar:SetSize(200, 70)
    -- Effective scale 1.15 (at the fixed global 1.2 the menu overlapped the
    -- player buffs at the top-right corner). Relative to the UIParent scale.
    menuBar:SetScale(MENU_SCALE / UIParent:GetScale())
    menuBar:Show()
    -- Diagnostic: log the menu bar's actual rendered edges (UIParent units,
    -- from the top of the screen) so overlap reports can be verified.
    MobileUI_Debug(string.format("  MENUBAR: top=%.0f bottom=%.0f w=%.0f h=%.0f scale=%.3f",
        menuBar:GetTop(), menuBar:GetBottom(),
        menuBar:GetWidth(), menuBar:GetHeight(), menuBar:GetScale()))

    -- 2 rows: first 6 buttons in top row, last 6 in bottom row
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
            -- After 6 buttons, wrap to second row
            if count == 6 then
                xOffset = 0
                yOffset = 32
            end
            MobileUI_Debug("  " .. name .. " -> x=" .. xOffset .. " row=" .. (count > 6 and 2 or 1))
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

-- 5a. Exit-Vehicle Button → right of the player frame (P1)
-- The stock "Leave Vehicle" button (MainMenuBarVehicleLeaveButton) is a
-- child of MainMenuBar, which the guard PARKS off-screen (SHOWN, at
-- BOTTOMLEFT -3000,-3000) so the scatter arc's buttons 1-10 keep rendering.
-- Result: in a vehicle the client shows the leave button
-- (SetShown(CanExitVehicle()) on the vehicle events) but it renders
-- off-screen with its parked parent — no way to get out. Fix part 1 — pure
-- re-anchor, like the scatter buttons: UIParent-relative points are
-- independent of the parent, so the button renders at its mobile spot while
-- MainMenuBar stays parked (the scatter buttons prove this pattern; a
-- PlayerFrame-relative anchor variant was tried and is NOT used — switched
-- to UIParent to match the proven pattern). Fix part 2 — visibility: this
-- Ascension client does NOT show the stock leave button itself (diagnosed:
-- anchor applied, button never appears on vehicle entry — the stock
-- MainMenuBar_OnEvent SetShown(CanExitVehicle()) path doesn't run here).
-- The button is a plain (non-secure) button whose stock OnClick calls
-- VehicleExit(), so the addon can own visibility safely: SetShown on the
-- vehicle events + a 0.25s poll (same pattern as the stealth flip poll) to
-- catch missed events. Revert hands visibility back to the client. It's a
-- plain button, so SetPoint/SetShown/SetWidth are taint-clean.
MobileUIFrames.VEHICLE_EXIT_OFFSET = 2  -- px gap between the bar block's right edge (x=136 from center) and the button

function MobileUIFrames.AnchorVehicleExitButton()
    local btn = _G["MainMenuBarVehicleLeaveButton"]
    if not btn then return end
    btn:ClearAllPoints()
    -- UIParent-anchored, snug right of the health/mana bar block. The bars
    -- are anchored by ApplyPlayerFrame: 272 wide at 4px inset in a 280-wide
    -- frame centered on x=0, so the block's right edge is at 136 from screen
    -- center on any resolution. Center the button 2px right of that edge
    -- (width-adaptive), bottom-aligned with the player frame (y=12).
    local w = btn:GetWidth() or 32
    btn:SetPoint("BOTTOM", UIParent, "BOTTOM", 136 + MobileUIFrames.VEHICLE_EXIT_OFFSET + w / 2, 12)
end

local vehicleFrame, vehicleShown

function MobileUIFrames.UpdateVehicleExitButton(event)
    local btn = _G["MainMenuBarVehicleLeaveButton"]
    if not btn then return end
    local canExit = CanExitVehicle and CanExitVehicle() or nil
    local inVeh   = UnitInVehicle and UnitInVehicle("player") or nil
    local hasUI   = UnitHasVehicleUI and UnitHasVehicleUI("player") or nil
    local show    = (canExit or inVeh) and true or false
    if btn:IsShown() ~= show then
        btn:SetShown(show)
    end
    -- The client re-anchors this button back to its stock MainMenuBar-relative
    -- spot on vehicle entry (the bar is parked off-screen, so the button lands
    -- at ~-2800,-2860 — diagnosed in the ring: btnL/btnT went negative while
    -- btnShown=1). Re-assert our UIParent anchor whenever the button drifts
    -- off-screen. Our event handler runs after the client's (registration
    -- order), so this usually fixes it immediately; the 0.25s poll is the
    -- backstop for any other timing.
    local btnL = btn:GetLeft()
    if btnL and btnL < -1000 then
        MobileUIFrames.AnchorVehicleExitButton()
        MobileUI_Debug("Veh: client re-anchored leave button off-screen (btnL=" ..
            tostring(btnL) .. ") -> re-anchored to mobile spot")
    end
    -- Log on explicit events + on vehicle-state changes (the 0.25s poll only
    -- logs a change, so the ring doesn't spam). Includes the button's exact
    -- on-screen position (when shown), its normal texture, and PlayerFrame's
    -- position — the source of truth for where things actually render.
    if event ~= "POLL" or vehicleShown == nil or vehicleShown ~= show then
        local vmb = _G["VehicleMenuBar"]
        local pf = _G["PlayerFrame"]
        local nt = btn:GetNormalTexture()
        MobileUI_Debug("Veh: evt=" .. tostring(event) ..
            " canExit=" .. tostring(canExit) ..
            " inVeh=" .. tostring(inVeh) ..
            " ui=" .. tostring(hasUI) ..
            " btnShown=" .. tostring(btn:IsShown()) ..
            " btnL=" .. tostring(btn:GetLeft()) ..
            " btnT=" .. tostring(btn:GetTop()) ..
            " btnTex=" .. tostring(nt and nt:GetTexture()) ..
            " btnParent=" .. tostring(btn:GetParent() and btn:GetParent():GetName()) ..
            " pfL=" .. tostring(pf and pf:GetLeft()) ..
            " pfT=" .. tostring(pf and pf:GetTop()) ..
            " vehBar=" .. tostring(vmb and vmb:IsShown()))
    end
    vehicleShown = show
end

function MobileUIFrames.ApplyVehicleExitButton()
    local btn = _G["MainMenuBarVehicleLeaveButton"]
    if not btn then
        MobileUI_Debug("ApplyVehicleExitButton: MainMenuBarVehicleLeaveButton NOT FOUND")
        return
    end
    saved.vehicleExit = { points = SavePoints(btn), origNT = btn:GetNormalTexture() }
    -- Size to match the health/mana bar block (~29px tall) so the button
    -- blends with the bars instead of towering over them; 32 is the stock
    -- button's native texture size (crisp). Anchor AFTER sizing — the anchor
    -- is width-adaptive (snug right of the bars). Plain button, so sizing is
    -- taint-clean.
    btn:SetWidth(32)
    btn:SetHeight(32)
    MobileUIFrames.AnchorVehicleExitButton()
    -- Guarantee visible art: on this Ascension client the stock button may
    -- have no normal texture (a shown-but-invisible button). If so, set a
    -- stock icon so the button is always visible; revert restores the
    -- original (nil) texture.
    local nt = btn:GetNormalTexture()
    if not nt or not nt:GetTexture() then
        local t = btn:CreateTexture(nil, "BACKGROUND")
        t:SetTexture("Interface\\Icons\\INV_Misc_Arrow_01")
        t:SetAllPoints(btn)
        btn:SetNormalTexture(t)
        MobileUI_Debug("ApplyVehicleExitButton: stock normal texture missing -> set INV_Misc_Arrow_01")
    end
    if not vehicleFrame then
        vehicleFrame = CreateFrame("Frame")
        vehicleFrame:SetScript("OnEvent", function(_, event)
            MobileUIFrames.UpdateVehicleExitButton(event)
        end)
        vehicleFrame:SetScript("OnUpdate", function(self, elapsed)
            self.t = (self.t or 0) + elapsed
            if self.t >= 0.25 then
                self.t = 0
                MobileUIFrames.UpdateVehicleExitButton("POLL")
            end
        end)
        for _, ev in ipairs({
            "UNIT_ENTERED_VEHICLE", "UNIT_ENTERING_VEHICLE",
            "UNIT_EXITED_VEHICLE", "UNIT_EXITING_VEHICLE",
            "PLAYER_GAINS_VEHICLE_DATA", "PLAYER_LOSES_VEHICLE_DATA",
            "PLAYER_ENTERING_WORLD",
        }) do
            vehicleFrame:RegisterEvent(ev)
        end
    end
    vehicleFrame:Show()
    MobileUIFrames.UpdateVehicleExitButton("APPLY")
    MobileUI_Debug("ApplyVehicleExitButton: re-anchored snug right of bars, size=" ..
        (btn:GetWidth() or 0) .. "x" .. (btn:GetHeight() or 0) ..
        ", parent=" .. tostring(btn:GetParent() and btn:GetParent():GetName()))
end

function MobileUIFrames.RevertVehicleExitButton()
    local btn = _G["MainMenuBarVehicleLeaveButton"]
    if not btn or not saved.vehicleExit then return end
    if vehicleFrame then vehicleFrame:Hide() end
    vehicleShown = nil
    -- Remove the fallback texture we added (if any) and hand visibility back
    -- to the client (one SetShown so the button isn't left stale).
    if saved.vehicleExit.origNT ~= btn:GetNormalTexture() then
        btn:SetNormalTexture(saved.vehicleExit.origNT)
    end
    if CanExitVehicle then btn:SetShown(CanExitVehicle()) end
    RestorePoints(btn, saved.vehicleExit.points)
    saved.vehicleExit = nil
    MobileUI_Debug("RevertVehicleExitButton: original anchors restored")
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
-- reparenting does not taint. A 0.25s re-assert timer checks if any frame
-- drifted back to UIParent (the client may re-parent on disconnect/raid
-- events) and re-applies the reparent. The container has an explicit size
-- (128×242) so frames anchored TOPLEFT(0,0) render in the correct position
-- instead of extending off the right edge of the screen.
local function ReparentPartyFrames()
    if not partyFrame then return end
    for i, name in ipairs(PARTY_MEMBER_FRAMES) do
        local f = _G[name]
        if f then
            local curParent = f:GetParent()
            if curParent ~= partyFrame then
                MobileUI_Debug("PartyAssert: " .. name .. " re-parenting from " ..
                    (curParent and curParent:GetName() or "nil"))
                f:SetParent(partyFrame)
            end
            if i == 1 then
                f:ClearAllPoints()
                f:SetPoint("TOPLEFT", partyFrame, "TOPLEFT", 0, 0)
            end
        end
    end
end

function MobileUIFrames.ApplyPartyFrames()
    MobileUI_Debug("ApplyPartyFrames: starting")
    if not partyFrame then
        partyFrame = CreateFrame("Frame", "MobileUIPartyFrame", UIParent)
        partyFrame:SetFrameStrata("LOW")
    end
    partyFrame:ClearAllPoints()
    -- TOPRIGHT -20,-140: right edge aligned with button 15's column (right
    -- edge at -20); moved down from -90 (v2.9.x) then -115 so member 1 clears
    -- the menu bar — the menu still overlapped the first party member at
    -- -115 on the phone stream, so the container sits lower. PARTY_SCALE
    -- 0.55 renders a bit larger than 0.5 while still fitting the strip.
    partyFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -140)
    -- Container must have explicit size: 128 = PartyMemberFrame width,
    -- 242 = total unscaled stack height (4 frames at 53 + 3 gaps at ~10).
    -- Without this, the 0×0 container puts TOPLEFT at the right screen edge,
    -- and frames anchored TOPLEFT(0,0) extend off-screen to the right.
    partyFrame:SetSize(128, 242)
    partyFrame:SetScale(PARTY_SCALE)
    partyFrame:Show()

    ReparentPartyFrames()

    -- Diagnostic: log the container's and member 1's actual rendered edges
    -- (UIParent units, from the top of the screen) so overlap reports can be
    -- verified against the menu bar's logged position.
    local m1 = _G["PartyMemberFrame1"]
    MobileUI_Debug(string.format("  PARTY: container top=%.0f bottom=%.0f scale=%.2f member1 top=%.0f",
        partyFrame:GetTop(), partyFrame:GetBottom(), partyFrame:GetScale(),
        m1 and m1:GetTop() or -1))

    -- Re-assert timer: the client may re-parent or re-anchor frames on
    -- party events (PARTY_MEMBERS_CHANGED, disconnect, etc.). Periodically
    -- check and re-apply if a frame drifted back to UIParent.
    if not partyAssertTimer then
        partyAssertTimer = CreateFrame("Frame")
        partyAssertTimer._delay = 0
        partyAssertTimer:SetScript("OnUpdate", function(self, elapsed)
            if not MobileDB or not MobileDB.layoutEnabled then
                self:Hide()
                return
            end
            self._delay = self._delay + elapsed
            if self._delay < 0.25 then return end
            self._delay = 0
            if InCombatLockdown() then return end
            ReparentPartyFrames()
        end)
    end
    partyAssertTimer:Show()

    MobileUI_Debug("ApplyPartyFrames: done (scale=" .. PARTY_SCALE .. ")")
end
function MobileUIFrames.RevertPartyFrames()
    if partyAssertTimer then partyAssertTimer:Hide() end
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