# Menu Bar — 2×6 Micro-Button Grid (Top Right)

Feature: `MobileUIFrames.lua` (`ApplyMenuBar` / `RevertMenuBar`). The stock
micro buttons live in a bottom-left horizontal strip; this layout reparents
all of them into a single `MobileUIMenuBar` frame anchored `TOPRIGHT` of
`UIParent` at `(-8, -8)`, arranged as **6 columns × 2 rows** (12 buttons:
10 stock + 2 Ascension customs — `ChallengesMicroButton`,
`PathToAscensionMicroButton`).

## Layout

- Container: `TOPRIGHT (-8,-8)`, `SetSize(200, 70)` — buttons are placed
  `TOPRIGHT` of the bar at `(-xOffset, -yOffset)`; `xOffset` steps by 30 for
  the first 6 buttons, then wraps (`xOffset = 0, yOffset = 32`) for the
  second row.
- Buttons keep their default appearance (no circular skin — the menu icons
  are small and read fine as-is; `PVPMicroButton`'s icon texture gets a
  small nudge to center it).
- The bar renders at an **effective scale of 1.15** (`MENU_SCALE` in
  `MobileUILayout.lua`, applied as `MENU_SCALE / UIParent:GetScale()`).
  At the fixed global 1.2 the 2×6 grid overlapped the player buffs at the
  top-right corner; 1.15 shrinks it just enough to clear them. The menu
  bar's bottom edge lands at y≈75 from the top, which also gives the party
  frame strip below it a little more headroom.

## Constants

```lua
-- MobileUILayout.lua
local MENU_SCALE  = 1.15  -- effective scale (global fixed scale is 1.2)
```

## Revert

`RevertMenuBar()` hides the container and restores each micro button's saved
parent, size, points, shown state, and skin/icon state (see
`MobileUILayout.saved.micros`).

## Notes

- Reparenting micro buttons is safe — they are plain (non-secure) buttons,
  so `SetParent`/`SetPoint`/`SetScale` do not taint and can run in combat
  (the layout's `Apply` still defers during lockdown as a general rule).
- The bar is 2 rows of 6 because there are 12 buttons; the older
  `docs/mobile-layout-draft.html` shows a single horizontal row — the draft
  predates the 12-button wrap.
