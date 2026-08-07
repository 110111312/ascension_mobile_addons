# MobileUI — Mobile-Optimized UI for Ascension WoW

## What Is It

A WoW 3.3.5a addon for **Ascension WoW**, built for playing via **Apollo/Artemis** phone streaming. Scales the UI up, rearranges the layout for thumb reach, toggles chat, and lowers mouse-look sensitivity below the game's minimum.

## Repo Layout

| Path | What |
|------|------|
| `MobileUI/` | The addon itself (v2.1.0) |
| `docs/` | Feature docs — one doc per feature |
| `reference/MoveAnything/` | Reference addon, **do not modify** |
| `reference/wowprogramming/markdown/` | WoW 3.x API reference for AI agents. Start at `index.md`. |
| `reference/wowprogramming/crawl_resource/` | Crawl scripts + raw HTML. Not needed at runtime. |

## Docs Workflow

Each doc in `docs/` covers one feature. When a new request comes in:

1. **Check `docs/`** — find the doc for the feature you're touching.
2. **Read that doc** before making changes.
3. **Plan** (optional, for non-trivial work).
4. **Execute** the change.
5. **Update the related doc** to reflect what changed.

If no doc exists for the feature, create one.

## Tricky Parts

1. **Combat lockdown** — `SecureActionButton` frames can't be moved/shown/hidden in combat. Layout apply/revert **defers** until combat ends. Bottom-left bar buttons 6-12 are *parked off-screen* (not re-hidden) because the client re-shows them on combat entry and taint blocks re-hide during lockdown.
2. **Chat hide must use reparenting, not `:Hide()`** — Blizzard re-shows chat frames on combat/relog. Chat frames are reparented onto a hidden frame so they never render. See `docs/chat-internals.md`.
3. **Scale is fixed at 1.2** (minimap effective 1.25) — no slider, no slash option. Don't re-add one.
4. **Mouse look speed** goes below the game's minimum (90) via `SetCVar("cameraYawMoveSpeed", v)` directly. Range 10–90, default 90.
5. **Saved vars:** `MobileDB` (user settings) + `MobileUIDebugLog` (ring buffer, dev-only).
6. **Ascension is a private server** — customized 3.3.5a, so the WoW API reference in `reference/wowprogramming/` may not be 100% accurate. It'll work most of the time, but watch for server-specific differences.

## Rules

- **File cap: 600 lines** (200–400 typical). Split by feature when over. Vendored libs (`MobileUILib.lua`) are exempt.
- **Don't modify** anything in `reference/`.
- **After editing**, copy changed files to `C:\Ascension\Launcher\resources\ascension-live\Interface\AddOns\MobileUI\` and `/reload` in-game.
- **Working repo:** `C:\W\ascension_mobile_addons`