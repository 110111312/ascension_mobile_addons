# Spell Book — Centered on Screen

Feature: `SpellBookFrame` repositioning, implemented in `MobileUILayout.lua`
(section 5c, `ApplySpellBook` / `RevertSpellBook`).

## Problem

The stock 3.3.5a `SpellBookFrame` (600×700, anchored `TOPLEFT` of `UIParent`)
opens at the left edge of the screen — on this Ascension client it renders
**bottom-left**, where it is awkward to reach/read on a phone stream. The
layout previously never touched the spell book, so it always opened at that
stock spot.

## What the module does

`ApplySpellBook` (runs as a normal layout step, out of combat):

1. **Centers** the frame: `SetPoint("CENTER", UIParent, "CENTER", 0, 0)`.
2. **Scales it to fit the screen height** — a 600×700 frame centered on the
   1128×634 UIParent would overflow ~33 units top and bottom, clipping the
   top tab row. Scale is computed at apply time from the frame's actual
   height: `min(1, (screenH - 40) / h)` (never scales *up*; ~0.85 on the
   1128×634 screen). The frame is a plain movable frame, so
   `ClearAllPoints`/`SetPoint`/`SetScale` are safe.
3. **Re-asserts on show** — the frame's `OnShow` is replaced with a wrapper
   that first calls the original `OnShow` (preserved in `SaveOriginals`, so
   tab updates + open sound still run) and then re-applies the center + scale
   while the layout is enabled. A one-shot timer re-asserts again ~0.25s after
   show, covering clients that re-anchor the book in the open function
   *after* `Show()` returns (by then `OnShow` has already run).

`RevertSpellBook` restores the saved anchor points, scale, and original
`OnShow` script.

## Integration

- `SaveOriginals` saves `SpellBookFrame`'s points, scale, and `OnShow` script
  (once, guarded by `saved.init`).
- `MobileUILayout:Apply()` — `step("ApplySpellBook", ApplySpellBook)` (after
  party frames, before chat).
- `MobileUILayout:Revert()` — `RevertSpellBook()`.

## Notes / limitations

- The scale is a fit-to-screen value, not a user setting (consistent with the
  "scale is fixed, no slider" rule — this is per-frame layout, not the global
  UI scale).
- If the spell book is open when the layout applies, the apply-time
  reposition handles it (no need to close/reopen).
- Ascension is a private server: the frame name `SpellBookFrame` is standard
  (also listed in the `MoveAnything` reference), but the exact stock anchor
  was observed in-game as bottom-left; the center + fit-to-screen math is
  resolution-independent.
