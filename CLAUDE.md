# MobileUI - Mobile-Optimized UI for Ascension WoW

## Project Overview

**MobileUI** is a minimal standalone WoW addon (patch 3.3.5a / WotLK) for **Ascension WoW**.

The player streams WoW from a Windows PC to a mobile phone via **Apollo/Artemis** streaming. The PC runs at desktop resolutions (~1300x900), so on a phone screen all UI elements appear very small.

**Goal:** Make the UI readable and usable on mobile by scaling up the entire UI, with room for future mobile features (layout presets, chat toggle, touch-friendly controls).

### Relationship to MoveAnything

- `MoveAnything/` — Original addon by Wagthaa, kept as **reference only**. Do not modify.
- `MobileUI/` — New minimal addon built from scratch (5 files, ~1000 lines).
- MobileUI does NOT use MoveAnything's code. MoveAnything is only a reference for how WoW 3.3.5a addons are structured (toc, saved variables, options panels, event handling).

## Architecture

### Files

| File | Lines | Purpose |
|------|-------|---------|
| `MobileUI.toc` | 10 | Addon manifest, saved variables declaration |
| `MobileUI.lua` | ~178 | Core: saved vars, fixed UI scale (1.2x, minimap 1.25x), mouse-look speed, slash commands, options handlers, init dispatch |
| `MobileUIChat.lua` | ~144 | Chat toggle: chat-bubble button, reparent-hide technique |
| `MobileUILayout.lua` | ~582 | 5-point mobile layout revamp: map, menu bar, bags, action bar, player HP/MP |
| `MobileUIOptions.xml` | ~96 | Interface options panel: look-speed slider + layout checkbox (no scale slider — scale is fixed) |

### Saved Variable

| Variable | Scope | Purpose |
|----------|-------|---------|
| `MobileDB` | Account-wide | `{ chatHidden, lookSpeed, layoutEnabled, bubbleX/Y/Point/RelPoint }` — chat-hidden flag, mouse-look speed, layout toggle, saved chat-bubble position |

### How It Works

The addon scales the entire UI by calling `UIParent:SetScale(1.2)`. All UI frames (action bars, unit frames, minimap, chat, bags, tooltips, etc.) are children of `UIParent` and inherit the scale. The 3D world view (`WorldFrame`) is not affected.

- **Scale is fixed at 1.2** — no slider, no slash option (removed; was 1.0–3.0).
- **Minimap exception:** `MinimapCluster` gets `SetScale(1.25/1.2)` so its *effective* scale is 1.25 — slightly bigger than the rest for readability on a phone.
- **Applied on:** `PLAYER_ENTERING_WORLD` (idempotent)

### Mouse Look Speed

WoW's `cameraYawMoveSpeed` cvar controls how fast the camera turns during mouse look (right-click-drag, which is what Artemis multi-touch maps to). The in-game slider (Interface → Mouse → Mouse Look Speed) ranges 90–270, so 90 is both the default and the minimum — you **cannot** make it less sensitive via the game UI.

MobileUI exposes a slider going **below** 90 (range 10–90, step 5), using `SetCVar()` directly. Lower values mean you must swipe a longer distance to turn the same amount — critical for phone use where a short thumb swipe spins the camera too far.

