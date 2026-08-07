# WoW API — GetP*

_38 functions_

---

## GetPackageInfo




## GetParryChance

Returns the player's parry chance

**Signature:** `chance = GetParryChance()`

**Returns:**
- `chance` - The player's percentage chance to parry melee attacks (`number`)




## GetPartyAssignment

Returns whether a party/raid member is assigned a specific group role

**Signature:** `isAssigned = GetPartyAssignment("assignment", "unit") or GetPartyAssignment("assignment", "name" [, exactMatch])`

**Arguments:**
- `assignment` - A group role assignment (`string`) 

 - `MAINASSIST` - Return whether the unit is assigned the main assist role
- `MAINTANK` - Return whether the unit is assigned the main tank role
- `unit` - A unit in the player's party or raid (`string`, unitID)
- `name` - Name of a unit in the player's party or raid (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**Returns:**
- `isAssigned` - 1 if the unit is assigned the specified role; otherwise nil (`1nil`)




## GetPartyLeaderIndex

Returns the index of the current party leader. Returns 0 if the player is the party leader or if the player is not in a party.

**Signature:** `index = GetPartyLeaderIndex()`

**Returns:**
- `index` - Numeric portion of the `party` `unitID` for the party leader (e.g. 3 = `party3`) (`number`)




## GetPartyLFGBackfillInfo

_No snapshot available (page did not exist in archive)._




## GetPartyMember

Returns whether a party member exists at a given index

**Signature:** `hasMember = GetPartyMember(index)`

**Arguments:**
- `index` - Index of a party member (between 1 and `MAX_PARTY_MEMBERS`), or the numeric portion of a `party` `unitID` (e.g. 3 = `party3`) (`number`)

**Returns:**
- `hasMember` - 1 if the given `index` corresponds to a member in the player's party; otherwise nil (`1nil`)




## GetPetActionCooldown

Returns cooldown information about a given pet action slot

**Signature:** `start, duration, enable = GetPetActionCooldown(index)`

**Arguments:**
- `index` - Index of a pet action button (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the action is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the action is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the action is ready.) (`number`)

**See also:** Pet functions, Action functions.




## GetPetActionInfo

Returns information about a pet action

**Signature:** `name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(index)`

**Arguments:**
- `index` - Index of a pet action button (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)

**Returns:**
- `name` - Localized name of the action, or a token which can be used to get the localized name of a standard action (`string`)
- `subtext` - Secondary text for the action (generally a spell rank; e.g. "Rank 8") (`string`)
- `texture` - Path to an icon texture for the action, or a token which can be used to get the texture path of a standard action (`string`)
- `isToken` - 1 if the returned `name` and `texture` are tokens for standard actions, which should be used to look up actual values (e.g. `PET_ACTION_ATTACK`, `PET_ATTACK_TEXTURE`); nil if `name` and `texture` can be displayed as-is (`1nil`)
- `isActive` - 1 if the action is currently active; otherwise nil. (Indicates which state is chosen for the follow/stay and aggressive/defensive/passive switches.) (`1nil`)
- `autoCastAllowed` - 1 if automatic casting is allowed for the action; otherwise nil (`1nil`)
- `autoCastEnabled` - 1 if automatic casting is currently turned on for the action; otherwise nil (`1nil`)




## GetPetActionSlotUsable

Returns whether a pet action can be used. Used in the default UI to show pet actions as grayed out when the pet cannot be commanded to perform them (e.g. when the player or pet is stunned).

**Signature:** `usable = GetPetActionSlotUsable(index)`

**Arguments:**
- `index` - Index of a pet action button (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)

**Returns:**
- `usable` - 1 if the pet action is currently available; otherwise nil (`1nil`)

**See also:** Pet functions, Action functions.




## GetPetActionsUsable

Returns whether the pet's actions are usable. Note: `GetPetActionSlotUsable` can return nil for individual actions even if `GetPetActionsUsable` returns 1 (though not the other way around).

**Signature:** `petActionsUsable = GetPetActionsUsable()`

**Returns:**
- `petActionsUsable` - 1 if the pet's actions are usable; otherwise nil (`1nil`)

**See also:** Pet functions, Action functions.




## GetPetExperience

Returns information about experience points for the player's pet

**Signature:** `currXP, nextXP = GetPetExperience()`

**Returns:**
- `currXP` - The pet's current amount of experience points (`number`)
- `nextXP` - Total amount of experience points required for the pet to gain a level (`number`)




## GetPetFoodTypes

Returns a list of the food types the player's pet will eat

**Signature:** `... = GetPetFoodTypes()`

**Returns:**
- `...` - A list of strings, each the localized name of a food type the pet will eat (`list`) 

 - `Bread` - Baked goods
- `Cheese` - Cheese products
- `Fish` - Raw and cooked fish
- `Fruit` - Fruits
- `Fungus` - Mushrooms, lichens, and similar
- `Meat` - Raw and cooked meat

**See also:** Pet functions.




## GetPetHappiness

_No snapshot available (page did not exist in archive)._




## GetPetIcon

