# WoW API — GetQ*

_43 functions_

---

## GetQuestBackgroundMaterial

Returns background display style information for a questgiver dialog. The value returned can be used to look up background textures and text colors for display:

 
 - Background textures displayed in the default UI can be found by prepending `"Interface\\ItemTextFrame\\ItemText-"` and appending `"-TopLeft"`, `"-TopRight"`, `"-BotLeft"`, `"-BotRight"` to the material string (e.g. `"Interface\\ItemTextFrame\\ItemText-Stone-TopLeft"`).
 
 - Colors for body and title text can be found by calling `GetMaterialTextColors(material)` (a Lua function implemented in the Blizzard UI).

In cases where this function returns nil, the default UI uses the colors and textures for "Parchment".

**Signature:** `material = GetQuestBackgroundMaterial()`

**Returns:**
- `material` - String identifying a display style for the questgiver dialog, or nil for the default style (`string`) 

 - `Bronze` - Colored metallic background
- `Marble` - Light stone background
- `Parchment` - Yellowed parchment background (default)
- `Silver` - Gray metallic background
- `Stone` - Dark stone background

**See also:** Quest functions.




## GetQuestDifficultyColor

Returns a table of color values indicating the difficulty of a quest's level as compared to the player's

**Signature:** `color = GetQuestDifficultyColor(level)`

**Arguments:**
- `level` - Level for which to compare difficulty (`number`)

**Returns:**
- `color` - A table containing color values (keyed `r`, `g`, and `b`) representing the difficulty of a quest at the input level as compared to the player's (`table`)

> **Note:** This function is not a C API but a Lua function declared in Blizzard's default user interface. Its implementation can be viewed by extracting the addon data using the Addon Kit provided by Blizzard.

**See also:** Quest functions.




## GetQuestGreenRange

