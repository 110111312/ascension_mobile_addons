# Ascension Mobile Addons

WoW 3.3.5a addons for [Ascension WoW](https://ascension.gg), optimized for mobile streaming (Apollo/Artemis).

## MobileUI

Scales up the entire WoW UI for mobile screens, and lowers mouse-look sensitivity for better touch/swipe control.

- `/mui <1.0-3.0>` — set UI scale (e.g., `/mui 1.5`)
- `/mui look <10-90>` — set mouse look speed (e.g., `/mui look 30`; lower = less sensitive, longer swipe to turn)
- `/mui chat` — toggle chat UI on/off
- `/mui` — show current state
- Interface → MobileUI → UI Scale slider + Mouse Look Speed slider

### Mouse Look Speed

When streaming via Artemis multi-touch, swiping on the phone maps to mouse-look (right-click-drag) in WoW. WoW's built-in slider only goes 90–270, so 90 (the minimum) is still too sensitive for phone — a short swipe spins the camera too far. MobileUI lets you go **below 90** (down to 10), so you can swipe longer to look around less.

## reference/

All reference material lives under `reference/`:

### MoveAnything (reference)

The original [MoveAnything](https://github.com/Ascension-Addons/MoveAnything) addon is kept in `reference/MoveAnything/` as reference only. Do not enable both addons simultaneously.

### wowprogramming API reference

`reference/wowprogramming/` is an offline mirror of the WoW 3.x API reference
from wowprogramming.com (captured via the Wayback Machine, 2010-07-26 snapshot —
close to the 3.3.5a era). It includes API functions, events, widgets, and console
variables (cvars). Open `reference/wowprogramming/docs/index.html` to browse
offline.