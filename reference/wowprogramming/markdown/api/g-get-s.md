# WoW API — GetS*

_53 functions_

---

## GetSavedInstanceInfo

Returns information on a specific instance to which the player is saved

**Signature:** `instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName = GetSavedInstanceInfo(index)`

**Arguments:**
- `index` - Index of a saved instance (between 1 and `GetNumSavedInstances()`) (`number`)

**Returns:**
- `instanceName` - Name of the instance (`string`)
- `instanceID` - Unique identifier of the saved instance (commonly known as a RaidID) (`number`)
- `instanceReset` - Approximate number of seconds remaining until the instance resets (`number`)
- `instanceDifficulty` - Difficulty level of the saved instance (`number`) 

 - `1` - Normal ('10 Player' if instance is a raid)
- `2` - Heroic ('25 Player' if instance is a raid)
- `3` - 10 Player Heroic
- `4` - 25 Player Heroic
- `locked` - (`boolean`)
- `extended` - `true` if the reset time has been extended past its normal time; otherwise `false` (`boolean`)
- `instanceIDMostSig` - (`number`)
- `isRaid` - (`boolean`)
- `maxPlayers` - Number of players allowed (`number`)
- `difficultyName` - A string representing the difficulty of the given instance. (`string`)




## GetScreenHeight

Returns the height of the screen for UI layout purposes. Measurements for layout are affected by the UI Scale setting (i.e. the `uiscale` CVar) and may not match actual screen pixels.

**Signature:** `height = GetScreenHeight()`

**Returns:**
- `height` - Height of the screen in layout pixels (`number`)

**See also:** Video functions.




## GetScreenResolutions

Returns a list of available screen resolutions

**Signature:** `... = GetScreenResolutions()`

**Returns:**
- `...` - A list of strings, each a description of the dimensions of an available screen resolution (e.g. `"800x600"`, `"1024x768"`) (`string`)




## GetScreenWidth

_No snapshot available (page did not exist in archive)._




## GetScriptCPUUsage

Returns the total CPU time used by the scripting system. Only returns valid data if the `scriptProfile` CVar is set to 1; returns 0 otherwise.

**Signature:** `usage = GetScriptCPUUsage()`

**Returns:**
- `usage` - Amount of CPU time used by the scripting system (in milliseconds) since the UI was loaded or `ResetCPUUsage()` was last called (`number`)

**See also:** Debugging and Profiling functions.




## GetSelectedAuctionItem

Returns the index of the currently selected item in an auction listing. Auction selection is used only for display and internal recordkeeping in the default UI; it has no direct effect on other Auction APIs.

**Signature:** `index = GetSelectedAuctionItem("list")`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed

**Returns:**
- `index` - Index of the currently selected auction item (`number`)

**See also:** Auction functions.




## GetSelectedBattlefield

Returns the index of the selected battleground instance in the queueing list. Selection in the battleground instance list is used only for display in the default UI and has no effect on other Battlefield APIs.

**Signature:** `index = GetSelectedBattlefield()`

**Returns:**
- `index` - Index of the selection in the battleground queue listing (1 for the first available instance, or between 2 and `GetNumBattlefields()` for other instances) (`number`)




## GetSelectedDisplayChannel

Returns the selected channel in the channel list display

**Signature:** `index = GetSelectedDisplayChannel()`

**Returns:**
- `index` - Index of the selected channel in the display channel list (between 1 and `GetNumDisplayChannels()`) (`number`)

**See also:** Channel functions.




## GetSelectedFaction

Returns which faction entry is selected in the reputation UI. 
Selection has no bearing on other faction-related APIs; this function merely facilitates behaviors of Blizzard's reputation UI.

**Signature:** `index = GetSelectedFaction()`

**Returns:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**See also:** Faction functions.




## GetSelectedFriend

Returns the index of the selected character in the player's friends list. Selection in the Friends list is used only for display in the default UI and has no effect on other Friends list APIs.

**Signature:** `index = GetSelectedFriend()`

