# Tap = Interact — left click acts like right click on the world

Feature: `MobileUIClick.lua` (Phase 6). Toggle: `/mui tap` or Interface Options →
MobileUI → "Tap = Interact". Default: **on**.

## Why

Playing through Artemis (moonlight fork) with multi-touch: a **tap** sends
left-click, a **hold** sends right-click. In WoW, right-click is the
workhorse for world interaction — talk to an NPC, use a quest/world object —
while left-click only targets. On a phone, tap is the natural gesture, so we
make tap do the right-click interaction.

## How it works

World clicks are client bindings, not addon-accessible frame handlers:

| Physical button | Binding | Behavior |
|---|---|---|
| Left (BUTTON1) | `CAMERAORSELECTORMOVE` → `CameraOrSelectOrMoveStart/Stop` | hold = rotate camera, release = select target |
| Right (BUTTON2) | `TURNORACTION` → `TurnOrActionStart/Stop` | hold = steer, release = interact (talk/loot/attack/use) |

Both are marked `hidden="true"` in `Bindings.xml` ("not customizable in the
default UI"), and there is no CVar/API to swap the physical buttons.  But the
binding system itself can be overridden, and `TURNORACTION` is a real binding
command (`Bindings.xml:1276`, `runOnUp="true"`).  So:

1. `SetOverrideBinding(owner, false, "BUTTON1", "TURNORACTION")` rebinds
   left-click to the right-click world interaction command
   (`api/s-e.md` "SetOverrideBinding").
2. The client executes the binding natively: `TurnOrActionStart()` on press,
   `TurnOrActionStop()` on release — in **secure context**, so no Lua call
   from addon code and no taint.
3. The binding only fires when the click is **not** consumed by a UI frame —
   normal UI hit-testing wins, so action bars, bags, unit frames, minimap,
   chat bubble etc. keep their normal left-click behavior.

### Why not call TurnOrActionStart() from a frame handler?

The Ascension client **protects** `TurnOrActionStart/Stop` (the
wowprogramming reference doesn't flag them, but the client raises
`AddOn 'MobileUI' tainted the call of the secure function 'TurnOrActionStart()'`
and blocks the call).  Attempted workarounds that did **not** work in this
client:

- `SecureHandlerClickTemplate` frame with `OnMouseDown`/`OnMouseUp` — still
  tainted.
- Secure `_onclick` attribute snippets — the restricted environment
  (`RestrictedEnvironment.lua`) does not expose `TurnOrActionStart`.
- `securecall()` — only helps when called from *within* a secure
  environment (`api/s-e.md` "securecall"), not from tainted addon code.

Rebinding the button to the native binding command sidesteps all of it.
The override is set at `PLAYER_ENTERING_WORLD` and on toggle.

## What changes / what doesn't

- **Tap on NPC** → talks to it (was: just target it).
- **Tap on world objective** → uses it (was: nothing).
- **Tap on a unit** → interacts/attacks it and targets it (right-click
  behavior; right-click already targets as a side effect).
- **Tap on empty ground** → nothing (left-click deselect is gone — intended
  trade-off).
- **Left-click hold** (real mouse) → steers the character like right-click
  hold.
- **UI frames are untouched** — left click on buttons/bags/minimap still does
  its normal thing because hit-testing beats the binding.
- **Right-click (BUTTON2) is untouched** — hold on Artemis still sends
  right-click and behaves natively.

## Dropping items from the cursor

Stock WoW lets you remove an item from your bags by picking it up and
clicking the world — the item is dropped (destroyed). The BUTTON1 override
would swallow that world-click: the `TURNORACTION` binding fires instead,
the pickup is cancelled, and the item silently returns to its bag slot
(no drop, no confirmation — stock never confirms a ground drop).

Fix: the pickup poll in `MobileUIBagSwap.lua` tracks the cursor and calls
`MobileUIClick:SetCursorHolding(holding)` on holding-state changes:

- **Cursor holds an item** → `ClearOverrideBindings(owner)` — the stock
  left-click world behavior returns, so a tap on the ground drops the item.
- **Cursor empties** → `SetOverrideBinding(owner, false, "BUTTON1",
  "TURNORACTION")` re-applies tap=interact.

The override is only ever cleared while an item is actually on the cursor
(UI-frame clicks are unaffected either way — hit-testing beats the
binding), and it is re-applied the moment the cursor empties, including
when a sell/equip/swap reaction empties it within the same frame.

## Revert / disable

`/mui tap` toggles. Disabling calls `ClearOverrideBindings(owner)`
(`api/c-l.md`), restoring native left-click targeting. Override bindings are
temporary anyway — they never persist across reload/logout, and `Apply()` is
re-run on every `PLAYER_ENTERING_WORLD`.

## Research notes

- `TurnOrActionStart/Stop` — `api/t.md` (TURNORACTION binding, right-click).
- `CameraOrSelectOrMoveStart/Stop` — `api/c-a.md` (CAMERAORSELECTORMOVE
  binding, left-click).
- `SetOverrideBinding` / `SetOverrideBindingClick` / `SetBindingClick` —
  `api/s-e.md`.
- `ClearOverrideBindings` — `api/c-l.md`.
- `Bindings.xml` (FrameXML mirror) — `TURNORACTION` at line 1276,
  `CAMERAORSELECTORMOVE` at line 1283, both `hidden="true"` `runOnUp="true"`.
- `SecureHandlerTemplates.xml` / `SecureHandlers.lua` /
  `RestrictedEnvironment.lua` (FrameXML mirror) — why the secure-frame and
  `_onclick`-snippet routes can't call `TurnOrActionStart`.
- No `SwapMouseButtons`-style CVar exists in 3.3.5a. A full left/right swap
  (including camera) is not possible from an addon — the OS/Artemis side
  would be the place for that.
