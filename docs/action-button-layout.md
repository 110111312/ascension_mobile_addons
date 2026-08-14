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
keypresses internally (C-side). The scatter buttons (never reparented, stock
`OnEvent`) therefore only recompute on the events they register
(`UPDATE_SHAPESHIFT_FORM` etc.), and the client's own page management never
moves them to the bonus page: display and click stayed on page-1 actions
while a keypress (e.g. `-` bound to `ACTIONBUTTON11`) targeted the stealth
bar. The addon itself never pinned the page (verified: zero references to
page/action APIs before the fix).

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

**Implementation (`MobileUIActionFlip.ApplyFlip`, in `MobileUIActionFlip.lua`):**

- The client owns the stance→bar mapping; the addon only mirrors it. The target
  page is resolved generically (no per-class guessing):
  1. `GetActionBarPage() > 1` → follow it (stock 3.3.5a page flips).
  2. `GetBonusBarOffset() > 0` → bonus page `NUM_ACTIONBAR_PAGES + offset`
     (this client's stealth/stance mechanism — the same condition stock
     `BonusActionBarFrame` uses to show itself).
  3. Otherwise → 1.
- The bridge sets the `actionpage` **attribute** on `MainMenuBarArtFrame` —
  the buttons' STOCK parent (the buttons are never reparented: `SetParent`
  on a secure button taints it and blocks the client's own mid-combat
  `Show()`, the phase-3/4 error). A `SecureStateDriver` on the art frame
  re-evaluates the condition every 0.2s + on bonus/stealth/page events and
  securely writes `state-actionpage` (even in combat); the art frame's
  `OnAttributeChanged` (stock `SecureHandler_StateOnAttributeChanged`)
  runs the `_onstate-actionpage` snippet copying it to `actionpage`. The
  buttons' stock `useparent-actionpage` walk (or the client's own actionpage
  writes) then resolves the same page in `ActionButton_CalculateAction`.
  Display **and** click follow the same slots the keypress targets.
- **Plain Lua field writes on the buttons taint them — but only `action` is
  written, and its taint is COSMETIC (confirmed via `issecurevariable`
  diagnostics).** The poll and `ApplyFlip` write `btn.action = <slot>` to fix
  the stale usable tint / one-state-behind icon (see the display-fix section
  below). `issecurevariable(btn, "action")` returns `secure=nil src=MobileUI`,
  i.e. the `action` field is tainted by the addon — the ONLY tainted field
  (everything else — `showgrid`, `Show`, `OnEvent`, the stock
  `ActionButton_Update*` globals — reads `secure=1 src=nil`). The consequence
  is a **cosmetic console error** at in-combat unstealth, "AddOn 'MobileUI'
  prevented the call of the secure function 'ActionButton1:Show()'": the
  client's `ActionButton_Update` reads the tainted `self.action`, taints its
  execution path, and its `Show()` is blocked. This does NOT break clicks
  (click resolution reads the bridge's `actionpage` attribute, which is
  clean), icons, or the tint — the error is console-only. Clicks are NOT
  blocked (the old "next click errors with UseAction()" concern does not
  apply to `action`; only `SetParent`/`SetAttribute`/`Show`/`Hide` from
  addon context on the button produce that). Trade-off: removing the
  `btn.action` writes silences the error but regresses the tint (buttons
  stay grey for seconds after in-combat unstealth). Decision: keep the
  writes, accept the cosmetic error.
- On revert, the attribute is set to an explicit **1**, not cleared with `nil`:
  the client's C-side keypress resolver caches the attribute, and a `nil`-clear
  leaves it stuck on the bonus page after unstealth (keys then keep casting
  stealth slots). Display is identical either way (page 1).
- `SetAttribute` works during combat lockdown on this client (verified via
  diagnostics) — **no combat deferral** is needed. Display is client-owned
  (stock `OnEvent` kept, Direction A), so mid-combat the client's own event
  dispatch re-renders from the bridge's attribute; the addon never calls
  `ActionButton_UpdateAction` in combat (it hits protected `Show()`/`Hide()`
  from addon context — blocked + taints).

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
  probes the result (debug log): `bonusShown` should read 0 at
  unstealth (already hidden) or drop at +0.5s; if it persists to +3s the
  busy hypothesis failed and the fallback is restoring the flip-bridge
  driver (`63c5840` — working clicks, cosmetic `UNKNOWN()` error).
- **`ChangeActionBarPage(1)`** on the same transition — empirically required
  for the in-combat unstealth display flip. The page never visibly moves and
  no event fires, but without it the bar froze on stealth skills when
  unstealthing during combat.

