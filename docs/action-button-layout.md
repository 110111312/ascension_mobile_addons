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
> `-`/`=` virtual keys, so the five outermost arc spots (11-15) are filled by
> bottom-left bar buttons 1-5 in order — the arc reads **1-2-3-4-5** left to
> right (keybinds Q/E/R/T/F). The `-`/`=` keybinds still work from a physical
> keyboard (keybinds fire actions directly); the buttons are just not shown in
> the mobile arc.

## Action Bar 2 — Buttons 11–15 (MultiBarBottomLeftButton1–5)

| Btn | Keybind | Source Frame                    | Size | X     | Y   | Layer | Notes                          |
|-----|---------|--------------------------------|------|-------|-----|-------|--------------------------------|
| 11  | q       | MultiBarBottomLeftButton1      | 51   | -299  | 89  | 4     | Replaces "-" (ActionButton11) spot |
| 12  | e       | MultiBarBottomLeftButton2      | 51   | -271  | 170 | 4     | Replaces "=" (ActionButton12) spot |
| 13  | r       | MultiBarBottomLeftButton3      | 51   | -161  | 277 | 4     | Equidistant to btn 6 & 7 (70px)|
| 14  | t       | MultiBarBottomLeftButton4      | 51   | -86   | 298 | 4     | Equidistant to btn 5 & 6 (70px)|
| 15  | f       | MultiBarBottomLeftButton5      | 51   | -20   | 316 | 4     | Above btn 5, right-aligned     |

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
- **Combat re-show (bug + fix):** the client re-shows the bar's buttons when
  combat starts, and the guard pauses its per-frame re-hide during lockdown
  (Show/Hide on protected frames in combat taints → broken `UseAction` clicks
  — commit `20e2723`). So at apply time (always out of combat) the tail is
  also **parked off-screen** (`ParkBar2Tail()`: one-shot
  `ClearAllPoints`/`SetPoint` to `BOTTOMLEFT (-3000, -3000)`, one independent
  anchor per button). The combat re-show never re-anchors, so the re-shown
  buttons render off-screen and stay invisible — with no per-frame
  protected-frame calls during the fight.
- Revert un-parks the tail buttons (restores their anchor-chain points) and
  restores their original shown state (the bar itself is never moved).

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
shows the 2 auto-assigned stealth skills there, and why `GetActionBarPage()`
never moves (the bonus bar is an overlay, not a page flip).

**Events on this client:** `UPDATE_STEALTH`, `UPDATE_BONUS_ACTIONBAR`, and
`UPDATE_SHAPESHIFT_FORM` **do** fire on stealth enter/exit. Order matters on
unstealth: `UPDATE_STEALTH` fires while the bonus offset is still the *old*
value, then `UPDATE_BONUS_ACTIONBAR` carries the change. `ACTIONBAR_PAGE_CHANGED`
never fires, and `GetShapeshiftForm()` is unreliable (reports 2, sometimes 0,
while stealthed). So the reliable driver is a **0.25s state poll** in the
guardFrame `OnUpdate` comparing `GetActionBarPage()`/`GetBonusBarOffset()`;
the `flipFrame` event watcher is a fast path on top.

**Implementation (`MobileUILayout.ApplyFlip`):**

- The client owns the stance→bar mapping; the addon only mirrors it. The target
  page is resolved generically (no per-class guessing):
  1. `GetActionBarPage() > 1` → follow it (stock 3.3.5a page flips).
  2. `GetBonusBarOffset() > 0` → bonus page `NUM_ACTIONBAR_PAGES + offset`
     (this client's stealth/stance mechanism — the same condition stock
     `BonusActionBarFrame` uses to show itself).
  3. Otherwise → 1.
- The follower sets the `actionpage` **attribute** on each `ActionButton1–12`
  (a self attribute overrides the parent chain in
  `ActionButton_CalculateAction`), then refreshes the buttons. Display **and**
  click now follow the same slots the keypress targets.
- **Never write plain Lua fields on the buttons** (`isBonus`, `action`): doing
  so **taints** the secure action chain on this client — the next click errors
  with "AddOn 'MobileUI' tainted the call of the secure function 'UseAction()'"
  and the cast is blocked. Attributes are the only safe channel.
- On revert, the attribute is set to an explicit **1**, not cleared with `nil`:
  the client's C-side keypress resolver caches the attribute, and a `nil`-clear
  leaves it stuck on the bonus page after unstealth (keys then keep casting
  stealth slots). Display is identical either way (page 1).
- `SetAttribute` works during combat lockdown on this client (verified via
  diagnostics) — **no combat deferral** is needed. Mid-combat refreshes draw
  icons directly (`RefreshScatterButtons`): `ActionButton_UpdateAction` calls
  protected `Show()`/`Hide()`, so in combat the refresh resolves the page
  exactly as `ActionButton_CalculateAction` will at click time and sets the
  icon texture (textures aren't protected).

**The unstealth key-stall bug (root cause, fixed):** this client shows
`BonusActionBarFrame` on stealth but **never hides it on unstealth** — the
stock `HideBonusActionBar` slide path doesn't run on it (its animation state
stays `nil`, and the stock function is gated on `MainMenuBar.busy`). The
client's C-side keypress router targets the bonus bar **while that frame is
shown**, so after the first unstealth, ACTIONBUTTON keys kept casting stealth
slots even though the UI looked normal (display flip is pure Lua and kept
working — hence "bar flips back but keys dead"). Fixes on the unstealth
transition (bonus offset 1→0):

