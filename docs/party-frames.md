# Party Frames — Right-Edge Strip

> **⚠️ PARTIALLY TESTED.** Initial implementation was broken (container had
> no explicit size → frames rendered off-screen right; no re-assert → frames
> drifted back on disconnect). Fixed in v2.9.1: container now has
> `SetSize(128, 242)` and a 0.25s re-assert timer re-parents frames that drift
> back to UIParent. Needs full re-testing: verify party frames render in the
> right-edge strip, 4 members + pets fit, clicking members still works,
> layout toggle/revert restores the left-side column, and no secure-call
> errors appear in combat.

Feature: `MobileUIFrames.lua` (`ApplyPartyFrames` / `RevertPartyFrames`). Moves the stock 3.3.5a party
member frames off the left side (where they collided with the quest tracker
under the map) into the empty vertical strip on the right edge, scaled down
to fit.

## Stock 3.3.5a layout (what we replace)

Sourced from the shipped `PartyFrame.xml` (via the `wowgaming/3.3.5-interface-files`
mirror):

- `PartyMemberFrame1` is a `Button` (SecureUnitButtonTemplate, 128×53)
  anchored `TOPLEFT` of `UIParent` at `(10, -160)`.
- `PartyMemberFrame2-4` are each anchored `TOPLEFT` of the previous member's
  **pet frame** `BOTTOMLEFT` at `(-23, -10)`.
- The pet frame (`PartyMemberFrameNPetFrame`, 64×26) is anchored inside its
  member at `(20, -47)` and is always present (hidden when no pet), so the
  chain spacing is a constant **83 units per member** whether or not a pet
  exists. A pet simply fills the gap above the next member.

Result: a vertical column on the **left** side of the screen. With the map
at `TOPLEFT` (0,0), the quest tracker sits right under it — and the party
frames overlap that tracker.

The client never re-anchors the frames themselves:
`PartyMemberFrame.lua` only moves internal art textures (`Portrait`,
`LeaderIcon`, … on vehicle/pvp changes); visibility is owned by
`PartyMemberFrame_Update` on `PARTY_MEMBERS_CHANGED`. So one reposition at
apply time is stable, and the client keeps showing/hiding the frames as
members join/leave.

## What the module does

All four `PartyMemberFrame1-4` are **reparented into a single container**
frame (`MobileUIPartyFrame`) that the layout positions and scales:

1. **Container anchor:** `TOPRIGHT` of `UIParent` at `(-20, -140)` — right
   edge aligned with the action arc's rightmost column (button 15's right
   edge is also at -20). Moved down from `-90` (v2.9.x) then `-115` because
   the menu bar still overlapped member 1 on the phone stream; `-140` puts
   member 1 well below the 2-row menu bar (bottom edge at y≈75 at its
   effective 1.15 scale, see `menu-bar.md`).
2. **Container scale:** `PARTY_SCALE = 0.55` — a touch larger than the
   original 0.5. The container scale also scales the internal pet frame /
   debuff rows / fonts uniformly. (If the stack ever clips arc button 15 at
   the bottom with a full 4-member party, ease `PARTY_SCALE` back toward
   0.5.)
3. **Only frame 1 is re-anchored** (`TOPLEFT` of the container at 0,0).
   Frames 2-4 keep their stock pet-frame-relative anchors, so a member's
   pet still pushes the members below it down correctly, and the whole
   column (pet frames, debuff row, fonts, portrait, hit rect) scales
   uniformly with the container.
4. **Visibility is left to the client** — the layout never calls
   `Show()`/`Hide()` on the member frames. The client hides them in raids
   and solo (`GetNumPartyMembers()`), shows them on `PARTY_MEMBERS_CHANGED`,
   and reparenting does not taint, so its protected `Show()`/`Hide()` calls
   keep working.

## Why a container instead of per-frame anchors

- Scaling the container scales the member frames **and** all their children
  (portrait, bars, debuffs, pet frame, fonts) uniformly — per-frame
  `SetScale` would scale each member but leave the anchor offsets between
  them unscaled, misaligning the stack.
- Keeping the stock 2-4 chain (rather than giving every frame an absolute
  anchor) preserves pet-aware spacing for free.

## Combat / protected-frame notes

- The member frames are `SecureUnitButtonTemplate` (protected). All
  `SetParent` / `ClearAllPoints` / `SetPoint` / `SetScale` run **out of
  combat** — `Apply()`/`Revert()` already defer during lockdown.
- If a member joins mid-combat, the client's own `Show()` on the frame is
  allowed (protection only blocks addon calls) and the frame renders at the
  container position/scale.
- Clicking a member (target / right-click menu) works unchanged — the
  secure unit attributes live on the button, not the parent (same pattern
  as reparenting `ActionButton1-10` to UIParent and MoveAnything's virtual
  movers).

## Revert

`RevertPartyFrames()` hides the container, restores each frame's original
parent (`UIParent`) and anchor points (frame 1 → UIParent TOPLEFT (10,-160),
frames 2-4 → pet-frame chain). Shown state is deliberately **not** restored:
the client owns it and corrects it on the next `PARTY_MEMBERS_CHANGED`.

## Constants

```lua
local PARTY_MEMBER_FRAMES = { "PartyMemberFrame1", "PartyMemberFrame2",
                              "PartyMemberFrame3", "PartyMemberFrame4" }
local MENU_SCALE  = 1.15  -- 2x6 menu bar effective scale (was 1.2, overlapped buffs)
local PARTY_SCALE = 0.55  -- container TOPRIGHT offset is -20,-140
```

Tune `PARTY_SCALE` / the container `TOPRIGHT` offset to taste. `ApplyMenuBar`
and `ApplyPartyFrames` log the actual rendered edges (`MENUBAR: top/bottom`,
`PARTY: container top/bottom, member1 top`) to the `MobileUIDebugLog` ring
buffer — check `/mui debug` if overlap reports don't match the numbers here.
