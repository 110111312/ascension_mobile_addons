# Talent Frame — Centered, Scaled to 1.1

Feature: talent frame repositioning, implemented in `MobileUIFrames.lua`
(`ApplyTalentFrame` / `RevertTalentFrame`).

## Problem

The Ascension client customizes the talent frame. With the global UI scale
fixed at **1.2** (see `CLAUDE.md` — scale is fixed, no slider), the talent
frame is too large on the phone-streamed screen and overflows. The stock
3.3.5a talent frame is `PlayerTalentFrame`, loaded lazily via
`TalentFrame_LoadUI()` (per the `MoveAnything` reference addon, which hooks
`PlayerTalentFrame = TalentFrame_LoadUI`). Ascension likely uses a
custom-prefixed name, mirroring `AscensionSpellbookFrame`.

## What the module does

`ApplyTalentFrame` (runs as a normal layout step, out of combat):

1. **Triggers the lazy load** — if the talent frame doesn't exist yet,
   calls `TalentFrame_LoadUI()` so the frame is created before we target
   it. The frame is loaded on demand (first time the player opens talents),
   so it may be nil when the layout first applies.
2. **Targets the frame by name**, trying `AscensionTalentFrame` first
   (mirrors the `AscensionSpellbookFrame` convention) and falling back to
   the stock `PlayerTalentFrame`.
3. **Centers** the frame: `SetPoint("CENTER", UIParent, "CENTER", 0, 0)`.
4. **Scales to 1.1** (`TALENT_SCALE = 1.1`) — deliberately below the global
   1.2 so the talent frame reads a touch smaller than the rest of the UI.
   Unlike the spell book (fit-to-screen), this is a fixed value per the
   request.
5. **Re-asserts every frame while shown** — a persistent timer frame
   re-centers the talent frame each frame it is visible, so the client's
   re-anchor on open is overwritten. Same defensive pattern as the spell
   book.
6. **OnShow fast-path** — the frame's `OnShow` is replaced with a wrapper
   that first calls the original `OnShow` (preserved so the client's tab
   updates still run) and then re-centers in the same frame as show.
7. **Back-fills `saved.talent`** if `SaveOriginals` ran before the frame
   existed (i.e. the talent frame was never opened at login), so `Revert`
   can still restore the stock anchor/scale/OnShow.

Diagnostics (ring buffer only, never chat): `ApplyTalentFrame` logs the frame
name + scale, e.g. `ApplyTalentFrame: PlayerTalentFrame centered
(scale=1.1)`. If neither frame name resolves, it logs
`ApplyTalentFrame: talent frame NOT FOUND`.

`RevertTalentFrame` hides the re-assert timer and restores the saved anchor
points, scale, and original `OnShow` script.

## Integration

- `SaveOriginals` saves the talent frame's name, points, scale, and `OnShow`
  script (guarded by `saved.init`). Because the frame is lazy-loaded, the
  save may be skipped at first apply; `ApplyTalentFrame` back-fills it.
- `MobileUILayout:Apply()` — `step("ApplyTalentFrame", function() MobileUIFrames.ApplyTalentFrame() end)`
  (after `ApplySpellBook`, before `ApplyChatFrame`).
- `MobileUILayout:Revert()` — `MobileUIFrames.RevertTalentFrame()` (after
  `RevertSpellBook`, before `RevertChatFrame`).

## Notes / limitations

- The scale (1.1) is a fixed per-frame layout value, **not** a user setting
  (consistent with the "scale is fixed, no slider" rule — this is per-frame
  layout, not the global UI scale).
- The frame name `AscensionTalentFrame` is an assumption mirroring the
  spell-book naming. If the in-game debug log shows
  `ApplyTalentFrame: talent frame NOT FOUND`, the real frame name needs to
  be discovered via a frame scan (see `spell-book.md`) and added to
  `TALENT_FRAMES`.
- The frame is treated as a plain (non-secure) movable frame, same as the
  spell book. The `step()` wrapper's `pcall` logs any secure-call error
  rather than aborting the whole layout.