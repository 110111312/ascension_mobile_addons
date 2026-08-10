# Tap = Sell

Sell items to a vendor with a tap instead of a hold.

## Why

On Artemis (moonlight fork) a **tap** sends left-click and a **hold** sends
right-click. In WoW, right-clicking a bag item while the merchant frame is
open sells it; left-clicking picks it up. So selling required a hold — the
slowest gesture on a phone. This feature makes a plain tap on a bag item
sell it while a vendor is open.

## Mechanism

The bag item buttons wire their `OnClick` as a **string** handler in
`ContainerFrame.xml`:

```xml
<OnClick>
    ...
    ContainerFrameItemButton_OnClick(self, button);
</OnClick>
```

Because the handler is a string, the global `ContainerFrameItemButton_OnClick`
is resolved at click time — so wrapping the global intercepts every bag item
click:

```lua
local function InstallWrapper()
    origClick = ContainerFrameItemButton_OnClick
    ContainerFrameItemButton_OnClick = function(self, button)
        if ( button == "LeftButton" and MerchantFrame and MerchantFrame:IsShown() ) then
            local cursorType = GetCursorInfo()
            if ( not cursorType and not SpellCanTargetItem() ) then
                button = "RightButton"   -- empty cursor + vendor open: sell
            end
        end
        origClick(self, button)
    end
end
```

Rewriting the button to `"RightButton"` runs the client's own sell path
(`UseContainerItem` with the merchant guards: buyback-tab check,
extended-cost confirmation). No protected functions are called — the sell
path is the same code the user already triggers with a hold.

## Why the wrapper is only installed while the vendor is open

The bag buttons' OnClick string runs through this global for **every** bag
click — including plain right-clicks. Right-clicking an item with a "Use:"
effect (hearthstone, potion, food…) calls `UseContainerItem` in its
**protected** mode (per `api/u.md`: protected only when it activates a "Use:"
effect). If MobileUI code is on that call stack, the client reports

```
AddOn 'MobileUI' tainted the call of the secure function 'UseContainerItem()'
```

The sell path itself is never protected — in `UseContainerItem`'s dispatch
the merchant-open condition wins over the use-effect condition — so the
wrapper is installed **only while `MerchantFrame` is shown**:

- `MERCHANT_SHOWED` → install the wrapper
- `MERCHANT_CLOSED` / `PLAYER_REGEN_DISABLED` (combat) → remove it
- `PLAYER_REGEN_ENABLED` → reinstall if the vendor is still open

Outside vending the stock handler runs with no MobileUI code on the stack:
no interception, no taint. The `MerchantFrame:IsShown()` guard also stays
inside the wrapper so a left tap landing right as the vendor closes cannot
be rewritten into a right-click "use item".

## What is preserved

The conversion only fires when **all** of these hold:

- merchant frame is shown
- the click is a plain left button (modified clicks — shift/ctrl/alt — are
  routed to `ContainerFrameItemButton_OnModifiedClick` by the XML and never
  reach the wrapper)
- the cursor is empty (`GetCursorInfo()` returns nil)
- no spell is waiting for an item target (`SpellCanTargetItem()`)

So these still work normally while a vendor is open:

- **Buying** — tap a merchant item (cursor holds it), then tap a bag slot
  to complete the purchase
- **Item swapping** — cursor holds a bag item, tap another slot to swap
- **Money drops / guild-bank withdrawals** — cursor holds money
- **Spell targeting** — a spell waiting for an item target

## Trade-off

While a vendor is open, bag items can no longer be picked up by tap **or**
hold (both sell). Close the merchant to rearrange bags.

## Controls

- Default: **on**
- Toggle: `/mui sell`
- Interface Options → MobileUI → "Tap = Sell (tap a bag item to sell while
  a vendor is open)"
- Saved var: `MobileDB.tapSell`

## Files

- `MobileUISell.lua` — the module (Apply/Revert/Toggle)
- `MobileUI.lua` — default, dispatch, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
