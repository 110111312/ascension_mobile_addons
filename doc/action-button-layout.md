# MobileUI Action Button Layout — Final Specification

## Overview

Action buttons are arranged in a quarter-circle arc centered at the bottom-right corner of the screen. Buttons use 4 concentric layers with decreasing size outward. All positions are `BOTTOMRIGHT` anchor offsets (x = negative = left from right edge, y = positive = up from bottom).

## Action Bar 1 — Buttons 1–12 (ActionButton1–12)

| Btn | Keybind | Source Frame         | Size | X     | Y   | Layer | Notes                          |
|-----|---------|---------------------|------|-------|-----|-------|--------------------------------|
| 1   | 1       | ActionButton1       | 96   | -29   | 29  | 1     | Center, largest                |
| 2   | 2       | ActionButton2       | 77   | -35   | 144 | 2     | Above btn 1                    |
| 3   | 3       | ActionButton3       | 77   | -144  | 35  | 2     | Left of btn 1                  |
| 4   | 4       | ActionButton4       | 77   | -115  | 115 | 2     | Between btn 2 and 3            |
| 5   | 5       | ActionButton5       | 64   | -20   | 240 | 3     | Top of arc, rightmost          |
| 6   | 6       | ActionButton6       | 64   | -97   | 214 | 3     | Between btn 5 and 7            |
| 7   | 7       | ActionButton7       | 64   | -190  | 193 | 3     | Between btn 6 and 8            |
| 8   | 8       | ActionButton8       | 64   | -215  | 101 | 3     | Between btn 7 and 9            |
| 9   | 9       | ActionButton9       | 64   | -248  | 29  | 3     | Left of btn 8, bottom-aligned   |
| 10  | 0       | ActionButton10      | 51   | -336  | 29  | 4     | Bottom-aligned with btn 9      |
| 11  | -       | ActionButton11      | 51   | -299  | 89  | 4     | Equidistant to btn 8 & 9 (80px)|
| 12  | =       | ActionButton12      | 51   | -271  | 170 | 4     | Equidistant to btn 7 & 8 (80px)|

## Action Bar 2 — Buttons 13–15 (MultiBarBottomLeftButton1–3)

| Btn | Keybind | Source Frame                    | Size | X     | Y   | Layer | Notes                          |
|-----|---------|--------------------------------|------|-------|-----|-------|--------------------------------|
| 13  | q       | MultiBarBottomLeftButton1      | 51   | -161  | 277 | 4     | Equidistant to btn 6 & 7 (70px)|
| 14  | e       | MultiBarBottomLeftButton2      | 51   | -86   | 298 | 4     | Equidistant to btn 5 & 6 (70px)|
| 15  | r       | MultiBarBottomLeftButton3      | 51   | -20   | 316 | 4     | Above btn 5, right-aligned     |

## Critical Constraint: Never Reparent MultiBarBottomLeft Buttons

**Root cause of the "scatter shows main bar 1-2-3" bug (fixed Aug 2026):**

This Ascension client does **not** use stock WoW's action-bar slot numbering.
Empirically verified via in-game diagnostics (`ActionButton_CalculateAction` + `UseAction` hooks):

- Stock WoW: `MultiBarBottomLeftButton1-3` → slots **13-15**
- Ascension: `MultiBarBottomLeftButton1-3` → slots **61-63** (when attached to their bar)

The client resolves a button's slot **from the bar frame it is attached to**.
If a bar-2 button is reparented away from `MultiBarBottomLeft` (e.g. to
`UIParent`), the client falls back to resolving it by **button ID** (1, 2, 3) —
the same IDs as `ActionButton1-3` — so the scatter buttons become clones of the
main bar's first three buttons: assigning a skill to scatter-13 writes to slot 1
(visible on main button 1), and Q/E/R (bound to `MULTIACTIONBAR1BUTTON1-3`)
cast slots 1-3.

**The fix (current implementation):**

- The scatter buttons are **never reparented** — they stay children of
  `MultiBarBottomLeft` (→ resolve to free slots 61-63).
- The bar frame cannot be hidden (hidden parent = children don't render), so it
  is **parked off-screen**: shown, anchored `BOTTOMLEFT (-1000, -1000)`. The
  guard `OnUpdate` re-parks it every frame and keeps it shown.
- The 3 buttons are repositioned to the scatter spots with `UIParent`-relative
  anchors (`SetPoint("BOTTOMRIGHT", UIParent, ...)`) — anchors are independent
  of the parent, so they render at the arc position despite the parked bar.
- Revert restores the bar's original points.

Q/E/R bindings are unchanged: `Q/E/R → MULTIACTIONBAR1BUTTON1-3` → those buttons
→ slots 61-63. Assign skills to the scatter buttons and the keys work.

## Keybind Summary

```
1  2  3  4  5  6  7  8  9  0  -  =  q  e  r
```

## Layer Structure

- **Layer 1** (96px): btn 1 — the main action button, closest to bottom-right corner
- **Layer 2** (77px): btns 2, 3, 4 — surrounding btn 1 in a triangle
- **Layer 3** (64px): btns 5, 6, 7, 8, 9 — wider arc ring
- **Layer 4** (51px): btns 10, 11, 12, 13, 14, 15 — outer scattered ring

## Skinning

All buttons are skinned with the Aquatic circular skin via embedded LibButtonFacade (LibButtonFacade). Hotkey text and button names are hidden for cleaner appearance.