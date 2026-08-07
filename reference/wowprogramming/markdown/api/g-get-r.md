# WoW API — GetR*

_31 functions_

---

## GetRaidDifficulty




## GetRaidRosterInfo

Returns information about a member of the player's raid

**Signature:** `name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index)`

**Arguments:**
- `index` - The index of the raid member (`number`)

**Returns:**
- `name` - The name of the player (`string`)
- `rank` - The player's rank in the raid (`number`) 

 - `Raid Assistant`
- `Raid Leader`
- `0` - Raid Member
- `subgroup` - The raid subgroup that the player belongs to (`number`)
- `level` - The player's level (`number`)
- `class` - The localized name of the player's class (`string`)
- `fileName` - The uppercase english name of the player's class (`string`) 

 - `DRUID`
- `HUNTER`
- `MAGE`
- `PALADIN`
- `PRIEST`
- `ROGUE`
- `SHAMAN`
- `WARLOCK`
- `WARRIOR`
- `zone` - The name of the zone the player is currently in (`string`)
- `online` - 1 if the player is currently online, otherwise nil (`1nil`)
- `isDead` - 1 if the player is currently dead, otherwise nil (`1nil`)
- `role` - The player's role, or nil (`string`) 

 - `MAINASSIST`
- `MAINTANK`
- `isML` - 1 if the player is the master-looter, otherwise nil (`1nil`)




## GetRaidRosterSelection

Returns the index of the selected unit in the raid roster. Selection in the raid roster is used only for display in the default UI and has no effect on other Raid APIs.

**Signature:** `raidIndex = GetRaidRosterSelection()`

**Returns:**
- `raidIndex` - Index of the raid member (between 1 and `GetNumRaidMembers()`); matches the numeric part of the unit's `raid` `unitID`, e.g. 21 for `raid21` (`number`)

**See also:** Raid functions.




## GetRaidTargetIndex

Returns the index of the raid target marker on a unit

