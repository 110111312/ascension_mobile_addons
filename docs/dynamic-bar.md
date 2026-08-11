# Dynamic Action Bar (bottom-left strip)

A mobile "totem-style" bar in the empty strip between the bag button and the
player health/mana frame. **Tap = use, hold = assign.**

Feature: `MobileUIDynamicBar.lua` (v2.9.0). Toggle: `/mui dynamicbar` or
Interface Options → MobileUI → "Dynamic Action Bar". Default: **on** (only
visible while the layout is enabled).

## Why slots, not proxies

The tap-to-use path in this client is taint-protected: addon code calling
`UseContainerItem`/`UseItemByName` on the item's bag slot is blocked
(`docs/tap-use.md`). The clean path is a **real user click on a stock action
button** — the button resolves its slot and the client's own
`ActionButton_OnClick` → `UseAction(slot)` runs with zero addon code on the
stack.

So the bar assigns the chosen item/spell to a **real action slot** (66–71,
via the parked `MultiBarBottomLeftButton6–11`) using the drag-simulation
APIs (`PickupContainerItem`/`PickupSpell` + `PlaceAction` — none on the
protected list), and the tap is a plain stock action-button click. No
secure-button experiments, no OnEvent clearing, no attribute games: the
client renders icon / cooldown / stack count / usable tint natively.

## Layout

- The strip is **measured at apply time** (`MobileUIBagButton` right edge →
  `PlayerFrame` left edge): **6 buttons spread evenly** across the whole gap,
  targeting the **layer-3 arc size (64px)** and **shrinking to fit** when the
  gap is too small (min 24px). The measured size is logged
  (`applied 6 button(s) size=…`).
- Buttons are **vertically centered on the bag button**.
- Buttons 6–11 stay **children of `MultiBarBottomLeft`** (never reparented —
  slot resolution comes from the attached bar → slots 66–71, the same
  discipline as the scatter arc). `showgrid=1` keeps empty slots visible.
- The strip buttons get the **same circular skin as the arc** (embedded
  LibButtonFacade, `MobileUI-Circle` group) via `MobileUILayout.SkinButton`
  (exposed for this module).
- The layout guard's per-frame `HideBar2Tail` **skips** buttons owned by the
  dynamic bar (`MobileUIDynamicBar.TailUsed(i)`), so the strip stays visible
  through the combat re-show; the rest of the tail (12) stays parked
  off-screen as before.

## Gestures

| Gesture | What happens |
|---|---|
| **Tap** (left click) | Stock action-button click → `UseAction(slot)` — uses the item / casts the spell. Taint-clean. |
| **Hold** (right click) | An `OnMouseDown` script on the stock button (installed the same way the layout installs `OnEnter` on the arc buttons) opens the picker on right-**down** — works for empty and filled slots. |
| **Tap a row once** | Shows the entry's tooltip (global `GameTooltip`, pcall-wrapped) and **arms** the cell (gold outline). Also on hover for desktop. |
| **Tap the same row again** | Assigns it to the held button's slot via pickup+`PlaceAction`, closes the picker. Gated out of combat. |
| **X button / ESC / tap outside** | Dismisses the picker. |

The picker uses a **tap-tap** interaction (first tap = tooltip, second tap =
assign) instead of hold-for-tooltip — the hold gesture is flaky on Artemis.
Tapping a different row re-arms that row; the armed state and tooltip reset
on dismiss.

The stock right-click **up** still fires `ActionButton_OnClick` → `PickupAction(slot)`, which puts the slot's item on the cursor. The menu's **`OnHide`** re-places it via `PlaceAction` (fallback `ReturnCursorContent`), so nothing is lost or left dangling on the cursor — every dismissal path (X, ESC, tap-outside, assign, revert) ends in `menu:Hide()`.

### Why no overlay/catcher over the buttons

A `Button` with `RegisterForClicks("RightButtonDown", ...)` received **no mouse events at all** on this client (verified in-game via the debug ring: no `catcher down` line while the strip applied fine), and a plain mouse-enabled `Frame` overlay would also eat left taps (no click pass-through on this client). A direct `OnMouseDown` script on the stock button is the minimal proven mechanic: the layout already installs scripts on the arc buttons this way and casting stays clean. The left-click use path is untouched.