**Returns:**
- `index` - Index of the selected character in the Friends list (between 1 and `GetNumFriends()`) (`number`)

**See also:** Social functions.




## GetSelectedIgnore

Returns the index of the selected character in the player's ignore list. Selection in the Ignore list is used only for display in the default UI and has no effect on other Ignore list APIs.

**Signature:** `index = GetSelectedIgnore()`

**Returns:**
- `index` - Index of the selected character in the Ignore list (between 1 and `GetNumIgnores()`) (`number`)




## GetSelectedMute

Returns the index of the selected entry in the Muted list. Mute list selection is only used for display purposes in the default UI and has no effect on other API functions.

**Signature:** `selectedMute = GetSelectedMute()`

**Returns:**
- `selectedMute` - Index of the selected entry in the mute listing (between 1 and `GetNumMutes()`), or 0 if no entry is selected (`number`)

**See also:** Voice functions.




## GetSelectedSkill

_No snapshot available (page did not exist in archive)._




## GetSelectedStablePet

Returns the index of the selected stable pet

**Signature:** `selectedPet = GetSelectedStablePet()`

**Returns:**
- `selectedPet` - Index of the currently selected stable pet (`number`) 

 - `-1` - The player has no pets (in the stables or otherwise)
- `0` - The active pet is selected
- `1 to NUM_PET_STABLE_SLOTS` - A stable slot is selected




## GetSelectedStationeryTexture

Returns the currently selected stationery type. Always returns 1; the stationery feature for sending mail is not implemented in the current version of World of Warcraft.

**Signature:** `index = GetSelectedStationeryTexture()`

**Returns:**
- `index` - Index of the selected stationery type (between 1 and `GetNumStationeries()`) (`number`)

**See also:** Mail functions.




## GetSendMailCOD

Returns the Cash-On-Delivery cost of the outgoing message. Returns the amount set via `SetSendMailCOD()`, which in the default UI is only called once its Send button has been clicked (immediately before sending the message). Thus, does not return the COD amount set in the default UI's Send Mail window.

**Signature:** `amount = GetSendMailCOD()`

**Returns:**
- `amount` - COD cost for the items attached to the message (in copper) (`number`)

**See also:** Mail functions.




## GetSendMailItem

Returns information for an item attached to the outgoing message

**Signature:** `itemName, itemTexture, stackCount, quality = GetSendMailItem(slot)`

**Arguments:**
- `slot` - Index of an outgoing attachment slot (between 1 and `ATTACHMENTS_MAX_SEND`) (`number`)

**Returns:**
- `itemName` - Name of the attachment item (`string`)
- `itemTexture` - Path to an icon texture for the attachment item (`string`)
- `stackCount` - Number of stacked items (`string`)
- `quality` - Quality (rarity) of the attachment item (`number`, itemQuality)

**See also:** Mail functions.




## GetSendMailItemLink

Returns a hyperlink for an item attached to the outgoing message

**Signature:** `itemlink = GetSendMailItemLink(slot)`

**Arguments:**
- `slot` - Index of an outgoing attachment slot (between 1 and `ATTACHMENTS_MAX_SEND`) (`number`)

**Returns:**
- `itemlink` - A hyperlink for the attachment item (`string`, hyperlink)




## GetSendMailMoney

Returns the amount of money to be sent with the outgoing message. Returns the amount set via `SetSendMailMoney()`, which in the default UI is only called once its Send button has been clicked (immediately before sending the message). Thus, does not return the Send Money amount set in the default UI's Send Mail window.

**Signature:** `amount = GetSendMailMoney()`

**Returns:**
- `amount` - Amount of money to be sent (in copper) (`number`)

**See also:** Mail functions, Money functions.




## GetSendMailPrice

Returns the cost to send the outgoing mail message. The cost of sending a message rises as more items are attached.

**Signature:** `price = GetSendMailPrice()`

**Returns:**
- `price` - Cost to send the outgoing mail message (in copper) (`number`)

**See also:** Mail functions.




## GetShapeshiftForm

