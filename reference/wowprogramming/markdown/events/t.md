# WoW Events — T

_27 events_

---

## TABARD_CANSAVE_CHANGED

Fires when information about the player's ability to save a guild tabard design changes or becomes available

**Payload:** `()`


## TABARD_SAVE_PENDING

Fires when the player attempts to save a guild tabard design

**Payload:** `()`


## TALENTS_INVOLUNTARILY_RESET

Fires when the player's talents have undergone a forced reset. This usually happens after a major patch or on test realms.

**Payload:** `()`


## TAXIMAP_CLOSED

Fires when the player begins interaction with a flight master

**Payload:** `()`


## TAXIMAP_OPENED

Fires when the player ends interaction with a flight master

**Payload:** `()`


## TIME_PLAYED_MSG

Fires when information about the player's total time played becomes available. Such information is normally requested via the `/played` command.

**Payload:** `(total, level)`

**Arguments:**
- `total` - The ammount of time played total, in seconds. (`number`)
- `level` - The ammount of time played this level, in seconds. (`number`)


## TRACKED_ACHIEVEMENT_UPDATE

Fires when the player's progress changes on an achievement marked for watching in the objectives tracker

**Payload:** `(achievementId)`

**Arguments:**
- `achievementId` - The ID of the Achievement tracked (`number`)


## TRADE_ACCEPT_UPDATE

Fires when the player or trade target signals acceptance (or cancels acceptance) of the trade

**Payload:** `(player, target)`

**Arguments:**
- `player` - Your accepted status. 1 for yes, 0 for no. (`number`)
- `target` - Your target's accepted status. 1 for yes, 0 for no. (`number`)


## TRADE_CLOSED

Fires when a trade with another player ends or is canceled

**Payload:** `()`


## TRADE_MONEY_CHANGED

Fires when the amount of money offered by the trade target changes

**Payload:** `()`


## TRADE_PLAYER_ITEM_CHANGED

Fires when the set of items offered for trade by the player changes

**Payload:** `(slotID)`

**Arguments:**
- `slotID` - The slot id of the item you are trading (1-7). (`number`)


## TRADE_POTENTIAL_BIND_ENCHANT


## TRADE_REPLACE_ENCHANT

Fires if the player attempts to enchant an item offered by the trade target which is already enchanted

**Payload:** `("current", "new")`

**Arguments:**
- `current` - The current item enchant (`string`)
- `new` - The name of the new proposed item enchant (`string`)


## TRADE_REQUEST

Unused. Was once used for presenting the player with a confirmation dialog before initiating a trade offered by another character.

**Payload:** `()`


## TRADE_REQUEST_CANCEL

Unused. Was once used for canceling a confirmation dialog which would appear before initiating a trade offered by another character.

**Payload:** `()`


## TRADE_SHOW

Fires when a trade interaction with another character begins

**Payload:** `()`


## TRADE_SKILL_CLOSE

Fires when the player ends interaction with a trade skill recipe list

**Payload:** `()`


## TRADE_SKILL_FILTER_UPDATE

Fires when the search filter for a trade skill recipe list changes

**Payload:** `()`


## TRADE_SKILL_SHOW

Fires when the player begins interaction with a trade skill recipe list

**Payload:** `()`


## TRADE_SKILL_UPDATE

Fires when information about the contents of a trade skill recipe list changes or becomes available

**Payload:** `()`


## TRADE_TARGET_ITEM_CHANGED

Fires when the set of items offered for trade by the target changes

**Payload:** `(slotID)`

**Arguments:**
- `slotID` - The slot's ID that changed (1-7). (`number`)


## TRADE_UPDATE

Fires when new information becomes available about a trade process underway with another character. Not used for most changes to the trade process (see other `TRADE` events for changes to items and money offered for trade by either party).

**Payload:** `()`


## TRAINER_CLOSED

Fires when the player ends interaction with a class or skill trainer

**Payload:** `()`


## TRAINER_DESCRIPTION_UPDATE

Fires when description information for the selected trainer service changes or becomes available

**Payload:** `()`


## TRAINER_SHOW

Fires when the player begins interaction with a class or skill trainer

**Payload:** `()`


## TRAINER_UPDATE

Fires when information about the contents of the trainer service list changes or becomes available

**Payload:** `()`


## TUTORIAL_TRIGGER

Fires when a contextual tutorial should be shown

**Payload:** `(id)`

**Arguments:**
- `id` - The id for the tutorial that needs to show. Valid values are between 1 and 51. (`number`)

