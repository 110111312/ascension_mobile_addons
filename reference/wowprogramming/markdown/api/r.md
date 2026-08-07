# WoW API Functions — R

_65 functions_

---

## rad

Converts an angle specified in degrees to radians. Alias for the standard library function `math.rad`.

**Signature:** `radians = rad(degrees)`

**Arguments:**
- `degrees` - An angle specified in degrees (`number`)

**Returns:**
- `radians` - The angle specified in radians (`number`)


## random

Generates a pseudo-random number. Alias for the standard library function `math.random`.

**Signature:** `randomNum = random([m [, n]])`

**Arguments:**
- `m` - First limit for randomly generated numbers (`number`)
- `n` - Second limit for randomly generated numbers (`number`)

**Returns:**
- `randomNum` - If called without arguments, a uniform pseudo-random real number in the range [0,1); if `m` is specified, a uniform pseudo-random integer in the range [1,m]; if both `m` and `n` are specified, a uniform pseudo-random integet in the range [m,n] (`number`)


## RandomRoll

Initiates a public, server-side "dice roll". Used in the default UI to implement the `/roll` chat command; when called, the server generates a random integer and sends it to the player and all others nearby (or in the same party/raid) via a `CHAT_MSG_SYSTEM` event. (The server message is formatted according to the global `RANDOM_ROLL_RESULT`; e.g. "Leeroy rolls 3 (1-100)".)

For random number generation that does not involve the server or send visible messages to other clients, see `math.random`.

**Signature:** `RandomRoll(min, max)`

**Arguments:**
- `min` - Lowest number to be randomly chosen (`number,string`)
- `max` - Highest number to be randomly chosen (`number,string`)


## rawequal

Returns whether two values are equal without invoking any metamethods

**Signature:** `isEqual = rawequal(v1, v2)`

**Arguments:**
- `v1` - Any value (`value`)
- `v2` - Any value (`function`)

**Returns:**
- `isEqual` - True if the values are equal; false otherwise (`boolean`)


## rawget

Returns the real value associated with a key in a table without invoking any metamethods

**Signature:** `value = rawget(t, key)`

**Arguments:**
- `t` - A table (`table`)
- `key` - A key in the table (`value`)

**Returns:**
- `value` - Value of `t[key]` (`value`)


## rawset

Sets the value associated with a key in a table without invoking any metamethods

**Signature:** `rawset(t, key, value)`

**Arguments:**
- `t` - A table (`table`)
- `key` - A key in the table (cannot be `nil`) (`value`)
- `value` - New value to set for the key (`value`)

**See also:** Lua library functions.


## ReadFile

**Signature:** `ReadFile()`

**See also:** Blizzard internal functions.


## RefreshLFGList


## RegisterCVar

Registers a configuration variable to be saved

**Signature:** `RegisterCVar("cvar", "default")`

**Arguments:**
- `cvar` - Name of a CVar (`string`)
- `default` - Default value of the CVar (`string`)

**See also:** CVar functions.


## RegisterForSave

Enables a global variable for automatic saving upon logout & UI reload. Used for some data saved on the local client by the default UI.

Addons should use the `## SavedVariables` TOC directive instead.

**Signature:** `RegisterForSave()`

> **Note:** This function does nothing in the standard game client and is used by Blizzard for internal purposes


## RegisterForSavePerCharacter

Enables a global variable for automatic saving (on a per-character basis) upon logout & UI reload. Used for some data saved on the local client by the default UI.

Addons should use the `## SavedVariablesPerCharacter` TOC directive instead.

**Signature:** `RegisterForSavePerCharacter()`

> **Note:** This function does nothing in the standard game client and is used by Blizzard for internal purposes

**See also:** Utility functions.


## RegisterStaticConstants


## RejectProposal

Rejects a LFG dungeon invite.

**Signature:** `RejectProposal()`

**See also:** Looking for group functions.


## ReloadUI

Reloads the user interface. Saved variables are written to disk, the default UI is reloaded, and all enabled non-LoadOnDemand addons are loaded, including any addons previously disabled which were enabled during the session (see `EnableAddOn()` et al).

**Signature:** `ReloadUI()`


## RemoveChatWindowChannel

Removes a channel from a chat window's list of saved channel subscriptions. Used by the default UI's function `ChatFrame_RemoveChannel()` which manages the set of channel messages shown in a displayed ChatFrame.

