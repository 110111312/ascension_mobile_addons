# WoW API Functions — D

_50 functions_

---

## date

Returns a formatted date/time string for a date (or the current date). Alias to the standard library function `os.date`.

**Signature:** `dateValue = date(["format" [, time]])`

**Arguments:**
- `format` - A string describing the formatting of time values (as in the ANSI C `strftime()`function), or `*t` to return the time as a table; optionally preceded by `!` for Coordinated Universal Time instead of the local time zone; omitted for a date printed in the default format (`string`)
- `time` - Time value to be formatted (see `time()` for description); if omitted, uses the current time (`number`)

**Returns:**
- `dateValue` - A formatted date/time string, (`string or table`)


## debugbreak


## debugdump

**Signature:** `debugdump()`


## debughook


## debuginfo

**Signature:** `debuginfo()`


## debugload


## debuglocals

Returns information about the local variables at a given stack depth

**Signature:** `localsInfo = debuglocals(stackLevel)`

**Arguments:**
- `stackLevel` - The stack level to query (`number`)

**Returns:**
- `localsInfo` - A string detailing the local variables at the given stack depth. (`string`)

**See also:** Utility functions.


## debugprint

**Signature:** `debugprint()`


## debugprofilestart

Starts/resets the high resolution profiling timer. Subsequent calls to `debugprofilestop()` will return the current value of the timer.

**Signature:** `debugprofilestart()`


## debugprofilestop

Returns the value of the profiling timer

**Signature:** `time = debugprofilestop()`

**Returns:**
- `time` - Current value of the profiling timer (in milliseconds, with sub-millisecond precision) (`number`)


## debugstack

Returns information about the current function call stack

**Signature:** `debugstring = debugstack(start, countTop, countBot)`

**Arguments:**
- `start` - Stack level at which to begin listing functions; 0 is the `debugstack()` function itself, 1 is the function that called `debugstack()`, 2 is the function that called function 1, etc. Defaults to 1 if omitted (`number`)
- `countTop` - Maximum number of functions to output at the top of the stack trace (`number`)
- `countBot` - Maximum number of functions to output at the bottom of the stack trace, (`number`)

**Returns:**
- `debugstring` - A multi-line string describing the current function call stack (`string`)

**See also:** Debugging and Profiling functions.


## debugtimestamp


## DeclineArenaTeam

Declines an arena team invitation

**Signature:** `DeclineArenaTeam()`

**See also:** Arena functions.


## DeclineGroup

Declines an invitation to join a party or raid. Usable in response to the `PARTY_INVITE_REQUEST` event which fires when the player is invited to join a group.

**Signature:** `DeclineGroup()`

**See also:** Party functions, Raid functions.


## DeclineGuild

Declines an offered guild invitation. Usable in response to the `GUILD_INVITE_REQUEST` event which fires when the player is invited to join a guild.

**Signature:** `DeclineGuild()`

**See also:** Guild functions.


## DeclineInvite

Declines an invitation to a chat channel. Usable in response to the `CHANNEL_INVITE_REQUEST` event which fires when the player is invited to join a chat channel.

**Signature:** `DeclineInvite("channel")`

**Arguments:**
- `channel` - Name of a chat channel (`string`)

**See also:** Channel functions.


## DeclineLevelGrant

Refuses a level offered by the player's Recruit-a-Friend partner

**Signature:** `DeclineLevelGrant()`


## DeclineName

Returns suggested declensions for a name. In the Russian language, nouns (including proper names) take different form based on their usage in a sentence. When the player enters the base name for a character or pet, the game suggests one or more sets of variations for the five additional cases; the player is asked to choose from among the suggestions and/or enter their own. (The set of declensions ultimately chosen/entered by the player are only used internally and not available to addons.)

Has no effect in non-Russian-localized clients.

**Signature:** `genitive, dative, accusative, instrumental, prepositional = DeclineName("name", gender, declensionSet)`

