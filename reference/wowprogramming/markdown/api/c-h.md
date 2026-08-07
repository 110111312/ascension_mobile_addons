# WoW API — C (H*)

_26 functions_

---

## ChangeActionBarPage

Changes the current action bar page

**Signature:** `ChangeActionBarPage(page)`

**Arguments:**
- `page` - The action bar page to change to (`number`)

**See also:** ActionBar functions.



## ChangeChatColor

Changes the color of a message type in the chat windows. This change takes effect immediately.

**Signature:** `ChangeChatColor("messageType", red, green, blue)`

**Arguments:**
- `messageType` - The message type, as listed in chat-cache.txt. Example values are "SAY" and "CHANNEL1". (`string`)
- `red` - The value of the red component color (0.0 - 1.0) (`number`)
- `green` - The value of the green component color (0.0 - 1.0) (`number`)
- `blue` - The value of the blue component color (0.0 - 1.0) (`number`)



## ChangePlayerDifficulty

_No snapshot available (page did not exist in archive)._



## ChannelBan

Bans a character from a chat channel. Has no effect unless the player is a moderator of the given channel

**Signature:** `ChannelBan("channel", "fullname")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `fullname` - Name of the character to be banned (`string`)



## ChannelInvite

Invites a character to join a chat channel

**Signature:** `ChannelInvite("channel", "name")`

**Arguments:**
- `channel` - Name of a channel (`string`)
- `name` - Name of a character to invite (`string`)



## ChannelKick

Removes a player from the channel. Has no effect unless the player is a moderator of the given channel

**Signature:** `ChannelKick("channel", "fullname")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `fullname` - Name of the character to kick (`string`)

**See also:** Channel functions.



## ChannelModerator

Grants a character moderator status in a chat channel. Has no effect unless the player is the owner of the given channel

**Signature:** `ChannelModerator("channel", "fullname")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `fullname` - Name of the character to promote to moderator (`string`)

**See also:** Channel functions.



## ChannelMute

Grants a character ability to speak in a moderated chat channel

**Signature:** `ChannelMute("channelName", "name") or ChannelMute(channelId, "name")`

**Arguments:**
- `channelName` - Name of a channel (`string`)
- `channelId` - Index of a channel (`number`)
- `name` - Name of a character to mute (`string`)

**See also:** Channel functions.



## ChannelSilenceAll

Silences a character for chat and voice on a channel

**Signature:** `ChannelSilenceAll("channelName", ["unit"] or ["name"]) or ChannelSilenceAll(channelId, ["unit"] or ["name"]) or ChannelSilenceAll(["channelName"] or [channelId], "unit") or ChannelSilenceAll(["channelName"] or [channelId], "name")`

**Arguments:**
- `channelName` - Name of a channel (`string`)
- `channelId` - Index of a channel (`number`)
- `unit` - Unit to silence (`string`, unitID)
- `name` - Name of a character to silence (`string`)

**See also:** Voice functions, Channel functions.



## ChannelSilenceVoice

Silences the given character for voice chat on the channel. Only a raid/party/battleground leader or assistant can silence a player.

**Signature:** `ChannelSilenceVoice("channelName", ["unit"] or ["name"]) or ChannelSilenceVoice(channelId, ["unit"] or ["name"]) or ChannelSilenceVoice(["channelName"] or [channelId], "unit") or ChannelSilenceVoice(["channelName"] or [channelId], "name")`

**Arguments:**
- `channelName` - Name of a channel (`string`)
- `channelId` - Index of a channel (`number`)
- `unit` - Unit to silence (`string`, unitID)
- `name` - Name of a character to silence (`string`)



## ChannelToggleAnnouncements

Enables or disables printing of join/leave announcements for a channel

**Signature:** `ChannelToggleAnnouncements("channel")`

**Arguments:**
- `channel` - Name of the channel for which to enable or disable announcements (`string`)

**See also:** Channel functions.



## ChannelUnban

Lifts the ban preventing a character from joining a chat channel. Has no effect unless the player is a moderator of the given channel

**Signature:** `ChannelUnban("channel", "fullname")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `fullname` - Name of the character to for which to lift the ban (`string`)

**See also:** Channel functions.



## ChannelUnmoderator

Revokes moderator status from a character on a chat channel. Has no effect unless the player is the owner of the given channel

