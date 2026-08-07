# WoW Events — W

_6 events_

---

## WEAR_EQUIPMENT_SET

Fires when the player's current equipment set changes. The firing of this event indicates the moment when the player's "current equipment set" state (as returned by `GetEquipmentSetInfo()`) changes -- at that time, the process of equipping/unequipping the set's items may not yet be complete. 

See `EQUIPMENT_SWAP_PENDING` and `EQUIPMENT_SWAP_FINISHED` for monitoring the beginning and end of the equipment swap process.

**Payload:** `()`


## WHO_LIST_UPDATE

Fires when results of a Who query become available. Only fires if there are more than three results or if `SetWhoToUI(1)` was called before performing the query.

**Payload:** `()`


## WORLD_MAP_NAME_UPDATE

Fires when the name of the current world map area changes or becomes available

**Payload:** `()`


## WORLD_MAP_UPDATE

Fires when the contents of the world map change or become available

**Payload:** `()`


## WORLD_STATE_UI_TIMER_UPDATE

Fires when the state of a timer world state UI element changes or becomes available. World State UI elements include PvP, instance, and quest objective information (displayed at the top center of the screen in the default UI) as well as more specific information for "control point" style PvP objectives. Timer world state elements include the countdown between battles in Wintergrasp, the countdown between periods in which the PvP objectives in Terokkar Forest are available, and timers shown for the quests The Light of Dawn and The Battle For The Undercity.

**Payload:** `()`


## WOW_MOUSE_NOT_FOUND

This event fires when a man buttoned WoW mouse is not found, in response to a `DetectWowMouse()` function call

**Payload:** `()`

