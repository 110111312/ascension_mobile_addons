# WoW API — GetA*

_55 functions_

---

## GetAbandonQuestItems

Returns information about items that would be destroyed by abandoning a quest. Usable after calling `SetAbandonQuest()` but before calling `AbandonQuest()`.

**Signature:** `items = GetAbandonQuestItems()`

**Returns:**
- `items` - A string listing any items that would be destroyed (`string`)

**See also:** Quest functions.




## GetAbandonQuestName

Returns the name of the quest being abandoned. Usable after calling `SetAbandonQuest()` but before calling `AbandonQuest()`.

**Signature:** `name = GetAbandonQuestName()`

**Returns:**
- `name` - Name of the quest being abandoned (`string`)

**See also:** Quest functions.




## GetAccountExpansionLevel

Returns the most recent of WoW's retail expansion packs for which the player's account is authorized. 
Used in the default UI to determine the player's maximum possible level (and showing or hiding the XP bar accordingly). Also indicates whether the player is allowed to access expansion areas (e.g. Outland, Draenei / Blood Elf starting areas, Northrend).

**Signature:** `expansionLevel = GetAccountExpansionLevel()`

**Returns:**
- `expansionLevel` - Expansion level of the player's account (`number`) 

 - `0` - World of Warcraft ("Classic")
- `1` - World of Warcraft: The Burning Crusade
- `2` - World of Warcraft: Wrath of the Lich King
- `3` - World of Warcraft: Cataclysm

**See also:** Client control and information functions.




## GetAchievementCategory

Returns the numeric ID of the category to which an achievement belongs

**Signature:** `categoryID = GetAchievementCategory(achievementID)`

**Arguments:**
- `achievementID` - The numeric ID of an achievement (`number`)

**Returns:**
- `categoryID` - The numeric ID of the achievement's category (`number`)




## GetAchievementComparisonInfo

Returns information about the comparison unit's achievements. Only accurate once the `INSPECT_ACHIEVEMENT_READY` event has fired following a call to `SetAchievementComparisonUnit()`. No longer accurate once `ClearAchievementComparisonUnit()` is called.

