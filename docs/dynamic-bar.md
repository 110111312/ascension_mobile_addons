# Dynamic Action Bar (bottom-left strip)

A mobile "totem-style" bar in the empty strip between the bag button and the
player health/mana frame. **Tap = use, hold = assign.**

Feature: `MobileUIDynamicBar.lua` (v2.9.0). Toggle: `/mui dynamicbar` or
Interface Options → MobileUI → "Dynamic Action Bar". Default: **on** (only
visible while the layout is enabled).

## Why slots, not proxies

The tap-to-use path in this client is taint-protected: addon code calling
`UseContainerItem`/`UseItemByName` on the item's bag slot is blocked
(`docs/tap-use.md`). The clean path is a **real user click on a stock action
button** — the button resolves its slot and the client's own
`ActionButton_OnClick` → `UseAction(slot)` runs with zero addon code on the
stack.

So the bar assigns the chosen item/spell to a **real action slot** (66–70,
via the parked `MultiBarBottomLeftButton6–10`) using the drag-simulation
APIs (`PickupContainerItem`/`PickupSpell` + `PlaceAction` — none on the
protected list), and the tap is a plain stock action-button click. No
secure-button experiments, no OnEvent clearing, no attribute games: the
client renders icon / cooldown / stack count / usable tint natively.

## Layout

- The strip is **measured at apply time** (`MobileUIBagButton` right edge →
  `PlayerFrame` left edge), so the button count adapts to the actual empty
  space: 5 buttons when it fits, then 4, then 3 (shrinking button size if
  needed). Anchored at the bag button's bottom, 8px after it.
- Buttons 6–10 stay **children of `MultiBarBottomLeft`** (never reparented —
  slot resolution comes from the attached bar → slots 66–70, the same
  discipline as the scatter arc). `showgrid=1` keeps empty slots visible.
- The layout guard's per-frame `HideBar2Tail` **skips** buttons owned by the
  dynamic bar (`MobileUIDynamicBar.TailUsed(i)`), so the strip stays visible
  through the combat re-show; the rest of the tail (11–12) stays parked
  off-screen as before.

## Gestures

| Gesture | What happens |
|---|---|
| **Tap** (left click) | Stock action-button click → `UseAction(slot)` — uses the item / casts the spell. Taint-clean. |
| **Hold** (right click) | An `OnMouseDown` script on the stock button (installed the same way the layout installs `OnEnter` on the arc buttons) opens the picker on right-**down** — works for empty and filled slots. |
| **Tap an entry** | Assigns it to the held button's slot via pickup+`PlaceAction`, closes the picker. Gated out of combat. |
| **Tap outside** | Dismisses the picker (full-screen catcher, same pattern as the bag-swap menu). |

The stock right-click **up** still fires `ActionButton_OnClick` → `PickupAction(slot)`, which puts the slot's item on the cursor. `ClosePicker` (on dismiss) and `AssignEntry` (before assigning) re-place it via `PlaceAction`, so nothing is lost or left dangling on the cursor.

### Why no overlay/catcher over the buttons

A `Button` with `RegisterForClicks("RightButtonDown", ...)` received **no mouse events at all** on this client (verified in-game via the debug ring: no `catcher down` line while the strip applied fine), and a plain mouse-enabled `Frame` overlay would also eat left taps (no click pass-through on this client). A direct `OnMouseDown` script on the stock button is the minimal proven mechanic: the layout already installs scripts on the arc buttons this way and casting stays clean. The left-click use path is untouched.

## Picker content

- **Usable bag items** — any item with a "Use:" effect (`GetItemSpell(link)
  ~= nil`), deduped by item ID, showing icon + stack count.
- **Buff spells** — known, non-passive spells (`IsPassiveSpell` filter);
  spells currently active on the player (`UnitBuff`) sort to the top.
  3.3.5 has no "is this a buff" flag, so this is a pragmatic filter — v1
  lists all non-passive spells with active buffs first.
- Grid: 4×3 (12 per page), page `<`/`>` controls, clamped to screen, anchored
  above the held button.

Spells assign as plain spell slots: clicking casts at the current target
(stock behavior). Target-required buffs (Blessing-type) need a target or an
`@player` macro — same limitation as the default UI; no-target self-buffs
just work.

## Persistence / revert

Assignments live in the **client's action-bar save data** (slots 66–70), so
they survive reload/logout for free. Revert (`/mui dynamicbar off` or layout
revert) re-parks the strip buttons off-screen exactly as the layout left the
tail, but **leaves the slot contents in place** — they are the player's own
action slots (the layout revert also restores the tail's original anchors and
shown state from `saved.bar2tail`).

## Taint safety

- Assign path: `PickupContainerItem` (proven clean — bag-swap),
  `PickupSpell`/`PickupSpellBookItem`, `PlaceAction` (not on the protected
  list in the reference). Assignment is gated on `not InCombatLockdown()`.
- Use path: stock `ActionButton_OnClick` → `UseAction` — the button's OnClick
  is never swapped, the button is never field-written. The only addon script
  on it is `OnMouseDown` (opens the picker; no protected calls), which runs
  on the down event and is not on the stack of the later left-up
  `UseAction`. Same path every arc spell cast uses.
- The picker and its dismiss catcher are addon-created plain frames; they
  never call protected functions.
- Replacing an assignment: `PlaceAction` *exchanges*, so the previous slot
  content lands on the cursor — items are returned to a free bag slot
  (`ReturnCursorContent`), anything else is dropped. No lost items.

## Controls

- Default: **on**
- Toggle: `/mui dynamicbar`
- Interface Options → MobileUI → "Dynamic Action Bar (tap = use, hold =
  assign items/buffs)"
- Saved var: `MobileDB.dynamicBar`

## In-game verification checklist (first session)

These are the assumptions this client hasn't been tested against yet:

1. **The `OnMouseDown` script on the stock button doesn't taint the tap path**
   — assign a hearthstone to a strip button, tap it, and confirm no
   `'UseAction()'` taint error appears in the debug ring (`/mui debug`,
   "slot N now type=item id=…").
2. **`PickupContainerItem` → `PlaceAction` assigns cleanly** — the
   `GetActionInfo` debug line confirms the slot write.
3. **Spell pickup name** — the log line shows which of
   `PickupSpellBookItem`/`PickupSpell` ran; verify a buff spell assigns and
   casts.
4. **Slot mapping 6–10 → 66–70** — confirmed by the `GetActionInfo` debug
   line.
5. **No dangling cursor item on dismiss** — hold a filled button, dismiss
   the picker, and the slot's item should stay in the slot (re-placed).

The debug ring (`MobileUIDebugLog` SavedVariable, on disk after `/reload`
or logout) is the source of truth — no chat prints.

## Files

- `MobileUIDynamicBar.lua` — the module (strip + catchers + picker +
  assignment)
- `MobileUILayout.lua` — guard skip (`HideBar2Tail`), apply step, revert hook
- `MobileUI.lua` — default, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
