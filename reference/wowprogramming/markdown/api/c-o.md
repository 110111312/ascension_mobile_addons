# WoW API — C (O*)

_72 functions_

---

## CollapseAllFactionHeaders

Collapses all headers and sub-headers in the Reputation UI. This function works for both major groups (Classic, Burning Crusade, Wrath of the Lich King, Inactive, etc.) and the sub-groups within them (Alliance Forces, Steamwheedle Cartel, Horde Expedition, Shattrath City, etc.).

**Signature:** `CollapseAllFactionHeaders()`

**See also:** Faction functions.



## CollapseChannelHeader

Collapses a group header in the chat channel listing

**Signature:** `CollapseChannelHeader(index)`

**Arguments:**
- `index` - Index of a header in the display channel list (between 1 and `GetNumDisplayChannels()`) (`number`)

**See also:** Channel functions.



## CollapseFactionHeader

Collapses a given faction header or sub-header in the Reputation UI. 
Faction headers include both major groups (Classic, Burning Crusade, Wrath of the Lich King, Inactive, etc.) and the sub-groups within them (Alliance Forces, Steamwheedle Cartel, Horde Expedition, Shattrath City, etc.).

**Signature:** `CollapseFactionHeader(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**See also:** Faction functions.



## CollapseQuestHeader

Collapses a header in the quest log

**Signature:** `CollapseQuestHeader(questIndex)`

**Arguments:**
- `questIndex` - Index of a header in the quest log (between 1 and `GetNumQuestLogEntries()`), or 0 to collapse all headers (`number`)

**See also:** Quest functions.



## CollapseSkillHeader

_No snapshot available (page did not exist in archive)._



## CollapseTradeSkillSubClass

Collapses a group header in the trade skill listing. Causes an error if `index` does not refer to a header.

**Signature:** `CollapseTradeSkillSubClass(index)`

**Arguments:**
- `index` - Index of a header in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)



## CollapseTrainerSkillLine

_No snapshot available (page did not exist in archive)._



## collectgarbage

Interface to the Lua garbage collector

**Signature:** `collectgarbage(option [, arg])`

**Arguments:**
- `option` - One of the following options 

 - `collect` - Performs a full garbage collection cycle
- `count` - Returns the total Lua memory usage (in kilobytes)
- `restart` - Restarts the garbage collector
- `setpause` - Sets the garbage collector's pause percentage to `arg`; e.g., if 200, the collector waits for memory usage to double before starting a new cycle
- `setstepmul` - Sets the garbage collector's speed (as a percentage relative to memory allocation) to `arg`; e.g., if 200, the collector runs twice as fast as memory is allocated
- `step` - Performs a garbage collection step, with size `arg`
- `stop` - Stops the garbage collector
- `arg` - Argument applicable to some options



## CombatLog_Object_IsA

Returns whether an entity from the combat log matches a given filter

**Signature:** `isMatch = CombatLog_Object_IsA(unitFlags, mask)`

**Arguments:**
- `unitFlags` - Source or destination unit flags from a combat log entry (`number`, bitfield)
- `mask` - One of the following global constants: (`number`, bitfield) 

 - `COMBATLOG_FILTER_EVERYTHING` - Any entity
- `COMBATLOG_FILTER_FRIENDLY_UNITS` - Entity is a friendly unit
- `COMBATLOG_FILTER_HOSTILE_PLAYERS` - Entity is a hostile player unit
- `COMBATLOG_FILTER_HOSTILE_UNITS` - Entity is a hostile non-player unit
- `COMBATLOG_FILTER_ME` - Entity is the player
- `COMBATLOG_FILTER_MINE` - Entity is a non-unit object belonging to the player; e.g. a totem
- `COMBATLOG_FILTER_MY_PET` - Entity is the player's pet
- `COMBATLOG_FILTER_NEUTRAL_UNITS` - Entity is a neutral unit
- `COMBATLOG_FILTER_UNKNOWN_UNITS` - Entity is a unit currently unknown to the WoW client

**Returns:**
- `isMatch` - 1 if the entity flags match the given mask (`1nil`)

**See also:** CombatLog functions.



## CombatLogAddFilter

Adds a filter to the combat log system. Each time this function is called a new filter is added to the combat log system. Any combat log entry that passes the filter will be fired as a `COMBAT_LOG_EVENT` event in order from oldest to newest.

**Signature:** `CombatLogAddFilter("events", "srcGUID", ["destGUID"] or [destMask]) or CombatLogAddFilter("events", srcMask, ["destGUID"] or [destMask]) or CombatLogAddFilter("events", ["srcGUID"] or [srcMask], "destGUID") or CombatLogAddFilter("events", ["srcGUID"] or [srcMask], destMask)`

**Arguments:**
- `events` - Name of a combat log event type to include in the filtered list, or a comma-separated list of multiple names (`string`)
- `srcGUID` - GUID of the source unit (`string`, guid)
- `srcMask` - Bit mask of the source unit (`number`, bitfield)
- `destGUID` - GUID of the destination unit (`string`, guid)
- `destMask` - Bit mask of the destination unit (`number`, bitfield)

**See also:** CombatLog functions.



## CombatLogAdvanceEntry

Advances the "cursor" position used by other CombatLog functions. Information about the entry at the "cursor" position can be retrieved with `CombatLogGetCurrentEntry()`. That function then advances the cursor to the next entry, so calling it repeatedly returns all information in the combat log -- this function can be used to "rewind" the combat log to retrieve information about earlier events or skip entries without retrieving their information.

**Signature:** `hasEntry = CombatLogAdvanceEntry(count, ignoreFilter)`

**Arguments:**
- `count` - Number of entries by which to advance the "cursor"; can be negative to move to a previous entry (`number`)
- `ignoreFilter` - True to use the entire saved combat log history; false or omitted to use only events matching the current filter (`boolean`)

**Returns:**
- `hasEntry` - 1 if an entry exists at the new cursor position; otherwise nil (`1nil`)

**See also:** CombatLog functions.



## CombatLogClearEntries

Removes all entries from the combat log

**Signature:** `CombatLogClearEntries()`



## CombatLogGetCurrentEntry

Returns the combat log event information for the current entry and advances to the next entry. See `COMBAT_LOG_EVENT` for details of the event information.

The combat log maintains a "cursor" in the list of entries; this function returns information about the event at the cursor position and advances the cursor to the next entry. Since this function is used by the default UI's combat log display, the cursor position is usually at the end of the log -- calling it thus returns nothing. The function `CombatLogSetCurrentEntry()` can be used to "rewind" the combat log cursor, enabling retrieval of information about earlier events.

**Signature:** `timestamp, event, srcGUID, srcName, srcFlags, destGUID, destName, destFlags, ... = CombatLogGetCurrentEntry([ignoreFilter])`

**Arguments:**
- `ignoreFilter` - True to use the entire saved combat log history; false or omitted to use only events matching the current filter (`boolean`)

**Returns:**
- `timestamp` - Time at which the event occurred (same format as `time()` and `date()`, but with millisecond precision) (`number`)
- `event` - Type of combat log event (`string`)
- `srcGUID` - GUID of the unit that initiated the event (`string`, guid)
- `srcName` - Name of the unit that initiated the event (`string`)
- `srcFlags` - Flags indicating the nature of the source unit (`number`, bitfield)
- `destGUID` - GUID of the unit that was the target of the event (`string`, guid)
- `destName` - Name of the unit that was the target of the event (`string`)
- `destFlags` - Flags indicating the nature of the target unit (`number`, bitfield)
- `...` - Additional arguments specific to the event type (`list`)

**See also:** CombatLog functions.



## CombatLogGetNumEntries

Returns the number of available combat log events

**Signature:** `CombatLogGetNumEntries(ignoreFilter)`

**Arguments:**
- `ignoreFilter` - True to use the entire saved combat log history; false or omitted to use only events matching the current filter (`boolean`)



## CombatLogGetRetentionTime

Returns the amount of time combat log entries are stored

**Signature:** `seconds = CombatLogGetRetentionTime()`

**Returns:**
- `seconds` - Amount of time entries remain available (`number`)



## CombatLogResetFilter

Removes any filters applied to the combat log

**Signature:** `CombatLogResetFilter()`

**See also:** CombatLog functions.



## CombatLogSetCurrentEntry

Sets the "cursor" position used by other CombatLog functions. Information about the entry at the "cursor" position can be retrieved with `CombatLogGetCurrentEntry()`. That function then advances the cursor to the next entry, so calling it repeatedly returns all information in the combat log -- this function can be used to "rewind" the combat log to retrieve information about earlier events.

The argument `index` can be positive or negative: positive indices start at the beginning of the combat log (oldest events) and count up to the end (newest events); negative indices start at `-1` for the newest event and count backwards to to `-``CombatLogGetNumEntries(ignoreFilter)` for the oldest.

**Signature:** `CombatLogSetCurrentEntry(index [, ignoreFilter])`

**Arguments:**
- `index` - Index of a combat log event (between `1` and `CombatLogGetNumEntries(ignoreFilter)`, or between `-1` and `-``CombatLogGetNumEntries(ignoreFilter)`) (`number`)
- `ignoreFilter` - True to use the entire saved combat log history; false or omitted to use only events matching the current filter (`boolean`)



## CombatLogSetRetentionTime

Sets the amount of time combat log entries will be stored

**Signature:** `CombatLogSetRetentionTime(seconds)`

**Arguments:**
- `seconds` - The desired time (`number`)

**See also:** CombatLog functions.



## CombatTextSetActiveUnit

Sets the main unit for display of floating combat text. 
Certain types of floating combat text are only displayed for the "active" unit (normally the player): incoming damage, incoming heals, mana/energy/power gains, low health/mana warnings, etc. This function is used by the default UI to allow the player's vehicle to "stand in" for the player for purposes of combat text; using this function with units other than "player" or "vehicle" has no effect.

**Signature:** `CombatTextSetActiveUnit(unit)`

**Arguments:**
- `unit` - Unit to show main combat text for (`unitid`)

**See also:** Vehicle functions.



## CommentatorAddPlayer



## CommentatorEnterInstance

**Signature:** `CommentatorEnterInstance()`



## CommentatorExitInstance

**Signature:** `CommentatorExitInstance()`



## CommentatorFollowPlayer



## CommentatorGetCamera



## CommentatorGetCurrentMapID

**Signature:** `CommentatorGetCurrentMapID()`



## CommentatorGetInstanceInfo



## CommentatorGetMapInfo



## CommentatorGetMode



## CommentatorGetNumMaps

**Signature:** `CommentatorGetNumMaps()`



## CommentatorGetNumPlayers



## CommentatorGetPlayerInfo



## CommentatorGetSkirmishMode



## CommentatorGetSkirmishQueueCount



## CommentatorGetSkirmishQueuePlayerInfo



## CommentatorLookatPlayer



## CommentatorRemovePlayer

**Signature:** `CommentatorRemovePlayer()`



## CommentatorRequestSkirmishMode



## CommentatorRequestSkirmishQueueData



## CommentatorSetBattlemaster

**Signature:** `CommentatorSetBattlemaster()`



## CommentatorSetCamera



## CommentatorSetCameraCollision



## CommentatorSetMapAndInstanceIndex



## CommentatorSetMode

**Signature:** `CommentatorSetMode()`



## CommentatorSetMoveSpeed



## CommentatorSetPlayerIndex



## CommentatorSetSkirmishMatchmakingMode



## CommentatorSetTargetHeightOffset



## CommentatorStartInstance



## CommentatorStartSkirmishMatch



## CommentatorToggleMode



## CommentatorUpdateMapInfo



## CommentatorUpdatePlayerInfo



## CommentatorZoomIn



## CommentatorZoomOut



## ComplainChat

Reports a chat message as spam. Used in the default UI when right-clicking the name of a player in a chat message and choosing "Report Spam" from the menu.

**Signature:** `ComplainChat(lineID) or ComplainChat("name" [, "text"])`

**Arguments:**
- `lineID` - Unique identifier of a chat message (11th argument received with the corresponding `CHAT_MSG` event) (`number`)
- `name` - Name of a player to complain about (`string`)
- `text` - Specific text to complain about (`string`)

**See also:** Chat functions, Complaint functions.



## ComplainInboxItem

Reports a mail message as spam

**Signature:** `ComplainInboxItem(mailID)`

**Arguments:**
- `mailID` - Index of a message in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)



## CompleteLFGRoleCheck



## CompleteQuest

Begins turning in a quest to a questgiver. Usable following the `QUEST_PROGRESS` event in which it is determined whether the player can complete the quest.

Does not complete the quest turn-in process; after calling this function, the `QUEST_COMPLETE` event fires as the questgiver presents rewards (or sometimes only closure to the quest narrative); following that event, the `GetQuestReward()` function finishes the turn-in.

**Signature:** `CompleteQuest()`

**See also:** Quest functions.



## ConfirmAcceptQuest

Accepts a quest started by another group member. Usable following the `QUEST_ACCEPT_CONFIRM` event which fires when another member of the player's party or raid starts certain quests (e.g. escort quests).

**Signature:** `ConfirmAcceptQuest()`



## ConfirmBinder

Sets the player's Hearthstone to the current location. Usable in response to the `CONFIRM_BINDER` event which fires upon speaking to an Innkeeper (or similar NPC) and choosing the Hearthstone option.

**Signature:** `ConfirmBinder()`



## ConfirmBindOnUse

Confirms using an item, if using the item causes it to become soulbound. Usable in response to the `USE_BIND_CONFIRM` which fires when the player attempts to use a "Bind on Use" item.

**Signature:** `ConfirmBindOnUse()`



## ConfirmLootRoll

Confirms the player's intent regarding an item up for loot rolling. Usable after the `CONFIRM_LOOT_ROLL` event fires, warning that an item binds on pickup.

**Signature:** `ConfirmLootRoll(id, rollType)`

**Arguments:**
- `id` - Index of an item currently up for loot rolling (as provided in the `START_LOOT_ROLL` event) (`number`)
- `rollType` - Type of roll action to perform (`number`) 

 - `0` - Pass (declines the loot)
- `1` - Roll "need" (wins if highest roll)
- `2` - Roll "greed" (wins if highest roll and no other member rolls "need")

**See also:** Loot functions.



## ConfirmLootSlot

Confirms picking up an item available as loot. Usable after the `LOOT_BIND_CONFIRM` event fires, warning that an item binds on pickup.

**Signature:** `ConfirmLootSlot(slot)`

**Arguments:**
- `slot` - Index of a loot slot (between 1 and `GetNumLootItems()`) (`number`)



## ConfirmReadyCheck

Responds to a ready check

**Signature:** `ConfirmReadyCheck(ready)`

**Arguments:**
- `ready` - True to report as "ready"; false to report as "not ready" (`true`)

**See also:** Raid functions, Party functions.



## ConfirmSummon

Accepts an offered summons, teleporting the player to the summoner's location. Usable between when the `CONFIRM_SUMMON` event fires (due to a summoning spell cast by another player) and when the value returned by `GetSummonConfirmTimeLeft()` reaches zero.

**Signature:** `ConfirmSummon()`

**See also:** Summoning functions.



## ConfirmTalentWipe

Resets the player's talents. Usable following the `CONFIRM_TALENT_WIPE` event which fires when the player speaks to an trainer NPC and chooses to reset his or her talents.

**Signature:** `ConfirmTalentWipe()`

**See also:** Talent functions.



## ConsoleAddMessage

Prints text to the debug console. 
The debugging console can be activated by launching WoW from the command line with the "-console" option, then pressing the "`" (backtick/tilde) key ingame. Its usefulness outside of Blizzard internal environments is limited.

**Signature:** `ConsoleAddMessage()`



## ConsoleExec

Runs a console command. Used by the default UI to handle `/console` commands.

**Signature:** `ConsoleExec("console_command")`

**Arguments:**
- `console_command` - The console command to run (`string`)



## ContainerIDToInventoryID

Returns the `inventoryID` corresponding to a given `containerID`

**Signature:** `inventoryID = ContainerIDToInventoryID(container)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)

**Returns:**
- `inventoryID` - Identifier for the container usable with Inventory APIs (`number`, inventoryID)



## ContainerIDToInventoryID_

_No snapshot available (page did not exist in archive)._



## ContainerRefundItemPurchase

Sells an item purchased with alternate currency back to a vendor. Items bought with alternate currency (honor points, arena points, or special items such as Emblems of Heroism and Dalaran Cooking Awards) can be returned to a vendor for a full refund, but only within a limited time after the original purchase.

**Signature:** `ContainerRefundItemPurchase(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**See also:** Container functions, Merchant functions.



## ConvertToRaid

Converts a party to a raid. Only has effect if the player is in a party and the party leader.

**Signature:** `ConvertToRaid()`

**See also:** Raid functions, Party functions.