**Signature:** `RemoveChatWindowChannel(index, "channel")`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `channel` - Name of the channel to remove (`string`)


## RemoveChatWindowMessages

Removes a message type from a chat window's list of saved message subscriptions. Used by the default UI's functions `ChatFrame_RemoveMessageGroup()` and `ChatFrame_RemoveAllMessageGroups()` which manage the set of message types shown in a displayed ChatFrame.

**Signature:** `RemoveChatWindowMessages(index, "messageGroup")`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `messageGroup` - Token identifying a message type (`string`, chatMsgType)

**See also:** Chat functions.


## RemoveFriend

Removes a character from the friends list

**Signature:** `RemoveFriend("name")`

**Arguments:**
- `name` - Name of a character to remove from the friends list (`string`)

**See also:** Social functions.


## RemoveGlyphFromSocket

Removes the glyph from a socket

**Signature:** `RemoveGlyphFromSocket(socket)`

**Arguments:**
- `socket` - Which glyph socket to query (between 1 and `NUM_GLYPH_SLOTS`) (`number`, glyphIndex)

**See also:** Glyph functions.


## RemoveQuestWatch

Removes a quest from the objectives tracker

**Signature:** `RemoveQuestWatch(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)


## RemoveSkillUp

_No snapshot available (page did not exist in archive)._


## RemoveTrackedAchievement

Removes an achievement from the objectives tracker UI

**Signature:** `RemoveTrackedAchievement(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)


## RenameEquipmentSet

_No snapshot available (page did not exist in archive)._


## RenamePetition

Renames the guild or arena team to be created by the open petition

**Signature:** `RenamePetition("name")`

**Arguments:**
- `name` - New name for the guild or arena team (`string`)

**See also:** Petition functions.


## RepairAllItems

Attempts to repair all of the player's damaged items

**Signature:** `RepairAllItems([useGuildMoney])`

**Arguments:**
- `useGuildMoney` - 1 to use guild bank money (if available); nil or omitted to use the player's own money (`1nil`)

**See also:** Merchant functions.


## ReplaceEnchant

Confirms replacing an existing enchantment. Usable in response to the `REPLACE_ENCHANT` event which fires when the player attempts to apply a temporary or permanent enchantment to an item which already has one.

**Signature:** `ReplaceEnchant()`

**See also:** Item functions.


## ReplaceTradeEnchant

Confirms replacement of an existing enchantment when offering an enchantment for trade. After confirming, the enchantment is not actually performed until both parties accept the trade.

**Signature:** `ReplaceTradeEnchant()`

**See also:** Trade functions.


## RepopMe

Releases the player's spirit to the nearest graveyard. Only has effect if the player is dead.

**Signature:** `RepopMe()`

**See also:** Player information functions.


## ReportBug

. This function was once used to implement the `/bug` command, which was a feature of early World of Warcraft beta tests and is no longer available.

**Signature:** `ReportBug()`


## ReportPlayerIsPVPAFK

Reports a battleground participant as AFK

**Signature:** `ReportPlayerIsPVPAFK("name") or ReportPlayerIsPVPAFK("unit")`

**Arguments:**
- `name` - Name of a friendly player unit in the current battleground (`string`)
- `unit` - A friendly player unit in the current battleground (`string`, unitID)


## ReportSuggestion

. This function was once used to implement the `/suggest` command, which was a feature of early World of Warcraft beta tests and is no longer available.

**Signature:** `ReportSuggestion()`


## RequestBattlefieldPositions

Requests information from the server about team member positions in the current battleground. Automatically called in the default UI by UIParent's and WorldMapFrame's OnUpdate handlers.

**Signature:** `RequestBattlefieldPositions()`


## RequestBattlefieldScoreData

Requests battlefield score data from the server. Score data is not returned immediately; the `UPDATE_BATTLEFIELD_SCORE` event fires once information is available and can be retrieved by calling `GetBattlefieldScore()` and related functions.

**Signature:** `RequestBattlefieldScoreData()`

**See also:** Battlefield functions.


## RequestBattlegroundInstanceInfo

Requests information about available instances of a battleground from the server. The `PVPQUEUE_ANYWHERE_SHOW` event fires once information is available; data can then be retrieved by calling `GetNumBattlefields()` and `GetBattlefieldInstanceInfo()`.

**Signature:** `RequestBattlegroundInstanceInfo(index)`

