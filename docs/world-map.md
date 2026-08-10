# World Map — Full-Width Map + Tap-Marker Quest Panel

Feature: `MobileUIWorldMap.lua` (split across three files). Turns the stock
3.3.5a world map into a full-width map with no quest list; tapping a numbered
quest marker opens a right-side panel with that quest's log (objectives) and
rewards.

- `MobileUIWorldMap.lua` — lifecycle, layout, hooks (this doc's main subject)
- `MobileUIWorldMapPanel.lua` — the tap-marker quest panel (popover)
- `MobileUIWorldMapMarkers.lua` — quest marker anchoring + repositioning

## Stock 3.3.5a world map layout (what we replace)

Sourced from the shipped FrameXML (`WorldMapFrame.lua` / `WorldMapFrame.xml`,
via the `wowgaming/3.3.5-interface-files` GitHub mirror — the live FrameXML is
inside the game's MPQ archives, not loose on disk).

The map opens in **quest-list view** (`WORLDMAP_QUESTLIST_SIZE = 0.691`):

- `WorldMapDetailFrame` (1002×668) scaled to 0.691, anchored
  `TOPLEFT` of `WorldMapPositioningGuide` (1024×768, centered) at `(-726, -99)`.
- `WorldMapQuestScrollFrame` (283 wide) — the quest list on the right.
- `WorldMapQuestDetailScrollFrame` + `WorldMapQuestRewardScrollFrame` (199 tall
  each) — the selected quest's description + rewards at the bottom.
- The numbered quest markers are buttons on `WorldMapPOIFrame` (1002×668,
  anchored to `WorldMapDetailFrame`), created by `QuestPOI_DisplayButton`
  (`QuestPOI.lua`), named `poiWorldMapPOIFrame1_<n>`, `OnClick =
  WorldMapQuestPOI_OnClick`.

### The stock "full map" view already exists

`WorldMapFrame_SetFullMapView()` (`WorldMapFrame.lua:1500`) does almost exactly
what we want: sets `WORLDMAP_SETTINGS.size = 1.0`, scales the map frames to
1.0, repositions the map to fill the width (`TOPLEFT` of guide `TOP` at
`(-502, -69)`), and **hides** the quest list + detail + reward scroll frames.

`ApplyFullMapLayout` then **re-pins the map to the screen top**
(`WorldMapDetailFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)`): the stock
anchor leaves the map's top below the screen top on this 1128×634 resolution,
cropping the bottom of the map — where many quest objectives sit — off-screen
(that's why uncompleted quest markers existed in the log but were invisible).

Two problems with using it as-is:

1. It is only invoked when there are **no** quests. With quests,
   `WorldMapFrame_DisplayQuests` calls `WorldMapFrame_SetQuestMapView()` to
   switch back to the quest-list layout.
2. It hides the quest markers too (`WorldMapFrame_DisplayQuests` hides
   `WorldMapPOIFrame` / `WorldMapBlobFrame` / `WorldMapTrackQuest` when there
   are no quests, and the quest-list view is forced when there are).

## What the module does

Hooks (all `hooksecurefunc`, gated by an `enabled` flag so Revert is clean):

| Hook | Why |
|------|-----|
| `WorldMapFrame_OnShow` | Re-assert the full-map layout every time the map opens |
| `WorldMapFrame_OnHide` | Hide the quest panel when the map closes |
| `WorldMapFrame_SetQuestMapView` | The stock code switches back to the quest-list view whenever quests exist — bounce straight back to full-map |
| `WorldMapFrame_DisplayQuestPOI` | Stock anchors every marker with the quest-list (0.691) scale baked in; re-anchor with 1.0-scale math in full-map view (see gotcha below). Lives in `MobileUIWorldMapMarkers.lua` |
| `WorldMap_ToggleSizeDown` | Never let the map drop to windowed (mini) mode |
| `WorldMapQuestPOI_OnClick` | After the stock handler selects the quest, populate + show the right-side panel |

`ApplyFullMapLayout()` (called from the hooks):

1. If the map is in windowed mode, `WorldMap_ToggleSizeUp()` first.
2. `WorldMapFrame_SetFullMapView()` — stock full-map layout (map at 1.0,
   already filling the screen); then `WorldMapFrame_SetPOIMaxBounds()` so the
   stock marker clamp bounds match the 1.0 view.
3. **Scale the map's text + markers** (see gotcha below) — the map frame
   itself stays at 1.0.
4. Re-show `WorldMapPOIFrame`, `WorldMapBlobFrame` (scaled to 1.0),
   `WorldMapTrackQuest`; hide `WorldMapFrameSizeDownButton`.
5. **Re-position the quest markers** (see gotcha below) — pure 1.0-scale
   math, markers stay at 1.0 scale.
6. Refresh the quest panel if it is open.

## Gotcha: the big-window map is detached from UIParent

`WorldMap_ToggleSizeUp()` (`WorldMapFrame.lua:1313`) calls
`WorldMapFrame:SetParent(nil)` — the big-window map is **not** a child of
UIParent, so the global 1.2 UI scale (`UIParent:SetScale(1.2)` in
`MobileUI.lua`) never reaches it. The map content renders at 1.0 effective
while the rest of the UI is at 1.2, which is why the map text + components
looked small.

The map texture already fills the screen at 1.0, so scaling the whole frame
(`WorldMapFrame:SetScale(1.2)`) would push it off-screen. Instead,
`ApplyFullMapLayout` scales only the text + interactive elements:

- `WorldMapFrameAreaFrame` (zone label + sub-zone text, 62px/26px fonts) →
  `SetScale(1.2)`. It is a 400×128 child of `WorldMapDetailFrame` containing
  both FontStrings; scaling it brings the text up to 1.2 effective (1.5 was
  too big and broke the layout).
- Map chrome widgets (the dropdown bar the user calls the "header":
  `WorldMapContinentDropDown`, `WorldMapZoneDropDown`,
  `WorldMapZoneMinimapDropDown`, `WorldMapLevelDropDown`, plus
  `WorldMapZoomOutButton`, `WorldMapLevelUpButton`, `WorldMapLevelDownButton`,
  `WorldMapFrameCloseButton`, `WorldMapTrackQuest`,
  `WorldMapQuestShowObjectives`) → `SetScale(1.2)`. These are **not**
  children of `WorldMapDetailFrame`, so they stay at 1.0 effective while the
  map is detached; `CHROME_FRAMES` lists them and both Apply and Revert
  iterate it. (1.5 was too big and shifted the layout.)
- Quest markers → **must stay at `SetScale(1.0)`** — scaling them (1.5 was
  tried for a bigger tap target) **shifts their resolved position** down and
  right of the blobs. Tap target is instead enlarged via
  `poi:SetHitRectInsets(0,0,0,0)` (see the marker gotcha below).
- The quest panel → `SetScale(1.2)` so its text matches the scaled map text.

`ApplyFullMapLayout` also **forces the "Show Objectives" checkbox on**
(`WorldMapQuestShowObjectives:SetChecked(true)` + `SetCVar("questPOI", 1)` +
`WorldMapQuestShowObjectives_Toggle()`). That checkbox gates ALL quest
markers (`WorldMapFrame_UpdateMap` only calls `DisplayQuests` when
`WatchFrame.showObjectives` is true), and it sits off-screen in this layout
so the user can't toggle it — without this, tracked quests never appear on
the map.

The map frame, texture, blob hit area and `WorldMapButton` all stay at 1.0.
Click handling is scale-safe: `WorldMapButton_OnClick` and
`WorldMapBlobFrame_CalculateHitTranslations` divide by `GetEffectiveScale()`
/ recompute from their own dimensions.

`Revert()` restores the area frame and panel to 1.0 and markers to 1.0.

## Gotcha: stock full-map view has no quest-marker mode

`WorldMapFrame_DisplayQuestPOI` (stock `WorldMapFrame.lua`) hardcodes the
quest-list scale factor for **every** non-windowed view:

```lua
if ( WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE ) then
    POIscale = WORLDMAP_WINDOWED_SIZE;      -- 0.573
else
    POIscale = WORLDMAP_QUESTLIST_SIZE;     -- 0.691, also used in full-map view
end
posX = posX * WorldMapDetailFrame:GetWidth() * POIscale;
posY = -posY * WorldMapDetailFrame:GetHeight() * POIscale;
```

There is no `WORLDMAP_FULLMAP_SIZE` (1.0) branch, and stock
`WorldMapFrame_DisplayQuests` never shows markers in full-map view (it
switches back to the quest-list view when quests exist, or hides
`WorldMapPOIFrame` when there are none). So forcing full-map + markers means
every stock-computed offset is 30.9% too small and the numbers cluster
toward the top-left of the map.

The fix hooks `WorldMapFrame_DisplayQuestPOI` itself (it is the **only**
place stock anchors map markers, so the hook covers every quest update, zone
change and `QUEST_POI_UPDATE`). When the full-map view is active it re-sets
each marker's anchor with 1.0-scale math — `posX = normX *
WorldMapDetailFrame:GetWidth()`, `posY = -normY *
WorldMapDetailFrame:GetHeight()` — plus the same border clamping as stock
evaluated at 1.0 (min 12 / -12, max `w+12` / `-h+12`).

### Gotcha: markers must be children of `WorldMapButton` and stay at 1.0 scale

Stock anchors every marker to `WorldMapPOIFrame`, which is a child of
`WorldMapFrame` anchored `TOPLEFT` to `WorldMapDetailFrame`. The markers are
children of the POI frame, so their anchors resolve in the **POI frame's
coordinate space** — and that space is unreliable: the POI frame is never
re-laid-out when the detail frame moves, so its layout position diverges from
what `GetLeft/GetTop` reports. (The zone blobs were always correct because
`WorldMapBlobFrame` is a child of the *detail* frame and is client-drawn in
map-texture space.)

The fix re-parents the markers to **`WorldMapButton`** — the same parent as
the player arrow, which renders correctly at `detail_reported + anchor`.
Markers resolve in that same correct space, so **no offset is needed**: pure
1.0-scale math (`posX = normX * 1002`, `posY = -normY * 668`) lands the
numbers dead-center on the blobs. Two places set the anchors:

- the `DisplayQuestPOI` hook (primary, fires on every stock positioning pass),
- `RepositionPOIs()` (defensive re-assert, deferred one frame via a one-shot
  `OnUpdate` timer because stock lays the marker buttons out in the same
  frame the detail frame moves).

**The marker scale must stay at 1.0.** `poi:SetScale(1.5)` — added to make a
48px phone tap target — **shifts the marker position** down and to the right
of the blob (it is not a pure visual scale; it changes the resolved layout
position). This single mistake caused the entire offset-measurement saga:
with markers at 1.5, every measured offset (60,233 / 50,302) was
compensating for the scale artifact, and the numbers never sat on the blobs.
With markers at 1.0 the positions are correct instantly. The tap target is
kept usable via `poi:SetHitRectInsets(0,0,0,0)` (stock `QuestPOITemplate`
has 8px insets on every side, shrinking the clickable area to 16×16).

The completed-quest swap button (`poiWorldMapPOIFrame_Swap`) is re-parented
along with the markers (it is anchored to its poiButton and must share its
space). `Revert()` re-parents everything back to `WorldMapPOIFrame` so stock
anchors work again in the quest-list view.

> Earlier attempts (all caused by the 1.5 marker scale shifting positions):
> (1) a `dx`/`dy` "implied anchor" correction measured from
> `poi:GetLeft()/GetTop()` in the same frame as `SetPoint` — reads the previous
> layout's position, unreliable; (2) a two-pass measurement of the POI frame's
> stale offset — worked only when the first anchored marker was a shown
> (uncompleted) quest, and failed at map-open when the first quest was a
> completed one with a hidden icon; (3) anchoring to the detail frame by name
> while leaving the markers parented to the POI frame — the anchor still
> resolved through the POI frame's stale space; (4) re-parenting to the detail
> frame alone — necessary but not sufficient, the hierarchy offset remained;
> (5) re-parenting to `WorldMapBlobFrame` — the blob frame's Lua layout
> position is just as stale as the detail frame's; (6) a GetCenter-based offset
> measurement cached in `MobileDB` — measured (60,233) instead of the true
> offset because the marker's `GetCenter()` mixes coordinate spaces. All of
> these were chasing the 1.5-scale position shift; with markers at 1.0 the
> pure-math anchors are correct with no measurement at all.

## Quest panel (popover)

Lives in `MobileUIWorldMapPanel.lua`. A 300-wide frame
(`MobileUIWorldMapQuestPanel`), child of `WorldMapFrame`,
frame level 200 (above the map at 87 and the POI markers at ~188).
Semi-transparent tooltip-style backdrop, close button.

It is a **popover**, not a full-height side panel:

- **Auto-height** — `RefreshPanel` sizes the panel to its content (title +
  level + objectives + rewards + extras), capped at `MAX_PANEL_HEIGHT` (440);
  taller quests clip. The y cursor is computed from the title/level font
  heights, not `GetTop/GetBottom` (those return nil while the panel is
  hidden — `RefreshPanel` runs before the panel is shown).
- **Draggable** — grab anywhere on the panel (except the close button) to move
  it off the map; the drag re-anchors to `UIParent` and the position persists
  across map opens.
- **Dismissible** — close button, and it hides automatically when the map
  closes (`OnHide` hook).
- Anchored `TOPRIGHT` of `WorldMapFrame` at `(-8, -40)` (below the map's
  close button), scaled 1.2 to match the map text.

Populated from documented quest-log APIs only
(`reference/wowprogramming/markdown/api/g-get-q.md` / `g-get-n.md`):

- `GetQuestLogTitle(questLogIndex)` — title + level (title colored by
  `GetQuestDifficultyColor`).
- `GetNumQuestLeaderBoards(questLogIndex)` + `GetQuestLogLeaderBoard(i, idx)` —
  objective progress; finished objectives green. Completed quests show
  `GetQuestLogCompletionText(questLogIndex)` instead.
- `GetNumQuestLogRewards()` + `GetQuestLogRewardInfo(i)` — item rewards with
  icons, colored by `ITEM_QUALITY_COLORS`.
- `GetQuestLogRewardMoney()` / `GetQuestLogRewardXP()` /
  `GetQuestLogRewardTitle()` / `GetQuestLogRewardHonor()` /
  `GetQuestLogRewardArenaPoints()` — reward extras.
- `GetQuestLogRewardFactionInfo()` — no documented signature; wrapped in
  `pcall`.
- `GetNumQuestLogChoices()` + `GetQuestLogChoiceInfo(i)` — "choose one of"
  rewards, shown as a `Choice: a / b / c` line.

The "selected quest" APIs need the quest selected in the quest log, so
`RefreshPanel` calls `SelectQuestLogEntry(questLogIndex)` first (the stock POI
click handler already did this; it is idempotent).

## Integration

- `MobileUI.toc` — `MobileUIWorldMap.lua`, `MobileUIWorldMapPanel.lua` and
  `MobileUIWorldMapMarkers.lua` load before `MobileUILayout.lua`.
- `MobileUILayout:Apply()` — `step("ApplyWorldMap", MobileUIWorldMap.Apply)`.
- `MobileUILayout:Revert()` — `MobileUIWorldMap:Revert()` (restores the stock
  quest-list view if the map is open).

## Notes / limitations

- The map texture is a fixed 256px-tile grid (4×3 = 1024×768 for most zones)
  drawn at native size and clipped by `WorldMapDetailFrame` (1002×668). The
  stock full-map view is already tuned for this; we reuse it rather than
  resizing the frame (resizing would change the crop / show empty space).
- The quest panel is a popover that overlays the map (the map fills the full
  width). It is dismissible via its close button and draggable; it does not
  auto-open.
- `GetQuestLogIndexByID` / `GetQuestID` are **not** in the API reference, so
  the module never relies on them — it uses `questFrame.questLogIndex` (set by
  the stock `WorldMapFrame_UpdateQuests`) and index-based APIs.
- Ascension is a private server: the exact frame names / hook targets were
  verified against the stock 3.3.5a FrameXML mirror, but should be confirmed
  in-game on first load (watch the debug log for hook failures).