## Picker

A **column layout** (no scrolling) — one column per category, each a 2-wide
grid of compact rows (icon + name), in a wide frame (692px) whose height
adapts to the tallest column (cell height shrinks if a category is long):

- **Items** — usable bag items (any item with a "Use:" effect,
  `GetItemSpell(link) ~= nil`), deduped by item ID, showing icon + stack count.
- **Spells** — known spells filtered to *helpful* (`IsHelpfulSpell`, usable
  on player/friendly) minus attack spells (`IsAttackSpell`) minus passives
  (`IsPassiveSpell`) minus harmful (`IsHarmfulSpell`) minus **trade-skill
  recipes** minus **stance/stealth-required spells** (Palm Sigil needs
  Stealth). **No keep/drop filter** — every candidate shows, sorted
  alphabetically. Active buffs show remaining time (e.g. `12m`).
- **Mounts** — split out of the spell scan via the book type (`"MOUNT"`)
  or a name heuristic (Ascension's custom mount spells report book type
  `"SPELL"`, so names containing `Mount` are classified as mounts).
- **Professions** — the player's profession skills and sub-skills
  (e.g. **Enchanting** — clicking it opens the enchanting window — and
  **Disenchant**). Detected by **filter, not whitelist**:
  `GetProfessions()` + `GetProfessionInfo()` return each profession's exact
  spellbook range (`spellOffset`..`spellOffset+numSpells-1`); the first spell
  in the range is the profession skill, the rest are sub-skills. Recipes are
  **not** in the spellbook (they live in the profession window), so the
  range is small and clean. Profession spells **bypass the candidate
  filters** (the skill may read as passive, and sub-skills carry
  `Requires <prof> (rank)` which the stance filter would otherwise drop).
  If `GetProfessions`/`GetProfessionInfo` are stripped on this client, a
  fallback tags any non-General tab whose spells show a
  `Requires <X> (rank)` tooltip line as a profession tab.

**Filtering reality on this client:** `IsHelpfulSpell`, `IsHarmfulSpell`,
`IsAttackSpell` and `IsPassiveSpell` all **exist and work**; `IsTradeSkill`
is stripped (nil). Two quirks matter:

- **`IsHelpfulSpell` can't be used as a filter** — it returns `nil` (not
  `false`) for harmful spells *and* for weapon enchants (Weapon Engraving,
  Palm Sigil: Fire). `IsHarmfulSpell` is the correct discriminator: harmful
  spells have `hrm=1`, weapon enchants have `hrm=nil` (so they're kept).
- **The General tab is mostly skipped** — it holds racials/toggles/teleports
  (Every Man for Himself, PvE Mode, War Mode). Only **mounts** and the
  **Resurrect** teleports are kept from it (rejected as `general`); the
  custom tabs (Engravement / Glyphic / Riftblade) are scanned normally.

Recipes: `IsTradeSkill` is stripped, so they can't be filtered by API yet.
The `candidate-rejected:` log line lists every dropped spell with its reason
(`passive`/`attack`/`harmful`/`general`/`stance`), so a real recipe filter
can be derived from data instead of guessed.

Each row: small icon (20px) + name + count/duration. Tap a row once to
preview its tooltip (global `GameTooltip`, pcall-wrapped, anchored to
**the cell** — anchoring to the 520px menu would push it off-screen on a
phone), tap it again to assign. The tooltip uses
`GameTooltip:SetSpell(spellbookID, "spell")` —
`SetSpellBookItem` is stripped on this client, `GetSpellBookItemInfo`'s 2nd
return (spellID) is nil, and `GetSpellInfo` has no spellID return (9-value
form), so `SetSpellByID` can't work. The tooltip hides on dismiss and when
re-arming another row.

**Stance/stealth filter:** `GetNumTooltipLines` is stripped, so the
requirement is read by scanning the tooltip's font strings via
`GameTooltip:GetRegions()`. A `Requires X` line is a stance/stealth
requirement when X is a **skill name**: single word (or `the <word>`), not
`level N`, not `a/an <item>` — plus the `Stealth`/`Form`/`Stance` keywords
(case-insensitive). This catches custom Ascension stances like
`Requires Moonshroud` (the class stealth skill, which isn't even in the
spellbook). A `Requires X (rank)` line (numeric rank in parens) is a
**profession** requirement, not a stance — it's kept (profession spells are
handled by the profession detection). Every `Requires` line is logged
(`stance-scan: <spell> requires '<x>' -> FILTER/keep`) so the heuristic can
be tuned from data. Results cached by spell name; rejected spells log as
`name(stance)`.

