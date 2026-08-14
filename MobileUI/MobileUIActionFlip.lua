-- MobileUIActionFlip.lua - Stance/stealth flip diagnostics + guard poll
-- The Ascension client resolves keypresses internally (C-side): in stealth
-- '-' hits the stealth bar, which on this client is the BONUS bar
-- (GetBonusBarOffset() = 1 -> page 7, slots 73-84) — NOT an action-bar page.
-- GetActionBarPage() stays pinned at 1 and pages 2-5 are empty; the default
-- UI's "stealth bar" is BonusActionBarFrame. The scatter buttons (never
-- reparented, stock OnEvent) only recompute on the events they register, so
-- display and click stay on page 1 while keypresses go elsewhere. Driven by
-- a 0.25s state poll in guardFrame's OnUpdate (this client fires no
-- page/shapeshift events), the follower mirrors the client's choice via the
-- 'actionpage' ATTRIBUTE — the secure channel for configuring secure buttons.
--
-- DISPLAY OWNERSHIP (Direction A, 2026-08): the arc buttons keep their stock
-- OnEvent — the CLIENT owns icon / usable tint / cooldown / checked state /
-- attack flash / C-side proc glow, exactly like the dynamic strip (slots
-- 66-71) and the arc's own 11-15 buttons, which have always run client-owned
-- with zero combat taint. The addon only:
--   * repositions the buttons (apply, out of combat) — never reparents
--     (SetParent on a secure button taints it and blocks the client's own
--     mid-combat Show(), the phase-3/4 error);
--   * mirrors the page for diagnostics only — the CLIENT handles the
--     flip via the actionpage attribute bridge (SecureHandlerStateTemplate
--     handler frame with RegisterStateDriver);
--   * never calls ActionButton_UpdateAction itself: it hits protected
--     Show()/Hide() from addon context, which taints the button and re-blocks
--     the client's Show(). The client's own OnEvent (UPDATE_SHAPESHIFT_FORM
--     -> ActionButton_UpdateAction) re-resolves and re-renders the flip
--     via the bridge, in and out of combat.
-- The old hand-rolled display layer (RefreshScatterButtons / ReassertFlash)
-- was deleted: it re-implemented ActionButton_Update* and drifted — the
-- usable tint never refreshed on retarget (out-of-combat refresh called
-- ActionButton_UpdateAction, a no-op when the slot's action hadn't changed),
-- and the per-frame Flash hide killed the client's C-side proc glow. With
-- stock OnEvent back, the client's own event dispatch fixes both by
-- construction, plus every other case (mounts, vehicles, inventory, range
-- dot, stacks, equipment borders, procs).
--
-- TAINT RULES (learned the hard way):
--   * Writing plain Lua fields that ActionButton_CalculateAction READS
--     (e.g. isBonus) taints the secure click chain: the next click errors
--     "AddOn 'MobileUI' tainted the call of the secure function
--     'UseAction()'" and the cast is blocked. Attributes don't taint.
--   * On THIS client ANY direct field write on the secure buttons taints
--     — even self.action, which CalculateAction never reads: after the
--     write, the client's own later SetAttribute on the button errors
--     "prevented the call of the secure function 'ActionButtonN:SetAttribute()'"
--     and its page management breaks.
--   * SetVertexColor on the stock icon/NormalTexture and SetCooldown on the
--     stock Cooldown frame taint the button (the client's later Show()/Hide()
--     mid-combat is then blocked). SetTexture on the icon does NOT taint
--     (verified). LBF's skin writes on its own textures do NOT taint (the
--     strip buttons prove it). So: never write the stock regions' vertex
--     colors or cooldown from addon code; let the client render.

MobileUIActionFlip = {}

local flipFrame
local flipBarFrame
local flipBarOldParent
local flipArtOldUseparentActionpage