**Signature:** `ChannelUnmoderator("channel", "fullname")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `fullname` - Name of the character to demote from moderator (`string`)



## ChannelUnmute

Removes a character's ability to speak in a moderated chat channel

**Signature:** `ChannelUnmute("channelName", "name") or ChannelUnmute(channelId, "name")`

**Arguments:**
- `channelName` - Name of a channel (`string`)
- `channelId` - Index of a channel (`number`)
- `name` - Name of a character to unmute (`string`)

**See also:** Channel functions.



## ChannelUnSilenceAll

Unsilences a character for chat and voice on a channel

**Signature:** `ChannelUnSilenceAll("channelName", ["unit"] or ["name"]) or ChannelUnSilenceAll(channelId, ["unit"] or ["name"]) or ChannelUnSilenceAll(["channelName"] or [channelId], "unit") or ChannelUnSilenceAll(["channelName"] or [channelId], "name")`

**Arguments:**
- `channelName` - Name of a channel (`string`)
- `channelId` - Index of a channel (`number`)
- `unit` - Unit to unsilence (`string`, unitID)
- `name` - Name of a character to unsilence (`string`)

**See also:** Channel functions, Voice functions.



## ChannelUnSilenceVoice

Unsilences a character on a chat channel

**Signature:** `ChannelUnSilenceVoice("channelName", ["unit"] or ["name"]) or ChannelUnSilenceVoice(channelId, ["unit"] or ["name"]) or ChannelUnSilenceVoice(["channelName"] or [channelId], "unit") or ChannelUnSilenceVoice(["channelName"] or [channelId], "name")`

**Arguments:**
- `channelName` - Name of a channel (`string`)
- `channelId` - Index of a channel (`number`)
- `unit` - Unit to unsilence (`string`, unitID)
- `name` - Name of a character to unsilence (`string`)

**See also:** Channel functions, Voice functions.



## ChannelVoiceOff

Disables voice chat in a channel

**Signature:** `ChannelVoiceOff("channel") or ChannelVoiceOff(channelIndex)`

**Arguments:**
- `channel` - Name of a channel (`string`)
- `channelIndex` - Index of a channel (`number`)

**See also:** Voice functions, Channel functions.



## ChannelVoiceOn

Enables voice chat in a channel

**Signature:** `ChannelVoiceOn("channel") or ChannelVoiceOn(channelIndex)`

**Arguments:**
- `channel` - Name of a channel (`string`)
- `channelIndex` - Index of a channel (`number`)

**See also:** Voice functions, Channel functions.



## ChatFrame_AddMessageEventFilter

Adds a function to filter or alter messages to the chat display system. The filter function will be called each time a message is sent to one of the default chat frames (ChatFrame1, ChatFrame2, ..., ChatFrame7). The function will be passed the chat frame object that the message is being added to, along with the event that caused the messages to be added, and the arguments to that event.

A filter function may return `true` if the message should be filtered , or `false` if the message should be displayed. Following this boolean flag, the message can return a list of (possibly) altered arguments to be passed to the next filter function.

See examples for details.

**Signature:** `ChatFrame_AddMessageEventFilter("event", filter)`

**Arguments:**
- `event` - A `CHAT_MSG_` Event for which the filter should be used (`string`)
- `filter` - A function to filter incoming messages (`function`)



## ChatFrame_GetMessageEventFilters

Returns the list of filters registered for a chat event. See `ChatFrame_AddMessageEventFilter()` for details about chat message filters.

**Signature:** `filterTable = ChatFrame_GetMessageEventFilters("event")`

**Arguments:**
- `event` - A `CHAT_MSG_` Event (`string`)

**Returns:**
- `filterTable` - A table containing any filters set for the given event, with numeric keys corresponding to the order in which filters were registered (`table`)

> **Note:** This function is not a C API but a Lua function declared in Blizzard's default user interface. Its implementation can be viewed by extracting the addon data using the Addon Kit provided by Blizzard.

**See also:** Chat functions.



## ChatFrame_RemoveMessageEventFilter

Removes a previously set chat message filter. See `ChatFrame_AddMessageEventFilter()` for details about chat message filters.

**Signature:** `ChatFrame_RemoveMessageEventFilter("event", filter)`

**Arguments:**
- `event` - `CHAT_MSG_` Event from which to remove a filter (`string`)
- `filter` - A filter function registered for the event (`function`)

> **Note:** This function is not a C API but a Lua function declared in Blizzard's default user interface. Its implementation can be viewed by extracting the addon data using the Addon Kit provided by Blizzard.

**See also:** Chat functions.



## CheckBinderDist

Returns whether the player is in range of an NPC that can set the Hearthstone location. Usable following the `CONFIRM_BINDER` event which fires when the player speaks to an Innkeeper (or similar) NPC and chooses to set his or her Hearthstone location. Used in the default UI to hide the confirmation window for such if the player moves too far away from the NPC.

**Signature:** `inRange = CheckBinderDist()`

**Returns:**
- `inRange` - 1 if the player is in range of an NPC that can set the Hearthstone location; otherwise nil (`1nil`)



## CheckInbox

Requests the player's mailbox information from the server. When the client has received the inbox information the MAIL_INBOX_UPDATE event is fired. When this happens, the mail information is cached and can be accessed anywhere in the world. This function requires that the mailbox window be open.

**Signature:** `CheckInbox()`



## CheckInteractDistance

Returns whether the player is close enough to a unit for certain types of interaction

**Signature:** `canInteract = CheckInteractDistance("unit", distIndex)`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `distIndex` - Number identifying one of the following action types (`number`) 

 - `1` - Inspect
- `2` - Trade
- `3` - Duel
- `4` - Follow

**Returns:**
- `canInteract` - 1 if the player is close enough to the other unit to perform the action; otherwise nil (`1nil`)



## CheckSpiritHealerDist

Returns whether the player is in range of a spirit healer. Usable following the `CONFIRM_XP_LOSS` event which fires upon speaking to a spirit healer while dead and choosing the option to immediately resurrect. Used in the default UI to hide the confirmation window for such if the player moves too far away from the spirit healer.

**Signature:** `inRange = CheckSpiritHealerDist()`

**Returns:**
- `inRange` - 1 if the player is in range of a spirit healer; otherwise nil (`1nil`)

**See also:** Player information functions.



## CheckTalentMasterDist

Returns whether the player is in range of an NPC that can reset talents. Usable following the `CONFIRM_TALENT_WIPE` event which fires when the player speaks to an trainer NPC and chooses to reset his or her talents. Used in the default UI to hide the confirmation window for such if the player moves too far away from the NPC.

**Signature:** `inRange = CheckTalentMasterDist()`

**Returns:**
- `inRange` - 1 if the player is in range of a talent trainer; otherwise nil (`1nil`)

**See also:** Talent functions, Trainer functions.


