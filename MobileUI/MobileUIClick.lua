-- MobileUIClick.lua - Tap = Interact (Phase 6)
--
-- On Artemis (moonlight fork) a tap sends left-click and a hold sends
-- right-click.  In WoW, right-click is the workhorse for world interaction
-- (talk to NPCs, use quest objects) while left-click only targets.  This
-- module intercepts left-click on the 3-D world and re-routes it through the
-- right-click interaction pipeline, so a tap on an NPC talks to it and a tap
-- on a world objective uses it.
--
-- Mechanism: SetOverrideBindingClick() rebinds BUTTON1 (left mouse button)
-- to simulate a click on a hidden Button.  The binding only fires when the
-- click is NOT consumed by a UI frame (normal UI hit-testing still wins), so
-- action bars, bags, unit frames, etc. keep their normal left-click behavior.
-- The hidden button's OnMouseDown/OnMouseUp then drive TurnOrActionStart/Stop
-- — the exact API the client uses for right-click world interaction
-- (reference: api/t.md "TurnOrActionStart/Stop", "TURNORACTION" binding).
--
-- What this does NOT cover: left-click targeting is replaced (tap on a unit
-- now interacts/attacks it instead of just selecting it), and left-click on
-- empty ground no longer deselects.  That is the intended trade-off — the
-- user only needs tap = interact.

local ADDON = "MobileUI"

MobileUIClick = {}

local catcher -- hidden Button that receives the simulated clicks

-- ============================================================================
-- Hidden click catcher
-- ============================================================================
-- A 1x1 hidden Button.  Real mouse events never reach it (hidden frames are
-- skipped by hit-testing), but SetOverrideBindingClick simulates clicks on it
-- directly through the binding system, so visibility is irrelevant.
--
-- It MUST inherit SecureHandlerClickTemplate: TurnOrActionStart/Stop are
-- protected in the Ascension client (the wowprogramming reference doesn't flag
-- them, but the client taints insecure callers).  Scripts on a secure frame
-- run in secure context, so the protected calls are allowed.

local function CreateCatcher()
    if catcher then return end
    catcher = CreateFrame("Button", "MobileUIClickCatcher", UIParent, "SecureHandlerClickTemplate")
    catcher:SetSize(1, 1)
    catcher:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
    catcher:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            TurnOrActionStart()
        end
    end)
    catcher:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            TurnOrActionStop()
        end
    end)
    catcher:Hide()
end

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUIClick:Apply()
    CreateCatcher()
    -- Rebind the left mouse button: instead of the default
    -- CAMERAORSELECTORMOVE (targeting), simulate a left-click on our hidden
    -- catcher, which runs the right-click interaction pipeline.
    SetOverrideBindingClick(catcher, false, "BUTTON1", "MobileUIClickCatcher", "LeftButton")
    MobileUI_Debug("Tap=Interact: BUTTON1 override binding set")
end

function MobileUIClick:Revert()
    if catcher then
        ClearOverrideBindings(catcher)
        MobileUI_Debug("Tap=Interact: BUTTON1 override binding cleared")
    end
end

function MobileUIClick:Toggle()
    local enabled = not MobileDB.tapInteract
    MobileDB.tapInteract = enabled
    if enabled then
        self:Apply()
    else
        self:Revert()
    end
    return enabled
end
