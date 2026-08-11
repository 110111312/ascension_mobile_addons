# Tap = Equip

Equip armor/weapons out of combat with a tap instead of a hold.

## Why

On Artemis (moonlight fork) a **tap** sends left-click and a **hold** sends
right-click. Right-click equips an equippable item — but the hold gesture is
slow on a phone, and tap (left-click) normally just picks the item up. This
feature makes a plain tap on an equippable item equip it, taint-free.

## Mechanism (pickup-reaction — no click wrapper)

We never touch `ContainerFrameItemButton_OnClick` (see "Taint safety").
A tap on an item does its stock thing — it **picks the item up** — and a
per-frame poll in `MobileUIBagSwap` watches the cursor:

1. On an **empty-cursor → item** transition the poll reads `GetMouseFocus()`:
   if the pickup came from a container slot (frame name
   `ContainerFrame<N>Item<M>`), it extracts container/slot and the item
   link.
2. If the item is equippable (`IsEquippable`: `GetItemInfo`'s `equipSlot`
   exists, is non-empty, and is not `"INVTYPE_BAG"` — bags belong to the
   bag-swap branch), `MobileDB.tapEquip` is on, and the player is **out of
   combat**, the poll runs `PickupContainerItem(container, slot)` (returns
   the item to its slot) then `UseContainerItem(container, slot)` — the
   **equip path**, which is NOT taint-checked in this client, so the equip
   is clean. Both calls land in the same frame, so the item never visibly
   leaves its slot.

Equipping **in combat is protected**, so the reaction is gated on
`not InCombatLockdown()` — in combat a tap falls through to pick-up (the
item stays on the cursor, stock behavior).

## What is preserved

- **Holds** on equippable items still equip — stock right-click, never
  intercepted.
- **Moving items** — with tap=equip **off** (`/mui equiptap off`), a tap
  picks the item up like stock; hold equips. With it on, to move an
  equippable item you must toggle it off (the tap is otherwise consumed by
  equip).
- **Selling** — at a vendor, taps sell (tap=sell; the merchant branch runs
  first). Holds at a vendor sell too.
- **Bag swap** — bags are excluded from `IsEquippable` and handled by the
  bag-swap branch.

## Taint safety

See `docs/bag-swap.md` for the full reasoning: any wrapper install/remove
cycle on `ContainerFrameItemButton_OnClick` poisons the session for
hold-to-use, so this module never touches the global. The equip reaction
calls only clean APIs — `PickupContainerItem` and `UseContainerItem`'s
equip path, which is not taint-checked in this client.

## Controls

- Default: **on**
- Toggle: `/mui equiptap`
- Interface Options → MobileUI → "Tap = Equip (tap armor/weapons to equip
  them out of combat)"
- Saved var: `MobileDB.tapEquip`

## Files

- `MobileUIBagSwap.lua` — `IsEquippable` + the equip reaction in the pickup
  poll
- `MobileUI.lua` — default, dispatch, slash command, options handler
- `MobileUIOptions.xml` — checkbox
