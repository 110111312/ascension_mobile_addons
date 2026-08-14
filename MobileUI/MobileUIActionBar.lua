-- MobileUIActionBar.lua - Action Bar scatter arc + skinning
-- Reparents ActionButton1-10 into the scatter arc (bottom-right) and feeds
-- scatter spots 11-15 from MultiBarBottomLeft buttons 1-5. Skins all via
-- LibButtonFacade (exposed by MobileUILayout). The stance/stealth flip
-- follower (page mirroring, SecureStateDriver bridge) lives in
-- MobileUIActionFlip.

MobileUIActionBar = {}

local ACTION_BUTTONS   = MobileUILayout.ACTION_BUTTONS
local ACTION2_BUTTONS  = MobileUILayout.ACTION2_BUTTONS
local saved             = MobileUILayout.saved
local SkinButton        = MobileUILayout.SkinButton
local UnskinButton      = MobileUILayout.UnskinButton
local RestorePoints     = MobileUILayout.RestorePoints

-- No tooltip over the thumb-zone action buttons: GameTooltip would cover the
-- scatter arc. Installed as OnEnter while the layout is active; the original
-- OnEnter is saved in SaveOriginals and restored on revert (layout toggle).
local function NoActionTooltipOnEnter()
    if GameTooltip then GameTooltip:Hide() end
end

-- Hotkey/name frames to hide — populated by ApplyActionBar, read by the
-- guard OnUpdate (MobileUIGuard) to re-hide them when the client re-shows.
MobileUIActionBar.HOTKEY_FRAMES = {}
local HOTKEY_FRAMES = MobileUIActionBar.HOTKEY_FRAMES

function MobileUIActionBar:Apply()
    MobileUI_Debug("ApplyActionBar: starting")
    -- Reset the shared table in-place so MobileUIGuard sees the new list
    for k in pairs(HOTKEY_FRAMES) do HOTKEY_FRAMES[k] = nil end
    -- Main bar buttons 1-10 (keys 1-0). ActionButton11/12 ("-" and "=") are
    -- intentionally NOT scattered: Artemis has no "-"/"=" virtual keys, so
    -- those two spots are filled by bottom-left bar buttons 1/2 below.
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local cfg = ACTION_BUTTONS[i]
            -- NOT reparented (Direction A): SetParent on a secure button
            -- taints it on this client, which blocks the client's own
            -- ActionButton_Update self:Show() mid-combat (the phase-3/4
            -- error). The buttons stay children of MainMenuBarArtFrame,
            -- which the guard parks off-screen (shown) so the arc renders
            -- at these UIParent-anchored positions while the bar art stays
            -- invisible — exactly like the strip buttons (66-71) and arc
            -- 11-15, which are never reparented and never taint.
            btn:ClearAllPoints()
            btn:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", cfg.x, cfg.y)
            btn:SetSize(cfg.size, cfg.size)
            btn:SetFrameStrata("MEDIUM")
            -- NO btn:Show() or btn:SetAttribute here — those taint the
            -- secure button from addon context, blocking the client's
            -- mid-combat self:Show() (the 'ActionButton1:Show()' error).
            -- showgrid=1 and Show() are set by the SecureHandlerStateTemplate
            -- bridge's _onstate-actionpage snippet (secure context, no taint).
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
            -- showgrid=1 and Show() are set by the bridge's secure snippet,
            -- not here (SetAttribute from addon context taints the button).
            btn:SetScript("OnEnter", NoActionTooltipOnEnter)
            -- Register UPDATE_BONUS_ACTIONBAR so the button's stock OnEvent
            -- calls ActionButton_UpdateAction on stealth entry/unstealth
            -- (stock line 369). Stock ActionButton_OnLoad does NOT register
            -- this event, so without it the button never re-resolves the
            -- action when the bonus bar changes — the icon stays stale.
            btn:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
            -- OnEvent KEPT (Direction A): the client owns the display — icon,
            -- usable tint, cooldown, checked state, attack flash and the
            -- C-side proc glow all update natively, exactly like the dynamic
            -- strip (66-71) and the arc's own 11-15 buttons, which run
            -- client-owned with zero combat taint. The addon never writes the
            -- stock regions' vertex colors or cooldown (those taint the button
            -- and block the client's mid-combat Show()/Hide()); the page
            -- mirroring is done via the bridge's actionpage attribute
            -- (MobileUIActionFlip), and the flip poll kicks a stock
            -- re-resolution out of combat.
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
    MobileUIActionFlip.EnsureFlipWatcher()
    MobileUIActionFlip.InstallFlipBridge()
    MobileUIActionFlip.ApplyFlip()
end

function MobileUIActionBar:Revert()
    -- Clear the shared table in-place so the guard stops hiding hotkeys/names
    for k in pairs(HOTKEY_FRAMES) do HOTKEY_FRAMES[k] = nil end
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
            -- Only reparent if the button actually left its stock parent
            -- (Direction A never reparents, so this is normally a no-op —
            -- but the SetParent CALL itself taints a secure button, so skip
            -- it when the parent is already correct).
            if btn:GetParent() ~= sv.parent then btn:SetParent(sv.parent) end
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
            btn:UnregisterEvent("UPDATE_BONUS_ACTIONBAR")
            btn:SetAttribute("showgrid", sv.showgrid or 0)
        end
    end
    -- Revert MultiBarBottomLeft buttons (spots 11-15)
    for _, pair in ipairs(ACTION2_BUTTONS) do
        local i, src = pair.scatter, pair.src
        local btn = _G["MultiBarBottomLeftButton" .. src]
        local sv = saved.actions2 and saved.actions2[i]
        if btn and sv then
            UnskinButton(btn)
            if btn:GetParent() ~= sv.parent then btn:SetParent(sv.parent) end
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
    -- Drop the SecureStateDriver bridge (restore MainMenuBarArtFrame's
    -- parent and clear useparent-actionpage forwarding).
    MobileUIActionFlip.UninstallFlipBridge()
end