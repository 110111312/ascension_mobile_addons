# WoW 3.3.5a Chat Internals — research notes

Findings that drove the `MobileUI` chat-toggle design. Sourced from the shipped
FrameXML (`FloatingChatFrame.xml` / `FloatingChatFrame.lua`, `ChatFrame.xml`,
`UIParent.lua`) and the `wowgaming/3.3.5-interface-files` GitHub mirror.

> The live FrameXML is **not** loose on disk — it lives inside the game's MPQ
> archives (`Data\common.MPQ`, `patch-*.MPQ`, …). There is no MPQ extractor in
> this environment, so the `wowgaming/3.3.5-interface-files` GitHub mirror
> (branch `main`, raw file URLs) is the practical reference for reading it.
> See `docs/setup-and-workflow.md` for the on-disk Blizzard addons path.

## Chat frame hierarchy (what is parented to what)

- `FloatingChatFrameTemplate` (`FloatingChatFrame.xml:505`):
  `inherits="ChatFrameTemplate,FloatingBorderedFrame" parent="UIParent" movable="true"`.
  So every `ChatFrameN` is a top-level frame on `UIParent` and is movable.
- `ChatFrame1` is created at `FloatingChatFrame.xml:871`, docked as the primary
  dock frame (`isStaticDocked = true`, `FCFDock_SetPrimary(GENERAL_CHAT_DOCK, self)`).
  Docked chat is locked by default (Blizzard behaviour) — undock to drag it.

### Children of `ChatFrameN` (hide along with it when reparented)

- `$parentBackground` + the border textures (`FloatingBorderedFrame` layers) =>
  `ChatFrameNBackground`, `ChatFrameNTopLeftTexture`, … listed in the global
  `CHAT_FRAME_TEXTURES` table (`FloatingChatFrame.lua:30`).
- `$parentButtonFrame` (`parentKey="buttonFrame"`, `FloatingChatFrame.xml:572`) =>
  the scroll up/down/bottom button frame (`ChatFrameNButtonFrame`) and its buttons.
- `$parentEditBox` (`parentKey="editBox"`, `FloatingChatFrame.xml:681`) =>
  `ChatFrameNEditBox`.
- `$parentResizeButton`, `$parentClickAnywhereButton`.

### Separate top-level frames on `UIParent`

- `ChatFrameNTab` — `ChatTabTemplate` (`parent="UIParent"`). When docked,
  Blizzard reparents the tab onto the dock's scroll child
  (`chatTab:SetParent(dock)` / `scrollChild`, `FloatingChatFrame.lua:2020/2089/2098`).
- `GENERAL_CHAT_DOCK` — `DockManagerTemplate` (`parent="UIParent"`); holds the
  tab strip. Its OnUpdate is `FCF_OnUpdate`.
- `ChatFrameMenuButton` (`parent="UIParent"`) — the speech-bubble chat-menu
  button, anchored `BOTTOM` to `ChatFrame1ButtonFrameUpButton TOP`. Uses
  `Interface\ChatFrame\UI-ChatIcon-Chat-Up` / `-Down` / `-Disabled`.
- `FriendsMicroButton` (`parent="UIParent"`) — social menu button, anchored
  above `ChatFrameMenuButton`.

## Why a plain `:Hide()` is unreliable (the combat/relog re-show bug)

- **Relog:** `FloatingChatFrame_Update(id, onUpdateEvent)`
  (`FloatingChatFrame.lua`) reads the saved `shown` flag via
  `FCF_GetChatWindowInfo` / `GetChatWindowInfo` and, if `shown`, calls
  `chatFrame:Show()`. This fires from the `UPDATE_CHAT_WINDOWS` event on load.
  Our `:Hide()` did not change the saved `shown` flag, so the chat reappeared on
  relog.
- **Combat / mouseover:** `FCF_FadeInChatFrame(chatFrame)` re-fades the
  background textures back in (it iterates `CHAT_FRAME_TEXTURES` and calls
  `UIFrameFadeIn`, which calls `frame:Show()`). The dock's `FCF_OnUpdate` also
  fades frames in when the cursor is over them.
- Result of the old per-piece `:Hide()`: the chat box reappeared, but the
  scroll-button frame we hid separately stayed hidden => inconsistent
  half-shown state.

## The reparent technique (what we use instead)

- Create a never-shown frame
  `chatHideContainer = CreateFrame("Frame", nil, UIParent); :Hide()`.
  Reparent the chat frames onto it to hide them.
- A frame whose **parent is hidden never renders**, no matter how often Blizzard
  calls `:Show()` on it. Also, `chatFrame:IsShown()` then returns false, so the
  dock's `FCF_OnUpdate` skips the frame entirely (`if chatFrame:IsShown() then …`).
- We remember each frame's original parent
  (`f._muiHiddenParent = f:GetParent()`) and restore it exactly on show —
  important because docked tabs are parented to the dock's scroll child, not
  `UIParent`.
- Zero hooks; survives combat, relog and `/reload`. `SetParent` does **not**
  change the `movable` flag or drag scripts, so movability is preserved.

## `UIFrameFadeIn` calls `frame:Show()`

- `UIFrameFade(frame, fadeInfo)` (`UIParent.lua`) always executes
  `frame:Show()` before animating alpha. So any frame managed by the chat dock's
  fade can be re-shown by a fade-in trigger — another reason the reparent
  approach (hidden parent) beats per-frame `:Hide()`.

## Action-bar height caveat (DragonUI)

- The default bottom action bar (`MainMenuBar`) is ~40–43 UI units tall;
  `MobileUI`'s chat-bubble button originally defaulted to `y=52` to clear it.
  With **DragonUI** enabled the bottom action bar is taller and covered the
  button. The bubble is **fixed** at the coded position (not draggable):
  layout on → `BOTTOMLEFT (10, 62)` (just above the bag icon), layout off →
  `BOTTOMLEFT (2, 64)`. The layout-off default must clear the taller DragonUI
  bar — if a future bar-height change covers it again, raise the `y` default
  in `MobileUI:PositionChatBubble()` rather than re-adding drag.