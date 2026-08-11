# Spell Book — Centered on Screen

Feature: `AscensionSpellbookFrame` repositioning, implemented in
`MobileUILayout.lua` (section 5c, `ApplySpellBook` / `RevertSpellBook`).

## Problem

The Ascension client's spell book is **`AscensionSpellbookFrame`** (540×525),
**not** the stock `SpellBookFrame` (384×512 — never shown on this client,
verified via a frame scan in the debug ring). The client anchors it
bottom-left, mostly off-screen: on the 1139×640 UIParent it sits at
`(22,514)`, so its bottom edge lands ~400 units below the screen — the book
appears bottom-left and cut off. The layout previously targeted the stock
frame, so it never moved.

## What the module does

`ApplySpellBook` (runs as a normal layout step, out of combat):

1. **Targets `AscensionSpellbookFrame`** (falls back to `SpellBookFrame` if
   the custom frame is absent).
2. **Centers** the frame: `SetPoint("CENTER", UIParent, "CENTER", 0, 0)`.
3. **Scales it to fit the screen height** — `min(1, (screenH - 40) / h)`
   (never scales *up*; 540×525 fits the 640-tall screen at 1.0). The frame
   is a plain movable frame, so `ClearAllPoints`/`SetPoint`/`SetScale` are
   safe.
4. **Re-asserts every frame while shown** — a persistent timer frame
   re-centers the book each frame it is visible. This is the primary
   mechanism: it does **not** depend on the client keeping our `OnShow`
   script, and it catches re-anchors that happen *after* `Show()` returns
   (open function, delayed event, or per-frame).
5. **OnShow fast-path** — the frame's `OnShow` is replaced with a wrapper
   that first calls the original `OnShow` (preserved in `SaveOriginals`, so
   tab updates + open sound still run) and then re-centers in the same frame
   as show.

Diagnostics (ring buffer only, never chat): `ApplySpellBook` logs the frame
name + scale (`ApplySpellBook: AscensionSpellbookFrame centered (scale=…)`),
matching the one-line-per-step pattern of the other layout steps.

`RevertSpellBook` restores the saved anchor points, scale, and original
`OnShow` script.

## Integration

- `SaveOriginals` saves `AscensionSpellbookFrame`'s name, points, scale, and
  `OnShow` script (once, guarded by `saved.init`), plus the micro button's
  original `OnClick`.
- `MobileUILayout:Apply()` — `step("ApplySpellBook", ApplySpellBook)` (after
  party frames, before chat).
- `MobileUILayout:Revert()` — `RevertSpellBook()`.

## Notes / limitations

- The scale is a fit-to-screen value, not a user setting (consistent with the
  "scale is fixed, no slider" rule — this is per-frame layout, not the global
  UI scale).
- If the spell book is open when the layout applies, the apply-time
  reposition handles it (no need to close/reopen).
- The frame name `AscensionSpellbookFrame` was identified empirically via a
  frame scan (`EnumerateFrames`) in the debug ring — it is the client's
  custom spell book; stock `SpellBookFrame` is kept as a fallback target.
