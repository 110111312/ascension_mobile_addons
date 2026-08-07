# WoW Events — A

_31 events_

---

## ACHIEVEMENT_EARNED

Fires when the player earns an achievement

**Payload:** `()`


## ACTIONBAR_HIDEGRID

Fires when an item, spell or other entity that can be placed into an action bar slot is removed from the cursor. In the default UI, this event causes the grid of empty action bar slots to be hidden. (This grid only appears when something that can be dragged to an action bar slot is picked up, unless the "Always show action bars" option is enabled.)

**Payload:** `()`


## ACTIONBAR_PAGE_CHANGED

Fires when the main action bar changes pages

**Payload:** `()`


## ACTIONBAR_SHOWGRID

Fires when an item, spell or other entity that can be placed into an action bar slot is picked up onto the cursor. In the default UI, this event causes the grid of empty action bar slots to be shown. (This grid only appears when something that can be dragged to an action bar slot is picked up, unless the "Always show action bars" option is enabled.)

**Payload:** `()`


## ACTIONBAR_SLOT_CHANGED

Fires when the contents of an action bar slot change

**Payload:** `(slot)`

**Arguments:**
- `slot` - The action id of the slot that needs to be updated or 0 if all slots need to be updated. (`number`)


## ACTIONBAR_UPDATE_COOLDOWN

Fires when the cooldown for an action bar item begins or ends

**Payload:** `()`


## ACTIONBAR_UPDATE_STATE

Fires when the state of an action bar item changes. State changes include the action becoming the current or active action.

**Payload:** `()`


## ACTIONBAR_UPDATE_USABLE

Fires when an action becomes usable or unusable. For example, an action may become unusable if it contains a spell for which the player does not have enough mana.

**Payload:** `()`


## ACTIVE_TALENT_GROUP_CHANGED

Fires when the player (with Dual Talent Specialization enabled) switches talent builds

**Payload:** `()`


## ADDON_ACTION_BLOCKED

Fires when a non-Blizzard addon attempts to use a protected API

**Payload:** `()`


## ADDON_ACTION_FORBIDDEN

Fires when a non-Blizzard addon attempts to use a protected API. In the default UI, this event triggers a dialog box providing the name of the addon and offering to disable it and reload the UI.

**Payload:** `("culprit")`

**Arguments:**
- `culprit` - The name of the addon that called the forbidden function (`string`)


## ADDON_LOADED

Fires when an addon and its saved variables are loaded. Fires once for each addon (i.e. an addon loaded early in sequence will see `ADDON_LOADED` events for all addons loaded later).

**Payload:** `("name")`

**Arguments:**
- `name` - The name of the addon that has been loaded (`string`)


## AREA_SPIRIT_HEALER_IN_RANGE

Fires when the player enters into the area of effect of a spirit healer that periodically resurrects nearby player units. Such spirit healers are found in Battlegrounds and certain other PvP areas.

**Payload:** `()`


## AREA_SPIRIT_HEALER_OUT_OF_RANGE

Fires when the player enters leaves the area of effect of a spirit healer that periodically resurrects nearby player units. Such spirit healers are found in Battlegrounds and certain other PvP areas.

**Payload:** `()`


## ARENA_OPPONENT_UPDATE

Fires when the availability of information about an arena opponent changes

**Payload:** `()`


## ARENA_SEASON_WORLD_STATE

Fires when the arena season changes

**Payload:** `()`


## ARENA_TEAM_INVITE_REQUEST

Fires when the player is invited to join an arena team

**Payload:** `("source", "team")`

**Arguments:**
- `source` - The name of the player that invited you to join a team. (`string`)
- `team` - The name of the team that you have been invited to join. (`string`)


## ARENA_TEAM_ROSTER_UPDATE

Fires when roster detail information for one of the player's arena teams becomes available

**Payload:** `(unknown)`

**Arguments:**
- `unknown` - Appears to be a boolean value to determin if updated information is available or not. (`boolean`)


## ARENA_TEAM_UPDATE

Fires when the player joins or leaves an arena team

**Payload:** `()`


## AUCTION_BIDDER_LIST_UPDATE

Fires when information becomes available or changes for the list of auctions bid on by the player

**Payload:** `()`


## AUCTION_HOUSE_CLOSED

Fires when the player ends interaction with an auction house

**Payload:** `()`


## AUCTION_HOUSE_DISABLED

Fires when the server refuses to give the player access to the auction house because it is disabled

**Payload:** `()`


## AUCTION_HOUSE_SHOW

Fires when the player begins interaction with an auction house

**Payload:** `()`


## AUCTION_ITEM_LIST_UPDATE

Fires when the information becomes available for the list of auction browse/search results

**Payload:** `()`


## AUCTION_MULTISELL_FAILURE

Fires when an auction house multisell could not complete for any reason

**Payload:** `()`


## AUCTION_MULTISELL_START

Fires when the player starts a multisell in the auction house

**Payload:** `(amount)`

**Arguments:**
- `amount` - Amount of items in total to put on the auction house (`number`)


## AUCTION_MULTISELL_UPDATE

Fires when one of the auctions in an auction house multisell has successfully been created

**Payload:** `(createdAmount, amount)`

**Arguments:**
- `createdAmount` - Amount of auctions that have successfully been created (`number`)
- `amount` - Amount of auctions to create in total (`number`)


## AUCTION_OWNED_LIST_UPDATE

_No snapshot available._


## AUTOEQUIP_BIND_CONFIRM

Fires when the player attempts to equip an item which will become soulbound in the process

**Payload:** `(slot)`

**Arguments:**
- `slot` - The slot of the item that you are attempting to equip. (`number`)


## AUTOFOLLOW_BEGIN

Fires when the player starts following another character

**Payload:** `(following)`

**Arguments:**
- `following` - The unit that you are following. (`number`)


## AUTOFOLLOW_END

Fires when the player stops following another character

**Payload:** `()`