Returns an icon representing the current pet. Used in the default Pet Stables and Talent UIs for hunter pets; returns nil for other pets.

**Signature:** `texture = GetPetIcon()`

**Returns:**
- `texture` - Path to an icon texture for the pet (`string`)

**See also:** Pet functions.




## GetPetitionInfo

Returns information about the currently open petition

**Signature:** `petitionType, title, bodyText, maxSignatures, originatorName, isOriginator, minSignatures = GetPetitionInfo()`

**Returns:**
- `petitionType` - Type of the petition (`string`) 

 - `arena` - An arena team charter
- `guild` - A guild charter
- `title` - Title of the petition (`string`)
- `bodyText` - Body text of the petition (`string`)
- `maxSignatures` - Maximum number of signatures allowed (`number`)
- `originatorName` - Name of the character who initially purchased the charter (`string`)
- `isOriginator` - 1 if the player is the petition's originator; otherwise nil (`1nil`)
- `minSignatures` - Minimum number of signatures required to establish the charter (`number`)




## GetPetitionItemInfo

_No snapshot available (page did not exist in archive)._




## GetPetitionNameInfo

Returns the name of a character who has signed the currently offered petition

**Signature:** `name = GetPetitionNameInfo(index)`

**Arguments:**
- `index` - Index of a signature slot on the petition (between 1 and `minSignatures`, where `minSignatures = select(7,``GetPetitionInfo()``)`) (`number`)

**Returns:**
- `name` - Name of the signatory character, or nil if the slot has not yet been signed (`string`)




## GetPetSpellBonusDamage




## GetPetTalentTree

Returns the name of the talent tree used by the player's current pet. Hunter pets use one of three different talent trees according to pet type. Returns `nil` if the player does not have a pet or the player's current pet does not use talents (i.e. warlock pets, quest pets, etc.)

**Signature:** `talent = GetPetTalentTree()`

**Returns:**
- `talent` - Localized name of the pet's talent tree (`string`)

**See also:** Pet functions, Talent functions.




## GetPetTimeRemaining

Returns the time remaining before a temporary pet is automatically dismissed. Temporary pets include priests' Shadowfriend, mages' Water Elemental, and various quest-related pets.

**Signature:** `petTimeRemaining = GetPetTimeRemaining()`

**Returns:**
- `petTimeRemaining` - Amount of time remaining until the temporary pet is automatically dismissed (in seconds), or nil if the player does not have a temporary pet (`number`)

**See also:** Pet functions.




## GetPlayerFacing

Returns the player's orientation (heading). Indicates the direction the player model is (normally) facing and in which the player will move if he begins walking forward, not the camera orientation.

**Signature:** `facing = GetPlayerFacing()`

**Returns:**
- `facing` - Direction the player is facing (in radians, 0 = north, values increasing counterclockwise) (`number`)




## GetPlayerInfoByGUID

Returns information about a player character identified by globally unique identifier. Returns `nil` if given the GUID of a non-player unit. The leading 0x may be omitted.

**Signature:** `class, classFilename, race, raceFilename, sex, name, realm = GetPlayerInfoByGUID("guid")`

**Arguments:**
- `guid` - Globally unique identifier of a player unit (`string`, guid)

**Returns:**
- `class` - Localized name of the unit's class (`string`)
- `classFilename` - Non-localized token identifying the unit's class (`string`)
- `race` - Localized name of the unit's race (`string`)
- `raceFilename` - Non-localized token identifying the unit's race (`string`)
- `sex` - Number identifying the unit's gender (`number`) 

 - `1` - Neuter / Unknown
- `2` - Male
- `3` - Female
- `name` - Unit's name (`string`)
- `realm` - Unit's realm (empty string if from the same realm) (`string`)

**See also:** Unit functions.




## GetPlayerMapPosition

Returns the position of a unit in the player's party or raid on the world map. Returns `0,0` if the unit's location is not visible on the current world map.

**Signature:** `unitX, unitY = GetPlayerMapPosition("unit")`

**Arguments:**
- `unit` - A unit in the player's party or raid (`string`, unitID)

**Returns:**
- `unitX` - Horizontal position of the unit relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `unitY` - Vertical position of the unit relative to the zone map (0 = top, 1 = bottom) (`number`)

**See also:** Map functions.




## GetPlayerTradeMoney

Returns the amount of money offered for trade by the player

**Signature:** `amount = GetPlayerTradeMoney()`

**Returns:**
- `amount` - Amount of money offered for trade by the player (in copper) (`number`)




## GetPossessInfo

Returns information about special actions available while the player possesses another unit. Used in the default UI to show additional special actions (e.g. canceling possession) while the player possesses another unit through an ability such as Eyes of the Beast or Mind Control.

Does not apply to actions (spells) belonging to the possessed unit; those are regular actions (see `GetActionInfo()`) whose `actionID`s begin at `((NUM_ACTIONBAR_PAGES - 1 +` `GetBonusBarOffset()``) * NUM_ACTIONBAR_BUTTONS + 1)`.

**Signature:** `texture, name = GetPossessInfo(index)`

**Arguments:**
- `index` - Index of a possession bar action (between 1 and `NUM_POSSESS_SLOTS`) (`number`)