- **Bonus bar hide is IMPOSSIBLE from the addon on this client — boundary
  confirmed in-game.** The client's own `HideBonusActionBar()` is ~3s late in
  combat (stock slide path gated on `MainMenuBar.busy`); during that window
  the shown bar's stock buttons overlap the bottom-right arc and steal
  clicks: they resolve to the stealth slots (73–84), which are unusable out
  of stealth (`you can't do that yet`) even though the arc display
  (attribute-driven) already shows the normal bar. But every hide mechanism
  taints the protected frame and blocks the client's own secure calls on it:
  - addon-context `Hide()` (the original layout-guard approach) →
    `AddOn 'MobileUI' prevented the call of the secure function
    'BonusActionBarFrame:Hide()'`;
  - a state-driver snippet on an addon-created handler calling methods on a
    frame via `self:GetParent()` → `'UNKNOWN()'`;
  - a driver on the frame with a `self:Hide()`/`self:Show()` snippet →
    `'UNKNOWN()'`;
  - a driver on the frame with a **pure `self:SetShown`** snippet (the
    flip-bridge ops) → `'UNKNOWN()'` still.
  Conclusion: restricted snippets on this client may ONLY `SetAttribute`;
  any `Hide`/`Show`/`SetShown` — even on `self` — taints.
  **Current approach — the busy clear:** the guard's OnUpdate clears
  `MainMenuBar.busy` every frame (`MainMenuBar.busy = nil` — a plain FIELD
  write, not a protected method call, so no taint; runs every frame
  including combat). That un-gates the client's own `HideBonusActionBar()`:
  with `busy` falsy it takes its instant `Hide()` path at the unstealth
  event, hiding the bar in combat with **zero addon touch on it** — no
  error, no window. (Hypothesis: our layout hides `MainMenuBar` every
  frame, plausibly jamming the client's own bar-slide state machine around
  combat transitions so `busy` stays set — which is exactly when the 3s
  window appears.) Belt-and-suspenders: the guard also hides
  `BonusActionBarFrame` **out of combat only** (same section that hides
  `MainMenuBar` — the identical call has run for months with zero errors,
  so out-of-combat protected calls are clean here). The unstealth branch
  probes the result (Debug to Chat): `bonusShown` should read 0 at
  unstealth (already hidden) or drop at +0.5s; if it persists to +3s the
  busy hypothesis failed and the fallback is restoring the flip-bridge
  driver (`63c5840` — working clicks, cosmetic `UNKNOWN()` error).
- **`ChangeActionBarPage(1)`** on the same transition — empirically required
  for the in-combat unstealth display flip. The page never visibly moves and
  no event fires, but without it the bar froze on stealth skills when
  unstealthing during combat.

**Combat display ownership:** the scatter buttons' `OnEvent` is **cleared** at
apply (see below), so the client never dispatches `ActionButton_Update` on
them — which means it never calls `self:Show()/self:Hide()` (blocked on our
tainted buttons mid-combat) and never renders icon/tint/cooldown. The addon
owns the display via `RefreshScatterButtons`, triggered by `flipFrame` events
(`UPDATE_BONUS_ACTIONBAR`, `UPDATE_SHAPESHIFT_FORM`, `ACTIONBAR_UPDATE_COOLDOWN`,
etc.) and the 0.25s guard poll — **not per-frame**: the cooldown spiral is
widget-internal after `SetCooldown`, so event-driven re-sync is enough. It
redraws from the attr-resolved page: icon texture, usability tints
(`IsUsableAction` vertex colors — the old per-frame `RefreshScatterCombat`
that did this was removed in phase 4; the event/poll-driven re-assert replaced
it), and the cooldown (`GetActionCooldown` with `enable == 1`). The stock
auto-attack flash is **not** re-asserted (not reported as an issue; the old
per-frame redraw handled it via `IsAttackAction`/`IsAutoRepeatAction`/
`IsCurrentAction`).

**Why `OnEvent` is cleared (taint, learned in-game):** the client's
`ActionButton_Update` resolves `self.action` from the `actionpage` attribute,
but on a detected-while-stealthed form transition it runs *before* the bridge's
state driver updates that attribute, leaving a stale (stealth) `self.action`.
Fixing the resulting gray tint requires `SetVertexColor` — which **taints** the
button on this client. With `OnEvent` intact, the client then calls
`self:Show()` on the tainted button mid-combat, which is blocked
(`AddOn 'MobileUI' prevented the call of the secure function
'ActionButton1:Show()'`). Clearing `OnEvent` stops the client from dispatching
those updates at all, so the blocked `Show()`/`Hide()` never happens — and the
addon's own display ops (vertex colors, cooldown), while they do taint the
button, never surface because the client no longer touches the button in
combat. `showgrid=1` is also set so non-event client code paths don't hide
empty slots. Phase 3's `flipLite` test only covered stealth toggles (no taint);
the detected-in-combat form transition is what triggers the blocked
`self:Show()`.

## Keybind Summary

```
1  2  3  4  5  6  7  8  9  0  t  f  q  e  r
```

## Layer Structure

- **Layer 1** (96px): btn 1 — the main action button, closest to bottom-right corner
- **Layer 2** (77px): btns 2, 3, 4 — surrounding btn 1 in a triangle
- **Layer 3** (64px): btns 5, 6, 7, 8, 9 — wider arc ring
- **Layer 4** (51px): btns 10, 11, 12, 13, 14, 15 — outer scattered ring
  (11-15 = bar-2 buttons 1-5 in order: Q/E/R/T/F)

## Skinning

All buttons are skinned with the Aquatic circular skin via embedded LibButtonFacade (LibButtonFacade). Hotkey text and button names are hidden for cleaner appearance.