**Signature:** `completed, month, day, year = GetAchievementComparisonInfo(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**Returns:**
- `completed` - True if the comparison unit has completed the achievement; otherwise nil (`boolean`)
- `month` - Month in which the comparison unit completed the achievement (`number`)
- `day` - Day of the month on which the comparison unit completed the achievement (`number`)
- `year` - Year in which the comparison unit completed the achievement. (Two digit year, assumed to be 21st century.) (`number`)

**See also:** Achievement functions.




## GetAchievementCriteriaInfo

Gets information about criteria for an achievement or data for a statistic

**Signature:** `description, type, completed, quantity, requiredQuantity, characterName, flags, assetID, quantityString, criteriaID = GetAchievementCriteriaInfo(achievementID, index) or GetAchievementCriteriaInfo(statisticID)`

**Arguments:**
- `achievementID` - The numeric ID of an achievement (`number`)
- `index` - Index of one of the achievement's criteria (between 1 and GetAchievementNumCriteria()) (`number`)
- `statisticID` - The numeric ID of a statistic (`number`)

**Returns:**
- `description` - Description of the criterion (as displayed in the UI for achievements with multiple criteria) or statistic (`string`)
- `type` - Type of criterion: a value of 8 indicates the criterion is another achievement; other values are not used in the default UI (`number`)
- `completed` - True if the player has completed the criterion; otherwise false (`boolean`)
- `quantity` - If applicable, number of steps taken towards completing the criterion (e.g. for the only criterion of "Did Somebody Order a Knuckle Sandwich?", the player's current Unarmed skill; for the first criterion of "Pest Control", 1 if the player has killed an Adder, 0 otherwise (`number`)
- `requiredQuantity` - If applicable, number of steps required to complete the criterion (e.g. 400 for the only criterion of "Did Somebody Order a Knuckle Sandwich?"; 1 for any criterion of "Pest Control" (`number`)
- `characterName` - Character name with which the criterion was completed. Currently always the player character's name for completed criteria (`string`)
- `flags` - Test against the following masks with bit.band() to reveal additional information: (`bitfield`) 

 - `0x00000001` - Criterion should be displayed as a progress bar
- `0x00000002` - Criterion should be hidden in normal achievement displays
- `assetID` - Internal ID number of the quest to complete, NPC to kill, item to acquire, world object to interact with, achievement to earn, or other game entity related to completing the criterion. (Note: some but not all of these ID types are usable elsewhere in the WoW API) (`number`)
- `quantityString` - Text to be shown when displaying `quantity` and `requiredQuantity` in a UI element. (Not always the same as `format("%d / %d", quantity, requiredQuantity)`; e.g. "Got My Mind On My Money" shows monetary amounts with embedded textures for gold, silver, and copper) (`string`)
- `criteriaID` - Unique ID number identifying the criterion; usable with `GetAchievementInfoFromCriteria()` (`number`)

**See also:** Achievement functions.




## GetAchievementInfo

Gets information about an achievement or statistic

**Signature:** `id, name, points, completed, month, day, year, description, flags, icon, rewardText = GetAchievementInfo(category, index) or GetAchievementInfo(id)`

**Arguments:**
- `category` - Numeric ID of an achievement category (`number`)
- `index` - Index of an achievement within a category (between 1 and GetCategoryNumAchievements()) (`number`)
- `id` - The numeric ID of an achievement or statistic (`number`)

**Returns:**
- `id` - The numeric ID of the achievement or statistic (`number`)
- `name` - Name of the achievement or statistic (`string`)
- `points` - Amount of achievement points awarded for completing the achievement (`number`)
- `completed` - True if the player has completed the achievement; otherwise false (`boolean`)
- `month` - Month in which the player completed the achievement (`number`)
- `day` - Day of the month on which the player completed the achievement (`number`)
- `year` - Year in which the player completed the achievement. (Two digit year, assumed to be 21st century.) (`number`)
- `description` - Description of the achievement (`string`)
- `flags` - Test against the following masks with bit.band() to reveal additional information: (`bitfield`) 

 - `0x00000001` - Info is for a statistic, not an achievement
- `0x00000002` - Achievement should be hidden in normal displays
- `0x00000080` - Achievement should display its criteria as a progress bar regardless of per-criterion flags
- `icon` - Path to an icon texture for the achievement (`string`)
- `rewardText` - Text describing a reward for the achievement, or the empty string if no reward is offered (`string`)




## GetAchievementInfoFromCriteria

Gets information about an achievement or statistic given a criterion ID

**Signature:** `id, name, points, description, flags, icon, rewardText = GetAchievementInfoFromCriteria(id)`

**Arguments:**
- `id` - The numeric ID of an achievement or statistic criterion (as can be retrieved from GetAchievementCriteriaInfo()) (`number`)

**Returns:**
- `id` - The numeric ID of the achievement or statistic (`number`)
- `name` - Name of the achievement or statistic (`string`)
- `points` - Amount of achievement points awarded for completing the achievement (`number`)
- `description` - Description of the achievement (`string`)
- `flags` - Test against the following masks with bit.band() to reveal additional information: (`bitfield`) 

 - `0x00000001` - Info is for a statistic, not an achievement
- `0x00000002` - Achievement should be hidden in normal displays
- `0x00000080` - Achievement should display its criteria as a progress bar regardless of per-criterion flags
- `icon` - Path to an icon texture for the achievement (`string`)
- `rewardText` - Text describing a reward for the achievement, or the empty string if no reward is offered (`string`)

**See also:** Achievement functions.




## GetAchievementLink

Returns a hyperlink representing the player's progress on an achievement. 
The tooltip associated with the hyperlink shows not only the details of the achievement itself, but also the completion of or progress towards the achievement by the player who produced the link.

**Signature:** `link = GetAchievementLink(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**Returns:**
- `link` - A hyperlink for the player's achievement (`string`)

**See also:** Achievement functions, Hyperlink functions.




## GetAchievementNumCriteria

Returns the number of measured criteria for an achievement. 
Measured criteria for an achievement are shown in the default UI as details when clicking on an achievement in the achievements window or when showing an achievement in the objectives tracker; e.g. "Master of Arms" (15 criteria: Axes, Bows, Crossbows, Daggers, etc.) and "Safe Deposit" (1 criterion: number of bank slots purchased).

Not all achievements have criteria: achievements with zero criteria are those that can be completed in a single event (though a complicated event it may be), explained in achievement's description: e.g. "Reach level 80", "Fall 65 yards without dying", and "With all three Twilight Drakes still alive, engage and defeat Sartharion the Onyx Guardian on Normal Difficulty".

**Signature:** `count = GetAchievementNumCriteria(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**Returns:**
- `count` - Number of criteria for the achievement (`number`)

**See also:** Achievement functions.




## GetAchievementNumRewards

Returns the number of point rewards for an achievement (currently always 1). 
Currently all achievements and statistics offer one reward (according to this function), though the rewards offered by statistics are all zero points.

**Signature:** `count = GetAchievementNumRewards(id)`

**Arguments:**
- `id` - The numeric ID of an achievement or statistic (`number`)

**Returns:**
- `count` - Number of point rewards offered for the achievement (`number`)

**See also:** Achievement functions.




## GetAchievementReward

Returns the number of achievement points awarded for earning an achievement. 
Currently all achievements and statistics offer one reward (according to this function), though the rewards offered by statistics are all zero points.

**Signature:** `points = GetAchievementReward(id, index)`

**Arguments:**
- `id` - The numeric ID of an achievement or statistic (`number`)
- `index` - Index of one of the achievement's rewards (between 1 and GetAchievementNumRewards(); currently always 1) (`number`)

**Returns:**
- `points` - Number of achievement points awarded for completing the achievement (`number`)

**See also:** Achievement functions.




## GetActionAutocast

Returns information about autocast actions. No player actions have allowed automatic casting since the initial public release of World of Warcraft.

**Signature:** `autocastAllowed, autocastEnabled = GetActionAutocast(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `autocastAllowed` - 1 if automatic casting is allowed for the action; otherwise nil (`1nil`)
- `autocastEnabled` - 1 if automatic casting is currently turned on for the action; otherwise nil (`1nil`)

**See also:** Action functions.




## GetActionBarPage

Returns the current action bar page

**Signature:** `page = GetActionBarPage()`

**Returns:**
- `page` - The current action bar page (`number`)

**See also:** ActionBar functions.




## GetActionBarToggles

Returns the current visibility settings for the four secondary action bars

**Signature:** `showBar1, showBar2, showBar3, showBar4 = GetActionBarToggles()`

**Returns:**
- `showBar1` - 1 if the interface option is set to show the Bottom Left ActionBar, otherwise nil (`1nil`)
- `showBar2` - 1 if the interface option is set to show the Bottom Right ActionBar, otherwise nil (`1nil`)
- `showBar3` - 1 if the interface option is set to show the Right ActionBar, otherwise nil (`1nil`)
- `showBar4` - 1 if the interface option is set to show the Right ActionBar 2, otherwise nil (`1nil`)

**See also:** ActionBar functions.




## GetActionCooldown

Returns cooldown information about an action

**Signature:** `start, duration, enable = GetActionCooldown(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the action is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the action is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the action is ready.) (`number`)




## GetActionCount

Returns the number of uses remaining for the given action slot. Applies to spells that require reagents, items that stack, or items with charges; used in the default UI to display the count on action buttons.

Returns 0 for any action that does not use a count. To distinguish between actions which do not use a count and actions which do but whose current count is 0, see `IsConsumableAction`.

**Signature:** `count = GetActionCount(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `count` - Number of times the action can be used (`number`)

**See also:** Action functions.




## GetActionInfo

Returns information about an action slot

**Signature:** `type, id, subType, spellID = GetActionInfo(slot)`

**Arguments:**
- `slot` - An action slot (`number`)

**Returns:**
- `type` - Type of action in the slot (`string`) 

 - `companion` - Summons a mount or non-combat pet
- `equipmentset` - Equips a set of items
- `item` - Uses an item
- `macro` - Runs a macro
- `spell` - Casts a spell
- `id` - An identifier for the action; varies by type: (`number or string`) 

 - `companion` - The companion's index in the mount or minipet list
- `equipmentset` - Name of the equipment set
- `item` - The item's itemID
- `macro` - The macro's index in the macro list (macroID)
- `spell` - The spell's index in the player's spellboook ( spellbookID)
- `subType` - Subtype of the action (or `nil` if not applicable) (`string`) 

 - `CRITTER` - For `companion` actions: indicates `id` is as an index in the non-combat pets list
- `MOUNT` - For `companion` actions: indicates `id` is an index in the mounts list
- `spell` - For `spell` actions: indicates `id` is an index in the player's spellbook (as opposed to the pet's)
- `spellID` - For `spell` and `companion` actions, the global ID of the spell (or the summoning "spell" for a companion) (`string`, spellID)




## GetActionText

Returns the text label associated with an action. Currently used only for macros, which in the default UI show their name as a label on an action button.

**Signature:** `text = GetActionText(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `text` - Label for the action (`string`)




## GetActionTexture

Returns the icon texture for an action. Can be the icon of a spell or item, the icon manually set for a macro, or an icon reflecting the current state of a macro.

**Signature:** `texture = GetActionTexture(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `texture` - Path to an icon texture for the action in the slot, or nil if the slot is empty (`string`)

**See also:** Action functions.




## GetActiveLevel

Returns the level of a quest which can be turned in to the current Quest NPC. Only returns valid information after a `QUEST_GREETING` event.

Note: Most quest NPCs present active quests using the `GetGossipActiveQuests()` instead of this function.

**Signature:** `level = GetActiveLevel(index)`

**Arguments:**
- `index` - Index of a quest which can be turned in to the current Quest NPC (between 1 and `GetNumActiveQuests()`) (`number`)

**Returns:**
- `level` - Recommended character level for attempting the quest (`number`)




## GetActiveTalentGroup

Returns the index of the active talent specialization

**Signature:** `activeTalentGroup = GetActiveTalentGroup(isInspect, isPet)`

**Arguments:**
- `isInspect` - true to query talent info for the currently inspected unit, false to query talent info for the player (`boolean`)
- `isPet` - true to query talent info for the player's pet, false to query talent info for the player (`boolean`)

**Returns:**
- `activeTalentGroup` - Which talent group is currently active (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents




## GetActiveTitle

Returns the name of a quest which can be turned in to the current Quest NPC. Only returns valid information after a `QUEST_GREETING` event.

Note: Most quest NPCs present active quests using the `GetGossipActiveQuests()` instead of this function.

**Signature:** `title = GetActiveTitle(index)`

**Arguments:**
- `index` - Index of a quest which can be turned in to the current Quest NPC (between 1 and `GetNumActiveQuests()`) (`number`)

**Returns:**
- `title` - Title of the quest (`string`)

**See also:** Quest functions.




## GetActiveVoiceChannel

Returns the currently active voice channel

**Signature:** `index = GetActiveVoiceChannel()`

**Returns:**
- `index` - Index of the active voice channel in the chat display window (between 1 and `GetNumDisplayChannels()`), or nil if no channel is active (`number`)




## GetAddOnCPUUsage

Returns the amount of CPU time used by an addon. Only returns valid data if the `scriptProfile` CVar is set to 1; returns 0 otherwise.

The value returned is from a cache only updated when calling `UpdateAddOnCPUUsage()`. This value is the sum of `GetFunctionCPUUsage()` for all functions created on the addon's behalf -- note that if the addon calls external functions which in turn create new functions, the new functions are considered to belong to the addon.

**Signature:** `usage = GetAddOnCPUUsage("name") or GetAddOnCPUUsage(index)`

**Arguments:**
- `name` - Name of an addon (name of the addon's folder and TOC file, not the Title found in the TOC) (`string`)
- `index` - Index of an addon in the addon list (between 1 and `GetNumAddOns()`) (`number`)

**Returns:**
- `usage` - Amount of CPU time used by the addon (in milliseconds) since the UI was loaded or `ResetCPUUsage()` was last called (`number`)

**See also:** Debugging and Profiling functions.




## GetAddOnDependencies

Returns a list of addons a given addon is dependent upon

**Signature:** `... = GetAddOnDependencies("name") or GetAddOnDependencies(index)`

**Arguments:**
- `name` - Name of an addon (name of the addon's folder and TOC file, not the Title found in the TOC) (`string`)
- `index` - Index of an addon in the addon list (between 1 and `GetNumAddOns()`) (`number`)

**Returns:**
- `...` - A list of strings, each the (folder) name of another addon this addon is dependent upon (`list`)

**See also:** Addon-related functions.




## GetAddOnInfo

Returns information about an addon in the client's addon list

**Signature:** `name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(index) or GetAddOnInfo("name")`

**Arguments:**
- `index` - The index of the AddOn, must be in the range of 1 to GetNumAddOns(). (`number`)
- `name` - The name of the AddOn, as it appears in its folder name. (`string`)

**Returns:**
- `name` - The name of the addon (`string`)
- `title` - The title of the addon (`string`)
- `notes` - The value of the "Notes" field from the table of contents (`string`)
- `enabled` - 1 if the addon is enabled for the current character, otherwise nil (`1nil`)
- `loadable` - If the addon is capable of being loaded (`1nil`)
- `reason` - If the addon isn't loadable, what is the reason (`string`)
- `security` - "SECURE" if the addon is secure, otherwise "INSECURE". A "secure" addon is one that is released by Blizzard and is digitally signed (`string`)




## GetAddOnMemoryUsage

Returns the amount of memory used by an addon. The value returned is from a cache only updated when calling `UpdateAddOnMemoryUsage()`.

**Signature:** `mem = GetAddOnMemoryUsage("name") or GetAddOnMemoryUsage(index)`

**Arguments:**
- `name` - Name of an addon (name of the addon's folder and TOC file, not the Title found in the TOC) (`string`)
- `index` - Index of an addon in the addon list (between 1 and `GetNumAddOns()`) (`number`)

**Returns:**
- `mem` - Memory usage of the addon (in kilobytes) (`number`)

**See also:** Debugging and Profiling functions.




## GetAddOnMetadata

Returns the value of certain fields in an addon's TOC file

**Signature:** `data = GetAddOnMetadata(index, "variable") or GetAddOnMetadata("name", "variable")`

**Arguments:**
- `index` - The index of the AddOn, must be in the range of 1 to GetNumAddOns(). (`number`)
- `name` - The name of the AddOn as it appears in its folder name. (`string`)
- `variable` - The variable name that you want to query, only a limited number of values are accepted. (`string`) 

 - `Author` - The author of the AddOn as outlined in the TOC file
- `Notes` - Any notes the author of the AddOn placed into the TOC file
- `Title` - The title of the AddOn, this defaults to the name of the AddOn as it appears in its folder name
- `Version` - The version string that the author placed in the TOC file
- `X-` - These are the only custom tags that can be queried, can be anything you want.

**Returns:**
- `data` - The data available in the TOC for the variable queried, or nil if the variable is not queryable or not defined. (`string`)




## GetAdjustedSkillPoints

_No snapshot available (page did not exist in archive)._




## GetAllowLowLevelRaid




## GetAreaSpiritHealerTime

Returns the time remaining until a nearby battleground spirit healer resurrects all players in its area

**Signature:** `timeleft = GetAreaSpiritHealerTime()`

**Returns:**
- `timeleft` - Seconds remaining before the next area resurrection (`number`)

**See also:** Battlefield functions.




## GetArenaCurrency

_No snapshot available (page did not exist in archive)._




## GetArenaTeam

Returns information about one of the player's arena teams

**Signature:** `teamName, teamSize, teamRating, teamPlayed, teamWins, seasonTeamPlayed, seasonTeamWins, playerPlayed, seasonPlayerPlayed, teamRank, playerRating, bg_red, bg_green, bg_blue, emblem, emblem_red, emblem_green, emblem_blue, border, border_red, border_green, border_blue = GetArenaTeam(team)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)

**Returns:**
- `teamName` - Name of the arena team (`string`)
- `teamSize` - Size of the team (2 for 2v2, 3 for 3v3, or 5 for 5v5) (`number`)
- `teamRating` - The team's current rating (`number`)
- `teamPlayed` - Number of games played by the team in the current week (`number`)
- `teamWins` - Number of games won by the team in the current week (`number`)
- `seasonTeamPlayed` - Number of games played by the team in the current arena season (`number`)
- `seasonTeamWins` - Number of games won by the team in the current arena season (`number`)
- `playerPlayed` - Number of games in which the player has participated in the current week (`number`)
- `seasonPlayerPlayed` - Number of games in which the player has participated in the current arena season (`number`)
- `teamRank` - The team's current rank among same-size teams in its battlegroup (`number`)
- `playerRating` - The player's personal rating with this team (`number`)
- `bg_red` - Red component of the color value for the team banner's background (`number`)
- `bg_green` - Green component of the color value for the team banner's background (`number`)
- `bg_blue` - Blue component of the color value for the team banner's background (`number`)
- `emblem` - Index of the team's emblem graphic; full path to the emblem texture can be found using the format `"Interface\PVPFrame\Icons\PVP-Banner-Emblem-"..emblem` (`number`)
- `emblem_red` - Red component of the color value for the team banner's emblem (`number`)
- `emblem_green` - Green component of the color value for the team banner's emblem (`number`)
- `emblem_blue` - Blue component of the color value for the team banner's emblem (`number`)
- `border` - Index of the team's border graphic; full path to the border texture can be found by using the format `"Interface\PVPFrame\PVP-Banner-"..teamSize.."-Border-"..border` (`number`)
- `border_red` - Red component of the color value for the team banner's border (`number`)
- `border_green` - Green component of the color value for the team banner's border (`number`)
- `border_blue` - Blue component of the color value for the team banner's border (`number`)




## GetArenaTeamGdfInfo




## GetArenaTeamRosterInfo

Returns information about an arena team member

**Signature:** `name, rank, level, class, online, played, win, seasonPlayed, seasonWin, rating = GetArenaTeamRosterInfo(team, index)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)
- `index` - Index of a team member (between 1 and `GetNumArenaTeamMembers(team)`) (`number`)

**Returns:**
- `name` - Name of the team member (`string`)
- `rank` - Rank of the member in the team (`number`) 

 - `0` - Team captain
- `1` - Member
- `level` - Character level of the team member (`number`)
- `class` - Localized name of the team member's class (`string`)
- `online` - 1 if the team member is currently online; otherwise nil (`1nil`)
- `played` - Number of games played by the team member in the current week (`number`)
- `win` - Number of winning games played by the team member in the current week (`number`)
- `seasonPlayed` - Number of games played by the team member in the current arena season (`number`)
- `seasonWin` - Number of winning games played by the team member in the current arena season (`number`)
- `rating` - The team member's personal rating with this team (`number`)

**See also:** Arena functions.




## GetArenaTeamRosterSelection

Returns the currently selected member in an arena team roster. Selection in the arena team roster currently has no effect beyond highlighting list entry in the default UI.

**Signature:** `index = GetArenaTeamRosterSelection(team)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)

**Returns:**
- `index` - Index of the selected member in the roster listing (`number`)




## GetArenaTeamRosterShowOffline

Returns whether arena team roster listings should include offline members. The "Show Offline" filter is not used in the default UI; if disabled, offline members are still shown.

**Signature:** `showOffline = GetArenaTeamRosterShowOffline()`

**Returns:**
- `showOffline` - 1 if the show offline filter for arena teams is enabled, otherwise nil (`1nil`)

**See also:** Arena functions.




## GetArmorPenetration

Returns the percentage of enemy armor ignored due to the player's Armor Penetration Rating

**Signature:** `amount = GetArmorPenetration()`

**Returns:**
- `amount` - Percentage of enemy armor ignored due to the player's Armor Penetration Rating (`number`)




## GetAttackPowerForStat

Returns the attack power bonus provided by one of the player's basic statistics

**Signature:** `attackPower = GetAttackPowerForStat(statIndex, effectiveStat)`

**Arguments:**
- `statIndex` - Index of a basic statistic (`number`) 

 - `1` - Strength
- `2` - Agility
- `3` - Stamina
- `4` - Intellect
- `5` - Spirit
- `effectiveStat` - Value of the statistic to use in attack power calculation (`number`)

**Returns:**
- `attackPower` - Attack power bonus provided to the player by the basic statistic value (`number`)




## GetAuctionHouseDepositRate

Returns the deposit rate for the current auction house. Obsolete (returns different values for faction and neutral auction houses, but these values do not describe the ratio of auction deposit to an item's vendor buy or sell price); use `CalculateAuctionDeposit()` instead.

**Signature:** `rate = GetAuctionHouseDepositRate()`

**Returns:**
- `rate` - The current auction house deposit rate (`number`)

**See also:** Auction functions.




## GetAuctionInvTypes

Returns a list of the inventory subtypes for a given auction house item subclass. Inventory types are the second level of hierarchy seen when browsing item classes (categories) and subclasses at the Auction House: `Head`, `Neck`, `Shirt`, et al for `Miscellaneous`; `Head`, `Shoulder`, `Chest`, `Wrist`, et al for `Cloth`; etc.

This function still returns valid information if the player is not interacting with an auctioneer.

**Signature:** `token, display, ... = GetAuctionInvTypes(classIndex, subClassIndex)`

**Arguments:**
- `classIndex` - Index of an item class (in the list returned by `GetAuctionItemClasses()`); currently, inventory types are only applicable in class `2` (armor) (`number`)
- `subClassIndex` - Index of an item subclass (in the list returned by `GetAuctionItemSubClasses(classIndex)`); currently, inventory types are only applicable in the armor subclasses listed below: (`number`) 

 - `1` - Miscellaneous
- `2` - Cloth
- `3` - Leather
- `4` - Mail
- `5` - Plate

**Returns:**
- `token` - Name of a global variable containing the localized name of the inventory type (e.g. `INVTYPE_FINGER`) (`string`)
- `display` - 1 if the inventory type should be displayed; otherwise nil (used in the default auction UI to hide subclass/invType combinations that don't exist in the game; e.g. Plate/Back, Leather/Trinket, etc) (`1nil`)
- `...` - Additional `token, display` pairs for each inventory type listed (`list`)

**See also:** Auction functions.




## GetAuctionItemClasses

Returns a list of localized item class (category) names. Item classes are the first level of hierarchy seen when browsing at the Auction House: `Weapon`, `Armor`, `Container`, `Consumable`, etc.

This function still returns valid information if the player is not interacting with an auctioneer.

**Signature:** `... = GetAuctionItemClasses()`

**Returns:**
- `...` - A list of strings, each the name of an item class (`list`)

**See also:** Auction functions.




## GetAuctionItemInfo

Returns information about an auction listing

**Signature:** `name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", index)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of an auction in the listing (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `count` - Number of items in the stack (`number`)
- `quality` - The quality (rarity) level of the item (`number`, itemQuality)
- `canUse` - 1 if the player character can use or equip the item; otherwise nil (`1nil`)
- `level` - Required character level to use or equip the item (`number`)
- `minBid` - Minimum cost to bid on the item (in copper) (`number`)
- `minIncrement` - Minimum bid increment to become the highest bidder on the item (in copper) (`number`)
- `buyoutPrice` - Buyout price of the auction (in copper) (`number`)
- `bidAmount` - Current highest bid on the item (in copper); 0 if no bids have been placed (`number`)
- `highestBidder` - 1 if the player is currently the highest bidder; otherwise nil (`1nil`)
- `owner` - Name of the character who placed the auction (`string`)
- `sold` - 1 if the auction has sold (and payment is awaiting delivery; applies only to `owner` auctions); otherwise nil (`number`)

**See also:** Auction functions.




## GetAuctionItemLink

Returns a hyperlink for an item in an auction listing

**Signature:** `link = GetAuctionItemLink("list", index)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of an auction in the listing (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)




## GetAuctionItemSubClasses

Returns a list of localized subclass names for a given item class. Item subclasses are the second level of hierarchy seen when browsing item classes (categories) at the Auction House: `One-Handed Axes`, `Two-Handed Axes`, `Bows`, `Guns`, et al for `Weapon`; `Cloth`, `Leather`, `Plate`, `Shields`, et al for `Armor`; `Food & Drink`, `Potion`, `Elixir` et al for `Consumable`; `Red`, `Blue`, `Yellow`, et al for `Gem`; etc.

This function still returns valid information if the player is not interacting with an auctioneer.

**Signature:** `... = GetAuctionItemSubClasses(classIndex)`

**Arguments:**
- `classIndex` - Index of an item class (in the list returned by `GetAuctionItemClasses()`) (`number`)

**Returns:**
- `...` - A list of strings, each the name of an item subclass; or nil if the class contains no subclasses (`list`)




## GetAuctionItemTimeLeft

Returns the time remaining before an auction listing expires

**Signature:** `duration = GetAuctionItemTimeLeft("list", index)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of an auction in the listing (`number`)

**Returns:**
- `duration` - General indication of the amount of time remaining on the auction (`number`) 

 - `1` - Short (less than 30 minutes)
- `2` - Medium (30 minutes to 2 hours)
- `3` - Long (2 hours to 12 hours)
- `4` - Very Long (more than 12 hours)




## GetAuctionSellItemInfo

Returns information about the item currently being set up for auction. Only returns useful information once an item has been placed in the Create Auction UI's "auction item" slot (see `ClickAuctionSellItemButton()`).

**Signature:** `name, texture, count, quality, canUse, price = GetAuctionSellItemInfo()`

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `count` - Number of items in the stack (`number`)
- `quality` - Quality (rarity) level of the item (`number`, itemQuality)
- `canUse` - 1 if the player character can use or equip the item; otherwise nil (`1nil`)
- `price` - Price to sell the item to a vendor (in copper) (`number`)




## GetAuctionSort

Returns the current sort settings for auction data. The `index` argument describes priority order for sort criteria: e.g. if `GetAuctionSort("list",1)` returns `quality` and `GetAuctionSort("list",2)` returns `level,1`, items are sorted first by `itemQuality` and items with the same quality are sorted by required level.

**Signature:** `criterion, reverse = GetAuctionSort("list", index)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of a sorting priority (`number`)

**Returns:**
- `criterion` - Non-localized string naming the criterion (or column in the default UI) by which listings are sorted (`string`)
- `reverse` - 1 if listings are sorted in reverse order; otherwise nil. "Reverse" here is relative to the default order, not to absolute value: e.g. the default order for `quality` is descending (Epic, Rare, Uncommon, etc), but the default order for `level` is ascending (1-80) (`1nil`)




## GetAutoCompletePresenceID




## GetAutoCompleteResults

Returns a list of character names which complete a given partial name prefix

**Signature:** `... = GetAutoCompleteResults("inputString", includeBitfield, excludeBitfield, maxResults [, cursorPosition])`

**Arguments:**
- `inputString` - Partial name for which to return completions (`string`)
- `includeBitfield` - One or more of the following flags (combined via `bit.bor()`), indicating which characters should be included in the result list: (`number`, bitfield) 

 - `0x00000000` - `AUTOCOMPLETE_FLAG_NONE`: No characters
- `0x00000001` - `AUTOCOMPLETE_FLAG_IN_GROUP`: Characters in the player's party or raid
- `0x00000002` - `AUTOCOMPLETE_FLAG_IN_GUILD`: Characters in the player's guild
- `0x00000004` - `AUTOCOMPLETE_FLAG_FRIEND`: Characters from the player's friends list
- `0x00000010` - `AUTOCOMPLETE_FLAG_INTERACTED_WITH`: Characters with whom the player has recently interacted
- `0x00000020` - `AUTOCOMPLETE_FLAG_ONLINE`: Currently online friends and guildmates
- `0xffffffff` - `AUTOCOMPLETE_FLAG_ALL`: All characters
- `excludeBitfield` - One or more of the following flags (combined via `bit.bor()`), indicating which characters should be excluded from the result list: (`number`, bitfield) 

 - `0x00000000` - `AUTOCOMPLETE_FLAG_NONE`: No characters
- `0x00000001` - `AUTOCOMPLETE_FLAG_IN_GROUP`: Characters in the player's party or raid
- `0x00000002` - `AUTOCOMPLETE_FLAG_IN_GUILD`: Characters in the player's guild
- `0x00000004` - `AUTOCOMPLETE_FLAG_FRIEND`: Characters from the player's friends list
- `0x00000010` - `AUTOCOMPLETE_FLAG_INTERACTED_WITH`: Characters with whom the player has recently interacted
- `0x00000020` - `AUTOCOMPLETE_FLAG_ONLINE`: Currently online friends and guildmates
- `0xffffffff` - `AUTOCOMPLETE_FLAG_ALL`: All characters
- `maxResults` - Maximum number of results to be returned (`number`)
- `cursorPosition` - Cursor position in the `inputString`; currently unused (`number`)

**Returns:**
- `...` - A list of strings, each the name of a character matching the search parameters (`list`)

**See also:** Utility functions.




## GetAvailableLevel

Returns the level of a quest available from the current Quest NPC. Only returns valid information after a `QUEST_GREETING` event.

Note: Most quest NPCs present available quests using the `GetGossipAvailableQuests()` instead of this function.

**Signature:** `level = GetAvailableLevel(index)`

**Arguments:**
- `index` - Index of a quest available from the current Quest NPC (between 1 and `GetNumAvailableQuests()`) (`number`)

**Returns:**
- `level` - Recommended character level for attempting the quest (`number`)

**See also:** Quest functions.




## GetAvailableQuestInfo

Returns the flags of an available quest during an NPC dialog

**Signature:** `isTrivial, isDaily, isRepeatable = GetAvailableQuestInfo(availableIndex)`

**Arguments:**
- `availableIndex` - Number of an available quest in the dialog frame; 1..`GetNumAvailableQuests()` (`number`)

**Returns:**
- `isTrivial` - True if the quest is trivial (gray), false otherwise. (`boolean`)
- `isDaily` - True if the quest is daily, false otherwise. (`boolean`)
- `isRepeatable` - True if the quest is repeatable, false otherwise. (`boolean`)

**See also:** Quest functions.




## GetAvailableRoles

_No snapshot available (page did not exist in archive)._




## GetAvailableTitle

Returns the name of a quest available from the current Quest NPC. Only returns valid information after a `QUEST_GREETING` event.

Note: Most quest NPCs present available quests using the `GetGossipAvailableQuests()` instead of this function.

**Signature:** `title = GetAvailableTitle(index)`

**Arguments:**
- `index` - Index of a quest available from the current Quest NPC (between 1 and `GetNumAvailableQuests()`) (`number`)

**Returns:**
- `title` - Title of the quest (`string`)

**See also:** Quest functions.