Returns the level range in which a quest below the player's level still rewards XP. If a quest's level is up to `range` levels below the player's level, the quest is considered easy but still rewards experience points upon completion; these quests are colored green in the default UI's quest log. (Quests more than `range` levels below the player's are colored gray in the default UI and reward no XP.)

**Signature:** `range = GetQuestGreenRange()`

**Returns:**
- `range` - Maximum difference between player level and a lower quest level for a quest to reward experience (`number`)




## GetQuestIndexForTimer

Returns the quest log index of a timed quest's timer

**Signature:** `questIndex = GetQuestIndexForTimer(index)`

**Arguments:**
- `index` - Index of a timer (in the list returned by `GetQuestTimers()`) (`number`)

**Returns:**
- `questIndex` - Index of the quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**See also:** Quest functions.




## GetQuestIndexForWatch

Returns the quest log index of a quest in the objectives tracker

**Signature:** `questIndex = GetQuestIndexForWatch(index)`

**Arguments:**
- `index` - Index of a quest in the list of quests on the objectives tracker (between 1 and `GetNumQuestWatches()`) (`number`)

**Returns:**
- `questIndex` - Index of the quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**See also:** Quest functions, Objectives tracking functions.




## GetQuestItemInfo

Returns information about items in a questgiver dialog. Only valid when the questgiver UI is showing the accept/decline, progress, or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED`, `QUEST_PROGRESS` and `QUEST_FINISHED`, or `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return empty values or those from the most recently displayed quest.

**Signature:** `name, texture, numItems, quality, isUsable = GetQuestItemInfo("type", index)`

**Arguments:**
- `type` - Which of the possible sets of items to query (`string`) 

 - `choice` - Items from which the player may choose a reward
- `required` - Items required to complete the quest
- `reward` - Items given as reward for the quest
- `index` - Which item to query (from 1 to GetNumQuestChoices(), GetNumQuestItems(), or GetNumQuestRewards(), depending on the value of the itemType argument) (`number`)

**Returns:**
- `name` - The name of the item (`string`)
- `texture` - Path to a texture for the item's icon (`string`)
- `numItems` - Number of the item required or rewarded (`number`)
- `quality` - The quality of the item (`number`) 

 - `0` - Poor
- `1` - Common
- `2` - Uncommon
- `3` - Rare
- `4` - Epic
- `5` - Legendary
- `6` - Artifact
- `isUsable` - 1 if the player can currently use/equip the item; otherwise nil (`1nil`)

**See also:** Quest functions.




## GetQuestItemLink

Returns a hyperlink for an item in a questgiver dialog. Only valid when the questgiver UI is showing the accept/decline, progress, or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED`, `QUEST_PROGRESS` and `QUEST_FINISHED`, or `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return `nil` or a value from the most recently displayed quest.

**Signature:** `link = GetQuestItemLink("itemType", index)`

**Arguments:**
- `itemType` - Token identifying one of the possible sets of items (`string`) 

 - `choice` - Items from which the player may choose a reward
- `required` - Items required to complete the quest
- `reward` - Items given as reward for the quest
- `index` - Index of an item in the set (between 1 and `GetNumQuestChoices()`, `GetNumQuestItems()`, or `GetNumQuestRewards()`, according to `itemType`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`)

**See also:** Quest functions, Hyperlink functions.




## GetQuestLink

Returns a hyperlink for an entry in the player's quest log

**Signature:** `link = GetQuestLink(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `link` - A hyperlink for the quest (`string`, hyperlink)




## GetQuestLogChoiceInfo

_No snapshot available (page did not exist in archive)._




## GetQuestLogCompletionText

Returns the completion text for the selected quest in the quest log. Completion text usually includes instructions on to whom and where to hand in the quest once it has been completed. Example: "Return to William Pestle at Goldshire in Elwynn Forest."

**Signature:** `completionText = GetQuestLogCompletionText()`

**Returns:**
- `completionText` - Completion instructions for the quest (`string`)

**See also:** Quest functions.




## GetQuestLogGroupNum

Returns the suggested group size for the selected quest in the quest log

**Signature:** `suggestedGroup = GetQuestLogGroupNum()`

**Returns:**
- `suggestedGroup` - Recommended number of players in a group attempting the quest (`number`)

**See also:** Quest functions.




## GetQuestLogItemDrop




## GetQuestLogItemLink

Returns a hyperlink for an item related to the selected quest in the quest log

**Signature:** `GetQuestLogItemLink("itemType", index)`

**Arguments:**
- `itemType` - Token identifying one of the possible sets of items (`string`) 

 - `choice` - Items from which the player may choose a reward
- `reward` - Items always given as reward for the quest
- `index` - Index of an item in the set (between 1 and `GetNumQuestLogChoices()` or `GetNumQuestLogRewards()`, according to `itemType`) (`number`)

**See also:** Quest functions, Hyperlink functions.




## GetQuestLogLeaderBoard

Returns information about objectives for a quest in the quest log

**Signature:** `text, type, finished = GetQuestLogLeaderBoard(objective [, questIndex])`

**Arguments:**
- `objective` - Index of a quest objective (between 1 and `GetNumQuestLeaderBoards()`) (`number`)
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`); if omitted, defaults to the selected quest (`number`)

**Returns:**
- `text` - Text of the objective (e.g. "Gingerbread Cookie: 0/5") (`string`)
- `type` - Type of objective (`string`) 

 - `event` - Requires completion of a scripted event
- `item` - Requires collecting a number of items
- `monster` - Requires slaying a number of NPCs
- `object` - Requires interacting with a world object
- `reputation` - Requires attaining a certain level of reputation with a faction
- `finished` - 1 if the objective is complete; otherwise nil (`1nil`)

**See also:** Quest functions.




## GetQuestLogPushable

Return whether the selected quest in the quest log can be shared to party members

**Signature:** `shareable = GetQuestLogPushable()`

**Returns:**
- `shareable` - 1 if the quest is shareable; otherwise nil (`1nil`)

**See also:** Quest functions.




## GetQuestLogQuestText

Returns the description and objective text for the selected quest in the quest log

**Signature:** `questDescription, questObjectives = GetQuestLogQuestText()`

**Returns:**
- `questDescription` - Full description of the quest (as seen in the NPC dialog when accepting the quest) (`string`)
- `questObjectives` - A (generally) brief summary of quest objectives (`string`)

**See also:** Quest functions.




## GetQuestLogRequiredMoney

Returns the amount of money required for the selected quest in the quest log

**Signature:** `money = GetQuestLogRequiredMoney()`

**Returns:**
- `money` - The amount of money required to complete the quest (in copper) (`number`)




## GetQuestLogRewardArenaPoints




## GetQuestLogRewardFactionInfo




## GetQuestLogRewardHonor

_No snapshot available (page did not exist in archive)._




## GetQuestLogRewardInfo

Returns information about item rewards for the selected quest in the quest log. This function refers to items always awarded upon quest completion; for quest rewards for which the player is allowed to choose one item from among several, see GetQuestLogChoiceInfo.

**Signature:** `name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(index)`

**Arguments:**
- `index` - Index of a quest reward (between 1 and GetNumQuestLogRewards()) (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `numItems` - Number of items in the stack (`number`)
- `quality` - Quality of the item (`number`, itemQuality)
- `isUsable` - 1 if the player can use or equip the item; otherwise nil (`1nil`)

**See also:** Quest functions.




## GetQuestLogRewardMoney

Returns the money reward for the selected quest in the quest log

**Signature:** `money = GetQuestLogRewardMoney()`

**Returns:**
- `money` - Amount of money rewarded for completing the quest (in copper) (`number`)




## GetQuestLogRewardSpell

Returns information about the spell reward for the selected quest in the quest log. If both `isTradeskillSpell` and `isSpellLearned` are `nil`, the reward is a spell cast upon the player.

**Signature:** `texture, name, isTradeskillSpell, isSpellLearned = GetQuestLogRewardSpell()`

**Returns:**
- `texture` - Path to the spell's icon texture (`string`)
- `name` - Name of the spell (`string`)
- `isTradeskillSpell` - 1 if the spell is a tradeskill recipe; otherwise nil (`1nil`)
- `isSpellLearned` - 1 if the reward teaches the player a new spell; otherwise nil (`1nil`)

**See also:** Quest functions, Spell functions.




## GetQuestLogRewardTalents

Returns the talent point reward for the selected quest in the quest log. Returns `0` for quests which do not award talent points.

(Very few quests award talent points; currently this functionality is only used within the Death Knight starting experience.)

**Signature:** `talents = GetQuestLogRewardTalents()`

**Returns:**
- `talents` - Number of talent points to be awarded upon completing the quest (`number`)

**See also:** Quest functions.




## GetQuestLogRewardTitle

Returns the title reward for the selected quest in the quest log. Returns `nil` if no title is awarded or if no quest is selected.

**Signature:** `title = GetQuestLogRewardTitle()`

**Returns:**
- `title` - Title to be awarded to the player upon completing the quest (`string`)




## GetQuestLogRewardXP

Returns the experience reward at the player's level for the selected quest in the quest log

**Signature:** `experience = GetQuestLogRewardXP()`

**Returns:**
- `experience` - Amount of experience rewarded for completing the quest (`number`)

**See also:** Quest functions.




## GetQuestLogSelection

Returns the index of the selected quest in the quest log

**Signature:** `questIndex = GetQuestLogSelection()`

**Returns:**
- `questIndex` - Index of the selected quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**See also:** Quest functions.




## GetQuestLogSpecialItemCooldown

Returns cooldown information about an item associated with a current quest. Available for a number of quests which involve using an item (i.e. "Use the MacGuffin to summon and defeat the boss", "Use this saw to fell 12 trees", etc.)

**Signature:** `start, duration, enable = GetQuestLogSpecialItemCooldown(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest log entry with an associated usable item (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the item is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the item is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the item is ready.) (`number`)

**See also:** Quest functions, Objectives tracking functions.




## GetQuestLogSpecialItemInfo

Returns information about a usable item associated with a current quest. Available for a number of quests which involve using an item (i.e. "Use the MacGuffin to summon and defeat the boss", "Use this saw to fell 12 trees", etc.)

**Signature:** `link, icon, charges = GetQuestLogSpecialItemInfo(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest log entry with an associated usable item (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)
- `icon` - Path to an icon texture for the item (`string`)
- `charges` - Number of times the item can be used, or 0 if no limit (`number`)

**See also:** Quest functions, Objectives tracking functions.




## GetQuestLogSpellLink

Returns a hyperlink for a spell in the selected quest in the quest log

**Signature:** `link = GetQuestLogSpellLink()`

**Returns:**
- `link` - A hyperlink for the spell or tradeskill recipe (`string`, hyperlink)

**See also:** Quest functions.




## GetQuestLogTimeLeft

Returns time remaining for the selected quest in the quest log. If the selected quest is not timed, returns nil.

**Signature:** `questTimer = GetQuestLogTimeLeft()`

**Returns:**
- `questTimer` - The amount of time left to complete the quest (`number`)

**See also:** Quest functions.




## GetQuestLogTitle

Returns information about an entry in the player's quest log

**Signature:** `questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `questLogTitleText` - Title of the quest (`string`)
- `level` - Recommended character level for attempting the quest (`number`)
- `questTag` - Localized tag describing the type of quest (`string`) 

 - `Dungeon` - Dungeon or instance quest
- `Elite` - Elite quest
- `Group` - Group quest
- `Heroic` - Heroic quest
- `PVP` - PVP specific quest
- `Raid` - Raid quest
- `nil` - Standard quest
- `suggestedGroup` - For some group quests, the recommended number of group members for attempting the quest (`number`)
- `isHeader` - 1 if the entry is a group header; nil if the entry is a quest (`1nil`)
- `isCollapsed` - 1 if the entry is a collapsed header; otherwise nil (`1nil`)
- `isComplete` - Whether the quest is complete (`number`) 

 - `-1` - The quest was failed
- `1` - The quest was completed
- `nil` - The quest has yet to reach a conclusion
- `isDaily` - 1 if the quest is a daily quest; otherwise nil (`1nil`)
- `questID` - The quest's questID. (`number`)




## GetQuestMoneyToGet

Returns the amount of money required to complete the quest presented by a questgiver. Usable following the `QUEST_PROGRESS` event in which it is determined whether the player can complete the quest.

**Signature:** `money = GetQuestMoneyToGet()`

**Returns:**
- `money` - Amount of money required to complete the quest (in copper) (`number`)

**See also:** Quest functions.




## GetQuestPOILeaderBoard




## GetQuestResetTime

Returns the amount of time remaining until the daily quest period resets

**Signature:** `time = GetQuestResetTime()`

**Returns:**
- `time` - Amount of time remaining until the daily quest period resets (in seconds) (`number`)




## GetQuestReward

Finishes turning in a quest to a questgiver, selecting an item reward if applicable. Usable following the `QUEST_COMPLETE` event in which the questgiver presents the player with rewards.

**Signature:** `GetQuestReward(choice)`

**Arguments:**
- `choice` - Index of a quest reward choice (between 1 and `GetNumQuestChoices()`), or nil if the quest does not offer a choice of item rewards (`number`)




## GetQuestsCompleted

Gets a table containing the quests the player has completed. This function will only return data after QueryQuestsCompleted() has been called and the `QUEST_QUERY_COMPLETE` event has fired. The keys in the returned table are the numeric questIds, with a value of true for each set key.

**Signature:** `completedQuests = GetQuestsCompleted(questTbl)`

**Arguments:**
- `questTbl` - A table that will be wiped and filled with the quest data (`table`)

**Returns:**
- `completedQuests` - A hash table containing a list of the questIds the player has completed. (`table`)




## GetQuestSortIndex




## GetQuestSpellLink

Returns a hyperlink for a spell in a questgiver dialog. Only valid when the questgiver UI is showing the accept/decline, progress, or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED`, `QUEST_PROGRESS` and `QUEST_FINISHED`, or `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return empty values or those from the most recently displayed quest.

**Signature:** `link = GetQuestSpellLink()`

**Returns:**
- `link` - A hyperlink for the spell or tradeskill recipe (`string`, hyperlink)




## GetQuestText

Returns the text for the quest offered by a questgiver. Only valid when the questgiver UI is showing the accept/decline stage of a quest dialog (between the `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return the empty string or a value from the most recently displayed quest.

**Signature:** `text = GetQuestText()`

**Returns:**
- `text` - The text for the currently displayed quest (`string`)

**See also:** Quest functions.




## GetQuestTimers

Returns a list of the times remaining for any active timed quests

**Signature:** `... = GetQuestTimers()`

**Returns:**
- `...` - A list of numbers, each the amount of time (in seconds) remaining for a timed quest (`number`)




## GetQuestWatchIndex

Returns the quest watch (objective tracker) index of a quest in the quest log

**Signature:** `questWatchIndex = GetQuestWatchIndex(questLogIndex)`

**Arguments:**
- `questLogIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `questWatchIndex` - Index of a quest in the list of quests on the objectives tracker (between 1 and `GetNumQuestWatches()`) (`number`)

**See also:** Quest functions, Objectives tracking functions.




## GetQuestWorldMapAreaID



