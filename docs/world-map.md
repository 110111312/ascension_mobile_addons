# World Map — Full-Width Map + Tap-Marker Quest Panel

Feature: `MobileUIWorldMap.lua`. Turns the stock 3.3.5a world map into a
full-width map with no quest list; tapping a numbered quest marker opens a
right-side panel with that quest's log (objectives) and rewards.

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
| `WorldMap_ToggleSizeDown` | Never let the map drop to windowed (mini) mode |
| `WorldMapQuestPOI_OnClick` | After the stock handler selects the quest, populate + show the right-side panel |

`ApplyFullMapLayout()` (called from the hooks):

1. If the map is in windowed mode, `WorldMap_ToggleSizeUp()` first.
2. `WorldMapFrame_SetFullMapView()` — stock full-map layout.
3. Re-show `WorldMapPOIFrame`, `WorldMapBlobFrame` (scaled to 1.0),
   `WorldMapTrackQuest`; hide `WorldMapFrameSizeDownButton`.
4. **Re-position the quest markers** (see gotcha below).
5. Refresh the quest panel if it is open.

## Gotcha: POI positions are scale-dependent

`WorldMapFrame_DisplayQuestPOI` positions each marker as
`posX = normX * WorldMapDetailFrame:GetWidth() * WORLDMAP_SETTINGS.size`
(0.691 in quest-list view). In our full-map view the map is at 1.0, so the
stock positions would cluster every marker in the top-left 69% of the map.

`RepositionPOIs()` recomputes each marker from its quest's normalized coords
(`QuestPOIGetIconInfo(questId)` → `_, posX, posY`) at 1.0 scale, with the same
clamping the stock code applies (min 12 / max `frameSize + 12`). It iterates
`WorldMapQuestFrame1..N` (each has `.poiIcon` and `.questId`).

## Quest panel

A 300-wide frame (`MobileUIWorldMapQuestPanel`), child of `WorldMapFrame`,
anchored to the right edge, frame level 200 (above the map at 87 and the POI
markers at ~188). Semi-transparent tooltip-style backdrop, close button.

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

- `MobileUI.toc` — `MobileUIWorldMap.lua` loads before `MobileUILayout.lua`.
- `MobileUILayout:Apply()` — `step("ApplyWorldMap", MobileUIWorldMap.Apply)`.
- `MobileUILayout:Revert()` — `MobileUIWorldMap:Revert()` (restores the stock
  quest-list view if the map is open).

## Notes / limitations

- The map texture is a fixed 256px-tile grid (4×3 = 1024×768 for most zones)
  drawn at native size and clipped by `WorldMapDetailFrame` (1002×668). The
  stock full-map view is already tuned for this; we reuse it rather than
  resizing the frame (resizing would change the crop / show empty space).
- The quest panel overlays the right edge of the map (the map fills the full
  width). It is dismissible via its close button; it does not auto-open.
- `GetQuestLogIndexByID` / `GetQuestID` are **not** in the API reference, so
  the module never relies on them — it uses `questFrame.questLogIndex` (set by
  the stock `WorldMapFrame_UpdateQuests`) and index-based APIs.
- Ascension is a private server: the exact frame names / hook targets were
  verified against the stock 3.3.5a FrameXML mirror, but should be confirmed
  in-game on first load (watch the debug log for hook failures).
