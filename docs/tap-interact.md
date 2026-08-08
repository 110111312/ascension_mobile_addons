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

Both are marked "not customizable in the default UI" (`api/c-a.md`,
`api/t.md`), and there is no CVar/API to swap the physical buttons. But
`TurnOrActionStart/Stop` are plain callable functions, and
`SetOverrideBindingClick()` can rebind a mouse button to simulate a click on
a frame. So:

1. `SetOverrideBindingClick(catcher, false, "BUTTON1", "MobileUIClickCatcher", "LeftButton")`
   rebinds left-click to simulate a click on a hidden 1x1 Button
   (`api/s-e.md` "SetOverrideBindingClick").
2. The binding only fires when the click is **not** consumed by a UI frame —
   normal UI hit-testing wins, so action bars, bags, unit frames, minimap,
   chat bubble etc. keep their normal left-click behavior.
3. The hidden button's `OnMouseDown`/`OnMouseUp` call `TurnOrActionStart()` /
   `TurnOrActionStop()` — the exact pipeline the client uses for right-click
   world interaction. Tap on NPC → talk. Tap on world objective → use it.
   Hold (real mouse) → steer, then interact on release, mirroring right-click.

None of these functions are marked protected in the wowprogramming reference,
but the Ascension client **does** protect `TurnOrActionStart/Stop` — calling
them from a plain (insecure) frame's handler raises
`AddOn 'MobileUI' tainted the call of the secure function 'TurnOrActionStart()'`
and the call is blocked.  The catcher therefore inherits
`SecureHandlerClickTemplate` (FrameXML `SecureHandlers.xml`): scripts on a
secure frame run in secure context, so the protected calls are allowed.  The
override is set at `PLAYER_ENTERING_WORLD` and on toggle.

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

## Revert / disable

`/mui tap` toggles. Disabling calls `ClearOverrideBindings(catcher)`
(`api/c-l.md`), restoring native left-click targeting. Override bindings are
temporary anyway — they never persist across reload/logout, and `Apply()` is
re-run on every `PLAYER_ENTERING_WORLD`.

## Research notes

- `TurnOrActionStart/Stop` — `api/t.md` (TURNORACTION binding, right-click).
- `CameraOrSelectOrMoveStart/Stop` — `api/c-a.md` (CAMERAORSELECTORMOVE
  binding, left-click).
- `SetOverrideBindingClick` / `SetBindingClick` — `api/s-e.md`.
- `ClearOverrideBindings` — `api/c-l.md`.
- `GetMouseButtonClicked` — `api/g-get-m.md` (used to identify the button in
  click handlers; not needed here since the catcher only registers left).
- No `SwapMouseButtons`-style CVar exists in 3.3.5a. A full left/right swap
  (including camera) is not possible from an addon — the OS/Artemis side
  would be the place for that.
