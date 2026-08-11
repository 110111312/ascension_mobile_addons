# Tap = Use (removed — see notes)

**Status: removed in v2.7.0+ rework.** Tapping a "Use:" item (hearthstone,
potion, food) currently does **not** use it. This doc records why, what was
tried, and what any future mechanism must satisfy.

## Why it's hard — the protected use door

`UseContainerItem` / `UseItemByName` on the **use path** is taint-protected.
The client refuses to run it if *any* MobileUI code is on the call stack
when it executes:

```
AddOn 'MobileUI' tainted the call of the secure function 'UseItemByName()'
```

This is the only protected door in the whole bag interaction space.
Verified in-game:

- **Sell path** — not protected (merchant-open wins the dispatch). Tap=sell
  returns the item to its slot and sells via `UseContainerItem` cleanly.
- **Equip path** — not taint-checked in this client (a bag right-click
  through the wrapper errors "This item cannot be equipped" — a game-logic
  message, never a taint error).
- **Pickup/place** (`PickupContainerItem`) — not taint-checked.
- **Use path** — protected. Every attempted mechanism failed:
  - wrapper pass-through (even `securecall()`) → taint
  - addon-initiated `button:Click()` on a secure button → taint (the taint
    is inherited from the wrapper entry point, not the use mechanism)
  - per-item secure-button overlays → the only *theoretically* clean
    approach (a real finger-click lands on Blizzard's own
    `SecureActionButton_OnClick` with no addon on the stack), but the
    overlays were not receiving the clicks in-game (tap did nothing, hold
    still fell through to the wrapper and tainted), and the failure mode
    was never conclusively diagnosed.

## Current behavior (interim)

There is no click wrapper anymore (see `docs/bag-swap.md` — any wrapper on
`ContainerFrameItemButton_OnClick` poisons the session for hold-to-use). The
pickup-reaction poll (`MobileUIBagSwap`) leaves use-items entirely alone:

- **Hold** a "Use:" item → the stock handler runs directly, no MobileUI on
the stack, ever → **the item is used, cleanly** — every session, even
after tap=sell / tap=equip / bag-swap have been used.
- **Tap** a "Use:" item → pick-up (stock left-click behavior); the item
stays on the cursor. The pickup poll sees it, classifies it as a use-item
(not a bag, not equippable, not at a merchant) and does nothing.

## What a future "tap to use" mechanism must satisfy

The only known-clean path is a **real user click on a secure button** whose
`OnClick` is Blizzard's own `SecureActionButton_OnClick` (`type="item"`),
with no addon code on the stack. Any design that routes the use through
MobileUI code (wrapper, `:Click()`, `securecall`) taints.

The pickup reaction is the natural seam: when it detects a pickup of a
use-item (`IsUsableItem`, i.e. `GetItemSpell(link) ~= nil` — the helper is
still in `MobileUIBagSwap.lua`), the "everything else" branch currently
leaves the item on the cursor. A future mechanism could route that pickup
to a secure-button activation instead. Candidates:

- a secure button positioned under the cursor (one button tracking
  `GetMouseFocus()` instead of per-item overlays)
- a floating "USE" button at a fixed spot, loaded with the item on the
  cursor
- re-routing the pickup through a secure-button `:Click()` — note this
  tainted before, but from a *wrapper* entry point; from the poll it may
  behave differently and is worth re-testing

## Controls

- Toggle `/mui use` removed; slash now exposes `/mui equiptap` instead.
- Saved var `MobileDB.tapUse` no longer read.
- Options checkbox "Tap = Use" replaced by "Tap = Equip".

## Files

- `MobileUIBagSwap.lua` — the pickup poll; the "everything else" branch is
  the seam a future tap=use mechanism hooks into
- `docs/tap-equip.md` — the feature that replaced tap=use in the options UI