**Signature:** `index = GetRaidTargetIndex("unit") or GetRaidTargetIndex("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `index` - Index of a target marker (`number`) 

 - `1` - Star
- `2` - Circle
- `3` - Diamond
- `4` - Triangle
- `5` - Moon
- `6` - Square
- `7` - Cross
- `8` - Skull
- `nil` - No marker

**See also:** Raid functions.




## GetRandomBGHonorCurrencyBonuses




## GetRandomDungeonBestChoice

Returns the dungeonID of the random dungeon group that provides the best loot for the player.. The dungeonID that is returned refers to an integer found in LFGDungeons.dbc.

This function is normally used only for initialization of the LFGQueueFrame in FrameXML LFDFrame.lua. You can programatically join the suggested queue for a random dungeon for which your character is eligible.

**Signature:** `GetRandomDungeonBestChoice()`

**See also:** Looking for group functions.




## GetRangedCritChance

Returns the player's ranged critical strike chance

**Signature:** `critChance = GetRangedCritChance()`

**Returns:**
- `critChance` - The player's percentage critical strike chance for ranged attacks (`number`)

**See also:** Stat information functions.




## GetReadyCheckStatus

Returns a unit's status during a ready check. Returns nil for all units unless the player is the party/raid leader or a raid assistant.

**Signature:** `status = GetReadyCheckStatus("unit")`

**Arguments:**
- `unit` - A unit in the player's party or raid (`string`, unitID)

**Returns:**
- `status` - Ready check status for the unit (`string`) 

 - `"notready"` - Unit has responded as not ready
- `"ready"` - Unit has responded as ready
- `"waiting"` - Unit has not yet responded
- `nil` - No ready check is in progress

**See also:** Party functions, Raid functions.




## GetReadyCheckTimeLeft

Returns the amount of time left on the current ready check. Returns `0` if no ready check is in progress.

**Signature:** `timeLeft = GetReadyCheckTimeLeft()`

**Returns:**
- `timeLeft` - Amount of time remaining on the ready check (in seconds) (`number`)

**See also:** Party functions, Raid functions.




## GetRealmName

Returns the name of the player's realm (server name)

**Signature:** `realm = GetRealmName()`

**Returns:**
- `realm` - The name of the player's realm (server) (`string`)

**See also:** Realm functions.




## GetRealNumPartyMembers

Returns the number of members in the player's non-battleground party. When the player is in a party/raid and joins a battleground or arena, the normal party/raid functions refer to the battleground's party/raid, but the game still keeps track of the player's place in a non-battleground party/raid.

**Signature:** `numMembers = GetRealNumPartyMembers()`

**Returns:**
- `numMembers` - Number of members in the player's non-battleground party (`number`)

**See also:** Party functions, Battlefield functions.




## GetRealNumRaidMembers

Returns the number of members in the player's non-battleground raid. When the player is in a party/raid and joins a battleground or arena, the normal party/raid functions refer to the battleground's party/raid, but the game still keeps track of the player's place in a non-battleground party/raid.

**Signature:** `numMembers = GetRealNumRaidMembers()`

**Returns:**
- `numMembers` - Number of members in the player's non-battleground raid (`number`)

**See also:** Raid functions, Battlefield functions.




## GetRealZoneText

Returns the "official" name of the zone or instance in which the player is located. This name matches that seen in the Who, Guild, and Friends UIs when reporting character locations. It may differ from those the default UI displays in other locations (`GetZoneText()` and `GetMinimapZoneText()`), especially if the player is in an instance: e.g. this function returns "The Stockade" when the others return "Stormwind Stockade".

**Signature:** `zoneName = GetRealZoneText()`

**Returns:**
- `zoneName` - Name of the zone or instance (`string`)




## GetRefreshRates

Returns a list of available screen refresh rates. The current refresh rate can be found in the `gxRefresh` CVar.

**Signature:** `... = GetRefreshRates()`

**Returns:**
- `...` - A list of numbers, each an available screen refresh rates (in hertz, or zycles per second) (`number`)

**See also:** Video functions.




## GetReleaseTimeRemaining

Returns the amount of time remaining until the player's spirit is automatically released when dead. Returns `-1` if the player died in a dungeon or raid instance; in such cases, the player's spirit will not be released automatically (see `RepopMe()` to release manually).

**Signature:** `timeleft = GetReleaseTimeRemaining()`

**Returns:**
- `timeleft` - Amount of time remaining until the player's spirit is automatically released to the nearest graveyard (in seconds) (`number`)

**See also:** Player information functions.




## GetRepairAllCost

Returns the cost to repair all of the player's damaged items. Returns `0, nil` if none of the player's items are damaged. Only returns valid data while interacting with a vendor which allows repairs (i.e. for whom `CanMerchantRepair()` returns `1`).

**Signature:** `repairAllCost, canRepair = GetRepairAllCost()`

**Returns:**
- `repairAllCost` - Cost to repair all damaged items (in copper) (`number`)
- `canRepair` - 1 if repairs are currently available; otherwise nil (`1nil`)




## GetResSicknessDuration

Returns the duration of resurrection sickness at the player's current level. Returns nil for players under level 10, who are allowed to resurrect at a spirit healer without suffering resurrection sickness.

**Signature:** `resSicknessTime = GetResSicknessDuration()`

**Returns:**
- `resSicknessTime` - Text describing the duration of resurrection sickness were the player to resurrect at a spirit healer (`string`)

**See also:** Player information functions.




## GetRestState

Returns the player's current rest state

**Signature:** `state, name, multiplier = GetRestState()`

**Returns:**
- `state` - Number identiying the current rest state (`number`) 

 - `1` - Rested
- `2` - Normal
- `3` - Tired - used in locales with account play time limits
- `4` - Unhealthy - used in locales with account play time limits
- `name` - Localized text describing the player's current rest state (`string`)
- `multiplier` - Multiplier for experience points earned from kills (`number`)

**See also:** Player information functions.




## GetRewardArenaPoints

Returns the amount of arena points awarded when completing a quest. 
Only valid when the questgiver UI is showing the accept/decline or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events, or between the `QUEST_COMPLETE` and `QUEST_FINISHED `events); otherwise may return zero or a value from the most recently displayed quest.

Unused as of 3.3.3, as no quest rewards arena points since the Call to Arms quests have been removed.

**Signature:** `arenaPoints = GetRewardArenaPoints()`

**Returns:**
- `arenaPoints` - The arena points to be awarded (`number`)

**See also:** Arena functions, Quest functions.




## GetRewardHonor

Returns the amount of honor points awarded when completing a quest. 
Only valid when the questgiver UI is showing the accept/decline or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events, or between the `QUEST_COMPLETE` and `QUEST_FINISHED `events); otherwise may return zero or a value from the most recently displayed quest.

**Signature:** `honor = GetRewardHonor()`

**Returns:**
- `honor` - The honor points to be awarded (`number`)

**See also:** Quest functions.




## GetRewardMoney

Returns the amount of money awarded when completing a quest. 
 

Only valid when the questgiver UI is showing the accept/decline or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events, or between the `QUEST_COMPLETE` and `QUEST_FINISHED `events); otherwise may return zero or a value from the most recently displayed quest.

**Signature:** `money = GetRewardMoney()`

**Returns:**
- `money` - The amount of money to be awarded (in copper) (`number`)

**See also:** Quest functions.




## GetRewardSpell

Returns information about a spell awarded when completing a quest. Only valid when the questgiver UI is showing the accept/decline or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events, or between the `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return zero or values from the most recently displayed quest.

