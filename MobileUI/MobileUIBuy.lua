-- MobileUIBuy.lua - Tap = Buy (Phase 8)
--
-- On Artemis (moonlight fork) a tap sends left-click and a hold sends
-- right-click.  In WoW, left-clicking a merchant item picks it up to the
-- cursor (then you tap a bag slot to complete the purchase — a two-step
-- buy), while right-clicking buys one item directly.  This module makes a
-- plain tap on a merchant item buy it directly, so buying doesn't require
-- the two-step pickup-and-drop.
--
-- Mechanism: wrap the global MerchantItemButton_OnClick.  The merchant item
-- buttons wire their OnClick as a string handler in MerchantFrame.xml
-- ("MerchantItemButton_OnClick(self, button)"), so the global is resolved at
-- click time and wrapping it intercepts every merchant item click.  When the
-- merchant frame is shown on the merchant tab (selectedTab == 1), the cursor
-- is empty, and the click is a plain left button, the button is rewritten to
-- "RightButton", which runs the client's own buy path (BuyMerchantItem with
-- the cost guards: extended-cost and high-price confirmations).  Modified
-- clicks never reach us — the XML routes them to
-- MerchantItemButton_OnModifiedClick (shift-tap still opens the quantity
-- picker for buying stacks).
--
-- What is preserved: dragging anything onto a merchant item (cursor not
-- empty), and the buyback tab (left click there already buys back — no
-- conversion needed).
--
-- Trade-off: the two-step buy (pick up a merchant item, then drop it on a
-- bag slot) is replaced by direct buy-on-tap.  Tap repeatedly to buy
-- multiple; shift-tap for a specific quantity.

local ADDON = "MobileUI"

MobileUIBuy = {}

local installed = false
local origClick

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUIBuy:Apply()
    if installed then return end
    origClick = MerchantItemButton_OnClick
    MerchantItemButton_OnClick = function(self, button)
        if ( button == "LeftButton" and MerchantFrame and MerchantFrame:IsShown()
             and MerchantFrame.selectedTab == 1 ) then
            local cursorType = GetCursorInfo()
            if ( not cursorType ) then
                -- Empty cursor + merchant tab + plain tap: buy one instead of picking up
                button = "RightButton"
            end
        end
        origClick(self, button)
    end
    installed = true
    MobileUI_Debug("Tap=Buy: MerchantItemButton_OnClick wrapped")
end

function MobileUIBuy:Revert()
    if not installed then return end
    MerchantItemButton_OnClick = origClick
    origClick = nil
    installed = false
    MobileUI_Debug("Tap=Buy: MerchantItemButton_OnClick restored")
end

function MobileUIBuy:Toggle()
    local enabled = not MobileDB.tapBuy
    MobileDB.tapBuy = enabled
    if enabled then
        self:Apply()
    else
        self:Revert()
    end
    return enabled
end
