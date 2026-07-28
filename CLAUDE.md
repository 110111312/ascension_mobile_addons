# MobileUI - Mobile-Optimized UI for Ascension WoW

## Project Overview

**MobileUI** is a minimal standalone WoW addon (patch 3.3.5a / WotLK) for **Ascension WoW**.

The player streams WoW from a Windows PC to a mobile phone via **Apollo/Artemis** streaming. The PC runs at desktop resolutions (~1300x900), so on a phone screen all UI elements appear very small.

**Goal:** Make the UI readable and usable on mobile by scaling up the entire UI, with room for future mobile features (layout presets, chat toggle, touch-friendly controls).

### Relationship to MoveAnything

- `MoveAnything/` — Original addon by Wagthaa, kept as **reference only**. Do not modify.
- `MobileUI/` — New minimal addon built from scratch (3 files, ~165 lines).
- MobileUI does NOT use MoveAnything's code. MoveAnything is only a reference for how WoW 3.3.5a addons are structured (toc, saved variables, options panels, event handling).

## Architecture

### Files

| File | Lines | Purpose |
|------|-------|---------|
| `MobileUI.toc` | 8 | Addon manifest, saved variables declaration |
| `MobileUI.lua` | 98 | Core logic: events, scale, slash commands, options handlers |
| `MobileUIOptions.xml` | 59 | Interface options panel with scale slider |

### Saved Variable

| Variable | Scope | Purpose |
|----------|-------|---------|
| `MobileDB` | Account-wide | `{ scale = 1.5 }` — the global UI scale multiplier |

### How It Works

The addon scales the entire UI by calling `UIParent:SetScale(scale)`. All UI frames (action bars, unit frames, minimap, chat, bags, tooltips, etc.) are children of `UIParent` and inherit the scale. The 3D world view (`WorldFrame`) is not affected.

- **Scale range:** 1.0 to 3.0 (step 0.05)
- **Default:** 1.5 (good starting point for 1300x900 on phone)
- **Applied on:** `PLAYER_ENTERING_WORLD` (initial) and on user change

### Controls

- **Slash command:** `/mui <scale>` (e.g., `/mui 1.5`) or `/mui` to show current
- **Options panel:** Interface → MobileUI → UI Scale slider

## Progress Log

### ✅ Phase 1: Global UI Scale
- [x] Minimal addon structure (toc + lua + xml)
- [x] `UIParent:SetScale()` based global scaling
- [x] Slash command `/mui`
- [x] Options panel with slider
- [x] Default 1.5x, range 1.0-3.0

### 🔲 Phase 2: Layout Presets
- Mobile-friendly layout (action bars at bottom, minimap repositioned)
- One-tap preset switching

### 🔲 Phase 3: Chat Toggle
- Show/hide chat with slash command or keybind
- Chat scaling

### 🔲 Phase 4: Touch-Friendly Controls
- Larger click hitboxes
- Quick-access mobile toolbar