-- MobileUIGuard.lua - Hide bottom-bar art + OnUpdate guard
-- Hides the stock extra action bars and bonus action bar, PARKS the stock
-- main menu bar + art frame off-screen (shown — the scatter buttons 1-10
-- stay children of MainMenuBarArtFrame, never reparented, so a hidden
-- parent would hide them), parks the main bar's non-scatter tail buttons
-- (ActionButton11/12, "-"/"=") off-screen, and parks the bottom-left bar's
-- tail buttons (6-12) off-screen. Runs a per-frame guard OnUpdate that
-- re-hides everything the client re-shows, re-asserts the stance/stealth
-- flip poll (delegated to MobileUIActionFlip), and keeps MultiBarBottomLeft
-- shown (its scatter buttons are children). Pauses protected-frame
-- enforcement during combat lockdown to avoid taint.

MobileUIGuard = {}

local HIDE_FRAMES     = MobileUILayout.HIDE_FRAMES
local saved           = MobileUILayout.saved
local RestorePoints   = MobileUILayout.RestorePoints

local guardFrame

-- MultiBarBottomLeft must NOT be hidden or moved: the scatter buttons stay
-- attached to it (slot resolution comes from the attached bar), and a hidden
-- parent means children don't render. The client marks the bar container as a
-- protected frame, so ClearAllPoints()/SetPoint() on it raise a secure-call
-- error ("prevented the call of the secure function"). We leave it at its
-- stock anchor — the container has no art, so it is invisible — and only
-- ensure it stays SHOWN. Its non-scatter buttons (6-12) are hidden
-- individually instead.
local function EnsureBarShown()
    local mbl = _G["MultiBarBottomLeft"]
    if mbl and not mbl:IsShown() then mbl:Show() end
end

-- Hide the bottom-left bar's non-scatter buttons (6-12). The bar is horizontal
-- and its buttons are anchor-chained (each LEFT of the previous button's
-- RIGHT), so buttons 6-12 chain off the last scatter button
-- (MultiBarBottomLeftButton5 at scatter spot 15) and would render on screen
-- next to the arc. Hiding them individually is safe: they stay attached to the
-- bar, so slot resolution for the scatter buttons is unaffected.
local function HideBar2Tail()
    for i = 6, 12 do
        -- The dynamic action bar (bottom-left strip) owns buttons 6-10 while
        -- enabled — leave them shown so the strip stays visible through the
        -- guard's per-frame re-hide.
        if MobileUIDynamicBar and MobileUIDynamicBar.TailUsed and MobileUIDynamicBar.TailUsed(i) then
            -- dynamic bar owns this button; keep it shown
        else
            local b = _G["MultiBarBottomLeftButton" .. i]
            if b and b:IsShown() then b:Hide() end
        end
    end
end

