-- MobileUIClick.lua - Tap = Interact (Phase 6)
--
-- On Artemis (moonlight fork) a tap sends left-click and a hold sends
-- right-click.  In WoW, right-click is the workhorse for world interaction
-- (talk to NPCs, use quest objects) while left-click only targets.  This
-- module rebinds the left mouse button to the right-click world interaction
-- binding, so a tap on an NPC talks to it and a tap on a world objective
-- uses it.
--
-- Mechanism: SetOverrideBinding() rebinds BUTTON1 (left mouse button) to the
-- TURNORACTION binding command (Bindings.xml:1276, hidden="true",
-- runOnUp="true"): TurnOrActionStart() on press, TurnOrActionStop() on
-- release — the exact pipeline the client uses for right-click world
-- interaction.  The client executes binding commands natively in secure
-- context, so there is no Lua call and no taint.
--
-- Why not call TurnOrActionStart() from a frame handler?  The Ascension
-- client protects TurnOrActionStart/Stop (the wowprogramming reference
-- doesn't flag them, but the client taints insecure callers).  A
-- SecureHandlerClickTemplate frame's OnMouseDown/OnMouseUp still tainted in
-- this client, and the restricted environment used by secure _onclick
-- snippets (RestrictedEnvironment.lua) does not expose TurnOrActionStart.
-- Rebinding the button to the native binding command sidesteps all of it.
--
-- The binding only fires when the click is NOT consumed by a UI frame
-- (normal UI hit-testing still wins), so action bars, bags, unit frames,
-- etc. keep their normal left-click behavior.
--
-- What this does NOT cover: left-click targeting is replaced (tap on a unit
-- now interacts/attacks it instead of just selecting it), and left-click on
-- empty ground no longer deselects.  That is the intended trade-off — the
-- user only needs tap = interact.

local ADDON = "MobileUI"

MobileUIClick = {}

local owner -- any frame that owns the override binding

local function GetOwner()
    if not owner then
        owner = CreateFrame("Frame", "MobileUIClickOwner", UIParent)
    end
    return owner
end

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUIClick:Apply()
    -- Rebind the left mouse button: instead of the default
    -- CAMERAORSELECTORMOVE (targeting), execute the TURNORACTION binding
    -- (right-click world interaction).  Executed natively by the client in
    -- secure context — no Lua call, no taint.
    SetOverrideBinding(GetOwner(), false, "BUTTON1", "TURNORACTION")
    MobileUI_Debug("Tap=Interact: BUTTON1 -> TURNORACTION override set")
end

function MobileUIClick:Revert()
    if owner then
        ClearOverrideBindings(owner)
        MobileUI_Debug("Tap=Interact: BUTTON1 override cleared")
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

-- While the cursor holds an item, the BUTTON1 -> TURNORACTION override
-- swallows the world-click that stock uses to drop the item: the binding
-- fires instead, the pickup is cancelled and the item returns to the bag.
-- Clear the override while holding so the stock drop works, and re-apply
-- it when the cursor empties. Called by the MobileUIBagSwap poll on cursor
-- holding-state changes.
function MobileUIClick:SetCursorHolding(holding)
    if not (MobileDB and MobileDB.tapInteract) then return end
    if holding then
        if owner then
            ClearOverrideBindings(owner)
            MobileUI_Debug("Tap=Interact: override cleared (cursor holding item)")
        end
    else
        SetOverrideBinding(GetOwner(), false, "BUTTON1", "TURNORACTION")
        MobileUI_Debug("Tap=Interact: BUTTON1 -> TURNORACTION re-applied")
    end
end
