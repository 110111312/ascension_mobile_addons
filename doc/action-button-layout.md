# MobileUI Action Button Layout — Final Specification

## Overview

Action buttons are arranged in a quarter-circle arc centered at the bottom-right corner of the screen. Buttons use 4 concentric layers with decreasing size outward. All positions are `BOTTOMRIGHT` anchor offsets (x = negative = left from right edge, y = positive = up from bottom).

## Action Bar 1 — Buttons 1–10 (ActionButton1–10)

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

> **ActionButton11/12 ("-" and "=") are NOT scattered.** Artemis cannot create
> `-`/`=` virtual keys, so those two arc spots are filled by bottom-left bar
> buttons 4 and 5 (bound to **T** and **F**) — the exact keys the Artemis preset
> sends at those positions, so the icon matches the action. The `-`/`=` keybinds
> still work from a physical keyboard (keybinds fire actions directly); the
> buttons are just not shown in the mobile arc.

## Action Bar 2 — Buttons 11–15 (MultiBarBottomLeftButton1–5)

| Btn | Keybind | Source Frame                    | Size | X     | Y   | Layer | Notes                          |
|-----|---------|--------------------------------|------|-------|-----|-------|--------------------------------|
| 11  | t       | MultiBarBottomLeftButton4      | 51   | -299  | 89  | 4     | Replaces "-" (ActionButton11) spot |
| 12  | f       | MultiBarBottomLeftButton5      | 51   | -271  | 170 | 4     | Replaces "=" (ActionButton12) spot |
| 13  | q       | MultiBarBottomLeftButton1      | 51   | -161  | 277 | 4     | Equidistant to btn 6 & 7 (70px)|
| 14  | e       | MultiBarBottomLeftButton2      | 51   | -86   | 298 | 4     | Equidistant to btn 5 & 6 (70px)|
| 15  | r       | MultiBarBottomLeftButton3      | 51   | -20   | 316 | 4     | Above btn 5, right-aligned     |

## Critical Constraint: Never Reparent MultiBarBottomLeft Buttons

**Root cause of the "scatter shows main bar 1-2-3" bug (fixed Aug 2026):**

This Ascension client does **not** use stock WoW's action-bar slot numbering.
Empirically verified via in-game diagnostics (`ActionButton_CalculateAction` + `UseAction` hooks):

- Stock WoW: `MultiBarBottomLeftButton1-5` → slots **13-17**
- Ascension: `MultiBarBottomLeftButton1-5` → slots **61-65** (when attached to their bar)

The client resolves a button's slot **from the bar frame it is attached to**.
If a bar-2 button is reparented away from `MultiBarBottomLeft` (e.g. to
`UIParent`), the client falls back to resolving it by **button ID** (1, 2, 3, 4, 5) —
the same IDs as `ActionButton1-5` — so the scatter buttons become clones of the
main bar's first five buttons: assigning a skill to scatter-13 writes to slot 1
(visible on main button 1), and T/F/Q/E/R (bound to `MULTIACTIONBAR1BUTTON4-5/1-3`)
cast slots 1-5.

**The fix (current implementation):**

- The scatter buttons are **never reparented** — they stay children of
  `MultiBarBottomLeft` (→ resolve to free slots 61-65).
