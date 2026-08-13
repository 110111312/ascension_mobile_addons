-- MobileUIActionFlip.lua - Stance/stealth flip follower + SecureStateDriver bridge
-- The Ascension client resolves keypresses internally (C-side): in stealth
-- '-' hits the stealth bar, which on this client is the BONUS bar
-- (GetBonusBarOffset() = 1 -> page 7, slots 73-84) — NOT an action-bar page.
-- GetActionBarPage() stays pinned at 1 and pages 2-5 are empty; the default
-- UI's "stealth bar" is BonusActionBarFrame. The reparented scatter buttons
-- never recompute on their own, so display and click stay on page 1 while
-- keypresses go elsewhere. Driven by a 0.25s state poll in guardFrame's
-- OnUpdate (this client fires no page/shapeshift events), the follower
-- mirrors the client's choice via the 'actionpage' ATTRIBUTE — the secure
-- channel for configuring secure buttons.
-- TAINT RULES (learned the hard way):
--   * Writing plain Lua fields that ActionButton_CalculateAction READS
--     (e.g. isBonus) taints the secure click chain: the next click errors
--     "AddOn 'MobileUI' tainted the call of the secure function
--     'UseAction()'" and the cast is blocked. Attributes don't taint.
--   * On THIS client ANY direct field write on the secure buttons taints
--     — even self.action, which CalculateAction never reads: after the
--     write, the client's own later SetAttribute on the button errors
--     "prevented the call of the secure function 'ActionButtonN:SetAttribute()'"
--     and its page management breaks. So the display must be owned via
--     non-protected regions only (icon/cooldown textures, vertex color)
--     and the client must be prevented from hiding/re-rendering the
--     buttons from their stale self.action: the buttons' OnEvent is
--     cleared at apply (the client never dispatches their updates — which
--     also stops its Show()/Hide() from being blocked on our tainted
--     buttons), showgrid=1 keeps its Update from hiding them, and an
--     event/poll-driven re-assert (RefreshScatterButtons on flipFrame events
--     + guard poll) redraws icon/tint/cooldown from the attr page (usability
--     tints computed from the CORRECT action). NOT per-frame: the cooldown
--     spiral is widget-internal after SetCooldown.

MobileUIActionFlip = {}

local flipFrame
local flipHandlers = {}

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

-- Resolve a scatter button's action slot exactly as ActionButton_CalculateAction
-- will at click time (actionpage attribute first, then GetActionBarPage), so
-- display and click always agree. Returns the actionID and the icon texture.
local function ResolveScatterAction(btn, fallbackId)
    local id = btn:GetID()
    if not id or id < 1 then id = fallbackId end
    local attrPage = tonumber(SecureButton_GetModifiedAttribute(btn, "actionpage"))
    local page = attrPage or (GetActionBarPage() or 1)
    local action = id + (page - 1) * (NUM_ACTIONBAR_BUTTONS or 12)
    return action, _G[btn:GetName() .. "Icon"]
end

