-- MobileUISell.lua - Tap = Sell (Phase 7)
--
-- On Artemis (moonlight fork) a tap sends left-click and a hold sends
-- right-click.  In WoW, right-clicking a bag item while the merchant frame
-- is open sells it; left-clicking picks it up.  This module makes a plain
-- tap on a bag item sell it while a vendor is open, so selling doesn't
-- require a hold.
--
-- Mechanism: wrap the global ContainerFrameItemButton_OnClick.  The bag item
-- buttons wire their OnClick as a string handler in ContainerFrame.xml
-- ("ContainerFrameItemButton_OnClick(self, button)"), so the global is
-- resolved at click time and wrapping it intercepts every bag item click.
-- When the merchant frame is shown, the cursor is empty, and the click is a
-- plain left button, the button is rewritten to "RightButton", which runs
-- the client's own sell path (UseContainerItem with the merchant guards:
-- buyback-tab check, extended-cost confirmation).  Modified clicks never
-- reach us — the XML routes them to ContainerFrameItemButton_OnModifiedClick.
--
-- What is preserved: buying (cursor holds a merchant item -> tap a bag slot
-- still completes the purchase), item swapping (cursor holds a bag item),
-- money drops, guild-bank withdrawals, and spell-targeting
-- (SpellCanTargetItem).  Only the empty-cursor tap becomes sell.
--
-- Trade-off: while a vendor is open, bag items can no longer be picked up by
-- tap or hold (both sell).  Close the merchant to rearrange bags.

local ADDON = "MobileUI"

MobileUISell = {}

local installed = false
local origClick

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUISell:Apply()
    if installed then return end
    origClick = ContainerFrameItemButton_OnClick
    ContainerFrameItemButton_OnClick = function(self, button)
        if ( button == "LeftButton" and MerchantFrame and MerchantFrame:IsShown() ) then
            local cursorType = GetCursorInfo()
            if ( not cursorType and not SpellCanTargetItem() ) then
                -- Empty cursor + vendor open + plain tap: sell instead of pick up
                button = "RightButton"
            end
        end
        origClick(self, button)
    end
    installed = true
    MobileUI_Debug("Tap=Sell: ContainerFrameItemButton_OnClick wrapped")
end

function MobileUISell:Revert()
    if not installed then return end
    ContainerFrameItemButton_OnClick = origClick
    origClick = nil
    installed = false
    MobileUI_Debug("Tap=Sell: ContainerFrameItemButton_OnClick restored")
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
