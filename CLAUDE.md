# MobileUI - Mobile-Optimized UI for Ascension WoW

## Project Overview

**MobileUI** is a minimal standalone WoW addon (patch 3.3.5a / WotLK) for **Ascension WoW**.

The player streams WoW from a Windows PC to a mobile phone via **Apollo/Artemis** streaming. The PC runs at desktop resolutions (~1300x900), so on a phone screen all UI elements appear very small.

**Goal:** Make the UI readable and usable on mobile by scaling up the entire UI, with room for future mobile features (layout presets, chat toggle, touch-friendly controls).

### Relationship to MoveAnything

- `MoveAnything/` — Original addon by Wagthaa, kept as **reference only**. Do not modify.
- `MobileUI/` — New minimal addon built from scratch (3 files, ~290 lines).
- MobileUI does NOT use MoveAnything's code. MoveAnything is only a reference for how WoW 3.3.5a addons are structured (toc, saved variables, options panels, event handling).

## Architecture

### Files

| File | Lines | Purpose |
|------|-------|---------|
| `MobileUI.toc` | 8 | Addon manifest, saved variables declaration |
| `MobileUI.lua` | ~280 | Core logic: events, scale, mouse-look speed, chat-toggle bubble button (reparent-hide), slash commands, options handlers |
| `MobileUIOptions.xml` | ~75 | Interface options panel with scale slider + mouse-look-speed slider |

### Saved Variable

| Variable | Scope | Purpose |
|----------|-------|---------|
| `MobileDB` | Account-wide | `{ scale = 1.2, chatHidden = false, lookSpeed = 90, bubbleX/Y/Point/RelPoint }` — UI scale, chat-hidden flag, mouse-look speed, saved chat-bubble button position |

### How It Works

The addon scales the entire UI by calling `UIParent:SetScale(scale)`. All UI frames (action bars, unit frames, minimap, chat, bags, tooltips, etc.) are children of `UIParent` and inherit the scale. The 3D world view (`WorldFrame`) is not affected.

- **Scale range:** 1.0 to 3.0 (step 0.05)
- **Default:** 1.2 (tested good on phone)
- **Applied on:** `PLAYER_ENTERING_WORLD` (initial) and on user change

### Mouse Look Speed

WoW's `cameraYawMoveSpeed` cvar controls how fast the camera turns during mouse look (right-click-drag, which is what Artemis multi-touch maps to). The in-game slider (Interface → Mouse → Mouse Look Speed) ranges 90–270, so 90 is both the default and the minimum — you **cannot** make it less sensitive via the game UI.

MobileUI exposes a slider going **below** 90 (range 10–90, step 5), using `SetCVar()` directly. Lower values mean you must swipe a longer distance to turn the same amount — critical for phone use where a short thumb swipe spins the camera too far.

- Sets `cameraYawMoveSpeed` to the slider value and `cameraPitchMoveSpeed` to value/2 (matching WoW's convention)
- **Default:** 90 (= WoW default, no-op until user changes it)
- **Applied on:** `PLAYER_ENTERING_WORLD` (initial) and on user change

### Controls

- **Slash command:** `/mui <scale>` (e.g., `/mui 1.2`), `/mui look <10-90>` (e.g., `/mui look 30`), `/mui chat` to toggle the chat, or `/mui` to show current state
- **Options panel:** Interface → MobileUI → UI Scale slider + Mouse Look Speed slider
- **Chat toggle:** a dedicated chat-bubble button (`MobileUIChatBubble`) in the bottom-left corner, above the action bar. Click it to completely hide the whole chat UI (chat frame, tabs, dock, chat-menu & social buttons); click again to restore. Also `/mui chat`. **Drag** the button to reposition it (saved per-account) — useful to clear taller action bars like DragonUI's.

## Progress Log

### ✅ Phase 1: Global UI Scale
- [x] Minimal addon structure (toc + lua + xml)
- [x] `UIParent:SetScale()` based global scaling
- [x] Slash command `/mui`
- [x] Options panel with slider
- [x] Default 1.2x, range 1.0-3.0

### 🔲 Phase 2: Layout Presets
- Mobile-friendly layout (action bars at bottom, minimap repositioned)
- One-tap preset switching

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