**Returns:**
- `texture` - Path to an icon texture for the action (`string`)
- `name` - The name of the spell in the queried possess bar slot. (`string`)

**See also:** ActionBar functions.




## GetPowerRegen

Returns information about the player's mana/energy/etc regeneration rate. Contexts for `inactiveRegen` and `activeRegen` vary by power type. 

If the player (currently) uses mana, `activeRegen` refers to mana regeneration while casting (within five seconds of casting a spell) and `inactiveRegen` refers to mana regeneration while not casting (more than five seconds after casting a spell). For other power types, `activeRegen` refers to regeneration while in combat and `inactiveRegen` to regeneration outside of combat.

Note that values returned can be negative: e.g. for rage and runic power users, `inactiveRegen` describes the rate of power decay while not in combat.

**Signature:** `inactiveRegen, activeRegen = GetPowerRegen()`

**Returns:**
- `inactiveRegen` - Power change per second while inactive (`number`)
- `activeRegen` - Power change per second while active (`number`)

**See also:** Stat information functions.




## GetPrevCompleatedTutorial




## GetPreviewTalentPointsSpent




## GetPreviousAchievement

Returns the previous achievement for an achievement which is part of a series

**Signature:** `previousID = GetPreviousAchievement(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**Returns:**
- `previousID` - If the given achievement is part of a series and not the first in its series, the ID of the previous achievement in the series; otherwise nil (`number`)




## GetPreviousArenaSeason

Returns a number identifying the previous arena season. New arena seasons begin every few months, resetting team rankings and providing new rewards.

**Signature:** `season = GetPreviousArenaSeason()`

**Returns:**
- `season` - Number identifying the previous arena season (`number`)




## GetProgressText

Returns the quest progress text presented by a questgiver. Only valid when the questgiver UI is showing the progress stage of a quest dialog (between the `QUEST_PROGRESS` and `QUEST_FINISHED` events); otherwise may return the empty string or a value from the most recently displayed quest.

**Signature:** `text = GetProgressText()`

**Returns:**
- `text` - Progress text for the quest (`string`)

**See also:** Quest functions.




## GetPVPDesired

Returns whether the player has manually enabled PvP status. Only indicates whether the player has manually and directly enabled his PvP flag (e.g. by typing "/pvp" or using the default UI's menu when right-clicking the player portrait); returns 0 if the player only became PvP flagged by attacking an enemy player, entering an enemy zone, etc.

**Signature:** `isPVPDesired = GetPVPDesired()`

**Returns:**
- `isPVPDesired` - 1 if the PVP flag was toggled on by the player manually; otherwise 0 (`number`)

**See also:** PvP functions.




## GetPVPLifetimeStats

Returns the player's lifetime total of honorable kills and highest rank achieved. Highest rank achieved applies only to the older PvP rewards system that was abandoned with the WoW 2.0 patch, but is still accurate for players who participated in it.

**Signature:** `hk, highestRank = GetPVPLifetimeStats()`

**Returns:**
- `hk` - Number of honorable kills the player has scored (`number`)
- `highestRank` - Highest rank the player ever achieved in the pre-2.0 PvP rewards system (`number`)




## GetPVPRankInfo

Returns information about a given PvP rank index. These ranks are no longer in use, as they were part of the older PvP rewards system that was abandoned with the WoW 2.0 patch.

**Signature:** `rankName, rankNumber = GetPVPRankInfo(index [, "unit"])`

**Arguments:**
- `index` - Index of a rank (begins at 1, corresponding to a never-used "Pariah" rank; actual ranks start at 5) (`number`)
- `unit` - A unit to use as basis for the rank name (i.e. to return Horde rank names for Horde units and Alliance rank names for Alliance units); if omitted, uses the player's faction (`string`, unitID)

**Returns:**
- `rankName` - Name of the rank (`string`)
- `rankNumber` - Index of the rank relative to unranked status (positive values for ranks earned through honorable kills, negative values for the unused dishonorable ranks) (`number`)




## GetPVPRankProgress

**Signature:** `GetPVPRankProgress()`




## GetPVPSessionStats

Returns the number of kills and honor points scored by the player since logging in

**Signature:** `honorKills, honorPoints = GetPVPSessionStats()`

**Returns:**
- `honorKills` - Number of honorable kills scored (`number`)
- `honorPoints` - Amount of honor currency earned (`number`)




## GetPVPTimer

Returns the amount of time until the player's PVP flag expires. Returns 300000 or higher if the player's PvP flag is manually enabled or if the player is in a PvP or enemy zone.

**Signature:** `timer = GetPVPTimer()`

**Returns:**
- `timer` - Milliseconds remaining until the player's PvP flag expires (`number`)

**See also:** PvP functions.




## GetPVPYesterdayStats

Returns the number of kills and honor points scored by the player on the previous day

**Signature:** `honorKills, honorPoints = GetPVPYesterdayStats()`

**Returns:**
- `honorKills` - Number of honorable kills scored (`number`)
- `honorPoints` - Amount of honor currency earned (`number`)



