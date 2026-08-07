# WoW Events — G

_31 events_

---

## GLYPH_ADDED

Fires when a glyph is inscribed into the player's spellbook

**Payload:** `()`


## GLYPH_DISABLED

Fires when a glyph slot is no longer available. Currently, glyph slots are enabled as the player gains levels (at levels 15, 30, 50, 70, and 80) and are never disabled, but this event may be used should disabling of slots become possible.

**Payload:** `()`


## GLYPH_ENABLED

Fires when a glyph slot becomes available. New glyph slots become available as the player gains levels.

**Payload:** `()`


## GLYPH_REMOVED

Fires when the player removes an inscribed glyph

**Payload:** `()`


## GLYPH_UPDATED

Fires when information about the player's inscribed glyphs becomes available

**Payload:** `()`


## GM_PLAYER_INFO


## GMRESPONSE_RECEIVED

Fires when the player receives a response to a GM ticket. Used for non-interactive responses, not GM conversations.

**Payload:** `()`


## GMSURVEY_DISPLAY

Fires when the player is invited to participate in a GM feedback survey

**Payload:** `()`


## GOSSIP_CLOSED

Fires when an NPC gossip interaction ends. Many NPCs provide a single gossip option leading into another type of interaction (e.g. a flight master offering a greeting) -- in this case, the gossip interaction still happens but is automatically skipped by the default UI, so this event still fires.

**Payload:** `()`


## GOSSIP_CONFIRM

Fires when the player is requested to confirm a gossip choice. Used when a gossip interaction involves a warning, such as for spending a large amount of money (e.g. purchasing Dual Talent Specialization).

**Payload:** `(index, "message", cost)`

**Arguments:**
- `index` - The numeric index of the gossip option you're confirming (`number`)
- `message` - The message to display for the confirmation (`string`)
- `cost` - The cost of the action you're confirming. Will be 0 if there is no cost. (`number`)


## GOSSIP_CONFIRM_CANCEL

Fires when an attempt to confirm a gossip choice is canceled

**Payload:** `()`


## GOSSIP_ENTER_CODE

Fires when the player attempts a gossip choice which requires entering a code. Used for NPCs offering the ability to claim items such as Blizzcon special pets or loot cards from the WoW trading card game.

**Payload:** `(id)`

**Arguments:**
- `id` - The id of the gossip action you are attempting. (`number`)


## GOSSIP_SHOW

Fires when an NPC gossip interaction begins

**Payload:** `()`


## GUILD_EVENT_LOG_UPDATE

Fires when information for the guild event log becomes available

**Payload:** `()`


## GUILD_INVITE_CANCEL

Fires when an invitation to join a guild is no longer available. Can occur when the player declines an invitation or when the invitation expires after a period of time.

**Payload:** `()`


## GUILD_INVITE_REQUEST

Fires when the player is invited to join a guild

**Payload:** `("from", "guildname")`

**Arguments:**
- `from` - The username of the player who invited you to their guild (`string`)
- `guildname` - The name of the guild you are being invited to (`string`)


## GUILD_MOTD

Fires when the guild message of the day is updated. Also fires during the login process so that the player can see the existing message.

**Payload:** `("message")`

**Arguments:**
- `message` - The new guild message. (`string`)


## GUILD_REGISTRAR_CLOSED

Fires when the player ends interaction with a guild registrar

**Payload:** `()`


## GUILD_REGISTRAR_SHOW

Fires when the player begins interaction with a guild registrar

**Payload:** `()`


## GUILD_ROSTER_UPDATE

Fires when new information about the contents of the guild roster is available

**Payload:** `(update)`

**Arguments:**
- `update` - Wether or not the guild roster actually changes. Typically indicates if a player has joined or left your guild. (`boolean`)


## GUILDBANK_ITEM_LOCK_CHANGED

Fires when an item in the guild bank is locked for moving or unlocked afterward

**Payload:** `()`


## GUILDBANK_TEXT_CHANGED

Fires when the text associated with a guild bank tab is changed

**Payload:** `()`


## GUILDBANK_UPDATE_MONEY

Fires when the amount of money in the guild bank changes

**Payload:** `()`


## GUILDBANK_UPDATE_TABS

Fires when information about guild bank tabs becomes available

**Payload:** `()`


## GUILDBANK_UPDATE_TEXT

Fires when text associated with a guild bank tab becomes available

**Payload:** `()`


## GUILDBANK_UPDATE_WITHDRAWMONEY

Fires when the amount of money the player can withdraw from the guild bank changes. Also fires when the player deposits money.

**Payload:** `()`


## GUILDBANKBAGSLOTS_CHANGED

Fires when information about the contents of guild bank item slots changes or becomes available

**Payload:** `()`


## GUILDBANKFRAME_CLOSED

Fires when the player ends interaction with the guild bank

**Payload:** `()`


## GUILDBANKFRAME_OPENED

Fires when the player begins interaction with the guild bank

**Payload:** `()`


## GUILDBANKLOG_UPDATE

Fires when information for the guild bank transaction or money log becomes available

**Payload:** `()`


## GUILDTABARD_UPDATE

Fires when the player's guild tabard design changes.

**Payload:** `()`

