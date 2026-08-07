# Development Setup & Workflow

## Paths

### Working repo (this project) — `C:\W\ascension_mobile_addons`
- `MobileUI/`     — our addon (the code we edit): `MobileUI.toc`, `MobileUI.lua`,
  `MobileUIOptions.xml`.
- `reference/MoveAnything/` — original addon by Wagthaa, **reference only**. Never modify.
- `reference/wowprogramming/` — offline mirror of the WoW 3.x API reference
  (wowprogramming.com, Wayback Machine 2010-07-26 snapshot): API functions,
  events, widgets, and cvars.
- `docs/`         — feature docs (one doc per feature).

### Game install (what the running game actually loads)
- Addons folder: `C:\Ascension\Launcher\resources\ascension-live\Interface\AddOns\`
- Contains the default Blizzard addons (`Blizzard_AchievementUI`,
  `Blizzard_CombatLog`, `Blizzard_TalentUI`, …). These are a useful **reference**
  for how WoW 3.3.5a addons/UI are structured — do **not** edit them.
- Also contains a **copy of our `MobileUI/`** that the live game loads. This
  copy must be kept in sync with the working repo after edits (see workflow).

### Live FrameXML (Blizzard base UI source) — not loose on disk
- The base UI Lua/XML (`FloatingChatFrame.lua`, `ChatFrame.xml`, `UIParent.lua`,
  …) is packed inside MPQ archives under
  `C:\Ascension\Launcher\resources\ascension-live\Data\`
  (`common.MPQ`, `common-2.MPQ`, `patch-2..5.MPQ`, `patch-A/B.MPQ`, …).
- No MPQ extractor is installed here, so to read the base UI source use the
  `wowgaming/3.3.5-interface-files` GitHub mirror, e.g.:
  `https://raw.githubusercontent.com/wowgaming/3.3.5-interface-files/main/<File>.lua`
  (this is what was used for the chat-internals research; see
  `docs/chat-internals.md`).

## Workflow: editing the addon and testing in-game

1. **Edit** the files in the working repo (`MobileUI/...`).
2. **Sync** the changed files into the game install so the live game loads them.
   Keep all three files in sync (`MobileUI.toc`, `MobileUI.lua`,
   `MobileUIOptions.xml`):
   ```bash
   DEST=/c/Ascension/Launcher/resources/ascension-live/Interface/AddOns/MobileUI
   cp -v MobileUI/MobileUI.lua        "$DEST"/MobileUI.lua
   cp -v MobileUI/MobileUI.toc       "$DEST"/MobileUI.toc
   cp -v MobileUI/MobileUIOptions.xml "$DEST"/MobileUIOptions.xml
   ```
3. **Reload** the UI in-game: `/reload` (or restart the client). If you change
   `## SavedVariables` in the `.toc`, a full restart is required.
4. **Saved-variables gotcha:** `MobileDB` is account-wide and persists across
   sessions. The `DEFAULTS` table only fills keys that are `nil`, so existing
   accounts keep their old values. To force a fresh default (e.g. after
   changing a `DEFAULTS` value), either set it in-game once (e.g. `/mui look 90`), or delete
   the saved var file:
   `C:\Ascension\Launcher\resources\ascension-live\WTF\Account\<account>\SavedVariables\MobileUI.lua`
   then `/reload`.

## Reference rules
- `reference/MoveAnything/` and the Blizzard addons in the game install are **reference
  only** — never modify them.
- `reference/wowprogramming/` is the canonical WoW 3.x API reference (offline
  mirror of wowprogramming.com). Prefer it for API/event/widget/cvar lookups.
- When researching WoW 3.3.5a APIs/frame structure, prefer reading the live
  Blizzard addons (on disk) and the `wowgaming/3.3.5-interface-files` mirror
  (for packed FrameXML) before guessing.