If both `isTradeskillSpell` and `isSpellLearned` are `nil`, the reward is a spell cast upon the player.

**Signature:** `texture, name, isTradeskillSpell, isSpellLearned = GetRewardSpell()`

**Returns:**
- `texture` - Path to the spell's icon texture (`string`)
- `name` - Name of the spell (`string`)
- `isTradeskillSpell` - 1 if the spell is a tradeskill recipe; otherwise nil (`1nil`)
- `isSpellLearned` - 1 if the reward teaches the player a new spell; otherwise nil (`1nil`)




## GetRewardTalents

Returns the talent points awarded when completing a quest. Only valid when the questgiver UI is showing the accept/decline or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events, or between the `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return zero or a value from the most recently displayed quest.

(Very few quests award talent points; currently this functionality is only used within the Death Knight starting experience.)

**Signature:** `talents = GetRewardTalents()`

**Returns:**
- `talents` - The talent points to be awarded (`number`)

**See also:** Quest functions.




## GetRewardText

Returns questgiver dialog to be displayed when completing a quest. Only valid when the questgiver UI is showing the completion stage of a quest dialog (between the `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return the empty string or a value from the most recently displayed quest.

**Signature:** `text = GetRewardText()`

**Returns:**
- `text` - Text to be displayed for the quest completion dialog (`string`)

**See also:** Quest functions.




## GetRewardTitle

Returns the title awarded when completing a quest. 
 

Only valid when the questgiver UI is showing the accept/decline or completion stages of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events, or between the `QUEST_COMPLETE` and `QUEST_FINISHED `events); otherwise may return nil or a value from the most recently displayed quest.

**Signature:** `title = GetRewardTitle()`

**Returns:**
- `title` - The title to be awarded, or nil if the quest does not reward a title (`string`)




## GetRewardXP




## GetRuneCooldown

Returns cooldown information about one of the player's rune resources. Note the placement of runes 3-4 (normally Unholy) and 5-6 (normally Frost) are reversed in the default UI. Also note the behavior of returned values differs slightly from most other GetXYZCooldown-style functions.

**Signature:** `start, duration, runeReady = GetRuneCooldown(slot)`

**Arguments:**
- `slot` - Index of a rune slot, as positioned in the default UI: (`number`) 

 - `1` - Leftmost
- `2` - Second from left
- `3` - Fifth from left (second from right)
- `4` - Sixth from left (rightmost)
- `5` - Third from left
- `6` - Fourth from left

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the rune is ready (`number`)
- `duration` - The length of the cooldown (regardless of whether the rune is currently cooling down) (`number`)
- `runeReady` - True if the rune can be used; false if the rune is cooling down (`boolean`)

**See also:** Player information functions, Class resource functions.




## GetRuneCount

_No snapshot available (page did not exist in archive)._




## GetRuneType

Returns the type of one of the player's rune resources. Note the placement of runes 3-4 (normally Unholy) and 5-6 (normally Frost) are reversed in the default UI.

**Signature:** `runeType = GetRuneType(slot)`

**Arguments:**
- `slot` - Index of a rune slot, as positioned in the default UI: (`number`) 

 - `1` - Leftmost
- `2` - Second from left
- `3` - Fifth from left (second from right)
- `4` - Sixth from left (rightmost)
- `5` - Third from left
- `6` - Fourth from left

**Returns:**
- `runeType` - Type of the rune (`number`) 

 - `1` - Blood rune
- `2` - Unholy rune
- `3` - Frost rune
- `4` - Death rune




## GetRunningMacro

Returns the index of the currently running macro.

**Signature:** `index = GetRunningMacro()`

**Returns:**
- `index` - Index of the currently running macro, or nil if no macro is running (`number`, macroID)

**See also:** Macro functions.




## GetRunningMacroButton

Returns the mouse button that was used to activate the running macro

**Signature:** `button = GetRunningMacroButton()`

**Returns:**
- `button` - Name of the mouse button used to activate the macro; always "LeftButton" if the macro was triggered by a key binding (`string`) 

 - `Button4`
- `Button5`
- `LeftButton`
- `MiddleButton`
- `RightButton`



