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
-- Taint constraint (the reason the wrapper is merchant-scoped): the bag
-- buttons' OnClick runs through this global for EVERY bag click, including
-- plain right-clicks, and right-clicking an item with a "Use:" effect (a
-- hearthstone, potion, food...) calls the protected function
-- UseContainerItem.  If MobileUI code is on that call stack the client
-- reports "AddOn 'MobileUI' tainted the call of the secure function
-- 'UseContainerItem()'".  The sell path itself is never protected (the
-- merchant-open condition wins over the use-effect condition in
-- UseContainerItem's dispatch), so the wrapper is only installed WHILE THE
-- MERCHANT FRAME IS SHOWN.  Outside vending the stock handler runs with no
-- MobileUI code on the stack — no interception, no taint.  The wrapper is
-- installed on MERCHANT_SHOWED and removed on MERCHANT_CLOSED and on combat
-- start (PLAYER_REGEN_DISABLED); if the vendor is still open when combat
-- ends it is reinstalled.  A left tap right as the vendor closes is still
-- guarded by the MerchantFrame:IsShown() check inside the wrapper so it
-- can't turn into a right-click "use item".
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
local eventFrame

-- ============================================================================
-- Wrapper install / remove (merchant-scoped)
-- ============================================================================

local function InstallWrapper()
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
    MobileUI_Debug("Tap=Sell: ContainerFrameItemButton_OnClick wrapped (merchant open)")
end

local function RemoveWrapper()
    if not installed then return end
    ContainerFrameItemButton_OnClick = origClick
    origClick = nil
    installed = false
    MobileUI_Debug("Tap=Sell: ContainerFrameItemButton_OnClick restored")
end

-- The wrapper must only exist while the merchant is open (see header: it
-- would otherwise taint every right-click use of a bag item).  This frame
-- tracks the merchant lifecycle and keeps the wrapper in sync.
local function EnsureEventFrame()
    if eventFrame then return end
    eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("MERCHANT_SHOWED")
    eventFrame:RegisterEvent("MERCHANT_CLOSED")
    eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:SetScript("OnEvent", function(self, event)
        if not MobileDB or not MobileDB.tapSell then return end
        if event == "MERCHANT_SHOWED" then
            InstallWrapper()
        elseif event == "PLAYER_REGEN_ENABLED" then
            -- Vendor can stay open through a fight; re-arm if it did.
            if MerchantFrame and MerchantFrame:IsShown() then
                InstallWrapper()
            end
        else
            -- MERCHANT_CLOSED / PLAYER_REGEN_DISABLED / PLAYER_ENTERING_WORLD
            RemoveWrapper()
        end
    end)
end

-- ============================================================================
-- Apply / Revert / Toggle
-- ============================================================================

function MobileUISell:Apply()
    EnsureEventFrame()
    -- If the vendor is already open (e.g. /mui sell or options toggle while
    -- at the merchant), arm the wrapper now; otherwise MERCHANT_SHOWED will.
    if MerchantFrame and MerchantFrame:IsShown() then
        InstallWrapper()
    end
end

function MobileUISell:Revert()
    RemoveWrapper()
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
