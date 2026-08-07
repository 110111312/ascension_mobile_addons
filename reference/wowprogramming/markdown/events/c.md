# WoW Events — C

_111 events_

---

## CALENDAR_ACTION_PENDING

Fires when a change to the calendar is in progress

**Payload:** `()`


## CALENDAR_CLOSE_EVENT

Fires when the player ends viewing or editing details of a calendar event

**Payload:** `()`


## CALENDAR_EVENT_ALARM

Fires when a calendar event is soon to begin. Causes the default UI to display a message in the chat window 15 minutes prior to the event's scheduled time.

**Payload:** `()`


## CALENDAR_NEW_EVENT

Fires when an event created by the player is added to the calendar

**Payload:** `()`


## CALENDAR_OPEN_EVENT

Fires when the player begins viewing or editing details of a calendar event

**Payload:** `()`


## CALENDAR_UPDATE_ERROR

Fires when a calendar-related error message should be displayed

**Payload:** `()`


## CALENDAR_UPDATE_EVENT

Fires when details become available for the event being viewed or edited

**Payload:** `()`


## CALENDAR_UPDATE_EVENT_LIST

Fires when the list of events visible on the calendar changes

**Payload:** `()`


## CALENDAR_UPDATE_INVITE_LIST

Fires when the invite/signup list is updated for the event being viewed or edited

**Payload:** `()`


## CALENDAR_UPDATE_PENDING_INVITES

Fires when the player receives new calendar event invitations

**Payload:** `()`


## CANCEL_LOOT_ROLL

Fires when the player cancels a loot roll. Can occur after the player is requested to confirm rolling for an item which Binds on Pickup.

**Payload:** `(rollID)`

**Arguments:**
- `rollID` - The id of the roll that was cancled. (`number`)


## CANCEL_SUMMON

Fires when a summons offered to the player is canceled

**Payload:** `()`


## CHANNEL_COUNT_UPDATE

_No snapshot available._


## CHANNEL_FLAGS_UPDATED

Fires when information about a channel for the channel list display changes

**Payload:** `(id)`

**Arguments:**
- `id` - The id of the channel that has updated data (`number`)


## CHANNEL_INVITE_REQUEST

Fires when a player is invited into a chat channel

**Payload:** `("channelName", "inviterName")`

**Arguments:**
- `channelName` - The name of the channel you have been invited to. (`string`)
- `inviterName` - The name of the character that invited you. (`string`)


## CHANNEL_PASSWORD_REQUEST

Fires when the player attempts to join a password protected channel

**Payload:** `("channelName")`

**Arguments:**
- `channelName` - The name of the channel you are attempting to join. (`string`)


## CHANNEL_ROSTER_UPDATE

Fires when the list of members in a channel changes

**Payload:** `(id)`

**Arguments:**
- `id` - The id of the channel that has updated information. (`number`)


## CHANNEL_UI_UPDATE

Fires when information for the channel list display changes

**Payload:** `()`


## CHANNEL_VOICE_UPDATE

Fires when a member in a voice chat channel starts or stops speaking

**Payload:** `(id, enabled, active)`

**Arguments:**
- `id` - The id of the speaker who has changed. (`number`)
- `enabled` - If voice chat is enabled. (`boolean`)
- `active` - If the player is speaking at this moment. (`boolean`)


## CHARACTER_POINTS_CHANGED

Fires when the player's amount of available talent points changes. Note that since the introduction of Death Knights, who gain 46 of their talent points through questing, this event can fire without the player gaining a character level.

**Payload:** `(count, levels)`

**Arguments:**
- `count` - The number of talent points gained or lost. Positive numbers are gains negative numbers are expenditures. (`number`)
- `levels` - The number of levels gained in association to this change. Is 0 if there is no level change. (`number`)


## CHAT_MSG_ACHIEVEMENT

Fires when a nearby character earns an achievement

**Payload:** `()`


## CHAT_MSG_ADDON