**Arguments:**
- `index` - Index of a battleground (between 1 and `NUM_BATTLEGROUNDS`) (`number`)


## RequestInspectHonorData

Requests PvP honor and arena data from the server for the currently inspected unit. Once the `INSPECT_HONOR_UPDATE` event fires, PvP honor and arena information can be retrieved using `GetInspectHonorData(team)` and `GetInspectArenaTeamData()`.

**Signature:** `RequestInspectHonorData()`

**See also:** Inspect functions.


## RequestLFDPartyLockInfo


## RequestLFDPlayerLockInfo


## RequestRaidInfo

Requests information about saved instances from the server. Data is not returned immediately; the `UPDATE_INSTANCE_INFO` event when the raid information is available for retrieval via `GetSavedInstanceInfo()` and related functions.

**Signature:** `RequestRaidInfo()`

**See also:** Instance functions.


## RequestTimePlayed

Requests information from the server about the player character's total time spent online. Information is not returned immediately; the `TIME_PLAYED_MSG` event fires when the requested data is available.

**Signature:** `RequestTimePlayed()`


## ResetChatColors

Removes all saved color settings for chat message types, resetting them to default values

**Signature:** `ResetChatColors()`

**See also:** Chat functions.


## ResetChatWindows

Removes all saved chat window settings, resetting them to default values. Used by the default UI's function `FCF_ ResetChatWindows()` which resets the appearance and behavior of displayed FloatingChatFrames.

**Signature:** `ResetChatWindows()`

**See also:** Chat functions.


## ResetCPUUsage

Resets CPU usage statistics. Only has effect if the `scriptProfile` CVar is set to 1.

**Signature:** `ResetCPUUsage()`

**See also:** Debugging and Profiling functions.


## ResetCursor

Returns the cursor to its normal appearance (the glove pointer) and behavior. Has effect after the cursor image/mode has been changed via `SetCursor()`, `ShowContainerSellCursor()`, or similar. Has no immediately visible effect if the cursor is holding an item, spell, or other data.

**Signature:** `ResetCursor()`

**See also:** Cursor functions.


## ResetDisabledAddOns

Reverts changes to the enabled/disabled state of addons. Any addons enabled or disabled in the current session will return to their enabled/disabled state as of the last login or UI reload.

**Signature:** `ResetDisabledAddOns()`


## ResetGroupPreviewTalentPoints

Reverts all changes made in the Talent UI's preview mode

**Signature:** `ResetGroupPreviewTalentPoints(isPet, talentGroup)`

**Arguments:**
- `isPet` - true to edit talents for the player's pet, false to edit talents for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents


## ResetInstances

Resets all non-saved instances associated with the player. Only instances to which the player is not saved may be reset (i.e. normal 5-man dungeons, not heroic dungeons or raids), and only by a solo player or group leader.

**Signature:** `ResetInstances()`


## ResetPerformanceValues

**Signature:** `ResetPerformanceValues()`


## ResetPreviewTalentPoints

Reverts changes made within a specific tab in the Talent UI's preview mode

