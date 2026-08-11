-- MobileUISell.lua - Tap = Sell (pickup-reaction model)
--
-- On Artemis (moonlight fork) a tap sends left-click and a hold sends
-- right-click. In WoW, right-clicking a bag item while the merchant frame
-- is open sells it; left-clicking picks it up. This module makes a plain
-- tap on a bag item sell it while a vendor is open.
--
-- Mechanism: we never touch the click handler. The tap does its stock thing
-- — it picks the item up — and MobileUIBagSwap's per-frame pickup poll
-- detects the empty-cursor -> item transition (via GetMouseFocus), returns
-- the item to its slot and calls UseContainerItem: the SELL path is not
-- protected in this client (merchant-open wins the dispatch), so the sale
-- is clean. This module only flips the MobileDB.tapSell flag and makes sure
-- the poll is running (MobileUIBagSwap:EnsurePoll()).
--
-- Why no wrapper: wrapping ContainerFrameItemButton_OnClick — even scoped,
-- even with securecall() pass-through — poisons the session for hold-to-use
-- (after one install/remove cycle, right-clicking a hearthstone/potion
-- taints UseItemByName even with the wrapper removed). The pickup reaction
-- avoids the global entirely, so hold-to-use stays clean all session.

local ADDON = "MobileUI"

MobileUISell = {}

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUISell:Apply()
    -- The pickup poll (owned by bag-swap) is shared by tap=sell, tap=equip
    -- and bag-swap; each reaction checks its own MobileDB flag at pickup
    -- time. Just make sure the poll is running.
    if MobileUIBagSwap and MobileUIBagSwap.EnsurePoll then
        MobileUIBagSwap:EnsurePoll()
    end
end

function MobileUISell:Revert()
    -- Nothing to undo: the poll stays up (cheap) and its sell branch is
    -- gated on MobileDB.tapSell, which Toggle()/options flip.
end

function MobileUISell:Toggle()
    local enabled = not MobileDB.tapSell
    MobileDB.tapSell = enabled
    if enabled then
        self:Apply()
    else
        self:Revert()
    end
    return enabled
end