- Sets `cameraYawMoveSpeed` to the slider value and `cameraPitchMoveSpeed` to value/2 (matching WoW's convention)
- **Default:** 90 (= WoW default, no-op until user changes it)
- **Applied on:** `PLAYER_ENTERING_WORLD` (initial) and on user change

### Controls

- **Slash command:** `/mui look <10-90>`, `/mui chat`, `/mui layout`, or `/mui` to show current state
- **Options panel:** Interface → MobileUI → Look Speed slider + Mobile Layout checkbox
- **Chat toggle:** a dedicated chat-bubble button (`MobileUIChatBubble`) in the bottom-left corner, above the action bar. Click it to completely hide the whole chat UI (chat frame, tabs, dock, chat-menu & social buttons); click again to restore. Also `/mui chat`. **Drag** the button to reposition it (saved per-account) — useful to clear taller action bars like DragonUI's.

## Progress Log

### ✅ Phase 1: Global UI Scale (now fixed)
- [x] Minimal addon structure (toc + lua + xml)
- [x] `UIParent:SetScale()` based global scaling
- [x] Slash command `/mui`
- [x] Options panel with slider (later removed)
- [x] Default 1.2x, range 1.0-3.0
- [x] Scale now **fixed at 1.2x** (slider + `/mui <scale>` removed); minimap exception at effective 1.25x

### ✅ Phase 2: Mobile Layout Revamp
- [x] Map: MinimapCluster moved from top-right to top-left
- [x] Menu bar: 10 micro buttons → top-right horizontal circle row (26px)
- [x] Bags: single backpack icon at bottom-left; click opens all bag windows repositioned to the left side
- [x] Action bar: ActionButton1-12 → 4-layer concentric scatter in bottom-right quarter-circle (60/48/40/32px)
- [x] Player HP/MP: PlayerFrame → bottom-center long bars (280px), no portrait
- [x] Bottom-bar art, extra action bars, exp bar hidden
- [x] Reversible via `/mui layout` or options checkbox — original frame state saved & restored
- [x] Combat-safe: defers apply/revert when in combat (SecureActionButton lockdown)

### ✅ Phase 3: Chat Toggle
- [x] Dedicated chat-bubble button (`MobileUIChatBubble`) at bottom-left, above the action bar
- [x] Click to completely hide the whole chat UI; click again to restore
- [x] Bulletproof against Blizzard re-showing chat on combat/relog: chat frames are reparented onto a hidden frame (hidden parent => never renders), instead of `:Hide()`
- [x] Covers all chat chrome: ChatFrame1..N (+ their background/scroll-buttons/edit-box children), tabs, GENERAL_CHAT_DOCK, FriendsMicroButton, ChatFrameMenuButton
- [x] State persisted in `MobileDB.chatHidden` (survives relogs)
- [x] Slash command `/mui chat` to toggle; `/mui` reports chat state
- [x] Bubble is draggable; position saved in `MobileDB.bubbleX/Y/Point/RelPoint` (clears taller action bars like DragonUI's)
- [x] Chat movability preserved — reparenting only changes the parent, not the `movable` flag / drag scripts
- [ ] Chat scaling (separate from global scale)

### ✅ Phase 4: Mouse Look Speed
- [x] Slider in options panel (Interface → MobileUI → Mouse Look Speed, range 10–90, step 5)
- [x] Sets `cameraYawMoveSpeed` (yaw) and `cameraPitchMoveSpeed` (yaw/2) via `SetCVar()`
- [x] Persists in `MobileDB.lookSpeed` (survives relogs)
- [x] Applied on `PLAYER_ENTERING_WORLD` (like scale)
- [x] Slash command `/mui look <10-90>`; `/mui` reports look speed
- [x] Default 90 = WoW default (no-op until user lowers it)

### 🔲 Phase 5: Touch-Friendly Controls
- Larger click hitboxes
- Quick-access mobile toolbar

## Documentation (in `doc/`)

Detail lives in the `doc/` folder — read these when working on the relevant area:

- [`doc/chat-internals.md`](doc/chat-internals.md) — WoW 3.3.5a chat frame internals: hierarchy, why `:Hide()` re-shows on combat/relog, the reparent technique, DragonUI bar caveat. Drives the Phase 3 chat toggle.
- [`doc/setup-and-workflow.md`](doc/setup-and-workflow.md) — on-disk paths (working repo, **game install addons folder** = Blizzard addons reference + live copy of our addon), the FrameXML-in-MPQ note, and the **sync workflow** for updating our addon into the game install folder.

### Development setup (summary)

- Working repo: `C:\W\ascension_mobile_addons` — edit `MobileUI/...` here.
- Game install addons (reference + live copy to keep in sync): `C:\Ascension\Launcher\resources\ascension-live\Interface\AddOns\` (contains default Blizzard addons and a copy of `MobileUI/`).
- After editing, copy the changed files into that folder and `/reload` in-game. Full detail + saved-vars gotcha in `doc/setup-and-workflow.md`.