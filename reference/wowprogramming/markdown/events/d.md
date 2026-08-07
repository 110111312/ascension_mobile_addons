# WoW Events — D

_9 events_

---

## DELETE_ITEM_CONFIRM

Fires when the player attempts to delete an item

**Payload:** `("itemName", itemQuality)`

**Arguments:**
- `itemName` - The name of the item you are attempting to delete (`string`)
- `itemQuality` - The numeric index representing the items quality. (`number`)


## DISABLE_LOW_LEVEL_RAID


## DISABLE_TAXI_BENCHMARK

_No snapshot available._


## DISABLE_XP_GAIN

Fires when the player disables experience point gains

**Payload:** `()`


## DISPLAY_SIZE_CHANGED

Fires when the screen resolution changes

**Payload:** `()`


## DUEL_FINISHED

Fires when a duel in which the player is participating ends. Can fire due to the duel being won or forfeit.

**Payload:** `()`


## DUEL_INBOUNDS

Fires when the player reenters the duel area after leaving its boundaries

**Payload:** `()`


## DUEL_OUTOFBOUNDS

Fires when the player begins to move outside the boundaries of a duel area. If the player remains outside the duel area for more than 10 seconds, he or she will forfeit the duel.

**Payload:** `()`


## DUEL_REQUESTED

Fires when the player is challenged to a duel. No event (other than the associated system message) fires when the player challenges another to a duel.

**Payload:** `("challenger")`

**Arguments:**
- `challenger` - The challenger's username (`string`)