**Signature:** `ResetPreviewTalentPoints(tabIndex, isPet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent school/tab (between 1 and GetNumTalentTabs()) (`number`)
- `isPet` - true to edit talents for the player's pet, false to edit talents for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**See also:** Talent functions.


## ResetTutorials

Enables contextual tutorial display and clears the list of already displayed tutorials. Tutorials that have already been shown to the player will appear again (via `TUTORIAL_TRIGGER` events) once their conditions are met. The first tutorial will appear again immediately.

**Signature:** `ResetTutorials()`

**See also:** Tutorial functions.


## ResetView

Resets a saved camera setting to default values. There are five "slots" for saved camera settings, indexed 1-5. These views can be set and accessed directly using `SaveView()` and `SetView()`, and cycled through using `NextView()` and `PrevView()`.

**Signature:** `ResetView(index)`

**Arguments:**
- `index` - Index of a saved camera setting (between 1 and 5) (`number`)


## RespondInstanceLock

Allows leaving a recently entered instance to which the player would otherwise be saved. 
 

Applies when the player enters an instance to which other members of her group are saved; if the player leaves the within the time limit (see `GetInstanceLockTimeRemaining()`) she will not be saved to the instance.

**Signature:** `RespondInstanceLock(response)`

**Arguments:**
- `response` - Whether the player wishes to remain in the instance (`boolean`) 

 - `false` - Exit to the nearest graveyard
- `true` - Remain in the zone, saving the player to this instance

**See also:** Instance functions.


## RespondMailLockSendItem


## RestartGx

Restart the client's graphic subsystem. Does not reload the UI.

**Signature:** `RestartGx()`

**See also:** Video functions.


## RestoreVideoEffectsDefaults

_No snapshot available (page did not exist in archive)._


## RestoreVideoResolutionDefaults

_No snapshot available (page did not exist in archive)._


## RestoreVideoStereoDefaults

Resets stereoscopic 3D video options to default values. These options are shown in the Video -> Stereo panel in the default UI and include settings for convergence and eye separation.

**Signature:** `RestoreVideoStereoDefaults()`

**See also:** Video functions.


## ResurrectGetOfferer

Returns the name of a unit offering to resurrect the player. 
Returns nil if no resurrection has been offered or if an offer has expired.

**Signature:** `name = ResurrectGetOfferer()`

**Returns:**
- `name` - Name of the unit offering resurrection (`string`)

**See also:** Player information functions.


## ResurrectHasSickness

Returns whether accepting an offered resurrection spell will cause the player to suffer Resurrection Sickness. Usable following the `RESURRECT_REQUEST` event which fires when the player is offered resurrection by another unit.

Generally always returns `nil`, as resurrection by other players does not cause sickness.

**Signature:** `hasSickness = ResurrectHasSickness()`

**Returns:**
- `hasSickness` - 1 if accepting resurrection will cause Resurrection Sickness; otherwise nil (`1nil`)


## ResurrectHasTimer

Returns whether the player must wait before resurrecting. Applies to resurrection spells offered by other units, resurrecting by returning to the player's corpse as a ghost, and to resurrecting at a graveyard's spirit healer, if the player has recently died several times in short succession. See `GetCorpseRecoveryDelay()` for the time remaining until the player can resurrect.

**Signature:** `hasTimer = ResurrectHasTimer()`

**Returns:**
- `hasTimer` - 1 if the player must wait before resurrecting; otherwise nil (`1nil`)


## RetrieveCorpse

Confirms resurrection by returning to the player's corpse

**Signature:** `RetrieveCorpse()`


## ReturnInboxItem

Returns a message in the player's inbox to its sender

**Signature:** `ReturnInboxItem(mailID)`

**Arguments:**
- `mailID` - Index of a message in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)


## RollOnLoot

Register the player's intent regarding an item up for loot rolling. Rolls are not actually performed until all eligible group members have registered their intent or the time period for rolling expires.

If the item binds on pickup, the `CONFIRM_LOOT_ROLL` event fires, indicating that `ConfirmLootRoll(id)` must be called in order to actually roll on the item.

**Signature:** `RollOnLoot(id, rollType)`

**Arguments:**
- `id` - Index of an item currently up for loot rolling (as provided in the `START_LOOT_ROLL` event) (`number`)
- `rollType` - Type of roll action to perform (`number`) 

 - `0` - Pass (declines the loot)
- `1` - Roll "need" (wins if highest roll)
- `2` - Roll "greed" (wins if highest roll and no other member rolls "need")
- `3` - Disenchant

**See also:** Loot functions.


## RunBinding

Runs the script associated with a key binding action. Note: this function is not protected, but the scripts for many default key binding actions are (and can only be called by the Blizzard UI).

**Signature:** `RunBinding("COMMAND")`

**Arguments:**
- `COMMAND` - Name of a key binding command (`string`)

**See also:** Keybind functions.


## RunMacro

Runs a macro

**Signature:** `RunMacro(index [, ""button""]) or RunMacro("name" [, ""button""])`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)
- `"button"` - The mouse button used to click the macro; may be used by `[button:`x`]` options in the macro (`string`)

**See also:** Macro functions.


## RunMacroText

Runs arbitrary text as a macro

**Signature:** `RunMacroText(""text"" [, ""button""])`

**Arguments:**
- `"text"` - The text of the macro to run (`string`)
- `"button"` - The mouse button used to click the macro; may be used by `[button:`x`]` options in the macro (`string`)

**See also:** Macro functions.


## RunScript

Runs a string as a Lua script

**Signature:** `RunScript("script")`

**Arguments:**
- `script` - A Lua script to be run (`string`)

**See also:** Utility functions.