local function RefreshScatterButtons()
    if InCombatLockdown() then
        -- OnEvent is CLEARED at apply (see ApplyActionBar), so the client
        -- never dispatches ActionButton_Update on these buttons -- which means
        -- it never calls self:Show()/self:Hide() (blocked on our tainted
        -- buttons) and never renders icon/tint/cooldown. We own the display:
        -- icon texture, usability tint, and cooldown, all from the CORRECT
        -- (attribute-resolved) action via ResolveScatterAction.
        --
        -- Taint: SetVertexColor on the icon/NormalTexture and SetCooldown on
        -- the Cooldown frame all taint the button. This is SAFE because OnEvent
        -- is cleared: the client never calls self:Show() on the tainted button,
        -- so the taint never surfaces as a blocked-call error. This is the same
        -- approach the original code used (minus the per-frame cascade).
        --
        -- Trigger: event-driven (flipFrame OnEvent: UPDATE_BONUS_ACTIONBAR,
        -- UPDATE_SHAPESHIFT_FORM, ACTIONBAR_UPDATE_COOLDOWN, etc.) plus the
        -- 0.25s guard poll. NOT per-frame -- the cooldown spiral animation is
        -- widget-internal after SetCooldown, so event-driven re-sync is enough.
        for i = 1, 12 do
            local btn = _G["ActionButton" .. i]
            if btn then
                local action, icon = ResolveScatterAction(btn, i)
                local tex = GetActionTexture(action)
                if tex then
                    icon:SetTexture(tex)
                    icon:Show()
                    local isUsable, notEnoughMana = IsUsableAction(action)
                    if isUsable then
                        icon:SetVertexColor(1.0, 1.0, 1.0)
                    elseif notEnoughMana then
                        icon:SetVertexColor(0.5, 0.5, 1.0)
                    else
                        icon:SetVertexColor(0.4, 0.4, 0.4)
                    end
                    local nt = _G[btn:GetName() .. "NormalTexture"]
                    if nt then
                        if notEnoughMana then
                            nt:SetVertexColor(0.5, 0.5, 1.0)
                        else
                            nt:SetVertexColor(1.0, 1.0, 1.0)
                        end
                    end
                    -- Cooldown: we own this (OnEvent cleared, the client
                    -- won't update it). SetCooldown starts the widget's
                    -- internal spiral animation; ACTIONBAR_UPDATE_COOLDOWN
                    -- events (flipFrame registers them) re-trigger
                    -- RefreshScatterButtons to re-sync. Taints the button, but
                    -- with OnEvent cleared the client never calls self:Show().
                    local cd = _G[btn:GetName() .. "Cooldown"]
                    if cd then
                        local start, duration, enable = GetActionCooldown(action)
                        if start and duration and duration > 0 and enable == 1 then
                            if cd.start ~= start or cd.duration ~= duration then
                                cd:SetCooldown(start, duration)
                                cd.start, cd.duration = start, duration
                            end
                            if not cd:IsShown() then cd:Show() end
                        else
                            cd:Hide()
                            cd.start, cd.duration = nil, nil
                        end
                    end
                else
                    icon:Hide()
                end
            end
        end
        -- Diagnostic: which page-1 slots actually have content, and which
        -- buttons drew an icon (the user sees only some buttons populated
        -- after the in-combat flip — need to know if the slots are empty or
        -- the draw is failing). Only when debug is enabled.
        if MobileDB and MobileDB.debug then
            local drawn, slots = {}, {}
            for i = 1, 10 do
                if GetActionTexture(i) then slots[#slots + 1] = i end
            end
            for i = 1, 12 do
                local btn = _G["ActionButton" .. i]
                if btn then
                    local icon = _G[btn:GetName() .. "Icon"]
                    if icon and icon:IsShown() then drawn[#drawn + 1] = i end
                end
            end
            MobileUI_Debug("Refresh: slotTex1_10={" .. table.concat(slots, ",") .. "} drawn={" .. table.concat(drawn, ",") .. "}")
            ButtonStateDump("at-refresh")
        end
    else
        for i = 1, 12 do
            local btn = _G["ActionButton" .. i]
            if btn then
                local ok, err = pcall(ActionButton_UpdateAction, btn)
                if not ok then
                    MobileUI_Debug("Flip: ActionButton" .. i .. " update failed: " .. tostring(err))
                end
            end
        end
    end
end
MobileUIActionFlip.RefreshScatterButtons = RefreshScatterButtons

-- Flash (casting/attack glow) re-assert, called EVERY FRAME from the guard
-- OnUpdate (below). The client's ActionButton_UpdateFlash never runs (OnEvent
-- cleared) and cast events are unreliable on this server, so the stateflash
-- attribute latches at 1 after a cast and the glow sticks forever. Re-assert
-- it here from the attribute-resolved action: Show while casting/attacking/
-- repeating, Hide otherwise — so it turns off within a frame of the cast
-- ending. Flash is a plain texture region, so Show/Hide is taint-safe
-- (SetVertexColor/SetCooldown are the tainting ops, not texture Show/Hide).
-- Flash blink state (module-local): the red attack/auto-shot flash blinks
-- (stock behavior) instead of staying solid red. Toggled on a 0.5s timer in
-- ReassertFlash; resets to "on" whenever no flash is active so the glow
-- appears immediately when auto-attack starts.
local flashBlinkT, flashBlinkOn = 0, true

local function ReassertFlash(elapsed)
    local anyFlash = false
    for i = 1, 12 do
        local btn = _G["ActionButton" .. i]
        if btn then
            local action = ResolveScatterAction(btn, i)
            -- Red flash: auto-attack / auto-shot ONLY, and only while they are
            -- actually active (user preference — the red UI-QuickslotRed glow
            -- is not shown for spell casts). IsAttackAction/IsAutoRepeatAction
            -- are SLOT-CONTENT checks (1 whenever the attack/auto-shot ability
            -- is in the slot), so they must be ANDed with IsCurrentAction
            -- (1 while the repeating action is actually repeating) — otherwise
            -- the attack button glows red permanently.
            local flash = IsCurrentAction(action) and (IsAttackAction(action) or IsAutoRepeatAction(action))
            if flash then anyFlash = true end
            local fl = _G[btn:GetName() .. "Flash"]
            if fl then
                if flash and flashBlinkOn then
                    if not fl:IsShown() then fl:Show() end
                else
                    if fl:IsShown() then fl:Hide() end
                end
            end
            -- Clear a latched checked state: the client checks the button
            -- while casting (the casting highlight) but the uncheck runs via
            -- the OnEvent-driven ActionButton_UpdateState, which is cleared
            -- at apply — so the checked glow (RoundButtonChecked / Border)
            -- sticks forever. Clear it whenever the action is not currently
            -- being cast, so the glow is transient (shows during the cast,
            -- gone after). SetChecked is a plain state setter, not a
            -- protected call, so this is taint-safe.
            if not IsCurrentAction(action) and btn:GetChecked() then btn:SetChecked(nil) end
        end
    end
    -- Blink: advance the timer only while a flash is active; reset to "on"
    -- when idle so the glow appears immediately at attack start.
    if anyFlash then
        flashBlinkT = flashBlinkT + (elapsed or 0)
        if flashBlinkT >= 0.5 then
            flashBlinkT = 0
            flashBlinkOn = not flashBlinkOn
        end
    else
        flashBlinkT, flashBlinkOn = 0, true
    end
end

-- ---- SecureStateDriver bridge (combat-safe attribute writes) ----
-- Our own SetAttribute("actionpage", N) on the ActionButtons is SILENTLY
-- blocked during combat lockdown on this client (verified via readback:
-- after ApplyFlip writes 1 mid-combat, the attribute still reads 7; pcall
-- can't catch it because secure-call blocking is not a Lua error). The one
-- stock mechanism that CAN write attributes on protected frames during
-- combat is the SecureStateDriver manager (a secure frame). But the driver
-- manages 'state-<name>' attributes, which ActionButton_CalculateAction
-- does NOT read (it reads plain 'actionpage' via the useparent walk). So:
--   - each scattered ActionButton1-10 is reparented under a tiny
--     SecureHandlerStateTemplate frame (ours, created out of combat);
--   - RegisterStateDriver(handler, "actionpage", COND) makes the manager
--     re-evaluate COND every 0.2s (and immediately on bonus/stealth/page
--     events) and securely SetAttribute 'state-actionpage' on the handler
--     — even during combat lockdown;
--   - the handler's template-wired _onstate-actionpage snippet copies
--     'state-actionpage' -> 'actionpage' on the handler (restricted
--     closure: it runs in a secure context, so its SetAttribute is allowed
--     in combat too);
--   - the button's stock useparent-actionpage=true walk then reads the
--     handler's 'actionpage' -> CalculateAction, clicks, and our refresh
--     all resolve the same page, in and out of combat.
-- COND mirrors the client generically: [bonusbar:N] -> page 6+N (this
-- client's stealth/stance bonus bar), [bar:N] -> N (stock page flips),
-- else an explicit 1 (never nil — a nil-clear left the client's C-side
-- keypress resolver stuck on the bonus page after unstealth).
local FLIP_HANDLER_SNIPPET = [[
    if newstate then
        self:SetAttribute("actionpage", newstate)
    else
        self:SetAttribute("actionpage", 1)
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
    for i = 1, 10 do
        local btn = _G["ActionButton" .. i]
        if btn and not flipHandlers[i] then
            local h = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
            h:SetSize(1, 1)
            h:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
            h:Show()
            local ok, err = pcall(function()
                h:SetAttribute("_onstate-actionpage", FLIP_HANDLER_SNIPPET)
                RegisterStateDriver(h, "actionpage", FLIP_DRIVER_COND)
            end)
            if ok then
                btn:SetParent(h)
                flipHandlers[i] = h
            else
                MobileUI_Debug("Flip: bridge install failed for ActionButton" .. i .. ": " .. tostring(err))
                h:Hide()
            end
        end
    end
end

function MobileUIActionFlip.UninstallFlipBridge()
    for i = 1, 10 do
        local h = flipHandlers[i]
        if h then
            UnregisterStateDriver(h, "actionpage")
            h:Hide()
            flipHandlers[i] = nil
        end
    end
end

-- Gated so the ring buffer isn't flooded: ACTIONBAR_* events fire many
-- times per second, and logging each one pushes every other module's
-- diagnostics out of the 500-entry buffer within seconds. Only log when
-- the resolved page actually changes.
local lastFlipLog = ""
local lastFlipAttrLog = ""

function MobileUIActionFlip.ApplyFlip()
    if not MobileDB or not MobileDB.layoutEnabled then return end
    -- The actionpage ATTRIBUTE is now owned by the SecureStateDriver bridge
    -- above (InstallFlipBridge): the driver's manager is a secure frame, so
    -- it can SetAttribute during combat lockdown — our own writes cannot
    -- (verified: SetAttribute on ActionButtons is SILENTLY blocked
    -- mid-combat on this client; pcall can't catch it because blocking
    -- isn't a Lua error). Display, click, and keypress all resolve through
    -- the same attribute, so they always agree, in and out of combat.
    -- ApplyFlip only mirrors the client's side-effects and re-draws the
    -- buttons to follow the attribute.
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
    end
    RefreshScatterButtons()
    local b1 = _G["ActionButton1"]
    if b1 then
        local attrLog = "Flip: attr1=" .. tostring(SecureButton_GetModifiedAttribute(b1, "actionpage"))
        if attrLog ~= lastFlipAttrLog then
            lastFlipAttrLog = attrLog
            MobileUI_Debug(attrLog)
        end
    end
end

function MobileUIActionFlip.EnsureFlipWatcher()
    if flipFrame then return end
    flipFrame = CreateFrame("Frame")
    flipFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    flipFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
    flipFrame:RegisterEvent("UPDATE_STEALTH")
    flipFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    flipFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    flipFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    flipFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    -- The buttons re-render from their stale self.action on these, so we
    -- redraw right after their handlers run (our registration is newer,
    -- so we dispatch after them) to kill the one-frame stale flicker at
    -- combat transitions.
    flipFrame:RegisterEvent("PLAYER_ENTER_COMBAT")
    flipFrame:RegisterEvent("PLAYER_LEAVE_COMBAT")
    flipFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
    flipFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    flipFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    -- Cast boundaries: the flash (golden casting glow) is re-asserted by
    -- RefreshScatterButtons from IsCurrentAction. These events guarantee a
    -- refresh at cast start AND cast end even for spells with no cooldown
    -- (which fire no ACTIONBAR_UPDATE_COOLDOWN), so the glow can't latch on.
    flipFrame:RegisterEvent("UNIT_SPELLCAST_START")
    flipFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
    flipFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    flipFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    flipFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
    flipFrame:SetScript("OnEvent", function(self, event, ...)
        -- Combat-safe: ApplyFlip only touches non-protected regions (icon
        -- texture, NormalTexture vertex color, Cooldown frame). These taint
        -- the button, but OnEvent is cleared at apply so the client never
        -- calls self:Show()/self:Hide() on the tainted button mid-combat.
        -- The actionpage attribute is owned by the SecureStateDriver bridge.
        MobileUI_Debug(string.format("Flip evt: %s off=%d page=%d combat=%d",
            event, GetBonusBarOffset() or 0, GetActionBarPage() or 1,
            InCombatLockdown() and 1 or 0))
        MobileUIActionFlip.ApplyFlip()
        -- We own the scatter display (OnEvent cleared): RefreshScatterButtons
        -- redraws icon/tint/cooldown from the bridge's actionpage attribute.
        -- No per-frame redraw needed -- event/poll-driven is sufficient.
    end)
end

-- Guard tick: called every frame from MobileUIGuard's OnUpdate. Handles the
-- 0.25s flip state poll (stance/stealth detection, unstealth display flip,
-- diagnostic probes) and the per-frame flash re-assert. Pure Lua — safe
-- during combat lockdown.
local flipPollT = 0
local flipState, flipOff, flipPrevState

function MobileUIActionFlip.OnGuardTick(elapsed)
    -- Flip state check (0.25s throttle). The stance/stealth events
    -- (UPDATE_BONUS_ACTIONBAR / UPDATE_SHAPESHIFT_FORM) DO fire on
    -- Ascension (confirmed in-game), so flip detection is event-driven
    -- via flipFrame above. This poll is kept for two reasons: (1) the
    -- unstealth branch runs ChangeActionBarPage(1), empirically
    -- required for the in-combat unstealth display flip; (2) it
    -- re-asserts ApplyFlip when the bridge's actionpage attribute
    -- updates asynchronously (driver 0.2s throttle / event re-eval).
    -- The bonus bar's in-combat hide is handled by the busy clear
    -- in the guard (client's own HideBonusActionBar becomes instant); the
    -- unstealth branch probes that it worked.
    flipPollT = flipPollT + elapsed
    if flipPollT >= 0.25 then
        flipPollT = 0
        local page = GetActionBarPage() or 1
        local off = GetBonusBarOffset() or 0
        -- Include the resolved actionpage attribute: the bridge
        -- updates it asynchronously (driver 0.2s throttle / event
        -- re-eval), so re-run ApplyFlip when IT changes too, not
        -- just when page/off move.
        local b1 = _G["ActionButton1"]
        local a1 = b1 and SecureButton_GetModifiedAttribute(b1, "actionpage") or "?"
        local state = string.format("%d|%d|%s", page, off, tostring(a1))
        if state ~= flipState then
            local prevOff = flipOff
            flipState = state
            flipOff = off
            MobileUI_Debug(string.format("Flip poll: %s->%s combat=%d",
                flipPrevState or "?", state, InCombatLockdown() and 1 or 0))
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
            if off == 0 and prevOff and prevOff > 0 then
                local bf = BonusActionBarFrame
                local mmb = MainMenuBar
                local shown = bf and bf:IsShown() and 1 or 0
                local mmbShown = mmb and mmb:IsShown() and 1 or 0
                local busy = mmb and tostring(mmb.busy) or "?"
                local parent = (bf and bf:GetParent() and (bf:GetParent():GetName() or "?")) or "?"
                local ok = pcall(ChangeActionBarPage, 1)
                MobileUI_Debug(string.format(
                    "Flip unstealth: bonusShown=%d mmbShown=%d busy=%s parent=%s off=%d changePage=%s",
                    shown, mmbShown, busy, parent, off, tostring(ok)))
                if MobileDB and MobileDB.debug then
                    SlotDump("after-unstealth")
                    ButtonStateDump("unstealth")
                    DelayedDump(1.0, "unstealth+1s")
                    -- Probe: sample bf visibility + busy every 0.5s for
                    -- 4s to catch when the client's hide finally runs.
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
            end
            MobileUIActionFlip.ApplyFlip()
        end
    end
    -- Flash re-assert (every frame, incl. combat): the client's
    -- ActionButton_UpdateFlash never runs (OnEvent cleared) and cast
    -- events are unreliable on this server, so the casting glow
    -- latches on after a cast. Re-assert it here from the attribute-
    -- resolved action so it turns off within a frame of the cast
    -- ending. Taint-safe: Flash is a plain texture region.
    ReassertFlash(elapsed)
end