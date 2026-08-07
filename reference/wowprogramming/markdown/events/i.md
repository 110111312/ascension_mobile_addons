# WoW Events — I

_18 events_

---

## IGNORELIST_UPDATE

Fires when the content of the player's ignore list becomes available or changes

**Payload:** `()`


## IGR_BILLING_NAG_DIALOG

Fires when a message should be shown about the player's paid-per-hour game time expiring soon. Only used in locales where World of Warcraft is played via paid-per-hour Internet Game Rooms (e.g. Korea).

**Payload:** `()`


## INSPECT_ACHIEVEMENT_READY

Fires after the player attempts to compare achievements with another character, indicating that achievement information for the other unit has become available

**Payload:** `()`


## INSPECT_HONOR_UPDATE

Fires when information about the inspected unit's PvP activities becomes available

**Payload:** `()`


## INSPECT_TALENT_READY

Fires when information about the inspected player's talents becomes available

**Payload:** `()`


## INSTANCE_BOOT_START

Fires when the player will soon be ejected from an instance. Occurs when the player leaves the group to which the instance belongs and has not yet exited the instance -- some time after this event provides a warning, the player will be teleported to the nearest graveyard.

**Payload:** `()`


## INSTANCE_BOOT_STOP

Fires when the warning countdown for ejecting the player from an instance is canceled. The player can avoid being ejected from an instance by re-joining the group to which the instance belongs or leaving the instance via other means.

**Payload:** `()`


## INSTANCE_ENCOUNTER_ENGAGE_UNIT

Fires when a boss has been engaged in an instance. Does not fire for every boss fights, as it is used to add the boss unit to the UI.

**Payload:** `()`


## INSTANCE_LOCK_START

Fires when the player will soon be saved to an instance. If the player enters an instance to which other group members are saved, this event provides a warning allowing the player an opportunity to leave before also becoming saved to the instance.

**Payload:** `()`


## INSTANCE_LOCK_STOP

Fires when the warning countdown for saving the player to an instance is canceled. The countdown is stopped when the player either leaves the instance or accepts being saved to it.

**Payload:** `()`


## ITEM_LOCK_CHANGED

Fires when an item in the player's bags or equipped inventory is locked for moving or unlocked afterward

**Payload:** `(bagID, slotID)`

**Arguments:**
- `bagID` - The bag id that the slot is in. (`number`)
- `slotID` - The slot id that's lock is changing. (`number`)


## ITEM_LOCKED

Fires when an item in the player's bags or equipped inventory is locked for moving

**Payload:** `()`


## ITEM_PUSH

Fires when the player receives an item. This event fires in addition to others which may indicate the item's origin (e.g. `QUEST_ACCEPTED` or `CHAT_MSG_LOOT`); in the default UI, this event triggers an "item falling into bag" animation displayed above the bag icons.

**Payload:** `(bagID, "icon")`

**Arguments:**
- `bagID` - The id of the bag that the item is going into. (`number`)
- `icon` - The icon file for the item being received. (`string`)


## ITEM_TEXT_BEGIN

Fires when the player begins interaction with a readable item or world object. Readable items include books, scrolls, and saved copies of mail messages; readable world objects include plaques, gravestones and books on tables.

**Payload:** `()`


## ITEM_TEXT_CLOSED

Fires when the player ends interaction with a readable item or world object. Readable items include books, scrolls, and saved copies of mail messages; readable world objects include plaques, gravestones and books on tables.

**Payload:** `()`


## ITEM_TEXT_READY

Fires when text changes or becomes available for the readable item or world object with which the player is interacting. Also fires when turning pages in a multi-page text item.

Readable items include books, scrolls, and saved copies of mail messages; readable world objects include plaques, gravestones and books on tables.

**Payload:** `()`


## ITEM_TEXT_TRANSLATION

Fires when a "translation" progress bar should be displayed while the player interacts with a readable item or world object. Such a UI element indicates the player character's progress in translating the text to a readable in-game language; this feature is generally not used in the current version of WoW.

Readable items include books, scrolls, and saved copies of mail messages; readable world objects include plaques, gravestones and books on tables.

**Payload:** `(maxvalue)`

**Arguments:**
- `maxvalue` - The max value (`number`)


## ITEM_UNLOCKED

Fires when an item in the player's bags or equipped inventory is unlocked after moving

**Payload:** `()`