- The bar frame cannot be hidden (hidden parent = children don't render), and
  the client marks it as a **protected frame** — `ClearAllPoints()`/`SetPoint()`
  on it raise `AddOn 'MobileUI' prevented the call of the secure function
  'MultiBarBottomLeft:ClearAllPoints()'`. So the layout never touches its
  points: the container has no art (invisible) and the guard only ensures it
  stays `SHOWN`.
- The 5 buttons are repositioned to the scatter spots with `UIParent`-relative
  anchors (`SetPoint("BOTTOMRIGHT", UIParent, ...)`) — anchors are independent
  of the parent, so they render at the arc position regardless of the bar.
- The bar is **horizontal** and its buttons are anchor-chained (each `LEFT` of
  the previous button's `RIGHT`), so the tail buttons (6-12) chain off the last
  scatter button's right edge and would render on screen next to the arc. They
  are hidden individually (`HideBar2Tail()` + guard re-hide) — hiding doesn't
  affect slot resolution, which comes from the attached bar, not visibility.
- Revert re-shows the tail buttons (the bar itself is never moved).

T/F/Q/E/R bindings are unchanged: `T/F → MULTIACTIONBAR1BUTTON4-5` and
`Q/E/R → MULTIACTIONBAR1BUTTON1-3` → those buttons → slots 61-65. Assign skills
to the scatter buttons and the keys work.

## Stance / Stealth Flip Follower (ActionButton1–12)

**Problem:** on this Ascension client the Lua-visible action-bar page
(`GetActionBarPage()`) stays **pinned at 1** in stealth — the client resolves
keypresses internally (C-side). The reparented scatter buttons therefore never
recomputed on their own: display and click stayed on page-1 actions while a
keypress (e.g. `-` bound to `ACTIONBUTTON11`) targeted the stealth bar. The
addon itself never pinned the page (verified: zero references to page/action
APIs before the fix).

**What the stealth bar actually is (empirically verified):** the client does
**not** flip to action-bar page 2 — pages 2–5 are completely empty in stealth.
The stealth bar is the **bonus bar** (`BonusActionBarFrame`): in stealth
`GetBonusBarOffset() = 1` → page 7, slots **73–84**. That's why the default UI
shows the 2 auto-assigned stealth skills there, why `-` routes to the bonus
buttons in stealth (stock `ActionButtonUp` checks `BonusActionBarFrame:IsShown()`
first), and why `GetActionBarPage()` never moves (the bonus bar is an overlay,
not a page flip).

Also: this client fires **no** `ACTIONBAR_PAGE_CHANGED` /
`UPDATE_SHAPESHIFT_FORM` events for stealth, and `GetShapeshiftForm()` is
unreliable (reports 2, sometimes 0, while stealthed) — so `IsStealthed()` is
the primary detector.

**Implementation (`MobileUILayout.ApplyFlip`, polled every 0.25s in the
guardFrame `OnUpdate`):**

- The client owns the stance→bar mapping; the addon only mirrors it. The target
  page is derived generically (`GetFlipPage`), in priority order:
  1. `GetActionBarPage() > 1` → follow it (stock 3.3.5a behavior: the page
     flips for every class/form).
  2. `GetBonusBarOffset() > 0` → bonus page `NUM_ACTIONBAR_PAGES + offset`
     (this client's stealth/stance mechanism — the same condition stock
     `BonusActionBarFrame` uses to show itself).
  3. Fallbacks only when neither moves: `IsStealthed()` → page 2, then a small
     form table (`ROGUE` stealth → 2, `WARRIOR` stances → 3/4/5).
- Because `GetActionBarPage()` stays 1 here, the follower sets the `actionpage`
  **attribute** on each `ActionButton1–12` (a self attribute overrides the
  parent chain in `ActionButton_CalculateAction`), then calls
  `ActionButton_UpdateAction` to refresh. Display **and** click now follow the
  same slots the keypress targets. On revert (no form active) the attribute is
  cleared so stale mappings can't persist.
- Secure attribute writes are deferred out of combat (`flipPending` +
  `PLAYER_REGEN_ENABLED`), same pattern as the rest of the layout.

## Keybind Summary

```
1  2  3  4  5  6  7  8  9  0  t  f  q  e  r
```

## Layer Structure

- **Layer 1** (96px): btn 1 — the main action button, closest to bottom-right corner
- **Layer 2** (77px): btns 2, 3, 4 — surrounding btn 1 in a triangle
- **Layer 3** (64px): btns 5, 6, 7, 8, 9 — wider arc ring
- **Layer 4** (51px): btns 10, 11, 12, 13, 14, 15 — outer scattered ring
  (11/12 = bar-2 T/F buttons, 13-15 = bar-2 Q/E/R buttons)

## Skinning

All buttons are skinned with the Aquatic circular skin via embedded LibButtonFacade (LibButtonFacade). Hotkey text and button names are hidden for cleaner appearance.