**Picker rows are tap-tap**: the first tap shows the tooltip and arms the
cell (gold outline), the second tap on the same cell assigns. Keyed purely
on `OnClick` (which fires on every tap on this client — verified in the
debug ring) with `armedCell == self` as the discriminator. `OnEnter` only
shows the tooltip on hover; it does **not** arm, because `OnEnter` fires
only on the first touch per open and cannot be relied on for the arm state
(an earlier `wasArmed`-in-`OnEnter` design failed exactly this way). Tapping
a different row re-arms it; armed state + tooltip reset on dismiss. Every
cell click is logged (`cell click btn=… armed=… entry=…`) for tuning.

**First-open tap-tap bug (fixed):** on the first picker open after login,
`CreateMenu()` runs and ends with `menu:Hide()`, whose `OnHide` script nils
`pickerButton`. The old code set `pickerButton` *before* `CreateMenu()`, so
on the first open it was nil by the time the second tap called
`AssignEntry` — which silently returned and never assigned (second opens
skipped `CreateMenu`, so they worked). `OpenPicker` now sets `pickerButton`
**after** `CreateMenu()`, and `AssignEntry` logs its `pickerButton` value so
a regression is visible in the ring immediately.

Spellbook scan order: `GetSpellBookItemName` (documented) → `GetSpellName`
→ `GetSpellBookItemInfo`+`GetSpellInfo` (undocumented last resort). A debug
line reports which path ran and the candidate counts
(`N candidates (X spells, Y mounts)`), a `kept:` line lists every kept
spell (mounts marked `[mount]`), and a `candidate-rejected:` line gives the
reason (`passive`/`attack`/`harmful`/`general`) for tuning.

> **Why no scrolling?** This Ascension client strips the scroll primitives
> (`ScrollFrame:SetVerticalScroll`, `Slider:SetObeyStepOnDrag`,
> `Frame:SetClipsChildren` — verified in-game, like
> `GameTooltip:GetNumTooltipLines`), and scrolling is poor UX on a phone
> stream anyway. The column layout shows everything at once.

> **Why no duration filter?** 3.3.5 has no spell-duration API, and this
> Ascension client has **no tooltip line-reading API either**
> (`GetNumTooltipLines` is nil on both the global and addon-created tooltips
> — verified in-game), so duration can't be read at all. The picker shows
> every helpful non-passive non-attack non-trade spell; remaining time is
> shown only for buffs currently active on the player (UnitBuff gives the
> exact duration).

Spells assign as plain spell slots: clicking casts at the current target
(stock behavior). Target-required buffs (Blessing-type) need a target or an
`@player` macro — same limitation as the default UI; no-target self-buffs
just work.

## Persistence / revert

Assignments live in the **client's action-bar save data** (slots 66–71), so
they survive reload/logout for free. Revert (`/mui dynamicbar off` or layout
revert) re-parks the strip buttons off-screen exactly as the layout left the
tail, **uns skins** them, but **leaves the slot contents in place** — they are
the player's own action slots (the layout revert also restores the tail's
original anchors and shown state from `saved.bar2tail`).

## Taint safety

- Assign path: `PickupContainerItem` (proven clean — bag-swap),
  `PickupSpell`/`PickupSpellBookItem`, `PlaceAction` (not on the protected
  list in the reference). Assignment is gated on `not InCombatLockdown()`.