-- Park the tail buttons far off-screen. Hide() alone is not combat-proof: the
-- client re-shows the bar's buttons when combat starts, and the guard frame
-- pauses its per-frame HideBar2Tail() during combat lockdown (Show/Hide on
-- protected frames in combat taints them and breaks the next UseAction click).
-- Re-shows never re-anchor, so a one-shot off-screen reposition at apply time
-- (always out of combat) makes the combat re-show render invisibly — with no
-- per-frame protected-frame calls during the fight. Each button gets its own
-- independent anchor (don't rely on the chain dragging 7-12 after 6), and all
-- stay children of MultiBarBottomLeft, so slot resolution (61-72) is untouched.
local function ParkBar2Tail()
    for i = 6, 12 do
        local b = _G["MultiBarBottomLeftButton" .. i]
        if b then
            b:ClearAllPoints()
            b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
        end
    end
end

-- Park MainMenuBar + MainMenuBarArtFrame off-screen (SHOWN) instead of
-- hiding them: the scatter buttons 1-10 stay children of MainMenuBarArtFrame
-- (never reparented — SetParent on a secure button taints it and blocks the
-- client's mid-combat Show(), the phase-3/4 error). A hidden parent would
-- hide the buttons; a parked (shown) parent keeps them rendering at their
-- UIParent-anchored arc positions while the bar art stays off-screen.
-- MainMenuBarArtFrame is anchored to MainMenuBar, so parking MainMenuBar
-- parks both. SetPoint on a protected frame is clean here (the strip
-- buttons 66-71 and arc 11-15 are SetPoint'd the same way with zero errors).
local mmbSavedPoints
local function ParkMainMenuBar()
    local mmb = _G["MainMenuBar"]
    if mmb then
        if not mmbSavedPoints then mmbSavedPoints = MobileUILayout.SavePoints(mmb) end
        mmb:ClearAllPoints()
        mmb:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
        if not mmb:IsShown() then mmb:Show() end
    end
    local art = _G["MainMenuBarArtFrame"]
    if art and not art:IsShown() then art:Show() end
end

-- Park the main bar's non-scatter tail buttons (ActionButton11/12, keys "-"
-- and "=") off-screen. They are NOT scattered (Artemis has no "-"/"=" virtual
-- keys — scatter spots 11/12 are fed from MultiBarBottomLeft buttons), but
-- their stock chain anchor follows ActionButton10 (each button's LEFT is
-- anchored to the previous button's RIGHT), so once button 10 is repositioned
-- to the arc, buttons 11/12 render right next to it on screen. Give them
-- their own independent off-screen anchor, exactly like the bottom-left
-- bar's tail buttons (6-12). They stay SHOWN (never Hide — unlike the
-- bottom-left tail, their actions DO change with the actionpage flip, so an
-- addon-context Hide() would taint them and block the client's self:Show()
-- on stealth/unstealth; SetPoint on a protected frame is clean).
local function ParkMainBarTail()
    for i = 11, 12 do
        local b = _G["ActionButton" .. i]
        if b then
            b:ClearAllPoints()
            b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
        end
    end
end

function MobileUIGuard:Apply()
    for _, name in ipairs(HIDE_FRAMES) do
        local f = _G[name]
        if f then f:Hide() end
    end
    ParkMainMenuBar()
    ParkMainBarTail()
    EnsureBarShown()
    HideBar2Tail()
    ParkBar2Tail()
    if not guardFrame then
        guardFrame = CreateFrame("Frame")
        guardFrame:SetScript("OnUpdate", function(self, elapsed)
            if not MobileDB or not MobileDB.layoutEnabled then return end
            -- MainMenuBar.busy: the client's HideBonusActionBar() is gated on
            -- it. When set (our layout hides MainMenuBar every frame, plausibly
            -- jamming the client's own bar-slide state machine around combat
            -- transitions) the client takes the stuck/late slide path and the
            -- bonus bar stays SHOWN ~3s after an in-combat unstealth, stealing
            -- clicks ("you can't do that yet"). Clearing it — a plain FIELD
            -- write, not a protected method call, so no taint — makes the
            -- client's HideBonusActionBar() take its instant Hide() path,
            -- hiding the bar in combat with zero addon touch on it. Kept every
            -- frame, including during combat lockdown.
            MainMenuBar.busy = nil
            -- Flip poll + flash re-assert (delegated to MobileUIActionFlip):
            -- pure Lua, safe during combat lockdown.
            MobileUIActionFlip.OnGuardTick(elapsed)
            -- Everything below this line Show()/Hide()s PROTECTED frames (the
            -- stock bars and bar buttons): during combat lockdown those calls
            -- are blocked and TAINT the frames — which then surfaces as
            -- "MobileUI tainted the call of the secure function 'UseAction()'"
            -- on the next button click. Pause that enforcement during combat;
            -- the stock bar briefly showing is cosmetic, and full enforcement
            -- resumes when combat ends. (The flip poll above is pure Lua and
            -- stays active in combat.)
            if InCombatLockdown() then
                -- OnEvent is cleared on the scatter buttons, so the client
                -- doesn't dispatch their updates mid-combat. Keep the early
                -- return so we don't enforce HIDE_FRAMES on protected frames
                -- mid-combat. The flip poll above (pure Lua) stays active.
                return
            end
            for _, name in ipairs(HIDE_FRAMES) do
                local f = _G[name]
                if f and f:IsShown() then f:Hide() end
            end
            -- MainMenuBar + MainMenuBarArtFrame: keep SHOWN + parked (the
            -- scatter buttons 1-10 are children of MainMenuBarArtFrame; a
            -- hidden parent hides them, and the client re-shows/re-anchors
            -- the bar). Re-park only if the client moved it back on-screen.
            local mmb = _G["MainMenuBar"]
            if mmb then
                if not mmb:IsShown() then mmb:Show() end
                local l = mmb:GetLeft()
                if l and l > -1000 then
                    mmb:ClearAllPoints()
                    mmb:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
                end
            end
            local art = _G["MainMenuBarArtFrame"]
            if art and not art:IsShown() then art:Show() end
            -- ActionButton11/12 (main bar tail, "-"/"="): keep parked
            -- off-screen — re-park if the client re-anchored them on screen.
            for i = 11, 12 do
                local b = _G["ActionButton" .. i]
                if b then
                    local l = b:GetLeft()
                    if l and l > -1000 then
                        b:ClearAllPoints()
                        b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3000, -3000)
                    end
                end
            end
            -- BonusActionBarFrame hide (out of combat only): belt-and-
            -- suspenders for the MainMenuBar.busy clear at the top of this
            -- OnUpdate. The busy clear is what makes the client's own
            -- HideBonusActionBar instant (covering the in-combat unstealth);
            -- this hide keeps the bar gone whenever we're out of combat —
            -- including during stealth, where the arc flip replaces the stock
            -- bar. The call is clean out of combat (the guard has hidden
            -- MainMenuBar the same way for months with zero errors); in combat
            -- it must NOT run (taints, 'BonusActionBarFrame:Hide()' prevented)
            -- which is why it lives after the lockdown early-return.
            local bf = BonusActionBarFrame
            if bf and bf:IsShown() then bf:Hide() end
            -- MultiBarBottomLeft: keep SHOWN (a hidden parent hides the
            -- scatter buttons). Never touch its points — the client marks the
            -- bar container as a protected frame.
            EnsureBarShown()
            -- Tail buttons (6-12) chain off the last scatter button's RIGHT
            -- edge; re-hide them in case the client re-shows them
            HideBar2Tail()
            -- Keep action button hotkeys/names hidden
            local HOTKEY_FRAMES = MobileUIActionBar and MobileUIActionBar.HOTKEY_FRAMES
            if HOTKEY_FRAMES then
                for _, f in ipairs(HOTKEY_FRAMES) do
                    if f and f:IsShown() then f:Hide() end
                end
            end
        end)
    end
    guardFrame:Show()
end

function MobileUIGuard:Revert()
    if guardFrame then guardFrame:Hide() end
    -- Restore the bottom-left bar's tail buttons (6-12): un-park them (back on
    -- the anchor chain) and restore their original shown state.
    for i = 6, 12 do
        local b, sv = _G["MultiBarBottomLeftButton" .. i], saved.bar2tail and saved.bar2tail[i]
        if b and sv then
            if sv.points then RestorePoints(b, sv.points) end
            if sv.shown then b:Show() else b:Hide() end
        end
    end
    for _, name in ipairs(HIDE_FRAMES) do
        local f, sv = _G[name], saved.hides and saved.hides[name]
        if f and sv then f:Show() end
    end
    -- Restore MainMenuBar + MainMenuBarArtFrame: un-park (back on the stock
    -- anchor chain) and show.
    local mmb = _G["MainMenuBar"]
    if mmb then
        if mmbSavedPoints then
            RestorePoints(mmb, mmbSavedPoints)
            mmbSavedPoints = nil
        end
        mmb:Show()
    end
    local art = _G["MainMenuBarArtFrame"]
    if art then art:Show() end
end