**Combat display ownership (Direction A — client-owned):** the scatter
buttons keep their stock `OnEvent` (never cleared) and are **never
reparented** — they stay children of `MainMenuBarArtFrame`, which the guard
parks off-screen (shown) so the arc renders at its UIParent-anchored
positions while the bar art stays invisible. The client renders icon /
usable tint / cooldown / checked state / attack flash / C-side proc glow
natively — exactly like the dynamic strip (66–71) and the arc's own 11–15
buttons, which have always run client-owned with zero combat taint. The
addon never writes the stock regions' vertex colors or cooldown
(`SetVertexColor` on the icon/NormalTexture and `SetCooldown` on the
Cooldown frame taint the button, and the client's later mid-combat
`Show()`/`Hide()` on a tainted button is blocked — the phase-3/4 failure
mode). The page mirroring is done purely via the bridge's `actionpage`
attribute on `MainMenuBarArtFrame` (the driver re-evaluates in the secure
phase, before the button's `OnEvent` runs), and the client's own `OnEvent`
(`UPDATE_SHAPESHIFT_FORM` → `ActionButton_UpdateAction`) re-resolves and
re-renders the flip natively, in and out of combat. The addon never calls
`ActionButton_UpdateAction` itself: it hits protected `Show()`/`Hide()`
from addon context, which taints the button and re-blocks the client's
`Show()` (the phase-3/4 error).

This replaced the old hand-rolled display layer (`RefreshScatterButtons` +
per-frame `ReassertFlash`), which had drifted from stock:
- the usable tint never refreshed on retarget — the out-of-combat refresh
  called `ActionButton_UpdateAction`, a no-op when the slot's action hadn't
  changed (retarget changes usability, not the action), so a frozen-target
  spell stayed gray;
- `ReassertFlash` hid the Flash texture every frame unless the action was an
  active auto-attack/auto-shot, killing the client's C-side proc glow (e.g.
  an Ascension talent's "3rd cast empowered" border flash);
- the checked-state clear (`SetChecked(nil)`) was a band-aid for the
  casting highlight latching — stock `ActionButton_UpdateState` (via
  `ACTIONBAR_UPDATE_STATE`) already unchecks natively.

With stock `OnEvent` back, all of these — and every other case (mounts,
vehicles, inventory changes, equipment borders, stack counts, the range dot,
procs) — are handled by the client's own event dispatch, the same path the
default action bar uses.

**Stale display after flips — the poll's `btn.action` + `icon:SetTexture`
fix (Direction A follow-up).** Event dispatch order on this client is
**buttons-first, then `flipFrame`**: the buttons' stock
`UPDATE_BONUS_ACTIONBAR` `OnEvent` runs BEFORE `ApplyFlip` sets the bridge's
`actionpage`, so the buttons resolve against the PREVIOUS state's page and
set `self.action` one state behind (stealth-enter shows normal icons,
unstealth shows stealth icons, oscillating). The client also fires
`ACTIONBAR_UPDATE_USABLE` BEFORE the poll corrects things, so after
in-combat unstealth the buttons' tint is computed from stale `self.action`
(stealth slots 73-82, now unusable) → buttons 2/4 stay grey for a few
seconds until the server sends another usability update. The 0.25s poll
(guard `OnUpdate`) fixes both on every state change, in and out of combat:
it sets `btn.action` (plain field — taints, see the taint note above) and
`icon:SetTexture(GetActionTexture(action))` (safe, ArcAssign-verified).
`ApplyFlip` also sets `btn.action` synchronously at event time so the
client's `ACTIONBAR_UPDATE_USABLE` reads the corrected value and tints
immediately. `ChangeActionBarPage` is NOT used — the Ascension client's
state-driver manager processes `ACTIONBAR_PAGE_CHANGED` SYNCHRONOUSLY, so
any page toggle corrupts the bridge's `actionpage` (e.g. page 6 →
`actionpage=6`, buttons show MultiBarBottomLeft skills).

**Why `OnEvent` is kept (Direction A):** the phase-3/4 taint cascade
(blocked `self:Show()` mid-combat) was **self-inflicted** — it happened
because the addon wrote `SetVertexColor`/`SetCooldown` on the stock regions
AND reparented the buttons (`SetParent` on a secure button taints it on
this client), and the client's later `Show()`/`Hide()` on the tainted
button was then blocked. The dynamic strip (66–71) and the arc's own 11–15
buttons are LBF-skinned with stock `OnEvent` intact, never reparented, and
have zero combat taint — the proof that client-owned display is clean. The
stale-`self.action` race at a detected-while-stealthed form transition is
now self-healing: the bridge's driver updates the attribute in the secure
phase (before the button's `OnEvent` runs), and the client's own `OnEvent`
re-resolves and re-renders. A brief stale frame at the transition is
acceptable (the default UI has the same behavior with the bonus bar).
`showgrid=1` is still set so non-event client code paths don't hide empty
slots.

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
