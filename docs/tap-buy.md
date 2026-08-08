# Tap = Buy

Buy items from a vendor with a single tap.

## Why

On Artemis (moonlight fork) a **tap** sends left-click and a **hold** sends
right-click. In WoW, left-clicking a merchant item picks it up to the cursor
— you then tap a bag slot to complete the purchase (a two-step buy) — while
right-clicking buys one item directly. This feature makes a plain tap on a
merchant item buy it directly.

## Mechanism

The merchant item buttons wire their `OnClick` as a **string** handler in
`MerchantFrame.xml`:

```xml
<OnClick>
    if ( IsModifiedClick() ) then
        MerchantItemButton_OnModifiedClick(self, button);
    else
        MerchantItemButton_OnClick(self, button);
    end
</OnClick>
```

Because the handler is a string, the global `MerchantItemButton_OnClick` is
resolved at click time — so wrapping the global intercepts every merchant
item click:

```lua
origClick = MerchantItemButton_OnClick
MerchantItemButton_OnClick = function(self, button)
    if ( button == "LeftButton" and MerchantFrame and MerchantFrame:IsShown()
         and MerchantFrame.selectedTab == 1 ) then
        local cursorType = GetCursorInfo()
        if ( not cursorType ) then
            button = "RightButton"   -- empty cursor + merchant tab: buy one
        end
    end
    origClick(self, button)
end
```

Rewriting the button to `"RightButton"` runs the client's own buy path
(`BuyMerchantItem` with the cost guards: extended-cost and high-price
confirmations). No protected functions are called.

## What is preserved

The conversion only fires when **all** of these hold:

- merchant frame is shown on the merchant tab (`selectedTab == 1`)
- the click is a plain left button (modified clicks — shift/ctrl/alt — are
  routed to `MerchantItemButton_OnModifiedClick` by the XML and never reach
  the wrapper; **shift-tap still opens the quantity picker** for buying
  stacks)
- the cursor is empty (`GetCursorInfo()` returns nil)

So dragging anything onto a merchant item still works, and the buyback tab
is untouched (left click there already buys back).

## Trade-off

The two-step buy (pick up a merchant item, then drop it on a bag slot) is
replaced by direct buy-on-tap. Tap repeatedly to buy multiple; shift-tap for
a specific quantity.

## Controls

- Default: **on**
- Toggle: `/mui buy`
- Interface Options → MobileUI → "Tap = Buy (tap a merchant item to buy it
  directly)"
- Saved var: `MobileDB.tapBuy`

## Files

- `MobileUIBuy.lua` — the module (Apply/Revert/Toggle)
- `MobileUI.lua` — default, dispatch, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
