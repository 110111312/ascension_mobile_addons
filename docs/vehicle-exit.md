# Exit Vehicle Button — Right of the Player Frame (P1)

Feature: `MobileUIFrames.lua` (`ApplyVehicleExitButton` / `RevertVehicleExitButton` /
`AnchorVehicleExitButton`). Repositions the stock "Leave Vehicle" button
(`MainMenuBarVehicleLeaveButton`) from its stock home on the parked-off-screen
`MainMenuBar` to a thumb-reachable spot just right of the mobile player frame.

## Why it's needed

The layout parks `MainMenuBar` off-screen (SHOWN, `BOTTOMLEFT -3000,-3000`) so
the scatter arc's buttons 1-10 keep rendering. The stock leave button is a
child of `MainMenuBar`, so the client's own show (`SetShown(CanExitVehicle())`
on the vehicle events) rendered it off-screen with its parent: in a vehicle
there was no visible way to get out.

**Diagnosed in-game (ring log):** the re-anchor works
(`ApplyVehicleExitButton: re-anchored right of PlayerFrame, size=32x32`), but
the button never appeared on vehicle entry — this Ascension client does NOT
drive the stock button's visibility (the stock `MainMenuBar_OnEvent`
`SetShown(CanExitVehicle())` path doesn't run here). So the addon now owns
visibility itself (see below).

## API (from `reference/wowprogramming`)

- `VehicleExit()` — removes the player from the current vehicle (no-op outside one).
- `CanExitVehicle()` — `1` when in a vehicle and able to exit; the default UI
  uses this exact call to show the "Leave Vehicle" button.
- Events: `UNIT_ENTERED_VEHICLE` / `UNIT_EXITED_VEHICLE` (unit arg), plus
  `PLAYER_GAINS_VEHICLE_DATA` / `PLAYER_LOSES_VEHICLE_DATA`, `VEHICLE_UPDATE`.

## Layout

- Anchor: button `BOTTOM` → `UIParent` `BOTTOM`, **width-adaptive and snug**
  right of the health/mana bar block: the bars are 272 wide at a 4px inset in
  the 280-wide player frame, so the block's right edge is at x=136 from screen
  center on any resolution; the button's center sits at `136 + 2px gap +
  half the button width`, bottom-aligned with the player frame (y=12). This is
  the proven scatter-button pattern (UIParent-relative points on the parked
  bar render correctly). A PlayerFrame-relative anchor variant was tried first
  and abandoned (round-2 diagnosis: anchor applied but button never visible).
- **Re-assert (the real bug):** the client re-anchors this button back to its
  stock MainMenuBar-relative spot on `UNIT_ENTERED_VEHICLE` (the bar is parked
  off-screen, so the button lands at ~-2800,-2860 — diagnosed in the ring via
  `btnL`/`btnT` going negative while `btnShown=1`). `UpdateVehicleExitButton`
  re-asserts the UIParent anchor whenever the button drifts off-screen
  (`btnL < -1000`); the event handler runs after the client's (registration
  order) so this fixes it immediately, and the 0.25s poll is the backstop.
- Size is 32×32 — the stock button's native texture size, matching the
  ~29px-tall health/mana bar block so it blends with the bars (a 48px bump
  was tried first and read too big next to the bars; kept square per the
  user's preference — no circular skin). Plain button, so sizing is
  taint-clean.
- **Art fallback:** if the stock button has no normal texture on this client
  (a shown-but-invisible button), the layout creates one with a stock icon
  (`Interface\Icons\INV_Misc_Arrow_01`) so the button is always visible.
  Revert restores the original (nil) texture.
- **Visibility is addon-driven** (`UpdateVehicleExitButton`): a small event
  frame registers the vehicle events and calls `btn:SetShown(CanExitVehicle()
  or UnitInVehicle("player"))` on each, plus a 0.25s poll (same pattern as the
  stealth flip poll) to catch missed events. The stock OnClick already calls
  `VehicleExit()`, so the layout never replaces the click handler. The button
  is plain (non-secure), so `SetPoint`/`SetShown`/`SetWidth` are taint-clean;
  Apply defers during combat lockdown like every other step.

## Revert

Restores the button's original anchor points (MainMenuBar-relative), stops the
addon's vehicle event frame/poll, and hands visibility back to the client
(one `SetShown(CanExitVehicle())` so the button isn't left in a stale
addon-driven state). Order in `MobileUILayout:Revert()`: after
`RevertPlayerFrame` (the button's mobile anchor references `PlayerFrame`).

## Notes

- If the Ascension client ever fails to expose the stock button
  (`ApplyVehicleExitButton: MainMenuBarVehicleLeaveButton NOT FOUND` in the
  debug ring), the fallback is a custom addon-created button driven by the
  same events + poll.
- The `Veh:` ring lines log `canExit` / `inVeh` / `ui` / `btnShown` /
  `btnL`/`btnT` (the button's exact on-screen position when shown) /
  `btnTex` (its normal texture) / `btnParent` / `pfL`/`pfT` (PlayerFrame's
  position) / `vehBar` on every vehicle event and on state changes. A
  `Veh: client re-anchored leave button off-screen (btnL=…) -> re-anchored to
  mobile spot` line means the re-assert fired (expected on every vehicle
  entry). The texture is stock `Interface\Vehicles\UI-Vehicles-Button-Exit-Up`
  on this client — real art, so the `INV_Misc_Arrow_01` fallback never
  triggers.
- The guard does not touch this button: its anchor is PlayerFrame/UIParent-
  relative, so the client re-anchoring `MainMenuBar` (which the guard re-parks)
  cannot move it.

## Files

- `MobileUIFrames.lua` — anchor/apply/revert
- `MobileUILayout.lua` — apply step (`ApplyVehicleExitButton`) + revert step
  (`RevertVehicleExitButton`)

## In-game verification checklist

1. Jump on a vehicle → the leave button appears right of the player frame; tap
   it → you exit.
2. `/mui debug` shows `ApplyVehicleExitButton: re-anchored BOTTOM(165,12),
   size=48x48, parent=…` on apply, a `Veh: evt=… canExit=… inVeh=…` line on
   the state change, and a `Veh: client re-anchored leave button off-screen
   (btnL=-2788…) -> re-anchored to mobile spot` line when the re-assert fires.
   The entry `Veh:` line's `btnL` should read positive (~141), proving the
   re-assert landed before the log.
3. Enter a vehicle mid-combat → button still appears and works (plain button;
   our event frame + poll run in combat).
4. Layout revert → button returns to its stock anchors, no errors in the ring.
5. Regular mounts report `canExit=nil inVeh=nil` (no vehicle UI) — expected;
   those are mounts, not vehicles, and may need a separate dismount path.
