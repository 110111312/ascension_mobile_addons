# Bag Swap Menu

Swap a bag into a chosen bag slot with a tap.

## Why

Stock right-click on a bag item only equips it into a **free** bag slot — and
in this client it fails with "This item cannot be equipped" even when a free
slot exists (verified in-game: the old wrapper logged `blocked=false` — free
space present — and stock still errored). The mobile layout also hides the
bags bar, so there is no per-slot button to drag the bag onto either. The
player can never replace an old small bag with a new bigger one.

## Mechanism (pickup-reaction — no click wrapper)

We never touch `ContainerFrameItemButton_OnClick` (see "Taint safety"
below). A tap on a bag does its stock thing — it **picks the bag up** — and
a per-frame poll in this module watches the cursor:

1. On an **empty-cursor → item** transition the poll reads `GetMouseFocus()`:
   if the pickup came from a container slot (frame name
   `ContainerFrame<N>Item<M>`), it extracts container/slot and the item
   link. If the item is a bag (`IsBag`: localized class `"Container"`, the
   numeric id 1, or the locale-independent `equipSlot` token
   `"INVTYPE_BAG"` — 3.3.5's `GetItemInfo` returns class as a localized
   string, not a number, so all three signals are accepted), the bag-swap
   reaction fires.
2. With exactly **one** empty bag slot the swap runs immediately — no menu
   (the choice is unambiguous). Otherwise a small menu lists the empty bag
   slots / empty slots, each with the current bag's name, size and free
   slots (`GetBagName`, `GetContainerNumSlots`, `GetContainerNumFreeSlots`),
   or "Empty bag slot".
3. Tapping a slot runs the swap. The new bag is **already on the cursor**
   (the stock tap picked it up), so it's just the exchange:
   `PickupInventoryItem(ContainerIDToInventoryID(n))` — the API documents
   that when both sides are occupied the contents are exchanged, so the new
   bag goes into the slot and the old equipped bag lands on the cursor.
   (`PickupBagFromSlot` was tried first and does NOT exchange in this
   client — it only picks up the equipped bag and drops the cursor item
   back — so `PickupInventoryItem` is used.)
4. The old bag is **auto-placed** back into the slot the new bag came from,
   so the swap completes without any invisible cursor juggling (the cursor
   isn't visible on mobile).

The menu is anchored next to the held item and clamped to screen; a
full-screen catcher behind it dismisses it on any outside tap.

**Client restriction:** this client refuses to swap a bag that has items in
it ("can't swap bags with items in it") — unlike stock WoW, where the old
bag goes to the cursor with its contents. So the menu lists **only empty
bags and empty slots** as targets; non-empty bags are hidden entirely. If no
bag is empty, the menu shows a "No empty bag slots" notice. Empty the old
bag first, then swap.

**Frame re-layout:** the client re-lays the container frames out (and closes
the swapped slot's window) on `BAG_UPDATE` events after a swap. The module
registers its own `BAG_UPDATE` handler *after* the client's frames, so it
runs after their re-layout in the same event pass and re-pins the frames to
the mobile column (via `MobileUIFrames.RepositionContainerFrames()`, also
aliased as `MobileUILayout.RepositionContainerFrames()` for backward compat) plus
re-opens the swapped slot's window if it was open at swap time — all before
anything renders, so there is no visible flicker. A single late snap (~1.2s)
backstops anything that happens outside a `BAG_UPDATE`.

## Trigger scope

There is no wrapper and no install scope — the poll runs whenever any of
bag-swap / tap=equip / tap=sell is enabled and reacts to **every**
container-item pickup. What happens per pickup:

- **At a merchant** → tap=sell wins (a tap on the bag sells it); close the
  merchant to swap bags.
- **Not at a merchant, bag picked up** → swap menu / direct swap (above).
- **Not at a merchant, equippable picked up** → tap=equip reaction (see
  `docs/tap-equip.md`).
- **Anything else** → nothing; the item stays on the cursor (stock).

A **hold** (right-click) on a bag is not intercepted — it runs the stock
handler, which shows the "This item cannot be equipped" message. Tap is the
bag gesture.

## Taint safety

The stock container-item handler can reach the protected `UseContainerItem`
(right-click "Use:" items — hearthstone, potions…). In-game testing proved
that **any** wrapper install/remove cycle on `ContainerFrameItemButton_OnClick`
poisons the session: a fresh session holds a hearthstone fine, but after one
wrapper cycle the same hold errors `AddOn 'MobileUI' tainted the call of the
secure function 'UseItemByName()'` even with the wrapper removed
(`securecall()` does not help — it is "meaningless when called from outside
of the secure environment"). So this module never touches the global — the
stock handler stays pristine, and hold-to-use stays clean all session.

The pickup reaction itself only calls APIs that are clean in this client:
`PickupContainerItem` (not taint-checked), `PickupInventoryItem` (the swap
exchange), and `UseContainerItem` on the **sell** and **equip** paths only
(merchant-open wins the sell dispatch; the equip path is not taint-checked).
The **use** path is never called. The item-use mechanism is built
separately (see `docs/tap-use.md`).

## Controls

- Default: **on**
- Toggle: `/mui bagswap`
- Interface Options → MobileUI → "Bag Swap Menu (tap a bag to pick its
  slot)"
- Saved var: `MobileDB.bagSwap`

## Files

- `MobileUIBagSwap.lua` — the module (pickup poll + menu + swap)
- `MobileUI.lua` — default, dispatch, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