-- The CLIENT owns the stance->bar mapping; we only mirror it. Generic rules
-- in priority order — no per-class guessing for normal cases:
--   1. Stock 3.3.5a: entering a form flips GetActionBarPage() -> follow it.
--   2. This client: entering stealth/stance shows the BONUS bar
--      (GetBonusBarOffset() > 0) — the exact condition stock
--      BonusActionBarFrame uses to show itself. We mirror it via the
--      actionpage attribute: stock ActionButton_CalculateAction resolves
--      page from the button's actionpage attribute FIRST (falling back to
--      GetActionBarPage), so setting it to NUM_ACTIONBAR_PAGES + offset
--      (7) makes display, click, and keypress all follow the bonus slots.

-- Diagnostic: map every action-bar page's slots to see where the user's
-- skills actually live (page 1 = main bar, page 6 = bar 6, page 7 = bonus).
local function SlotDump(label)
    local parts = {}
    for p = 1, 7 do
        local row = {}
        for s = 1, 12 do
            local a = (p - 1) * 12 + s
            row[#row + 1] = GetActionTexture(a) and "X" or "."
        end
        parts[#parts + 1] = p .. ":" .. table.concat(row)
    end
    MobileUI_Debug("Slots " .. label .. ": " .. table.concat(parts, " | "))
end
MobileUIActionFlip.SlotDump = SlotDump

-- Diagnostic: per-button visible state — the icon's ACTUAL texture path and
-- the button's cached self.action (read-only; we never write fields on
-- secure buttons). Comparing a dump right after our refresh with one ~1s
-- later shows whether the client re-updates the buttons from stale
-- self.action (page-7 values) and overwrites our page-1 icon draws.
local function ButtonStateDump(label)
    local parts = {}
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local icon = _G[btn:GetName() .. "Icon"]
            local tex = icon and icon:GetTexture() or "?"
            parts[#parts + 1] = i .. ":act=" .. tostring(btn.action) .. ":tex=" .. tostring(tex)
        end
    end
    MobileUI_Debug("Btns " .. label .. ": " .. table.concat(parts, " "))
end
MobileUIActionFlip.ButtonStateDump = ButtonStateDump

local function DelayedDump(seconds, label)
    local f = CreateFrame("Frame")
    local t = 0
    f:SetScript("OnUpdate", function(self, el)
        t = t + el
        if t >= seconds then
            ButtonStateDump(label)
            self:SetScript("OnUpdate", nil)
        end
    end)
end
MobileUIActionFlip.DelayedDump = DelayedDump

-- ---- SecureStateDriver bridge (combat-safe attribute writes) ----
-- Our own SetAttribute("actionpage", N) on the ActionButtons is SILENTLY
-- blocked during combat lockdown on this client (verified via readback:
-- after writing 1 mid-combat, the attribute still reads 7; pcall can't
-- catch it because blocking isn't a Lua error). The one stock mechanism
-- that CAN write attributes on protected frames during combat is the
-- SecureStateDriver manager (a secure frame). But the driver manages
-- 'state-<name>' attributes, which ActionButton_CalculateAction does NOT
-- read (it reads plain 'actionpage'). So:
--   - a dedicated SecureHandlerStateTemplate frame is created as the
--     bridge target. This is the ONLY frame type that works with
--     RegisterStateDriver on this client — neither MainMenuBar nor
--     MainMenuBarArtFrame is protected, so RegisterStateDriver on either
--     errors "Invalid 'self' frame handle" (the secure handler snippet
--     cannot SetAttribute on a non-protected frame);
--   - MainMenuBarArtFrame (NOT the buttons) is reparented to the handler
--     frame. MainMenuBarArtFrame is a plain Frame (not a secure button),
--     so SetParent on it is clean (no taint). The buttons stay children
--     of MainMenuBarArtFrame (zero taint — SetParent on a secure button
--     taints it and blocks the client's mid-combat Show());
--   - RegisterStateDriver(handler, "actionpage", COND) makes the
--     manager re-evaluate COND and securely SetAttribute 'state-actionpage'
--     on the handler — even during combat lockdown;
--   - the handler's OnAttributeChanged (SecureHandler_StateOnAttributeChanged,
--     inherited from SecureHandlerStateTemplate) runs the _onstate-actionpage
--     snippet, copying 'state-actionpage' -> 'actionpage' on the handler
--     (restricted closure: secure context, so its SetAttribute is allowed
--     in combat too);
--   - MainMenuBarArtFrame gets useparent-actionpage=true so the buttons'
--     stock useparent-actionpage walk forwards through it:
--     button -> MainMenuBarArtFrame -> handler (which carries the
--     bridge's actionpage);
--   - the buttons then resolve the same page for CalculateAction, clicks,
--     and the client's own display updates, in and out of combat.
-- COND mirrors the client generically: [bonusbar:N] -> page 6+N (this
-- client's stealth/stance bonus bar), [bar:N] -> N (stock page flips),
-- else an explicit 1 (never nil — a nil-clear left the client's C-side
-- keypress resolver stuck on the bonus page after unstealth).
-- Parking: MainMenuBarArtFrame has SetAllPoints(MainMenuBar), so it
-- follows MainMenuBar off-screen (guard parks at -3000,-3000) regardless
-- of its parent. The handler frame has no visual elements (invisible).
local FLIP_HANDLER_SNIPPET = [[
    if newstate then
        self:SetAttribute("actionpage", newstate)
    else
        self:SetAttribute("actionpage", 1)
    end
    -- Set showgrid=1 and Show on each ActionButton (secure context —
    -- does NOT taint the buttons, unlike SetAttribute/Show from addon code).
    -- This keeps empty buttons visible and shown, replacing the old
    -- btn:SetAttribute("showgrid",1) + btn:Show() in the apply loop
    -- which tainted the secure buttons and blocked the client's mid-combat
    -- self:Show() call (the 'ActionButton1:Show()' taint error).
    for i = 1, 10 do
        local btn = self:GetFrameRef("btn" .. i)
        if btn then
            btn:SetAttribute("showgrid", 1)
            btn:Show()
        end
    end
]]
local flipNumPages = NUM_ACTIONBAR_PAGES or 6
local flipParts = {}
for flipOff = 1, 5 do
    flipParts[#flipParts + 1] = string.format("[bonusbar:%d] %d", flipOff, flipNumPages + flipOff)
end
for flipPage = 2, flipNumPages do
    flipParts[#flipParts + 1] = string.format("[bar:%d] %d", flipPage, flipPage)
end
flipParts[#flipParts + 1] = "1"
local FLIP_DRIVER_COND = table.concat(flipParts, "; ")

function MobileUIActionFlip.InstallFlipBridge()
    if flipBarFrame then return end
    local art = _G["MainMenuBarArtFrame"]
    if not art then
        MobileUI_Debug("Flip: bridge install failed: MainMenuBarArtFrame not found")
        return
    end
    local ok, err = pcall(function()
        -- Create a SecureHandlerStateTemplate handler frame — the only
        -- frame type that works with RegisterStateDriver on this client.
        local h = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
        h:Show() -- must be shown so MainMenuBarArtFrame (and its button
                 -- children) inherit visibility

        -- Reparent MainMenuBarArtFrame (NOT the buttons) to the handler.
        -- MainMenuBarArtFrame is a plain Frame, not a secure button, so
        -- SetParent is clean (no taint). The buttons stay children of
        -- MainMenuBarArtFrame (zero taint). MainMenuBarArtFrame's
        -- SetAllPoints(MainMenuBar) anchor keeps it off-screen (following
        -- MainMenuBar which the guard parks at -3000,-3000).
        flipBarOldParent = art:GetParent()
        art:SetParent(h)

        -- Forward useparent-actionpage through MainMenuBarArtFrame so the
        -- buttons' stock useparent-actionpage walk reaches the handler:
        -- button -> MainMenuBarArtFrame -> handler
        flipArtOldUseparentActionpage = art:GetAttribute("useparent-actionpage")
        art:SetAttribute("useparent-actionpage", true)

        -- Set the _onstate-actionpage snippet (copies state-actionpage
        -- to actionpage on the handler, and sets showgrid=1 + Show on
        -- each ActionButton via frame refs — secure context, no taint).
        -- OnAttributeChanged is already set to
        -- SecureHandler_StateOnAttributeChanged by the template.
        h:SetAttribute("_onstate-actionpage", FLIP_HANDLER_SNIPPET)

        -- Store frame refs to ActionButton1-10 so the secure snippet can
        -- SetAttribute("showgrid",1) and Show() on them without tainting.
        for i = 1, 10 do
            local btn = _G["ActionButton" .. i]
            if btn then
                h:SetFrameRef("btn" .. i, btn)
            end
        end

        RegisterStateDriver(h, "actionpage", FLIP_DRIVER_COND)

        flipBarFrame = h
    end)
    if ok then
        MobileUI_Debug("Flip: bridge installed on SecureHandlerStateTemplate")
    else
        MobileUI_Debug("Flip: bridge install failed: " .. tostring(err))
        -- Restore partial state on failure
        pcall(function()
            if flipBarOldParent and art then
                art:SetParent(flipBarOldParent)
                flipBarOldParent = nil
            end
        end)
    end
end

function MobileUIActionFlip.UninstallFlipBridge()
    if not flipBarFrame then return end
    local h = flipBarFrame
    local art = _G["MainMenuBarArtFrame"]
    pcall(function()
        UnregisterStateDriver(h, "actionpage")
        if art then
            if art:GetParent() == h and flipBarOldParent then
                art:SetParent(flipBarOldParent)
            end
            art:SetAttribute("useparent-actionpage", flipArtOldUseparentActionpage)
        end
    end)
    flipBarFrame = nil
    flipBarOldParent = nil
    flipArtOldUseparentActionpage = nil
end

-- Gated so the ring buffer isn't flooded: ACTIONBAR_* events fire many
-- times per second, and logging each one pushes every other module's
-- diagnostics out of the 500-entry buffer within seconds. Only log when
-- the resolved page actually changes.
local lastFlipLog = ""
local lastFlipAttrLog = ""

function MobileUIActionFlip.ApplyFlip()
    if not MobileDB or not MobileDB.layoutEnabled then return end
    -- The actionpage ATTRIBUTE is owned by the SecureStateDriver bridge
    -- (InstallFlipBridge): the driver's manager is a secure frame, so
    -- it can SetAttribute during combat lockdown — our own writes to the
    -- buttons are silently blocked mid-combat (pcall can't catch it;
    -- blocking isn't a Lua error). Display, click, and keypress all
    -- resolve through the same attribute, so they always agree.
    --
    -- Display is CLIENT-owned (stock OnEvent intact). The stock
    -- ActionButton_OnEvent calls ActionButton_UpdateAction (which
    -- re-resolves the action from actionpage and redraws the icon) only
    -- on ACTIONBAR_PAGE_CHANGED or UPDATE_BONUS_ACTIONBAR — NOT on
    -- UPDATE_SHAPESHIFT_FORM (which only calls ActionButton_Update with
    -- the stale self.action). So we register UPDATE_BONUS_ACTIONBAR on
    -- the buttons (stock doesn't), and set actionpage on the HANDLER
    -- here (out of combat only — in combat the driver's async update +
    -- the poll's ChangeActionBarPage kick covers it).
    --
    -- CRITICAL: actionpage is set on the HANDLER, NOT on the buttons.
    -- Setting it on the buttons shadows the handler's value — once set,
    -- the useparent walk returns the button's own value and never reaches
    -- the handler. In combat, SetAttribute on buttons is blocked, so we
    -- can't clear a stale button-level actionpage, and the walk is
    -- permanently stuck on the old value (root cause of the in-combat
    -- stuck-icon bug). By setting only the handler, the buttons always
    -- read the handler's current value (updated by the driver in combat).
    local page = GetActionBarPage() or 1
    local fp = page
    if page == 1 then
        local off = GetBonusBarOffset() or 0
        if off > 0 then fp = (NUM_ACTIONBAR_PAGES or 6) + off end
    end
    local logStr = string.format("Flip: page=%d off=%d fp=%d combat=%d",
        page, GetBonusBarOffset() or 0, fp, InCombatLockdown() and 1 or 0)
    if logStr ~= lastFlipLog then
        lastFlipLog = logStr
        MobileUI_Debug(logStr)
        if MobileDB and MobileDB.debug and fp > (NUM_ACTIONBAR_PAGES or 6) then
            ButtonStateDump("stealth")
        end
    end
    -- Set actionpage on the HANDLER (not the buttons) out of combat.
    -- The buttons read actionpage via the useparent walk:
    --   button -> MainMenuBarArtFrame -> handler
    -- Setting actionpage directly on the BUTTONS would shadow the handler's
    -- value AND taint the button (SetAttribute from addon context on a
    -- secure frame taints it, blocking the client's mid-combat Show()).
    --
    -- NO SetAttribute on the buttons at all — not even to clear stale
    -- values. SetAttribute("actionpage", nil) from addon context taints
    -- the button just as much as setting a non-nil value. If a stale
    -- button-level actionpage exists from a prior session, the useparent
    -- walk would read it instead of the handler, but this is a one-time
    -- migration issue (the current code never pushes actionpage to buttons).
    if not InCombatLockdown() then
        if flipBarFrame then
            flipBarFrame:SetAttribute("actionpage", fp)
        end
    end
    -- Set self.action directly on each button (plain Lua field, non-tainting).
    -- The buttons' stock UPDATE_BONUS_ACTIONBAR OnEvent fires BEFORE the
    -- flipFrame's OnEvent (this function), so the buttons read STALE
    -- actionpage from the handler and may set self.action to the wrong
    -- value. By setting self.action here (during event dispatch, before
    -- ACTIONBAR_UPDATE_USABLE fires), the client's ActionButton_UpdateUsable
    -- reads the CORRECT self.action and tints properly. Without this, the
    -- client tints grey based on the stale stealth self.action, and the
    -- tint stays wrong until the next ACTIONBAR_UPDATE_USABLE event (which
    -- can take seconds).
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn then
            btn.action = btn:GetID() + (fp - 1) * (NUM_ACTIONBAR_BUTTONS or 12)
        end
    end
    local b1 = _G["ActionButton1"]
    if b1 then
        -- Read the effective actionpage for diagnostics.
        local attrLog = "Flip: attr1=" .. tostring(SecureButton_GetModifiedAttribute(b1, "actionpage", b1))
        if attrLog ~= lastFlipAttrLog then
            lastFlipAttrLog = attrLog
            MobileUI_Debug(attrLog)
        end
    end
end

function MobileUIActionFlip.EnsureFlipWatcher()
    if flipFrame then return end
    flipFrame = CreateFrame("Frame")
    -- Page/bonus/stealth events only: the client's own buttons handle the
    -- display events (ACTIONBAR_UPDATE_USABLE/STATE/COOLDOWN,
    -- PLAYER_TARGET_CHANGED, UNIT_SPELLCAST_*, etc.) natively now that
    -- OnEvent is intact. This frame is a fast path for the page mirror +
    -- diagnostics; the 0.25s guard poll is the reliable fallback (async
    -- driver updates, unstealth kick).
    flipFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    flipFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    flipFrame:RegisterEvent("UPDATE_STEALTH")
    flipFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    flipFrame:SetScript("OnEvent", function(self, event, ...)
        MobileUI_Debug(string.format("Flip evt: %s off=%d page=%d combat=%d",
            event, GetBonusBarOffset() or 0, GetActionBarPage() or 1,
            InCombatLockdown() and 1 or 0))
        MobileUIActionFlip.ApplyFlip()
    end)
end

-- Guard tick: called every frame from MobileUIGuard's OnUpdate. Handles the
-- 0.25s flip state poll (stance/stealth detection, unstealth display flip,
-- diagnostic probes). Pure Lua — safe during combat lockdown.
local flipPollT = 0
local flipState, flipOff, flipPrevState

function MobileUIActionFlip.OnGuardTick(elapsed)
    -- Flip state check (0.25s throttle). The stance/stealth events
    -- (UPDATE_BONUS_ACTIONBAR / UPDATE_SHAPESHIFT_FORM) DO fire on
    -- Ascension (confirmed in-game), so flip detection is event-driven
    -- via flipFrame above. This poll is the DISPLAY FIX: the buttons'
    -- stock UPDATE_BONUS_ACTIONBAR OnEvent fires BEFORE the flipFrame's
    -- OnEvent (ApplyFlip), so the buttons read STALE actionpage from the
    -- handler and set self.action to the PREVIOUS state's value (one state
    -- behind). The poll detects the a1 change (after the handler's
    -- actionpage is updated by ApplyFlip or the driver) and directly sets
    -- self.action to the CORRECT value + updates the icon via SetTexture.
    -- Both are non-tainting (self.action is a plain Lua field, SetTexture
    -- on the stock icon is verified safe). The client's subsequent event
    -- handlers (UPDATE_USABLE, UPDATE_COOLDOWN) read self.action and
    -- update tint/cooldown correctly.
    -- NOTE: ChangeActionBarPage is NOT used — the Ascension client's driver
    -- processes ACTIONBAR_PAGE_CHANGED synchronously, so any page toggle
    -- corrupts the handler's actionpage (e.g. page 6 -> actionpage 6).
    -- The bonus bar's in-combat hide is handled by the busy clear
    -- in the guard (client's own HideBonusActionBar becomes instant).
    flipPollT = flipPollT + elapsed
    if flipPollT >= 0.25 then
        flipPollT = 0
        local page = GetActionBarPage() or 1
        local off = GetBonusBarOffset() or 0
        -- Include the resolved actionpage attribute for diagnostics:
        -- re-run ApplyFlip when it changes too, not just when page/off move.
        local b1 = _G["ActionButton1"]
        -- Read the effective actionpage (self attribute, then the useparent
        -- walk: button -> MainMenuBarArtFrame -> handler).
        local a1 = b1 and SecureButton_GetModifiedAttribute(b1, "actionpage", b1) or "?"
        -- Diagnostics: read handler attrs directly to see if the driver updated
        local hAP = flipBarFrame and flipBarFrame:GetAttribute("actionpage") or "?"
        local hSAP = flipBarFrame and flipBarFrame:GetAttribute("state-actionpage") or "?"
        local mgrShown = _G["SecureStateDriverManager"] and _G["SecureStateDriverManager"]:IsShown() or "?"
        local state = string.format("%d|%d|%s", page, off, tostring(a1))
        -- Periodic combat diagnostic: log handler attrs every ~1s during combat
        -- even when state doesn't change, to see if the driver ever updates.
        if InCombatLockdown() then
            flipCombatDiagT = (flipCombatDiagT or 0) + 0.25
            if flipCombatDiagT >= 1.0 then
                flipCombatDiagT = 0
                MobileUI_Debug(string.format("Flip combat-diag: hAP=%s hSAP=%s mgrShown=%s off=%d a1=%s",
                    tostring(hAP), tostring(hSAP), tostring(mgrShown), off, tostring(a1)))
            end
        else
            flipCombatDiagT = 0
        end
        if state ~= flipState then
            local prevOff = flipOff
            flipState = state
            flipOff = off
            MobileUI_Debug(string.format("Flip poll: %s->%s combat=%d hAP=%s hSAP=%s mgrShown=%s",
                flipPrevState or "?", state, InCombatLockdown() and 1 or 0,
                tostring(hAP), tostring(hSAP), tostring(mgrShown)))
            flipPrevState = state
            -- On unstealth (bonus offset 1->0):
            -- 1) ChangeActionBarPage(1) here is what makes the
            --    in-combat unstealth display flip work (cpage stays 1
            --    and no event fires, but without it the bar froze on
            --    stealth skills when unstealthing during combat).
            -- 2) Bonus bar hide: PROVEN impossible from the addon on
            --    this client (snippets may ONLY SetAttribute — even
            --    self:SetShown taints: 'UNKNOWN()'; addon-context
            --    bf:Hide() taints: 'BonusActionBarFrame:Hide()'
            --    prevented). Fix instead: the guard clears
            --    MainMenuBar.busy every frame (top of its OnUpdate),
            --    un-gating the client's own HideBonusActionBar so it
            --    takes its instant Hide() path at the unstealth
            --    event. The probe below verifies it: bonusShown
            --    should read 0 here (already hidden) or drop at
            --    +0.5s. If it persists to +3s the hypothesis failed.
            -- Kick: NO ChangeActionBarPage. The Ascension client's driver
            -- processes ACTIONBAR_PAGE_CHANGED SYNCHRONOUSLY, so any page
            -- toggle corrupts the handler's actionpage (e.g. page 6 ->
            -- actionpage 6). Instead, directly fix self.action + icon.
            --
            -- Root cause of the one-state-behind bug: the buttons' stock
            -- UPDATE_BONUS_ACTIONBAR OnEvent fires BEFORE the flipFrame's
            -- OnEvent (ApplyFlip), so the buttons read the STALE actionpage
            -- from the handler and set self.action to the PREVIOUS state's
            -- value. The poll detects the a1 change (after the handler's
            -- actionpage is updated by ApplyFlip or the driver) and directly
            -- sets self.action to the CORRECT value + updates the icon via
            -- SetTexture. Both are non-tainting (self.action is a plain Lua
            -- field, SetTexture on the stock icon is verified safe). The
            -- client's subsequent event handlers (UPDATE_USABLE, UPDATE_COOLDOWN)
            -- read self.action and update tint/cooldown correctly.
            -- This fires on EVERY state change, both in and out of combat.
            local kickMsg = string.format("Flip kick: off=%d prevOff=%s a1=%s",
                off, tostring(prevOff), tostring(a1))
            for i = 1, 10 do
                local btn = _G["ActionButton" .. i]
                if btn then
                    local ap = SecureButton_GetModifiedAttribute(btn, "actionpage", btn) or 1
                    local action = btn:GetID() + (ap - 1) * (NUM_ACTIONBAR_BUTTONS or 12)
                    -- Fix self.action (plain Lua field, non-tainting)
                    btn.action = action
                    -- Fix icon texture (SetTexture on stock icon, non-tainting)
                    local icon = _G[btn:GetName() .. "Icon"]
                    if icon and action then
                        icon:SetTexture(GetActionTexture(action))
                    end
                end
            end
            MobileUI_Debug(kickMsg)

            -- Diagnostics for specific transitions
            if off == 0 and prevOff and prevOff > 0 then
                -- Unstealth diagnostics: bonus bar hide probe
                local bf = BonusActionBarFrame
                local mmb = MainMenuBar
                local shown = bf and bf:IsShown() and 1 or 0
                local mmbShown = mmb and mmb:IsShown() and 1 or 0
                local busy = mmb and tostring(mmb.busy) or "?"
                local parent = (bf and bf:GetParent() and (bf:GetParent():GetName() or "?")) or "?"
                MobileUI_Debug(string.format(
                    "Flip unstealth: bonusShown=%d mmbShown=%d busy=%s parent=%s off=%d",
                    shown, mmbShown, busy, parent, off))
                if MobileDB and MobileDB.debug then
                    SlotDump("after-unstealth")
                    ButtonStateDump("unstealth")
                    DelayedDump(1.0, "unstealth+1s")
                    local probe = CreateFrame("Frame")
                    local pt, pi = 0, 0
                    probe:SetScript("OnUpdate", function(self, el)
                        pt = pt + el
                        if pt >= 0.5 then
                            pt = 0
                            pi = pi + 1
                            local b2, m2 = BonusActionBarFrame, MainMenuBar
                            MobileUI_Debug(string.format("Probe +%.1fs: bonusShown=%d mmbShown=%d busy=%s",
                                pi * 0.5, b2 and b2:IsShown() and 1 or 0,
                                m2 and m2:IsShown() and 1 or 0,
                                m2 and tostring(m2.busy) or "?"))
                            if pi >= 8 then self:Hide() end
                        end
                    end)
                    probe:Show()
                end
            elseif off > 0 and prevOff and prevOff == 0 then
                if MobileDB and MobileDB.debug then
                    ButtonStateDump("stealth-poll")
                end
            end
            MobileUIActionFlip.ApplyFlip()
        end
    end
end
