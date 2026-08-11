# Tap = Sell

Sell items to a vendor with a tap instead of a hold.

## Why

On Artemis (moonlight fork) a **tap** sends left-click and a **hold** sends
right-click. In WoW, right-clicking a bag item while the merchant frame is
open sells it; left-clicking picks it up. So selling required a hold — the
slowest gesture on a phone. This feature makes a plain tap on a bag item
sell it while a vendor is open.

## Mechanism (pickup-reaction — no click wrapper)

We never touch `ContainerFrameItemButton_OnClick` (see "Why no wrapper"
below). A tap does its stock thing — it **picks the item up** — and a
per-frame poll in `MobileUIBagSwap` watches the cursor:

1. On an **empty-cursor → item** transition the poll reads `GetMouseFocus()`:
   if the pickup came from a container slot (frame name
   `ContainerFrame<N>Item<M>`), it extracts container/slot and the item
   link.
2. With the vendor open and `MobileDB.tapSell` on, it runs
   `PickupContainerItem(container, slot)` (returns the item to its slot)
   then `UseContainerItem(container, slot)` — the **sell path**
   (merchant-open wins the dispatch), which is NOT protected in this client,
   so the sale is clean. Both calls land in the same frame, so the item
   never visibly leaves its slot.

This is the same sell path a stock hold triggers (`UseContainerItem` with
the merchant guards: buyback-tab check, extended-cost confirmation).

## Why no wrapper

Wrapping the global — even scoped, even with `securecall()` pass-through —
**poisons the session for hold-to-use**: in-game testing showed a fresh
session right-clicks a hearthstone fine, but after ONE wrapper install/
remove cycle the same hold errors `AddOn 'MobileUI' tainted the call of the
secure function 'UseItemByName()'` even with the wrapper removed. The pickup
reaction never touches the global, so hold-to-use stays clean all session.

Tap=sell originally wrapped the global itself (merchant-scoped); when
bag-swap started wrapping the same global the nesting broke and right-click
"Use:" items tainted. All of that is gone — there is no wrapper to nest.

## What is preserved

The sell conversion only fires when **all** of these hold:

- merchant frame is shown
- the pickup came from a container item button (focus-based detection)
- `MobileDB.tapSell` is on

So these still work normally while a vendor is open:

- **Buying** — tap a merchant item (cursor holds it), then tap a bag slot
  to complete the purchase
- **Placing / swapping** — a tap with an item already on the cursor
  places/exchanges (the cursor is not empty, so no pickup transition and no
  sell reaction)
- **Spell targeting** — a spell waiting for an item target: the stock
  handler targets the item (no pickup happens, so no reaction)
- **Moving items** — pick an item up and place it wherever you want; only
  while the vendor is open does a pickup become a sale

## Trade-off

While a vendor is open, bag items can no longer be picked up by tap — the
pickup is converted to a sale. Close the merchant to rearrange bags. (Holds
still sell too, stock.)

## Controls

- Default: **on**
- Toggle: `/mui sell`
- Interface Options → MobileUI → "Tap = Sell (tap a bag item to sell while
  a vendor is open)"
- Saved var: `MobileDB.tapSell`

## Files

- `MobileUISell.lua` — flag + poll delegation (Apply/Revert/Toggle)
- `MobileUIBagSwap.lua` — the pickup poll; the sell reaction lives here
- `MobileUI.lua` — default, dispatch, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