Fires when an addon communication message is received (see `SendAddonMessage()`). The local client receives any messages it sends; thus, this event fires for messages sent by the local client as well as those receives from others.

**Payload:** `("prefix", "message", "channel", "sender")`

**Arguments:**
- `prefix` - The prefix declared from SendAddonMessage. (`string`)
- `message` - The message from SendAddonMessage. (`string`)
- `channel` - The message channel used for this message. Possible values include PARTY, RAID, GUILD, BATTLEGROUND, or WHISPER. (`string`)
- `sender` - The username of the sender. (`string`)


## CHAT_MSG_AFK

Fires when an automatic AFK response is received. When the player attempts to whisper or invite a character whose status is AFK, an automatic response is returned containing either a custom message set by that character or the default message, "Away From Keyboard"

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter, "senderGUID")`

**Arguments:**
- `message` - The response message (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - counter of chat events that the client recieves. (`number`)
- `senderGUID` - The sender's GUID (`string`)


## CHAT_MSG_BATTLEGROUND

_No snapshot available._


## CHAT_MSG_BATTLEGROUND_LEADER

_No snapshot available._


## CHAT_MSG_BG_SYSTEM_ALLIANCE

Fires when an Alliance-related battleground system message is received. Faction-related messages include flags picked up, bases assaulted, etc.

**Payload:** `("message")`

**Arguments:**
- `message` - The message received. (`string`)


## CHAT_MSG_BG_SYSTEM_HORDE

Fires when a Horde-related battleground system message is received. Faction-related messages include flags picked up, bases assaulted, etc.

**Payload:** `("message")`

**Arguments:**
- `message` - The message received. (`string`)


## CHAT_MSG_BG_SYSTEM_NEUTRAL

_No snapshot available._


## CHAT_MSG_BN_CONVERSATION

Fires when you type a message in chat or when you recive a message from another player using Battle.Net

**Payload:** `("message", "sender", "unknown", "channelString", "unknown", "unknown", unknown, channelNumber, "unknown", unknown, counter, "unknown", presenceID, unknown)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's RealID name. (i.e 'John Doe') (`string`)
- `unknown` - unknown (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`number`)
- `channelNumber` - The numeric ID of the channel. (The UI adds +10 to the number) (`number`)
- `unknown` - unknown (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be sequential number that the client recieves. (`number`)
- `unknown` - unknown (`string`)
- `presenceID` - this is the presenceID of the sender. (`number`, presenceID)
- `unknown` - this seems to always be false (`boolean`)


## CHAT_MSG_BN_CONVERSATION_LIST


## CHAT_MSG_BN_CONVERSATION_NOTICE

Fires when you join a conversation channel (private channel for you and your friends) on Battle.Net

**Payload:** `("message/status", "sender", "unknown", "channelString", "unknown", "unknown", unknown, channelNumber, "unknown", unknown, counter, "unknown", presenceID, unknown)`

**Arguments:**
- `message/status` - The message thats received or a statuscode like YOU_ JOINED_ CONVERSATION, YOU_ LEFT_ CONVERSATION, MEMBER_ LEFT. (`string`)
- `sender` - The sender's RealID name. (i.e 'John Doe') or sometimes your own wow characters name. (looks like it will use the wow-character name when you are chatting, but will contain realid when other clients send messages) (`string`)
- `unknown` - unknown (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`number`)
- `channelNumber` - The numeric ID of the channel. (The UI adds +10 to the number) (`number`)
- `unknown` - unknown (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be sequential number that the client recieves. (`number`)
- `unknown` - unknown (`string`)
- `presenceID` - presenceID of the channel owner (`number`, presenceID)
- `unknown` - this seems to always be false (`boolean`)


## CHAT_MSG_BN_INLINE_TOAST_ALERT


## CHAT_MSG_BN_INLINE_TOAST_BROADCAST

Fires whenever a user changes their broadcast message on Battle.Net

**Payload:** `("message", "sender", "unknown", "unknown", "unknown", "unknown", unknown, unknown, "unknown", unknown, counter, "unknown", presenceID, unknown)`

**Arguments:**
- `message` - The broadcast message. (`string`)
- `sender` - The sender's RealID name. (i.e 'John Doe') (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`number`)
- `unknown` - unknown (`number`)
- `unknown` - unknown (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be sequential number that the client recieves. (`number`)
- `unknown` - unknown (`string`)
- `presenceID` - presenceID of the player sending the boadcast message (`number`, presenceID)
- `unknown` - this seems to always be false (`boolean`)


## CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM

Fires when the player sends a new broadcast (online message)

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter, "guid")`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)
- `guid` - GUID of the person who sent this message. Always empty for RealID events. (`string`)


## CHAT_MSG_BN_INLINE_TOAST_CONVERSATION


## CHAT_MSG_BN_WHISPER

Fires when you receive a whisper though Battle.Net

**Payload:** `("message", "sender", "unknown", "unknown", "unknown", "unknown", unknown, unknown, "unknown", unknown, counter, "unknown", presenceID, unknown)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's RealID name. (i.e 'John Doe') or sometimes your own wow characters name. (looks like it will use the wow-character name when you are chatting, but will contain realid when other clients send messages) (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`string`)
- `unknown` - unknown (`number`)
- `unknown` - unknown (`number`)
- `unknown` - unknown (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be sequential number that the client recieves. (`number`)
- `unknown` - unknown (`string`)
- `presenceID` - presenceID of the sender (`number`, presenceID)
- `unknown` - this seems to always be false (`boolean`)


## CHAT_MSG_BN_WHISPER_INFORM


## CHAT_MSG_CHANNEL

Fires when a message is received in a world or custom chat channel. Used for numbered chat channels (e.g. Trade, General, and player-created channels).

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter, "guid")`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)
- `guid` - GUID of the person who sent this message. (`string`)


## CHAT_MSG_CHANNEL_JOIN

Fires when another character joins a world or custom chat channel monitored by the player. Used for numbered chat channels (e.g. Trade, General, and player-created channels). Only used for other characters joining a channel -- when the player joins a channel, `CHAT_MSG_CHANNEL_NOTICE` fires.

**Payload:** `("unkown", "sender", "unknown", "channelString", "unknown", "unknown", unknown, channelNumber, "channelName", unknown, unknown)`

**Arguments:**
- `unkown` - empty string (`string`)
- `sender` - The sender's username. (`string`)
- `unknown` - empty string (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `unknown` - empty string (`string`)
- `unknown` - empty string (`string`)
- `unknown` - 0 (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - 0 (`number`)
- `unknown` - 800 (`number`)


## CHAT_MSG_CHANNEL_LEAVE

Fires when another character leaves a world or custom chat channel monitored by the player. Used for numbered chat channels (e.g. Trade, General, and player-created channels). Only used for other characters leaving the channel -- when the player leaves the channel, `CHAT_MSG_CHANNEL_NOTICE` fires.

**Payload:** `("unkown", "sender", "unknown", "channelString", "unknown", "unknown", unknown, channelNumber, "channelName", unknown, unknown)`

**Arguments:**
- `unkown` - empty string (`string`)
- `sender` - The sender's username. (`string`)
- `unknown` - empty string (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `unknown` - empty string (`string`)
- `unknown` - empty string (`string`)
- `unknown` - 0 (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - 0 (`number`)
- `unknown` - 852 (`number`)


## CHAT_MSG_CHANNEL_LIST

Fires in response to a channel list query (e.g. `/chatlist`). If the channel contains many characters, the event fires multiple times to list them all.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_CHANNEL_NOTICE


## CHAT_MSG_CHANNEL_NOTICE_USER

Fires when certain actions pertaining to specific members happen on a world or custom chat channel. Examples of member-specific actions include a member enabling the channel for voice chat, a member becoming the channel owner, or one member kicking or banning another from the channel.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_COMBAT_FACTION_CHANGE

Fires when the player gains or loses reputation with a faction

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_COMBAT_HONOR_GAIN

Fires when the player gains honor points

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_COMBAT_MISC_INFO

Fires for miscellaneous messages to be displayed in the combat log, such as loss of equipment durability upon death

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_COMBAT_XP_GAIN

Fires when the player gains experience points

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_DND

Fires when an automatic DND response is received. When the player attempts to whisper or invite a character whose status is DND, an automatic response is returned containing either a custom message set by that character or the default message, "Do Not Disturb"

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_EMOTE

Fires when a custom emote message is received.. Custom emote messages are those sent by typing `/emote` followed by some text; see `CHAT_MSG_TEXT_EMOTE` for standard emotes such as `/dance` and `/flirt`.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_FILTERED

Fires when the player attempts to send a chat message which is blocked by the spam filter

**Payload:** `()`


## CHAT_MSG_GUILD

Fires when a message is received in the guild chat channel

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_GUILD_ACHIEVEMENT

Fires when a member of the player's guild earns an achievement

**Payload:** `("message", "sender")`

**Arguments:**
- `message` - The message displayed to guild members (`string`)
- `sender` - The name of the guild member who earned the achievement (`string`)


## CHAT_MSG_IGNORED

Fires when an automatic response is received after whispering or inviting a character who is ignoring the player

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_LOOT

Fires when receiving notice that the player or a member of the player's group has looted an item

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_MONEY

Fires when the player receives money as loot

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_MONSTER_EMOTE

Fires when a nearby NPC performs emote text. e.g. Cro Threadstrong crushes an apple under his boot.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_MONSTER_PARTY

Fires when an NPC speaks to the player's party chat channel

**Payload:** `()`


## CHAT_MSG_MONSTER_SAY

Fires when a nearby NPC speaks (visible only to players in the immediate area). e.g. Granny smith says: What is that poor orc yelling about? Someone should see what is going on.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_MONSTER_WHISPER

Fires when an NPC whispers to the player

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_MONSTER_YELL

Fires when an NPC yells (visible to players in a wide area or the entire zone). e.g. Doom Lord Kazzak yells, All mortals will perish!

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_OFFICER

Fires when a message is received in officer chat.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_OPENING

Fires for messages about the player "opening" a world object. Used for some, but not all "openable" world objects (e.g. treasure chests, quest objects). Messages sent via this event are displayed in the default UI's combat log by default.

**Payload:** `()`


## CHAT_MSG_PARTY

Fires when a message is received in the party chat channel

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_PARTY_LEADER


## CHAT_MSG_PET_INFO

Fires for pet-related messages normally displayed in the combat log (e.g. summoning or dismissing a pet)

**Payload:** `()`


## CHAT_MSG_RAID

Fires when a message is received in the raid chat channel

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_RAID_BOSS_EMOTE

Fires when a raid boss performs emote text. In the default UI, emotes from a raid boss are displayed in large text in the center of the screen.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_RAID_BOSS_WHISPER

Fires when a raid boss whispers to the player. In the default UI, whispers from a raid boss are displayed in large text in the center of the screen.

**Payload:** `()`


## CHAT_MSG_RAID_LEADER

Fires when a message is received in the raid chat channel from the raid leader

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_RAID_WARNING

Fires when a raid warning message is received. These messages can be sent by the raid leader or a raid assistant; in the default UI, they appear in large text in the center of the screen.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_RESTRICTED

Fires when the player attempts to send a chat message which is disallowed because the player is on a trial account

**Payload:** `()`


## CHAT_MSG_SAY

Fires when the player or a nearby character speaks (visible to other nearby characters)

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_SKILL

Fires when skill related messages are received.. e.g. "Your skill in Unarmed has increased to 357."

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_SYSTEM

Fires when a system message is received. System messages are a catch-all category for messages received in via the chat system. Examples:

 
 - The server message which appears upon login (e.g. "Welcome to Patch 3.4! If you encounter interface problems, please disable your addons and delete your WTF folder.")
 
 - The feedback message which appears when the player enters AFK or DND status
 
 - Results from a `/who` query, if the query has three or fewer results
 
 - Notification that a friend or guild member has logged in or gone offline

Many standard system message patterns can be found as localized format strings in `FrameXML\GlobalStrings.lua` (after using the AddOn Kit to extract the default interface files). When this event is received, the message has already been localized and formatted, but using the format string may be useful for parsing variables from the message.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_TARGETICONS

Fires when a target icon message is sent in chat.

**Payload:** `message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter = ()`


## CHAT_MSG_TEXT_EMOTE

Fires when the player receives a standard emote (e.g. `/dance`, `/flirt`) message. For custom emote messages (those sent by typing `/emote` followed by some text), see `CHAT_MSG_EMOTE`.

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_TRADESKILLS

Fires when the player or a nearby character performs a trade skill recipe

**Payload:** `()`


## CHAT_MSG_WHISPER

Fires when the player receives a whisper from a player character

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter, guid)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)
- `guid` - This variable appears to contain the globally unique ID for the player character who whispered you (`guid`)


## CHAT_MSG_WHISPER_INFORM

Fires when the player sends a whisper to a player character

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CHAT_MSG_YELL

Fires when the player or another player character yells (visible to other characters in a wide area)

**Payload:** `("message", "sender", "language", "channelString", "target", "flags", unknown, channelNumber, "channelName", unknown, counter)`

**Arguments:**
- `message` - The message thats received (`string`)
- `sender` - The sender's username. (`string`)
- `language` - The language the message is in. (`string`)
- `channelString` - The full name of the channel, including number. (`string`)
- `target` - The username of the target of the action. Not used by all events. (`string`)
- `flags` - The various chat flags. Like, DND or AFK. (`string`)
- `unknown` - This variable has an unkown purpose, although it may be some sort of internal channel id. That however is not confirmed. (`number`)
- `channelNumber` - The numeric ID of the channel. (`number`)
- `channelName` - The full name of the channel, does not include the number. (`string`)
- `unknown` - This variable has an unkown purpose although it always seems to be 0. (`number`)
- `counter` - This variable appears to be a counter of chat events that the client recieves. (`number`)


## CINEMATIC_START

Fires when an in-game-engine cinematic begins to play. Used primarily for the introductory cinematic which plays upon logging into a newly created character, but can also appear at other times.

**Payload:** `()`


## CINEMATIC_STOP

Fires when an in-game-engine cinematic stops playing. Used primarily for the introductory cinematic which plays upon logging into a newly created character, but can also appear at other times.

**Payload:** `()`


## CLOSE_INBOX_ITEM

Fires when the mail message being viewed is no longer available. Occurs when the player takes all items attached to the currently viewed message, causing it to be deleted.

**Payload:** `(id)`

**Arguments:**
- `id` - The id of the mail slot you took the item from (`number`)


## CLOSE_TABARD_FRAME

Fires when the player ends interaction with a tabard designer

**Payload:** `()`


## CLOSE_WORLD_MAP

Fires when the world map should be hidden in response to external conditions. Such conditions include being teleported by a GM while the world map is open. Does not fire when the player closes the world map manually.

**Payload:** `()`


## COMBAT_LOG_EVENT


## COMBAT_LOG_EVENT_UNFILTERED

Fires when a combat log event is received. This event fires for all combat events visible to the player; `COMBAT_LOG_EVENT` fires only for combat log events which match the currently defined filters.

See the chapter "Responding to the Combat Log and Threat Information" for details.

**Payload:** `timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ... = ()`


## COMBAT_RATING_UPDATE

Fires when the player's combat rating statistics change

**Payload:** `()`


## COMBAT_TEXT_UPDATE

Fires when a message is received which can be displayed by the default UI's floating combat text feature

**Payload:** `("type", desc1, desc2)`

**Arguments:**
- `type` - Token identifying the type of message (`string`)
- `desc1` - This field varies depending on the type of message. See the chart for details (`varies`)
- `desc2` - This field varies depending on the type of message. See the chart for details (`varies`)


## COMMENTATOR_ENTER_WORLD


## COMMENTATOR_MAP_UPDATE


## COMMENTATOR_PLAYER_UPDATE


## COMMENTATOR_SKIRMISH_MODE_REQUEST


## COMMENTATOR_SKIRMISH_QUEUE_REQUEST


## COMPANION_LEARNED

Fires when the player learns to summon a new mount or non-combat pet

**Payload:** `()`


## COMPANION_UNLEARNED

Fires when the player unlearns a mount or a companion. This will pretty much never happen, unless a Game Master gets involved.

**Payload:** `()`


## COMPANION_UPDATE

Fires when new information about the player's mounts and non-combat pets is available

**Payload:** `()`


## CONFIRM_BINDER

Fires when the player attempts to set a new Hearthstone location

**Payload:** `("newHome")`

**Arguments:**
- `newHome` - Name of the new Hearthstone location (`string`)


## CONFIRM_DISENCHANT_ROLL

Fires when the player attempts to roll disenchant for an item which Binds on Pickup

**Payload:** `()`


## CONFIRM_LOOT_ROLL

Fires when the player attempts to roll for a loot item which Binds on Pickup

**Payload:** `(id, rolltype)`

**Arguments:**
- `id` - The slot id that you're rolling for (`number`)
- `rolltype` - The numeric representing the type of roll you are doing. Pass: 0, Need: 1, Greed: 2. (`number`)


## CONFIRM_SUMMON

Fires when a summons is offered to the player

**Payload:** `()`


## CONFIRM_TALENT_WIPE

Fires when the player attempts to unlearn talents

**Payload:** `(cost)`

**Arguments:**
- `cost` - The amount in copper that it will cost you to untrain your talents. (`number`)


## CONFIRM_XP_LOSS

Fires when the player attempts to resurrect at a graveyard spirit healer. Early in WoW's development, resurrecting at a spirit healer caused a loss of experience points. The change to a loss of item durability was made before the initial public release of World of Warcraft, but the name of this event was never changed.

**Payload:** `()`


## CORPSE_IN_INSTANCE

Fires when the player (dead, in spirit form) approaches the entrance to the instance in which his corpse is located

**Payload:** `()`


## CORPSE_IN_RANGE

Fires when the player (dead, in spirit form) approaches near enough to his corpse to return to life

**Payload:** `()`


## CORPSE_OUT_OF_RANGE

Fires when the player (dead, in spirit form) moves too far away from his corpse to resurrect

**Payload:** `()`


## CRITERIA_UPDATE

Fires when information about achievement criteria or player statistics becomes available

**Payload:** `()`


## CURRENCY_DISPLAY_UPDATE

Fires when new information for the currency list is available

**Payload:** `()`


## CURRENT_SPELL_CAST_CHANGED

Fires when the player starts or stops (cancels or finishes) casting a spell

**Payload:** `()`


## CURSOR_UPDATE

Fires when the mouse cursor image or contents is changed

**Payload:** `()`


## CVAR_UPDATE

Fires when the value of a configuration variable is updated. Fires regardless of whether the variable's value has changed.

Except that it doesn't fire for all CVars that can be set in preferences, and it doesn't fire when someone changes a CVar outside of preferences unless they specifically give it an argument to fire with. You likely want to hook SetCVar instead.

**Payload:** `("glStr", "value")`

**Arguments:**
- `glStr` - Global string related to the given CVAR (like "ENABLEBGSOUND" for "SoundEnableSoundWhenGameIsInBG" CVAR). (`string`)
- `value` - The updated value assigned to the CVAR. Note: For boolean values this is a string of 0 or 1. (`string`)