**Arguments:**
- `name` - Nominative form of the player's or pet's name (`string`)
- `gender` - Gender for the returned names (for declensions of the player's name, should match the player's gender; for the pet's name, should be neuter) (`number`) 

 - `1or nil` - Neuter
- `2` - Male
- `3` - Female
- `declensionSet` - Index of a set of suggested declensions (between 1 and `GetNumDeclensionSets(name,gender)`. Lower indices correspond to "better" suggestions for the given name. (`number`)

**Returns:**
- `genitive` - Genitive form of the name (`string`)
- `dative` - Dative form of the name (`string`)
- `accusative` - Accusative form of the name (`string`)
- `instrumental` - Instrumental form of the name (`string`)
- `prepositional` - Prepositional form of the name (`string`)

**See also:** Locale-specific functions.


## DeclineQuest

Declines a quest.. Usable following the `QUEST_DETAIL` event in which the questgiver presents the player with the details of a quest and the option to accept or decline.

**Signature:** `DeclineQuest()`


## DeclineResurrect

Declines an offered resurrection spell. Usable following the `RESURRECT_REQUEST` event which fires when the player is offered resurrection by another unit.

**Signature:** `DeclineResurrect()`

**See also:** Player information functions.


## deg

Converts an angle measurement in radians to degrees. Alias for the standard library function `math.deg`.

**Signature:** `degrees = deg(radians)`

**Arguments:**
- `radians` - An angle specified in radians (`number`)

**Returns:**
- `degrees` - The angle specified in degrees (`number`)

**See also:** Lua library functions.


## DeleteCursorItem

Destroys the item on the cursor. Used in the default UI when accepting the confirmation prompt that appears when dragging and dropping an item to an empty area of the screen.

**Signature:** `DeleteCursorItem()`

**See also:** Item functions, Cursor functions.


## DeleteEquipmentSet

Deletes an equipment set

**Signature:** `DeleteEquipmentSet("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)


## DeleteFile


## DeleteGMTicket

Abandons the currently pending GM ticket

**Signature:** `DeleteGMTicket()`

**See also:** GM Ticket functions.


## DeleteInboxItem

Deletes a mail from the player's inbox

**Signature:** `DeleteInboxItem(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**See also:** Mail functions.


## DeleteMacro

Deletes a macro

**Signature:** `DeleteMacro(index) or DeleteMacro("name")`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)


## DelIgnore

Removes a player from the ignore list

**Signature:** `DelIgnore("name")`

**Arguments:**
- `name` - Name of a character to remove from the ignore list (`string`)

**See also:** Social functions.


## DelMute

Removes a character from the muted list for voice chat. The Muted list acts for voice chat as the Ignore list does for text chat: muted characters will never be heard regardless of which voice channels they join the player in.

**Signature:** `DelMute("name")`

**Arguments:**
- `name` - Name of a character to remove from the mute list (`string`)

**See also:** Voice functions.


## DemoteAssistant

Demotes the given player from raid assistant status

**Signature:** `DemoteAssistant("unit") or DemoteAssistant("name" [, exactMatch])`

**Arguments:**
- `unit` - A unit in the raid (`string`, unitID)
- `name` - Name of a unit in the raid (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Raid functions.


## DepositGuildBankMoney

Deposits money into the guild bank

**Signature:** `DepositGuildBankMoney(money)`

**Arguments:**
- `money` - Amount of money to deposit (in copper) (`number`)


## DescendStop

Stops movement initiated by `SitStandOrDescendStart`. Used by the `SITORSTAND` binding, which also controls descent when swimming or flying. Has no meaningful effect if called while sitting/standing.

**Signature:** `DescendStop()`

**See also:** Movement functions.


## DestroyTotem

Destroys a specific totem (or ghoul). Totem functions are also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).

**Signature:** `DestroyTotem(slot)`

**Arguments:**
- `slot` - Which totem to destroy (`number`) 

 - `1` - Fire (or Death Knight's ghoul)
- `2` - Earth
- `3` - Water
- `4` - Air

**See also:** Pet functions, Class resource functions.


## DetectWowMouse

Detects the presence of a "WoW" compatible multi-button mouse. This function is used by the default user interface to enable or disable the configuration option for a many buttoned WoW mouse. If the mouse is not found, the `WOW_MOUSE_NOT_FOUND` event will fire.

**Signature:** `DetectWowMouse()`

**See also:** Blizzard internal functions.


## difftime

Returns the number of seconds between two time values. Alias for the standard library function `os.difftime`.

**Signature:** `seconds = difftime(time2, time1)`

**Arguments:**
- `time2` - A time value (see `time()` for description) (`number`)
- `time1` - A time value (see `time()` for description) (`number`)

**Returns:**
- `seconds` - Number of seconds between `time2` and `time1`; equivalent to `time2 - time1` on all current WoW clients (`number`)


## DisableAddOn

Marks an addon as disabled. The addon will remain active until the player logs out and back in or reloads the UI (see `ReloadUI()`). Changes to the enabled/disabled state of addons while in-game are saved on a per-character basis.

**Signature:** `DisableAddOn("name") or DisableAddOn(index)`

**Arguments:**
- `name` - Name of an addon (name of the addon's folder and TOC file, not the Title found in the TOC) (`string`)
- `index` - Index of an addon in the addon list (between 1 and `GetNumAddOns()`) (`number`)

**See also:** Addon-related functions.


## DisableAllAddOns

Marks all addons as disabled. Addons will remain active until the player logs out and back in or reloads the UI (see `ReloadUI()`).

Changes to the enabled/disabled state of addons while in-game are saved on a per-character basis.

**Signature:** `DisableAllAddOns()`

**See also:** Addon-related functions.


## DisableSpellAutocast

Disables automatic casting of a pet spell

**Signature:** `DisableSpellAutocast("spell")`

**Arguments:**
- `spell` - The name of a pet spell (`string`)

**See also:** Spell functions, Pet functions.


## DismissCompanion

Unsummons the current non-combat pet or mount

**Signature:** `DismissCompanion("type")`

**Arguments:**
- `type` - The type of companion (`string`) 

 - `CRITTER` - Non-combat pet
- `MOUNT` - Mount

**See also:** Companion functions.


## Dismount

Dismounts from the player's summoned mount

**Signature:** `Dismount()`

**See also:** Player information functions.


## DisplayChannelOwner

Requests information from the server about a channel's owner. Fires the `CHANNEL_OWNER` event indicating the name of the channel owner.

**Signature:** `DisplayChannelOwner("channel") or DisplayChannelOwner(channelIndex)`

**Arguments:**
- `channel` - Name of a channel (`string`)
- `channelIndex` - Index of a channel (`number`)

**See also:** Channel functions.


## DisplayChannelVoiceOff

Disables voice in a channel specified by its position in the channel list display

**Signature:** `DisplayChannelVoiceOff(index)`

**Arguments:**
- `index` - Index of a channel in the channel list display (between 1 and `GetNumDisplayChannels()`) (`number`)


## DisplayChannelVoiceOn

Enables voice in a channel specified by its position in the channel list display

**Signature:** `DisplayChannelVoiceOn(index)`

**Arguments:**
- `index` - Index of a channel in the channel list display (between 1 and `GetNumDisplayChannels()`) (`number`)

**See also:** Channel functions, Voice functions.


## DoEmote

Performs a preset emote (with optional target). The list of built-in emote tokens can be found in global variables whose names follow the format `"EMOTE"..num.."_TOKEN"`, where `num` is a number between `1` and `MAXEMOTEINDEX` (a variable local to ChatFrame.lua.)

For custom emotes (as performed using the `/emote` or `/me` commands in the default UI), see `SendChatMessage()`.

**Signature:** `DoEmote("emote" [, "target" [, hold]])`

**Arguments:**
- `emote` - Non-localized token identifying an emote to perform (`string`)
- `target` - Name of a unit at whom to direct the emote (`string`)
- `hold` - Hold the emote animation until cancelled (`boolean`)

**See also:** Chat functions.


## DoReadyCheck

Initiates a ready check. Only has effect if the player is the party/raid leader or a raid assistant.

**Signature:** `DoReadyCheck()`

**See also:** Party functions, Raid functions.


## DoTradeSkill

Performs a trade skill recipe

**Signature:** `DoTradeSkill(index [, repeat])`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)
- `repeat` - Number of times to repeat the recipe (`number`)


## DownloadSettings

Restores game settings from a backup stored on the server. This function only works if server-synchronized settings are enabled. This is controlled by the `synchronizeSettings` CVar.

**Signature:** `DownloadSettings()`

**See also:** Client control and information functions.


## DropCursorMoney

Drops any money currently on the cursor, returning it to where it was taken from

**Signature:** `DropCursorMoney()`


## DropItemOnUnit

"Gives" the item on the cursor to another unit; results vary by context. If the unit is a friendly player, adds the item to the trade window (opening it if necessary, and placing it in the first available trade slot or the "will not be traded" slot depending on whether the item is soulbound). If the unit is the player's pet and the player is a Hunter, attempts to feed the item to the pet (since this casts the Feed Pet spell, in this case this action is protected and can only be called by the Blizzard user interface). For other units, nothing happens and the item remains on the cursor.

**Signature:** `DropItemOnUnit("unit") or DropItemOnUnit("name")`

**Arguments:**
- `unit` - A unit to receive the item (`string`, unitID)
- `name` - Name of a unit to receive the item; only valid for `player`, `pet`, and party/raid members (`string`)

**See also:** Cursor functions.


## DungeonUsesTerrainMap