- Use path: stock `ActionButton_OnClick` → `UseAction` — the button's OnClick
  is never swapped, the button is never field-written. The only addon script
  on it is `OnMouseDown` (opens the picker; no protected calls), which runs
  on the down event and is not on the stack of the later left-up
  `UseAction`. Same path every arc spell cast uses.
- The picker and its dismiss catcher are addon-created plain frames; they
  never call protected functions.
- Replacing an assignment: `PlaceAction` *exchanges*, so the previous slot
  content lands on the cursor — items are returned to a free bag slot
  (`ReturnCursorContent`), anything else is dropped. No lost items.

## Controls

- Default: **on**
- Toggle: `/mui dynamicbar`
- Interface Options → MobileUI → "Dynamic Action Bar (tap = use, hold =
  assign items/buffs)"
- Saved var: `MobileDB.dynamicBar`

## Debug log (ring buffer only, no chat prints)

All `DynamicBar:` lines go to the `MobileUIDebugLog` ring buffer (view with
`/mui debug`; on disk after `/reload`/logout). What's logged:

- `applied 6 button(s) size=… pitch=… x0=… y=…` — strip geometry (apply)
- `btn <name> hold` / `btn <name> down button=…` — hold detection
- `OpenPicker btn=… createMenu=…` / `picker opened btn=… entries=…` — open
- `cell click btn=… armed=… entry=…` — tap-tap state per tap
- `AssignEntry pickerButton=… entry=…` — assignment entry (nil pickerButton
  = the first-open bug regressed)
- `assigned item/spell '…' to btn N (slot N)` + `slot N now type=… id=…` —
  assignment result + verification
- `spell tabs: …` / `N candidates (X spells, Y mounts, Z profs)` / `kept: …` /
  `candidate-rejected: …` — spell scan summary
- `profession <name> (rank r/m) offset=… num=…` — profession detection
  (or `professions API stripped — tooltip tab fallback` + `profession tab …`)
- `stance-scan: <spell> requires '<x>' -> FILTER/keep` — stance heuristic
- `tooltip ERROR: …` / `OpenPicker ERROR: …` — pcall-trapped failures

## In-game verification checklist

1. **The `OnMouseDown` script on the stock button doesn't taint the tap path**
   — assign a hearthstone to a strip button, tap it, and confirm no
   `'UseAction()'` taint error appears in the debug ring (`/mui debug`,
   "slot N now type=item id=…").
2. **`PickupContainerItem` → `PlaceAction` assigns cleanly** — the
   `GetActionInfo` debug line confirms the slot write.
3. **Spell pickup name** — the log line shows which of
   `PickupSpellBookItem`/`PickupSpell` ran; verify a buff spell assigns and
   casts.
4. **Slot mapping 6–11 → 66–71** — confirmed by the `GetActionInfo` debug
   line.
5. **No dangling cursor item on dismiss** — hold a filled button, dismiss
   the picker, and the slot's item should stay in the slot (re-placed).
6. **LBF circular skin on the strip buttons** — native icon/cooldown/count
   still display (stock OnEvent kept) with no combat taint errors.
7. **Strip size** — the `applied 6 button(s) size=…` log line shows whether
   the 64px target fit or shrank; adjust the window or `TARGET_SIZE` if the
   size looks off.
8. **Profession detection** — the log shows `profession Enchanting (rank …)
   offset=… num=…` (or the tooltip-tab fallback). The picker's Professions
   column lists the skill + sub-skills; assigning the skill and tapping it
   opens the profession window.

The debug ring (`MobileUIDebugLog` SavedVariable, on disk after `/reload`
or logout) is the source of truth — no chat prints.

## Files

- `MobileUIDynamicBar.lua` — the module (strip + picker + assignment)
- `MobileUILayout.lua` — guard skip (`HideBar2Tail`), apply step, revert
  hook, exposed `SkinButton`/`UnskinButton`
- `MobileUI.lua` — default, slash command, options handler
- `MobileUIOptions.xml` — checkbox
- `MobileUI.toc` — file list, version bump