Returns the index of the active ability on the stance/shapeshift bar

**Signature:** `index = GetShapeshiftForm()`

**Returns:**
- `index` - Index of the active ability on the stance/shapeshift bar (between 1 and `GetNumShapeshiftForms()`) (`number`)




## GetShapeshiftFormCooldown

Returns cooldown information about an ability on the stance/shapeshift bar

**Signature:** `start, duration, enable = GetShapeshiftFormCooldown(index)`

**Arguments:**
- `index` - Index of an ability on the stance/shapeshift bar (between 1 and `GetNumShapeshiftForms()`) (`number`)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the ability is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the ability is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the ability is ready.) (`number`)




## GetShapeshiftFormInfo

Returns information about a shapeshift form

**Signature:** `texture, name, isActive, isCastable = GetShapeshiftFormInfo(index)`

**Arguments:**
- `index` - The index of a shapeshift form (`number`)

**Returns:**
- `texture` - The path to the shapeshift form's icon texture (`string`)
- `name` - The name of the shapeshift form (`string`)
- `isActive` - 1 if the shapeshift form is currently active, otherwise nil (`1nil`)
- `isCastable` - 1 if the shapeshift form is currently castable, otherwise nil (`1nil`)




## GetShieldBlock

Returns the amount of damage prevented when the player blocks with a shield

**Signature:** `damage = GetShieldBlock()`

**Returns:**
- `damage` - The amount of damage prevented when the player blocks with a shield (`number`)




## GetSkillLineInfo

Returns information about a given skill line

**Signature:** `skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(index)`

**Arguments:**
- `index` - The index of the skill line (`number`)

**Returns:**
- `skillName` - The name of the skill (`string`)
- `header` - 1 if the skill line is a header, instead of a skill (`1nil`)
- `isExpanded` - 1 if the skill line is a header and is expanded, otherwise nil (`1nil`)
- `skillRank` - The rank of the skill (`number`)
- `numTempPoints` - The temporary profession rank increase (for example 15 for engineering for Gnomes due to the racial trait) (`number`)
- `skillModifier` - The temporary rank modifier due to buffs, equipment, etc. (for example +Defense gear and the Defense skill) (`number`)
- `skillMaxRank` - The max rank available (`number`)
- `isAbandonable` - 1 if the skill can be unlearnt, otherwise nil (`1nil`)
- `stepCost` - Unused return value (`number`)
- `rankCost` - Unused return value (`number`)
- `minLevel` - The minimum level required to learn the skill (`number`)
- `skillCostType` - Unused return value (`number`)
- `skillDescription` - The description of the skill (`string`)




## GetSocketItemBoundTradeable

Returns whether the item open for socketing is temporarily tradeable. A Bind on Pickup item looted by the player can be traded to other characters who were originally eligible to loot it, but only within a limited time after looting. This period can be ended prematurely if the player attempts certain actions (such as socketing gems into the item).

**Signature:** `tradeable = GetSocketItemBoundTradeable()`

**Returns:**
- `tradeable` - `1` if the item can temporarily be traded to other players; otherwise `nil` (`1nil`)

**See also:** Socketing functions.




## GetSocketItemInfo

Returns information about the item currently being socketed. Only returns valid information when the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `name, icon, quality = GetSocketItemInfo()`

**Returns:**
- `name` - Name of the item (`string`)
- `icon` - Path to an icon texture for the item (`string`)
- `quality` - Quality level of the item (`number`, itemQuality)

**See also:** Socketing functions.




## GetSocketItemRefundable

Returns whether the item open for socketing is temporarily refundable. Items bought with alternate currency (honor points, arena points, or special items such as Emblems of Heroism and Dalaran Cooking Awards) can be returned to a vendor for a full refund, but only within a limited time after the original purchase. This period can be ended prematurely if the player attempts certain actions (such as socketing gems into the item).

**Signature:** `refundable = GetSocketItemRefundable()`

**Returns:**
- `refundable` - `1` if the item can be returned to a vendor for a refund; otherwise `nil` (`1nil`)

