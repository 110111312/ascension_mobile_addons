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