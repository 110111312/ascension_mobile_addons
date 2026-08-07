# WoW API — GetL*

_46 functions_

---

## GetLanguageByIndex

Returns the localized name of a player character language

**Signature:** `language = GetLanguageByIndex(index)`

**Arguments:**
- `index` - Index of a player character language (between 1 and `GetNumLanguages()` (`number`)

**Returns:**
- `language` - Localized name of the language (e.g. "Common" or "Gnomish") (`string`)

**See also:** Chat functions.




## GetLastQueueStatusIndex




## GetLatestCompletedAchievements

Returns a list of the player's most recently earned achievements

**Signature:** `... = GetLatestCompletedAchievements()`

**Returns:**
- `...` - A list of up to five numeric IDs of recently earned achievements, ordered from newest to oldest (`list`)




## GetLatestCompletedComparisonAchievements

Returns a list of the comparison unit's most recently earned achievements

**Signature:** `... = GetLatestCompletedComparisonAchievements()`

**Returns:**
- `...` - A list of up to five numeric IDs of recently earned achievements, ordered from newest to oldest (`list`)




## GetLatestThreeSenders

Returns the names of the last three senders of new mail. Returns sender names for new messages which the player has not yet seen in the mailbox; returns nothing if the player's inbox only contains unread messages which have been seen in the mailbox listing but not yet opened.

**Signature:** `sender1, sender2, sender3 = GetLatestThreeSenders()`

**Returns:**
- `sender1` - Name of a recent message's sender (`string`)
- `sender2` - Name of a recent message's sender (`string`)
- `sender3` - Name of a recent message's sender (`string`)

**See also:** Mail functions.




## GetLatestUpdatedComparisonStats

Returns a list of the comparison unit's latest updated statistics. 
 

Currently always returns a list of invalid statistic IDs -- the "latest updated statistics" feature is no longer a part of the Achievements UI.

**Signature:** `... = GetLatestUpdatedComparisonStats()`

**Returns:**
- `...` - A list of up to five numeric IDs of recently updated statistics for the comparison unit, ordered from newest to oldest (`list`)




## GetLatestUpdatedStats

Returns a list of the player's latest updated statistics. 
Currently always returns a list of invalid statistic IDs -- the "latest updated statistics" feature is no longer a part of the Achievements UI.

**Signature:** `... = GetLatestUpdatedStats()`

**Returns:**
- `...` - A list of up to five numeric IDs of recently updated statistics for the player, ordered from newest to oldest (`list`)




## GetLFDChoiceCollapseState




## GetLFDChoiceEnabledState




## GetLFDChoiceInfo

_No snapshot available (page did not exist in archive)._




## GetLFDChoiceLockedState




## GetLFDChoiceOrder




## GetLFDLockInfo




## GetLFDLockPlayerCount




## GetLFGBootProposal




## GetLFGCompletionReward

Returns the various rewards for a completed LFG dungeon

**Signature:** `name, typeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards = GetLFGCompletionReward()`

**Returns:**
- `name` - Name of the instance (`string`)
- `typeID` - Type of the dungeon (TYPEIDDUNGEON, TYPEIDHEROICDIFFICULTY, TYPEIDRANDOM_DUNGEON) (`number`)
- `textureFilename` - Filename of the instance icon (to be used with 'Interface/LFGFrame/LFGIcon-' (`string`)
- `moneyBase` - Base amount of money (moneyAmount = moneyBase + moneyVar * numStrangers) (`number`)
- `moneyVar` - Money reward coefficient (`number`)
- `experienceBase` - Base amount of experience (experienceGained = experienceBase + experienceVar * numStrangers) (`number`)
- `experienceVar` - Experience reward coefficient (`number`)
- `numStrangers` - Amount of pickups in the group (`number`)
- `numRewards` - Amount of actual dungeon rewards (currency or item) (`number`)

**See also:** Looking for group functions.




## GetLFGCompletionRewardItem




## GetLFGDeserterExpiration




## GetLFGDungeonInfo




## GetLFGDungeonRewardInfo




## GetLFGDungeonRewardLink




## GetLFGDungeonRewards




## GetLFGInfoLocal




## GetLFGInfoServer




## GetLFGMode

Provides information about the LFG status of the player.

**Signature:** `mode, submode = GetLFGMode()`

**Returns:**
- `mode` - Current LFG status (`string`) 

 - `abandonedInDungeon` - The party disbanded and player is still in the dungeon.
- `lfgparty` - LFG dungeon is in-progress.
- `nil` - Player is not in LFG
- `proposal` - LFG party formed, notifying matched players dungeon is ready.
- `queued` - Player is in LFG queue.
- `rolecheck` - Querying groupmates to select their LFG roles before queuing.
- `submode` - Your LFG sub-status. Used to indicate priority for filling party slots. (`string`) 

 - `empowered` - Indicates that your party has lost a player and is set to higher priority for finding a replacement
- `nil` - Not looking for more party members
- `unempowered` - Default priority in the LFG system.

**See also:** Looking for group functions.




## GetLFGProposal

Returns info about the currently pending LFD operation

**Signature:** `GetLFGProposal()`




## GetLFGProposalEncounter




## GetLFGProposalMember




## GetLFGQueuedList




## GetLFGQueueStats




## GetLFGRandomCooldownExpiration




## GetLFGRandomDungeonInfo

_No snapshot available (page did not exist in archive)._




## GetLFGRoles

Returns the group roles for which the player has signed up in the LFG system

**Signature:** `leader, tank, healer, damage = GetLFGRoles()`

**Returns:**
- `leader` - True if the player is willing to lead a group; otherwise false (`boolean`)
- `tank` - True if the player is willing to take on the role of protecting allies by drawing enemy attacks; otherwise false (`boolean`)
- `healer` - True if the player is willing to take on the role of healing allies who take damage; otherwise false (`boolean`)
- `damage` - True if the player is willing to take on the role of damaging enemies; otherwise false (`boolean`)




## GetLFGRoleUpdate

_No snapshot available (page did not exist in archive)._




## GetLFGRoleUpdateMember




## GetLFGRoleUpdateSlot




## GetLFGTypes

Returns a list of LFG query types

**Signature:** `... = GetLFGTypes()`

**Returns:**
- `...` - A list of strings, each the localized name of an LFG type (Dungeon, Raid, Zone, etc.) (`list`)




## GetLFRChoiceOrder




## GetLocale

Returns a code indicating the localization currently in use by the client

**Signature:** `locale = GetLocale()`

**Returns:**
- `locale` - A four character locale code indicating the localization currently in use by the client (`string`) 

 - `deDE` - German
- `enGB` - British English
- `enUS` - American English
- `esES` - Spanish (European)
- `esMX` - Spanish (Latin American)
- `frFR` - French
- `koKR` - Korean
- `ruRU` - Russian
- `zhCN` - Chinese (simplified; mainland China)
- `zhTW` - Chinese (traditional; Taiwan)




## GetLootMethod

Returns information about the current loot method in a party or raid. Only returns useful information if the player is in a party or raid.

**Signature:** `method, partyMaster, raidMaster = GetLootMethod()`

**Returns:**
- `method` - Current loot method (`string`) 

 - `freeforall` - Free for All - any group member can take any loot at any time
- `group` - Group Loot - like Round Robin, but items above a quality threshold are rolled on
- `master` - Master Looter - like Round Robin, but items above a quality threshold are left for a designated loot master to
- `needbeforegreed` - Need before Greed - like Group Loot, but members automatically pass on items
- `roundrobin` - Round Robin - group members take turns being able to loot
- `partyMaster` - Numeric portion of the `party` `unitID` of the loot master (e.g. if `2`, the loot master's unitID is `party2`); nil if not using the Master Looter method or if the player is in a raid whose loot master is not in the player's subgroup. If the player is the master looter, this value will return 0. (`number`)
- `raidMaster` - Numeric portion of the `raid` `unitID` of the loot master (e.g. if `17`, the loot master's unitID is `raid17`); nil if not using the Master Looter method or not in a raid group (`number`)




## GetLootRollItemInfo

Returns information about an item currently up for loot rolling

**Signature:** `texture, name, count, quality, bindOnPickUp = GetLootRollItemInfo(id)`

**Arguments:**
- `id` - Index of an item currently up for loot rolling (as provided in the `START_LOOT_ROLL` event) (`number`)

**Returns:**
- `texture` - Path to an icon texture for the item (`string`)
- `name` - Name of the item (`string`)
- `count` - Number of stacked items (`number`)
- `quality` - Quality (rarity) of the item. (`number`, itemQuality)
- `bindOnPickUp` - 1 if the item is bind on pickup; otherwise nil (`1nil`)




## GetLootRollItemLink

Returns a hyperlink for an item currently up for loot rolling

**Signature:** `link = GetLootRollItemLink(id)`

**Arguments:**
- `id` - Index of an item currently up for loot rolling (as provided in the `START_LOOT_ROLL` event) (`number`)

**Returns:**
- `link` - A hyperlink for the loot roll item (`string`, hyperlink)

**See also:** Loot functions, Hyperlink functions, Item functions.




## GetLootRollTimeLeft

Returns the amount of time remaining before loot rolling for an item expires. When the time expires, all group members who have not yet chosen to roll Need or Greed automatically pass, random roll results are produced for those who chose to roll, and the server declares a winner and awards the item.

**Signature:** `timeLeft = GetLootRollTimeLeft(id)`

**Arguments:**
- `id` - Index of an item currently up for loot rolling (as provided in the `START_LOOT_ROLL` event) (`number`)

**Returns:**
- `timeLeft` - Amount of time remaining before loot rolling for the item expires (in milliseconds) (`number`)




## GetLootSlotInfo

Returns a hyperlink for an item available as loot

**Signature:** `texture, item, quantity, quality, locked = GetLootSlotInfo(slot)`

**Arguments:**
- `slot` - Index of a loot slot (between 1 and `GetNumLootItems()`) (`number`)

**Returns:**
- `texture` - Path to an icon texture for the item or amount of money (`string`)
- `item` - Name of the item, or description of the amount of money (`string`)
- `quantity` - Number of stacked items, or 0 for money (`number`)
- `quality` - Quality (rarity) of the item (`number`, itemQuality)
- `locked` - 1 if the item is locked (preventing the player from looting it); otherwise nil (`1nil`)




## GetLootSlotLink

Returns a hyperlink for an item available as loot. Returns nil if the loot slot is empty or contains money.

**Signature:** `link = GetLootSlotLink(slot)`

**Arguments:**
- `slot` - Index of a loot slot (between 1 and `GetNumLootItems()`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`)

**See also:** Loot functions, Hyperlink functions.




## GetLootThreshold

Returns the threshold used for Master Looter, Group Loot, and Need Before Greed loot methods. Items above the `threshold` quality will trigger the special behavior of the current loot method: for Group Loot and Need Before Greed, rolling will automatically begin once a group member loots the corpse or object holding the item; for Master Loot, the item will be invisible to all but the loot master tasked with assigning the loot.

**Signature:** `threshold = GetLootThreshold()`

**Returns:**
- `threshold` - Minimum item quality to trigger the loot method (`number`, itemQuality)

**See also:** Loot functions.



