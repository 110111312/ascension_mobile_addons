# Bag Swap Menu

Swap a bag into a chosen bag slot with a hold gesture.

## Why

Stock right-click on a bag item only equips it into a **free** bag slot — and
in this client it fails with "This item cannot be equipped" even when a free
slot exists (verified in-game: the wrapper logged `blocked=false` — free
space present — and stock still errored). The mobile layout also hides the
bags bar, so there is no per-slot button to drag the bag onto either. The
player can never replace an old small bag with a new bigger one.

## Mechanism

The bag item buttons wire their `OnClick` as a **string** handler in
`ContainerFrame.xml`, so replacing the global
`ContainerFrameItemButton_OnClick` intercepts every bag click (same mechanism
as tap=sell). On a **right-button** click (Artemis hold gesture) of a bag
item:

1. With exactly **one** empty bag slot the swap runs immediately — no menu
   (the choice is unambiguous). Otherwise a small menu lists the empty bag
   slots / empty slots, each with the current bag's name, size and free
   slots (`GetBagName`, `GetContainerNumSlots`, `GetContainerNumFreeSlots`),
   or "Empty bag slot".
2. Tapping a slot runs the swap: `PickupContainerItem(container, slot)` puts
   the held bag on the cursor, then
   `PickupInventoryItem(ContainerIDToInventoryID(n))` **exchanges** it into
   the chosen bag slot — the API documents that when both sides are occupied
   the contents are exchanged, so the new bag goes into the slot and the old
   equipped bag lands on the cursor. (`PickupBagFromSlot` was tried first
   and does NOT exchange in this client — it only picks up the equipped bag
   and drops the cursor item back — so `PickupInventoryItem` is used.)
3. The old bag is **auto-placed** back into the slot the new bag came from,
   so the swap completes without any invisible cursor juggling (the cursor
   isn't visible on mobile).

The menu is anchored next to the held item and clamped to screen; a
full-screen catcher behind it dismisses it on any outside tap.

Bag detection: 3.3.5's `GetItemInfo` returns `class` as a **localized
string** ("Container"), not a numeric id, so the check accepts the string,
the numeric id, and the locale-independent `equipSlot` token
("INVTYPE_BAG") as three independent signals.

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
the mobile column (via `MobileUILayout.RepositionContainerFrames()`) plus
re-opens the swapped slot's window if it was open at swap time — all before
anything renders, so there is no visible flicker. A single late snap (~1.2s)
backstops anything that happens outside a `BAG_UPDATE`.

## Trigger scope

We **always** own the hold-of-bag gesture — stock right-click never equips
bags in this client, so there is no fast path to preserve. (Originally the
menu was gated to "all slots full" to keep a free-slot fast path; in-game
testing showed that path errors anyway, so the gate was removed.)

- **At a merchant** → we defer entirely; tap=sell keeps owning bag clicks
  (hold still sells, per its docs). Close the merchant to swap bags.

## Taint safety

The stock handler can reach the protected `UseContainerItem` (right-click
"Use:" items — hearthstone, potions…). Every pass-through therefore runs
through `securecall()` in a clean protected stack, so MobileUI code never
sits on the protected call. The wrapper is installed once per session and
kept; disabling the feature only turns interception off, which keeps it
robust against tap=sell wrapping/unwrapping the same global on merchant
open/close.

## Controls

- Default: **on**
- Toggle: `/mui bagswap`
- Interface Options → MobileUI → "Bag Swap Menu (hold a bag to pick its slot)"
- Saved var: `MobileDB.bagSwap`

## Files

- `MobileUIBagSwap.lua` — the module (Apply/Revert/Toggle + menu)
- `MobileUI.lua` — default, dispatch, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