**See also:** Socketing functions.




## GetSocketTypes

Returns information about the gem types usable in a socket. Only returns valid information when the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `gemColor = GetSocketTypes(index)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)

**Returns:**
- `gemColor` - Type of the gem socket (`string`) 

 - `Blue` - Accepts any gem, but requires a blue, green, purple or prismatic gem to activate the item's socket bonus
- `Meta` - Accepts only meta gems
- `Red` - Accepts any gem, but requires a red, purple, orange or prismatic gem to activate the item's socket bonus
- `Socket` - Accepts any gem
- `Yellow` - Accepts any gem, but requires a yellow, orange, green or prismatic gem to activate the item's socket bonus




## GetSpellAutocast

Returns information about automatic casting for a spell in the spellbook. Generally, only certain pet spells can be autocast.

**Signature:** `autocastAllowed, autocastEnabled = GetSpellAutocast(id, "bookType")`

**Arguments:**
- `id` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook

**Returns:**
- `autocastAllowed` - 1 if automatic casting is allowed for the action; otherwise nil (`1nil`)
- `autocastEnabled` - 1 if automatic casting is currently turned on for the action; otherwise nil (`1nil`)




## GetSpellBonusDamage

Returns the player's spell damage bonus for a spell school

**Signature:** `minModifier = GetSpellBonusDamage(school)`

**Arguments:**
- `school` - Index of a spell school (`number`) 

 - `1` - Physical
- `2` - Holy
- `3` - Fire
- `4` - Nature
- `5` - Frost
- `6` - Shadow
- `7` - Arcane

**Returns:**
- `minModifier` - The player's spell damage bonus for the given school (`number`)




## GetSpellBonusHealing

Returns the player's amount of bonus healing

**Signature:** `bonusHealing = GetSpellBonusHealing()`

**Returns:**
- `bonusHealing` - Amount of bonus healing (`integer`)

**See also:** Stat information functions.




## GetSpellCooldown

Returns cooldown information about a spell in the spellbook

**Signature:** `start, duration, enable = GetSpellCooldown(index, "bookType") or GetSpellCooldown("name") or GetSpellCooldown(id)`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)
- `id` - Numeric ID of a spell (`number`, spellID)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the spell is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the spell is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the spell is ready.) (`number`)




## GetSpellCount

Returns the number of times a spell can be cast. Generally used for spells whose casting is limited by the number of item reagents in the player's possession.

**Signature:** `numCasts = GetSpellCount(index, "bookType") or GetSpellCount("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `numCasts` - Number of times the spell can be cast, or 0 if unlimited (`number`)




## GetSpellCritChance

Returns the player's spell critical strike chance for a spell school

**Signature:** `minCrit = GetSpellCritChance(school)`

**Arguments:**
- `school` - Index of a spell school (`number`) 

 - `1` - Physical
- `2` - Holy
- `3` - Fire
- `4` - Nature
- `5` - Frost
- `6` - Shadow
- `7` - Arcane

**Returns:**
- `minCrit` - The player's percentage critical strike chance for spells from the given school (`number`)




## GetSpellCritChanceFromIntellect

Returns additional spell critical strike chance provided by Intellect

**Signature:** `critChance = GetSpellCritChanceFromIntellect(["unit"])`

**Arguments:**
- `unit` - A unit to query; only valid for `player` and `pet`, defaults to `player` if omitted (`string`, unitID)

**Returns:**
- `critChance` - Additional percentage chance of spell critical strikes conferred by the unit's Intellect statistic (`number`)

**See also:** Stat information functions.




## GetSpellInfo

Returns information about a spell

**Signature:** `name, rank, icon, powerCost, isFunnel, powerType, castingTime, minRange, maxRange = GetSpellInfo(index, "bookType") or GetSpellInfo("name") or GetSpellInfo(id)`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell, optionally including secondary text (e.g. "Mana Burn" to find the player's highest rank, or "Mana Burn(Rank 2)" -- no space before the parenthesis -- for a specific rank) (`string`)
- `id` - Numeric ID of a spell (`number`, spellID)

**Returns:**
- `name` - Name of the spell (`string`)
- `rank` - Secondary text associated with the spell (e.g."Rank 5", "Racial", etc.) (`string`)
- `icon` - Path to an icon texture for the spell (`string`)
- `powerCost` - Amount of mana, rage, energy, runic power, or focus required to cast the spell (`number`)
- `isFunnel` - True for spells with health funneling effects (like Health Funnel) (`boolean`)
- `powerType` - Power type to cast the spell (`number`) 

 - `-2` - Health
- `0` - Mana
- `1` - Rage
- `2` - Focus
- `3` - Energy
- `5` - Runes
- `6` - Runic Power
- `castingTime` - Casting time of the spell in milliseconds (`number`)
- `minRange` - Minimum range from the target required to cast the spell (`number`)
- `maxRange` - Maximum range from the target at which you can cast the spell (`number`)




## GetSpellLink

Returns a hyperlink for a spell

**Signature:** `link, tradeLink = GetSpellLink(index, "bookType") or GetSpellLink("name") or GetSpellLink(id)`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell, optionally including secondary text (e.g. "Mana Burn" to find the player's highest rank, or "Mana Burn(Rank 2)" -- no space before the parenthesis -- for a specific rank) (`string`)
- `id` - Numeric ID of a spell (`number`, spellID)

**Returns:**
- `link` - A hyperlink for the spell (`string`, hyperlink)
- `tradeLink` - A hyperlink representing the player's list of trade skill recipes, if the spell is a trade skill (i.e. if "casting" the spell opens a trade skill window) (`string`)




## GetSpellName

Returns the name and secondary text for a spell in the spellbook. This function can been replaced with GetSpellBookItemName(index, bookType);

**Signature:** `spellName, subSpellName = GetSpellName(id, "bookType")`

**Arguments:**
- `id` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook

**Returns:**
- `spellName` - Localized name of the spell (`string`)
- `subSpellName` - Secondary text associated with the spell (e.g. "Rank 5", "Racial Passive", "Artisan") (`string`)

**See also:** Spell functions.




## GetSpellPenetration

Returns the amount of enemy magic resistance ignored due to the player's Spell Penetration Rating

**Signature:** `penetration = GetSpellPenetration()`

**Returns:**
- `penetration` - Amount of enemy magic resistance ignored due to the player's Spell Penetration Rating (`number`)

**See also:** Stat information functions.




## GetSpellTabInfo

Returns information about a tab in the spellbook

**Signature:** `name, texture, offset, numSpells = GetSpellTabInfo(index)`

**Arguments:**
- `index` - Index of a spellbook tab (between 1 and `GetNumSpellTabs()`) (`number`)

**Returns:**
- `name` - Name of the spellbook tab (`string`)
- `texture` - Path to an icon texture for the spellbook tab (`string`)
- `offset` - `spellbookID` of the first spell to be listed under the tab (`number`)
- `numSpells` - Number of spells listed under the tab (`number`)

**See also:** Spell functions.




## GetSpellTexture

Returns the icon texture path for a spell

**Signature:** `texture = GetSpellTexture(index, "bookType") or GetSpellTexture("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `texture` - Path to an icon texture for the spell (`string`)




## GetStablePetFoodTypes

Returns the types of food that a stabled pet will eat

**Signature:** `... = GetStablePetFoodTypes(index)`

**Arguments:**
- `index` - Index of a stable slot (`number`) 

 - `0` - Active pet
- `1 to NUM_PET_STABLE_SLOTS` - A stabled pet

**Returns:**
- `...` - A list of strings, each the localized name of a food type the pet will eat (`list`)

**See also:** Pet Stable functions.




## GetStablePetInfo

Returns information about a stabled pet

**Signature:** `icon, name, level, family, talent = GetStablePetInfo(index)`

**Arguments:**
- `index` - Index of a stable slot (`number`) 

 - `0` - Active pet
- `1 to NUM_PET_STABLE_SLOTS` - A stable slot

**Returns:**
- `icon` - Path to an icon texture for the pet (`string`)
- `name` - Name of the pet (`string`)
- `level` - Level of the pet (`number`)
- `family` - Localized name of the pet's creature family (e.g. Cat, Bear, Chimaera) (`string`)
- `talent` - Localized name of the pet's talent tree (e.g. Ferocity, Tenacity, Cunning) (`string`)

**See also:** Pet Stable functions.




## GetStationeryInfo

Returns information about a stationery type. Only returns information for the default stationery type; the stationery feature for sending mail is not implemented in the current version of World of Warcraft.

**Signature:** `name, texture, cost = GetStationeryInfo(index)`

**Arguments:**
- `index` - Index of a stationery type (between 1 and `GetNumStationeries()`) (`number`)

**Returns:**
- `name` - Name of the stationery type (`string`)
- `texture` - Path to an icon texture for the stationery type (`string`)
- `cost` - Cost to use the stationery when sending a message, in addition to normal postage (in copper) (`number`)

**See also:** Mail functions.




## GetStatistic

Returns data for a statistic that can be shown on the statistics tab of the achievements window

**Signature:** `info = GetStatistic(id)`

**Arguments:**
- `id` - The numeric ID of a statistic (`number`, blizzid)

**Returns:**
- `info` - The data for the statistic, or "--" if none has yet been recorded for it (`string`)

**See also:** Achievement functions.




## GetStatisticsCategoryList

Returns a list of all statistic categories

**Signature:** `categories = GetStatisticsCategoryList()`

**Returns:**
- `categories` - A list of statistic category IDs (`table`)

**See also:** Achievement functions.




## GetSubZoneText

Returns the name of the minor area in which the player is located. Subzones are named regions within a larger zone or instance: e.g. the Valley of Trials in Durotar, the Terrace of Light in Shattrath City, or the Njorn Stair in Utgarde Keep.

**Signature:** `subzoneText = GetSubZoneText()`

**Returns:**
- `subzoneText` - Name of the current subzone (`string`)




## GetSuggestedGroupNum

Returns the suggested group size for attempting the quest currently offered by a questgiver. Usable following the `QUEST_DETAIL` event in which the questgiver presents the player with the details of a quest and the option to accept or decline.

**Signature:** `suggestedGroup = GetSuggestedGroupNum()`

**Returns:**
- `suggestedGroup` - Suggested group size for attempting the quest currently offered by a questgiver (`number`)




## GetSummonConfirmAreaName

Returns the destination area of an offered summons. The name returned is generally that of the subzone in which the summoner performed the spell.

Usable between when the `CONFIRM_SUMMON` event fires (due to a summoning spell cast by another player) and when the value returned by `GetSummonConfirmTimeLeft()` reaches zero.

**Signature:** `area = GetSummonConfirmAreaName()`

**Returns:**
- `area` - Name of the location to which the player will be teleported upon accepting the summons (`string`)

**See also:** Summoning functions.




## GetSummonConfirmSummoner

Returns the name of the unit offering a summons to the player. Usable between when the `CONFIRM_SUMMON` event fires (due to a summoning spell cast by another player) and when the value returned by `GetSummonConfirmTimeLeft()` reaches zero.

**Signature:** `text = GetSummonConfirmSummoner()`

**Returns:**
- `text` - Name of the summoning unit (`string`)




## GetSummonConfirmTimeLeft

Returns the amount of time remaining before an offered summons expires. Returns 0 if no summons is currently available.

**Signature:** `timeleft = GetSummonConfirmTimeLeft()`

**Returns:**
- `timeleft` - Time remaining until the offered summons can no longer be accepted (in seconds) (`number`)




## GetSummonFriendCooldown

Returns cooldown information about the player's Summon Friend ability

**Signature:** `start, duration = GetSummonFriendCooldown()`

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the ability is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the ability is ready (`number`)

**See also:** Recruit-a-friend functions.



