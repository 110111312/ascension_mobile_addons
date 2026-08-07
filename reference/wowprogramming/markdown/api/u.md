# WoW API Functions — U

_118 functions_

---

## UninviteUnit

Removes a character from the player's party or raid. Only works if the player is the party leader, raid leader, or raid assistant.

**Signature:** `UninviteUnit("name")`

**Arguments:**
- `name` - Name of a character to uninvite (`string`)


## UnitAffectingCombat

Returns whether a unit is currently in combat

**Signature:** `inCombat = UnitAffectingCombat("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `inCombat` - 1 if the unit is currently involved in combat; otherwise nil (`1nil`)

**See also:** Unit functions, Combat functions.


## UnitArmor

Returns the player's or pet's armor value

**Signature:** `base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `base` - The unit's base armor value (`number`)
- `effectiveArmor` - The unit's effective armor value (`number`)
- `armor` - The unit's current armor value (`number`)
- `posBuff` - Positive modifiers to armor value (`number`)
- `negBuff` - Negative modifiers to armor value (`number`)

**See also:** Stat information functions.


## UnitAttackBothHands

Returns information about the player's or pet's weapon skill

**Signature:** `mainHandAttackBase, mainHandAttackMod, offHandHandAttackBase, offHandAttackMod = UnitAttackBothHands("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `mainHandAttackBase` - The unit's base weapon skill for the main hand weapon (`number`)
- `mainHandAttackMod` - Temporary modifiers to main hand weapon skill (`number`)
- `offHandHandAttackBase` - The unit's base weapon skill for the off hand weapon (`number`)
- `offHandAttackMod` - Temporary modifiers to off hand weapon skill (`number`)

**See also:** Stat information functions.


## UnitAttackPower

Returns the player's or pet's melee attack power

**Signature:** `base, posBuff, negBuff = UnitAttackPower("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `base` - The unit's ase attack power (`number`)
- `posBuff` - Total effect of positive buffs to attack power (`number`)
- `negBuff` - Total effect of negative buffs to attack power (`number`)


## UnitAttackSpeed

Returns information about the unit's melee attack speed

**Signature:** `speed, offhandSpeed = UnitAttackSpeed("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `speed` - Current speed of the unit's main hand attack (number of seconds per attack) (`number`)
- `offhandSpeed` - Current speed of the unit's off hand attack (number of seconds per attack) (`number`)

**See also:** Stat information functions.


## UnitAura

Returns information about buffs/debuffs on a unit

**Signature:** `name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura("unit", index [, "filter"]) or UnitAura("unit", "name" [, "rank" [, "filter"]])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `index` - Index of an aura to query (`number`)
- `name` - Name of an aura to query (`string`)
- `rank` - Secondary text of an aura to query (often a rank; e.g. "Rank 7") (`string`)
- `filter` - A list of filters to use separated by the pipe '|' character; e.g. `"RAID|PLAYER"` will query group buffs cast by the player (`string`) 

 - `CANCELABLE` - Show auras that can be cancelled
- `HARMFUL` - Show debuffs only
- `HELPFUL` - Show buffs only
- `NOT_CANCELABLE` - Show auras that cannot be cancelled
- `PLAYER` - Show auras the player has cast
- `RAID` - When used with a HELPFUL filter it will show auras the player can cast on party/raid members (as opposed to self buffs). If used with a HARMFUL filter it will return debuffs the player can cure

**Returns:**
- `name` - Name of the aura (`string`)
- `rank` - Secondary text for the aura (often a rank; e.g. "Rank 7") (`string`)
- `icon` - Path to an icon texture for the aura (`string`)
- `count` - The number of times the aura has been applied (`number`)
- `dispelType` - Type of aura (relevant for dispelling and certain other mechanics); nil if not one of the following values: (`string`) 

 - `Curse`
- `Disease`
- `Magic`
- `Poison`
- `duration` - Total duration of the aura (in seconds) (`number`)
- `expires` - Time at which the aura will expire; can be compared to GetTime() to determine time remaining (`number`)
- `caster` - Unit which applied the aura. If the aura was applied by a unit that does not have a token but is controlled by one that does (e.g. a totem or another player's vehicle), returns the controlling unit. Returns nil if the casting unit (or its controller) has no unitID. (`string`, unitID)
- `isStealable` - 1 if the aura can be transferred to a player using the Spellsteal spell; otherwise nil (`1nil`)
- `shouldConsolidate` - 1 if the aura is eligible for the 'consolidated' aura display in the default UI. (`1nil`)
- `spellID` - spellID of the aura (`number`)


## UnitBuff

Returns information about a buff on a given unit or player. This function is an alias for `UnitAura()` with a built-in `HELPFUL` filter (which cannot be removed or negated with the `HARMFUL` filter).

**Signature:** `name, rank, icon, count, dispelType, duration, expires, caster, isStealable = UnitBuff("unit", index [, "filter"]) or UnitBuff("unit", "name" [, "rank" [, "filter"]])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `index` - Index of an aura to query (`number`)
- `name` - Name of an aura to query (`string`)
- `rank` - Secondary text of an aura to query (often a rank; e.g. "Rank 7") (`string`)
- `filter` - A list of filters to use separated by the pipe '|' character; e.g. `"RAID|PLAYER"` will query group buffs cast by the player (`string`) 

 - `CANCELABLE` - Show auras that can be cancelled
- `NOT_CANCELABLE` - Show auras that cannot be cancelled
- `PLAYER` - Show auras the player has cast
- `RAID` - Show auras the player can cast on party/raid members (as opposed to self buffs)

**Returns:**
- `name` - Name of the aura (`string`)
- `rank` - Secondary text for the aura (often a rank; e.g. "Rank 7") (`string`)
- `icon` - Path to an icon texture for the aura (`string`)
- `count` - The number of times the aura has been applied (`number`)
- `dispelType` - Type of aura (relevant for dispelling and certain other mechanics); nil if not one of the following values: (`string`) 

 - `Curse`
- `Disease`
- `Magic`
- `Poison`
- `duration` - Total duration of the aura (in seconds) (`number`)
- `expires` - Time at which the aura will expire; can be compared to `<a href='/docs/api/GetTime'>GetTime()</a>` to determine time remaining (`number`)
- `caster` - Unit which applied the aura. If the aura was applied by a unit that does not have a token but is controlled by one that does (e.g. a totem or another player's vehicle), returns the controlling unit. Returns nil if the casting unit (or its controller) has no unitID. (`string`, unitID)
- `isStealable` - 1 if the aura can be transferred to a player using the Spellsteal spell; otherwise nil (`1nil`)


## UnitCanAssist

Returns whether one unit can assist another

**Signature:** `canAssist = UnitCanAssist("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `canAssist` - 1 if the first unit can assist the second; otherwise nil (`1nil`)


## UnitCanAttack

Returns whether one unit can attack another

**Signature:** `canAttack = UnitCanAttack("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `canAttack` - 1 if the first unit can attack the second unit; otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitCanCooperate

Returns whether two units can cooperate. Two units are considered to be able to cooperate with each other if they are of the same faction and are both players.

**Signature:** `canCooperate = UnitCanCooperate("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `canCooperate` - 1 if the two units can cooperate with each other; otherwise nil (`1nil`)


## UnitCastingInfo

Returns information about the spell a unit is currently casting

**Signature:** `name, subText, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `name` - Name of the spell being cast (`string`)
- `subText` - Secondary text associated with the spell (e.g."Rank 5", "Racial", etc.) (`string`)
- `text` - Text to be displayed on a casting bar (`string`)
- `texture` - Path to an icon texture for the spell (`string`)
- `startTime` - Time at which the cast was started (in milliseconds; can be compared to `GetTime()` `* 1000`) (`number`)
- `endTime` - Time at which the cast will finish (in milliseconds; can be compared to `GetTime()` `* 1000`) (`number`)
- `isTradeSkill` - 1 if the spell being cast is a trade skill recipe; otherwise nil (`1nil`)
- `castID` - Reference number for this spell; matches the 4th argument of `UNIT_SPELLCAST_*` events for the same spellcast (`number`)
- `notInterruptible` - 1 if the spell can be interrupted; otherwise nil. See the `UNIT_SPELLCAST_NOT_INTERRUPTIBLE` and `UNIT_SPELLCAST_INTERRUPTIBLE` events for changes to this status. (`1nil`)


## UnitChannelInfo

Returns information about the spell a unit is currently channeling

**Signature:** `name, subText, text, texture, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `name` - Name of the spell being cast (`string`)
- `subText` - Secondary text associated with the spell (e.g."Rank 5", "Racial", etc.) (`string`)
- `text` - Text to be displayed on a casting bar (`string`)
- `texture` - Path to an icon texture for the spell (`string`)
- `startTime` - Time at which the cast was started (in milliseconds; can be compared to `GetTime()` `* 1000`) (`number`)
- `endTime` - Time at which the cast will finish (in milliseconds; can be compared to `GetTime()` `* 1000`) (`number`)
- `isTradeSkill` - 1 if the spell being cast is a trade skill recipe; otherwise nil (`1nil`)
- `notInterruptible` - Indicates that the spell cannot be interrupted, `UNIT_SPELLCAST_NOT_INTERRUPTIBLE` and `UNIT_SPELLCAST_INTERRUPTIBLE` are fired to indicate changes in the interruptible status. (`boolean`)

**See also:** Unit functions, Spell functions.


## UnitCharacterPoints

_No snapshot available (page did not exist in archive)._


## UnitClass

Returns a unit's class. The second return (`classFileName`) can be used for locale-independent verification of a unit's class, or to look up class-related data in various global tables:

 
 - `RAID_CLASS_COLORS` provides a standard color for each class (as seen in the default who, guild, calendar, and raid UIs)
 
 - `CLASS_ICON_TCOORDS` provides coordinates to locate each class' icon within the "Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes" texture

For non-player units, the first return (`class`) will be the unit's name; to always get a localized class name regardless of unit type, use `UnitClassBase` instead.

**Signature:** `class, classFileName = UnitClass("unit") or UnitClass("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - Name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `class` - The localized name of the unit's class, or the unit's name if the unit is an NPC (`string`)
- `classFileName` - A non-localized token representing the class (`string`)


## UnitClassBase

Returns a unit's class. The second return (`classFileName`) can be used for locale-independent verification of a unit's class, or to look up class-related data in various global tables:

 
 - `RAID_CLASS_COLORS` provides a standard color for each class (as seen in the default who, guild, calendar, and raid UIs)
 
 - `CLASS_ICON_TCOORDS` provides coordinates to locate each class' icon within the "Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes" texture

Unlike `UnitClass`, this function returns the same values for NPCs as for players.

**Signature:** `class, classFileName = UnitClassBase("unit") or UnitClassBase("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - Name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `class` - The localized name of the unit's class, or the unit's name if the unit is an NPC (`string`)
- `classFileName` - A non-localized token representing the class (`string`)


## UnitClassification

Returns a unit's classification

**Signature:** `classification = UnitClassification("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `classification` - Classification of the unit (`string`) 

 - `elite` - Elite
- `normal` - Normal
- `rare` - Rare
- `rareelite` - Rare-Elite
- `worldboss` - World Boss


## UnitControllingVehicle

Returns whether a unit is controlling a vehicle

**Signature:** `isControlling = UnitControllingVehicle("unit") or UnitControllingVehicle("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `isControlling` - True if the unit is controlling a vehicle; otherwise false (`boolean`)

**See also:** Vehicle functions.


## UnitCreatureFamily

Returns the creature family of the unit. Applies only to beasts of the kinds that can be taken as Hunter pets (e.g. cats, worms, and ravagers but not zhevras, talbuks and pterrordax), demons of the types that can be summoned by Warlocks (e.g. imps and felguards, but not demons that require enslaving such as infernals and doomguards or world demons such as pit lords and armored voidwalkers) and Death Knight's pets (ghouls).

**Signature:** `family = UnitCreatureFamily("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `family` - Localized name of the subtype of creature (e.g. Bear, Devilsaur, Voidwalker, Succubus), or nil if not applicable (`string`)


## UnitCreatureType

Returns the creature type of a unit. Note that some creatures have no type (e.g. slimes).

**Signature:** `type = UnitCreatureType("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `type` - Localized name of the type of creature (e.g. Beast, Humanoid, Undead), or nil if not applicable (`string`)


## UnitDamage

Returns information about the player's or pet's melee attack damage

**Signature:** `minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `minDamage` - The unit's minimum melee damage (`number`)
- `maxDamage` - The unit's maximum melee damage (`number`)
- `minOffHandDamage` - The unit's minimum offhand melee damage (`number`)
- `maxOffHandDamage` - The unit's maximum offhand melee damage (`number`)
- `physicalBonusPos` - Positive physical bonus (should be >= 0) (`number`)
- `physicalBonusNeg` - Negative physical bonus (should be <= 0) (`number`)
- `percent` - Factor by which damage output is multiplied due to buffs/debuffs (`number`)

**See also:** Stat information functions.


## UnitDebuff

Returns information about a debuff on a unit. This function is an alias for `UnitAura()` with a built-in `HARMFUL` filter (which cannot be removed or negated with the `HELPFUL` filter).

**Signature:** `name, rank, icon, count, dispelType, duration, expires, caster, isStealable = UnitDebuff("unit", index [, "filter"]) or UnitDebuff("unit", "name" [, "rank" [, "filter"]])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `index` - Index of an aura to query (`number`)
- `name` - Name of an aura to query (`string`)
- `rank` - Secondary text of an aura to query (often a rank; e.g. "Rank 7") (`string`)
- `filter` - A list of filters to use separated by the pipe '|' character; e.g. `"CANCELABLE|PLAYER"` will query cancelable debuffs cast by the player (`string`) 

 - `CANCELABLE` - Show auras that can be cancelled
- `NOT_CANCELABLE` - Show auras that cannot be cancelled
- `PLAYER` - Show auras the player has cast
- `RAID` - Show auras the player can cast on party/raid members (as opposed to self buffs)

**Returns:**
- `name` - Name of the aura (`string`)
- `rank` - Secondary text for the aura (often a rank; e.g. "Rank 7") (`string`)
- `icon` - Path to an icon texture for the aura (`string`)
- `count` - The number of times the aura has been applied (`number`)
- `dispelType` - Type of aura (relevant for dispelling and certain other mechanics); nil if not one of the following values: (`string`) 

 - `Curse`
- `Disease`
- `Magic`
- `Poison`
- `duration` - Total duration of the aura (in seconds) (`number`)
- `expires` - Time at which the aura will expire; can be compared to `GetTime()` to determine time remaining (`number`)
- `caster` - Unit which applied the aura. If the aura was applied by a unit that does not have a token but is controlled by one that does (e.g. a totem or another player's vehicle), returns the controlling unit. Returns nil if the casting unit (or its controller) has no unitID. (`string`, unitID)
- `isStealable` - 1 if the aura can be transferred to a player using the Spellsteal spell; otherwise nil (`1nil`)


## UnitDefense

Returns the player's or pet's Defense skill

**Signature:** `base, modifier = UnitDefense("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `base` - The unit's base defense skill (`number`)
- `modifier` - Temporary modifiers to defense skill (`number`)

**See also:** Stat information functions.


## UnitDetailedThreatSituation

Returns detailed information about the threat status of one unit against another. 
The different values returned by this function reflect the complexity of NPC threat management:

Raw threat roughly equates to the amount of damage a unit has caused to the NPC plus the amount of healing the unit has performed in the NPC's presence. (Each quantity that goes into this sum may be modified, however; such as by a paladin's Righteous Fury self-buff, a priest's Silent Resolve talent, or a player whose cloak is enchanted with Subtlety.)

Generally, whichever unit has the highest raw threat against an NPC becomes its primary target, and raw threat percentage simplifies this comparison.

However, most NPCs are designed to maintain some degree of target focus -- so that they don't rapidly switch targets if, for example, a unit other than the primary target suddenly reaches 101% raw threat. The amount by which a unit must surpass the primary target's threat to become the new primary target varies by distance from the NPC. 

Thus, a scaled percentage value is given to provide clarity. The `rawPercent` value returned from this function can be greater than 100 (indicating that `unit` has greater threat against `mobUnit` than `mobUnit`'s primary target, and is thus in danger of becoming the primary target), but the `scaledPercent` value will always be 100 or lower.

Threat information for a pair of units is only returned if the player has threat against the NPC unit in question. (For example, no threat data is provided if the player's pet is attacking an NPC but the player himself has taken no action, even though the pet has threat against the NPC.)

**Signature:** `isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, mobUnit) or UnitDetailedThreatSituation("name", mobUnit)`

**Arguments:**
- `unit` - The unit whose threat situation is being requested (`unitid`)
- `name` - The name of a unit to query. Only valid for the player, pet, and party/raid members. (`string`)
- `mobUnit` - An NPC unit the first unit may have threat against (`unitid`)

**Returns:**
- `isTanking` - 1 if unit is mobUnit's primary target, nil otherwise (`1nil`)
- `status` - A threat status category (`number`) 

 - `0` - Unit has less than 100% raw threat (default UI shows no indicator)
- `1` - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
- `2` - Unit is `mobUnit`'s primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
- `3` - Unit is `mobUnit`'s primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
- `scaledPercent` - A percentage value representing unit's threat against `mobUnit`, scaled such that a value of 100% represents unit becoming `mobUnit`'s primary target (`number`)
- `rawPercent` - A percentage value representing unit's threat against `mobUnit` relative to the the threat of mobUnit's primary target (`number`)
- `threatValue` - The raw value of unit's threat against mobUnit (`number`)

**See also:** Threat functions.


## UnitExists

Returns whether a unit exists. A unit "exists" if it can be referenced by the player; e.g. `party1` exists if the player is in a party with at least one other member (regardless of whether that member is nearby), `target` exists if the player has a target, `npc` exists if the player is currently interacting with an NPC, etc.

**Signature:** `exists = UnitExists("unit") or UnitExists("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, `npc`, and party/raid members (`string`)

**Returns:**
- `exists` - 1 if the unit exists, otherwise nil (`1nil`)


## UnitFactionGroup

Returns a unit's primary faction allegiance

**Signature:** `factionGroup, factionName = UnitFactionGroup("unit") or UnitFactionGroup("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `factionGroup` - Non-localized (English) faction name of the faction ("Horde" or "Alliance") (`string`)
- `factionName` - Localized name of the faction (`string`)


## UnitGroupRolesAssigned


## UnitGUID

Returns a unit's globally unique identifier

**Signature:** `guid = UnitGUID("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `guid` - The unit's GUID (`string`, guid)


## UnitHasLFGDeserter


## UnitHasLFGRandomCooldown


## UnitHasRelicSlot

Returns whether a unit has a relic slot instead of a ranged weapon slot

**Signature:** `hasRelic = UnitHasRelicSlot("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `hasRelic` - 1 if the unit has a relic slot; otherwise nil (`1nil`)


## UnitHasVehicleUI

Returns whether a unit is controlling a vehicle or vehicle weapon. Used in the default UI to show the vehicle's health and power status bars in place of the controlling unit's. Returns false for passengers riding in but not controlling part of a vehicle; to find out whether a unit is riding in a vehicle, use `UnitInVehicle`. Also note that in some vehicles the player can command a vehicle weapon (e.g. gun turret) without controlling the vehicle itself; to find out whether a unit is controlling a vehicle, use `UnitControllingVehicle`.

**Signature:** `hasVehicle = UnitHasVehicleUI("unit") or UnitHasVehicleUI("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `hasVehicle` - True if the unit is controlling a vehicle or vehicle weapon; otherwise false (`boolean`)

**See also:** Vehicle functions.


## UnitHealth

Returns a unit's current amount of health

**Signature:** `health = UnitHealth("unit") or UnitHealth("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `health` - The unit's current amount of health (hit points) (`number`)


## UnitHealthMax

Returns a unit's maximum health value

**Signature:** `maxValue = UnitHealthMax("unit") or UnitHealthMax("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `maxValue` - The unit's maximum health (hit points) (`number`)


## UnitInBattleground

Returns whether a unit is in same battleground instance as the player

**Signature:** `raidNum = UnitInBattleground("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `raidNum` - Numeric portion of the unit's `raid` `unitID` (e.g. 13 for `raid13`) (`number`)


## UnitInParty

Returns whether or not a given unit is in the player's party.. This function always returns 1 for the "player" unit. If the player has a pet, it is not considered part of the party.

**Signature:** `inParty = UnitInParty(unit)`

**Arguments:**
- `unit` - The unit to query for party membership (`unitId`)

**Returns:**
- `inParty` - 1 if the unit is in the player's party, otherwise nil. (`1nil`)


## UnitInRaid

Returns whether a unit is in the player's raid

**Signature:** `inRaid = UnitInRaid("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `inRaid` - Index of the unit in the raid (matches the numeric part of the unit's `raid` `unitID` minus 1; e.g. returns 0 for `raid1`, 12 for `raid13`, etc) (`number`)


## UnitInRange

Returns whether a party/raid member is nearby. The range check used by this function isn't directly based on the player's abilities (which may have varying ranges); it's fixed by Blizzard at a distance of around 40 yards (which encompasses many common healing spells and other abilities often used on raid members).

Also returns nil for units outside the player's area of view.

**Signature:** `inRange = UnitInRange("unit") or UnitInRange("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for party/raid members and their pets (`string`)

**Returns:**
- `inRange` - 1 if the unit is close enough to the player to (likely) be in range for helpful spells; otherwise nil (`1nil`)


## UnitInVehicle

Returns whether a unit is in a vehicle. A unit can be riding in a vehicle without controlling it: to test whether a unit is controlling a vehicle, use `UnitControllingVehicle` or `UnitHasVehicleUI`.

Note: multi-passenger mounts appear as vehicles for passengers but not for the owner.

**Signature:** `inVehicle = UnitInVehicle("unit") or UnitInVehicle("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `inVehicle` - 1 if the unit is in a vehicle; otherwise nil (`1nil`)

**See also:** Vehicle functions.


## UnitInVehicleControlSeat

Returns whether a unit controls a vehicle

**Signature:** `isInControl = UnitInVehicleControlSeat()`

**Returns:**
- `isInControl` - True if the unit controls a vehicle (`boolean`)

**See also:** Vehicle functions.


## UnitIsAFK

Returns whether a unit is marked AFK (Away From Keyboard)

**Signature:** `isAFK = UnitIsAFK("unit") or UnitIsAFK("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `isAFK` - 1 if the unit is AFK; otherwise nil (`1nil`)


## UnitIsCharmed

Returns whether a unit is currently charmed. A charmed unit is affected by Mind Control (or a similar effect) and thus hostile to units which are normally his or her allies.

**Signature:** `isCharmed = UnitIsCharmed("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isCharmed` - 1 if the unit is charmed; otherwise nil (`1nil`)


## UnitIsConnected

Returns whether a unit is connected (i.e. not Offline)

**Signature:** `isConnected = UnitIsConnected("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isConnected` - 1 if the player is connected; otherwise nil (`1nil`)


## UnitIsControlling

Returns whether a unit is controlling another unit. Applies to Mind Control and similar cases as well as to players piloting vehicles.

**Signature:** `isControlling = UnitIsControlling("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isControlling` - 1 if the unit is controlling another unit; otherwise nil (`1nil`)


## UnitIsCorpse

Returns whether a unit is a corpse

**Signature:** `isCorpse = UnitIsCorpse("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isCorpse` - 1 if the unit is a corpse; otherwise nil (`1nil`)


## UnitIsDead

Returns whether a unit is dead. Only returns 1 while the unit is dead and has not yet released his or her spirit. See `UnitIsGhost()` for after the unit has released.

**Signature:** `isDead = UnitIsDead("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isDead` - 1 if the unit is dead; otherwise nil (`1nil`)


## UnitIsDeadOrGhost

Returns whether a unit is either dead or a ghost

**Signature:** `isDeadOrGhost = UnitIsDeadOrGhost("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isDeadOrGhost` - 1 if the unit is dead or a ghost, otherwise nil (`1nil`)


## UnitIsDND

Returns whether a unit is marked DND (Do Not Disturb)

**Signature:** `isDND = UnitIsDND("unit") or UnitIsDND("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `isDND` - 1 if the unit is marked Do Not Disturb, otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitIsEnemy

Returns whether two units are enemies

**Signature:** `isEnemy = UnitIsEnemy("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `isEnemy` - 1 if the units are enemies; otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitIsFeignDeath

Returns whether or not a given unit is feigning death. This function only works for friendly units.

**Signature:** `isFeign = UnitIsFeignDeath(unit)`

**Arguments:**
- `unit` - The unit to query (`unitid`)

**Returns:**
- `isFeign` - 1 if the unit is feigning death, otherwise nil (`1nil`)


## UnitIsFriend

Returns whether two units are friendly

**Signature:** `isFriends = UnitIsFriend("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `isFriends` - 1 if the two units are friendly; otherwise nil (`1nil`)


## UnitIsGhost

Returns whether a unit is currently a ghost

**Signature:** `isGhost = UnitIsGhost("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isGhost` - 1 if the unit is a ghost; otherwise nil (`1nil`)


## UnitIsInMyGuild

Returns whether or not a given unit or player is in the player's guild

**Signature:** `inGuild = UnitIsInMyGuild(unit) or UnitIsInMyGuild("name")`

**Arguments:**
- `unit` - The unitId to query (`unitId`)
- `name` - The name of the player to query (`string`)

**Returns:**
- `inGuild` - 1 if the unit is in the player's guild, otherwise nil (`1nil`)


## UnitIsPartyLeader

Returns whether a unit is the leader of the player's party

**Signature:** `leader = UnitIsPartyLeader("unit") or UnitIsPartyLeader("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query (`string`)

**Returns:**
- `leader` - 1 if the unit is the party leader; otherwise nil (`1nil`)

**See also:** Unit functions, Party functions, Raid functions.


## UnitIsPlayer

Returns whether a unit is a player unit (not an NPC)

**Signature:** `isPlayer = UnitIsPlayer("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isPlayer` - 1 if the unit is a player unit; otherwise nil (`1nil`)


## UnitIsPossessed

Returns whether a unit is possessed by another

**Signature:** `isPossessed = UnitIsPossessed("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isPossessed` - 1 if the given unit is possessed; otherwise nil (`1nil`)


## UnitIsPVP

Returns whether a unit is flagged for PvP activity

**Signature:** `isPVP = UnitIsPVP("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isPVP` - 1 if the unit is flagged for PVP activity; otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitIsPVPFreeForAll

Returns whether a unit is flagged for free-for-all PvP. Free-for-all PvP allows all players to attack each other regardless of faction; used in certain outdoor areas (such as Gurubashi Arena and "The Maul" outside Dire Maul).

**Signature:** `isFreeForAll = UnitIsPVPFreeForAll("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isFreeForAll` - 1 if the unit is enabled for free-for-all PvP; otherwise nil (`1nil`)


## UnitIsPVPSanctuary

Returns whether a unit is in a Sanctuary area preventing PvP activity

**Signature:** `state = UnitIsPVPSanctuary("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `state` - 1 if the unit is in a PVP Sanctuary; otherwise nil (`1nil`)


## UnitIsRaidOfficer

Returns whether a unit is a raid assistant in the player's raid

**Signature:** `leader = UnitIsRaidOfficer("unit") or UnitIsRaidOfficer("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query (`string`)

**Returns:**
- `leader` - 1 if the unit is a raid assistant; otherwise nil (`1nil`)


## UnitIsSameServer

Returns whether two units are from the same server. Only meaningful in cross-realm battlegrounds.

**Signature:** `isSame = UnitIsSameServer("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `isSame` - 1 if the two units are from the same server; otherwise nil. (`1nil`)


## UnitIsSilenced

Returns whether a character is silenced on a voice channel

**Signature:** `silenced = UnitIsSilenced("name", "channel")`

**Arguments:**
- `name` - Name of a character (`string`)
- `channel` - Name of a chat channel (`string`)

**Returns:**
- `silenced` - 1 if the unit is silenced on the given channel; otherwise nil (`1nil`)


## UnitIsTalking

Returns whether a unit is currently speaking in voice chat. Despite the "unit" name, this function only accepts player names, not `unitID`s.

**Signature:** `state = UnitIsTalking("unit")`

**Arguments:**
- `unit` - Name of a character in the player's current voice channel (`string`)

**Returns:**
- `state` - 1 if the unit is currently speaking in voice chat; otherwise nil (`1nil`)


## UnitIsTapped

Returns whether a unit is tapped. Normally, rewards for killing a unit are available only to the character or group who first damaged the unit; once a character has thus established his claim on the unit, it is considered "tapped".

**Signature:** `UnitIsTapped(unit)`

**Arguments:**
- `unit` - The unitid to query (`unitId`)


## UnitIsTappedByAllThreatList

Returns whether a unit allows all players on its threat list to receive kill credit. Used to override the normal "tapping" behavior for certain mobs -- if this function returns 1, the player does not have to be the first to attack the mob (or in the same party/raid as the first player to attack) in order to receive quest or achievement credit for killing it.

In the default UI, this function can prevent the graying of a unit's name background in the TargetFrame and FocusFrame even if the unit is otherwise tapped, indicating that kill credit is still available if the player attacks.

**Signature:** `allTapped = UnitIsTappedByAllThreatList("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `allTapped` - 1 if the unit allows all players on its threat list to receive kill credit; otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitIsTappedByPlayer

Returns whether a unit is tapped by the player or the player's group. Normally, rewards for killing a unit are available only to the character or group who first damaged the unit; once a character has thus established his claim on the unit, it is considered "tapped".

**Signature:** `isTapped = UnitIsTappedByPlayer("unit")`

**Arguments:**
- `unit` - The unit to be queried (`string`)

**Returns:**
- `isTapped` - 1 if the unit is tapped by the player; otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitIsTrivial

Returns whether a unit is trivial at the player's level. Killing trivial units (whose level is colored gray in the default UI) does not reward honor or experience.

**Signature:** `isTrivial = UnitIsTrivial("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isTrivial` - 1 if the unit is trivial at the player's level; otherwise nil (`1nil`)


## UnitIsUnit

Returns whether two unit references are to the same unit. Useful for determining whether a composite `unitID` (such as `raid19target`) also refers to a basic `unitID`; see example.

**Signature:** `isSame = UnitIsUnit("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `isSame` - Returns 1 if the two references are to the same unit; otherwise nil (`1nil`)


## UnitIsVisible

Returns whether a unit is in the player's area of interest

**Signature:** `isVisible = UnitIsVisible("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isVisible` - 1 if the unit is is in the player's area of interest; otherwise nil (`1nil`)

**See also:** Unit functions.


## UnitLevel

Returns a unit's level. Returns -1 for boss units and hostile units whose level is ten levels or more above the player's.

**Signature:** `level = UnitLevel("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `level` - The unit's level (`number`)


## UnitMana

. Replaced by `UnitPower()`.

**Signature:** `mana = UnitMana(unit) or UnitMana("name")`

**Arguments:**
- `unit` - The unit to query (`unitid`)
- `name` - The name of a unit to query. Only valid for the player, pet, and party/raid members. (`string`)

**Returns:**
- `mana` - The unit's current level of mana, rage, energy, runic power, or other power type (`unitId`)


## UnitManaMax

. Replaced by `UnitPowerMax()`.

**Signature:** `maxValue = UnitManaMax(unit) or UnitManaMax("name")`

**Arguments:**
- `unit` - The unit to query (`unitid`)
- `name` - The name of a unit to query. Only valid for the player, pet, and party/raid members. (`string`)

**Returns:**
- `maxValue` - The maximum amount of mana, rage, energy, or other power the unit can have. (`number`)


## UnitName

Returns the name of a unit

**Signature:** `name, realm = UnitName("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `name` - Name of the unit (`string`)
- `realm` - Name of the unit's home realm if the unit is not from the player's realm; otherwise nil (`string`)


## UnitOnTaxi

Returns whether a unit is currently riding a flight path (taxi). Valid for any unit in the player's area of interest, but generally useful only for `player` -- taxi flights move quickly, so a taxi-riding unit visible to the player will not remain visible for very long.

**Signature:** `onTaxi = UnitOnTaxi("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `onTaxi` - 1 if the unit is on a taxi; otherwise nil (`1nil`)

**See also:** Unit functions, Taxi/Flight functions.


## UnitPlayerControlled

Returns whether a unit is controlled by a player

**Signature:** `isPlayer = UnitPlayerControlled("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isPlayer` - 1 if the unit is controlled by a player; otherwise nil (`1nil`)


## UnitPlayerOrPetInParty

Returns whether a unit is in the player's party or belongs to a party member. Returns nil for the player and the player's pet.

**Signature:** `inParty = UnitPlayerOrPetInParty("unit") or UnitPlayerOrPetInParty("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query (`string`)

**Returns:**
- `inParty` - 1 if the unit is in the player's party or is a pet belonging to a party member; otherwise nil (`1nil`)


## UnitPlayerOrPetInRaid

Returns whether a unit is in the player's raid or belongs to a raid member

**Signature:** `inParty = UnitPlayerOrPetInRaid("unit") or UnitPlayerOrPetInRaid("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query (`string`)

**Returns:**
- `inParty` - 1 if the unit is in the player's raid or is a pet belonging to a raid member; otherwise nil (`1nil`)


## UnitPower

Returns a unit's current level of mana, rage, energy or other power type. Returns zero for non-existent units.

**Signature:** `power = UnitPower("unitID" [, "powerType"])`

**Arguments:**
- `unitID` - A unit to query (`string`, unitID)
- `powerType` - A specific power type to query (`string`, powerType)

**Returns:**
- `power` - The unit's current level of mana, rage, energy, runic power, or other power type (`unitID`)


## UnitPowerMax

_No content available._


## UnitPowerType

Returns the power type (energy, mana, rage) of the given unit. Does not return color values for common power types (mana, rage, energy, focus, and runic power); the canonical colors for these can be found in the `PowerBarColor` table. Color values may be included for special power types such as those used by vehicles.

**Signature:** `powerType, powerToken, altR, altG, altB = UnitPowerType("unit") or UnitPowerType("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `powerType` - A number identifying the power type (`number`) 

 - `0` - Mana
- `1` - Rage
- `2` - Focus
- `3` - Energy
- `6` - Runic Power
- `powerToken` - The name of a global variable containing the localized name of the power type (`string`)
- `altR` - Red component of the color used for displaying this power type (`number`)
- `altG` - Green component of the color used for displaying this power type (`number`)
- `altB` - Blue component of the color used for displaying this power type (`number`)


## UnitPVPName

Returns the name of a unit including the unit's current title. Titles are no longer specific to PvP; this function returns a unit's name with whichever title he or she is currently displaying (e.g. "Gladiator Spin", "Keydar Jenkins", "Ownsusohard, Champion of the Frozen Wastes", etc).

**Signature:** `name = UnitPVPName("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `name` - Name of the unit including the unit's current title (`string`)

**See also:** PvP functions, Unit functions.


## UnitPVPRank

Returns a unit's PVP rank as a number. Returns 0 for all units; was only applicable in the older PvP rewards system that was abandoned with the WoW 2.0 patch.

**Signature:** `rank = UnitPVPRank("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `rank` - The numeric PvP rank of the unit, or 0 if the unit has no PvP rank (`number`)

**See also:** Unit functions, PvP functions.


## UnitRace

Returns the name of a unit's race

**Signature:** `race, fileName = UnitRace("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `race` - Localized name of the unit's race (`string`)
- `fileName` - A non-localized token representing the unit's race (`string`)


## UnitRangedAttack

Returns information about the player's or pet's ranged weapon skill

**Signature:** `rangedAttackBase, rangedAttackMod = UnitRangedAttack("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `rangedAttackBase` - The unit's base ranged weapon skill (`number`)
- `rangedAttackMod` - Temporary modifiers to ranged weapon skill (`number`)

**See also:** Stat information functions.


## UnitRangedAttackPower

Returns the player's or pet's ranged attack power

**Signature:** `base, posBuff, negBuff = UnitRangedAttackPower("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `base` - Base ranged attack power (`number`)
- `posBuff` - Positive buffs to ranged attack power (`number`)
- `negBuff` - Negative buffs to ranged attack power (`number`)


## UnitRangedDamage

Returns information about the player's or pet's ranged attack damage and speed

**Signature:** `rangedAttackSpeed, minDamage, maxDamage, physicalBonusPos, physicalBonusNeg, percent = UnitRangedDamage("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `rangedAttackSpeed` - Current speed of the unit's ranged attack (attacks per second), or 0 if no ranged weapon is equipped (`number`)
- `minDamage` - The minimum base damage per attack (`number`)
- `maxDamage` - The maximum base damage per attack (`number`)
- `physicalBonusPos` - Positive modifiers to ranged weapon damage (`number`)
- `physicalBonusNeg` - Negative modifiers to ranged weapon damage (`number`)
- `percent` - Factor by which damage output is multiplied due to buffs/debuffs (`number`)

**See also:** Stat information functions.


## UnitReaction

Returns the reaction of one unit with regards to another as a number. The returned value often (but not always) matches the unit's level of reputation with the second unit's faction, and can be used with the `UnitReactionColor` global table to return the color used to display a unit's reaction in the default UI.

**Signature:** `reaction = UnitReaction("unit", "unit")`

**Arguments:**
- `unit` - A unit (`string`, unitID)
- `unit` - Another unit (`string`, unitID)

**Returns:**
- `reaction` - Reaction of the first unit towards the second unit (`number`) 

 - `1` - Hated
- `2` - Hostile
- `3` - Unfriendly
- `4` - Neutral
- `5` - Friendly
- `6` - Honored
- `7` - Revered
- `8` - Exalted


## UnitResistance

Returns information about the player's or pet's magic resistance

**Signature:** `base, resistance, positive, negative = UnitResistance("unit", resistanceIndex)`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)
- `resistanceIndex` - Index of a magic resistance type (`number`) 

 - `1` - Fire
- `2` - Nature
- `3` - Frost
- `4` - Shadow
- `5` - Arcane

**Returns:**
- `base` - Base resistance value (generally 0) (`number`)
- `resistance` - Current resistance value (including modifiers (`number`)
- `positive` - Positive resistance modifiers (`number`)
- `negative` - Negative resistance modifiers (`number`)

**See also:** Stat information functions.


## UnitSelectionColor

Returns a color indicating hostility and related status of a unit. This color is used in various places in the default UI, such as the background behind a unit's name in the target and focus frames. For NPCs, the color reflects hostility and reputation, ranging from red (hostile) to orange or yellow (unfriendly or neutral) to green (friendly). When the unit is a player, a blue color is used unless the player is active for PvP, in which case the color may be red (he can attack you and you can attack him), yellow (you can attack him but he can't attack you) or green (ally). Color component values are floating point numbers between 0 and 1.

**Signature:** `red, green, blue, alpha = UnitSelectionColor("unit") or UnitSelectionColor("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `red` - The red component of the color. (`number`)
- `green` - The green component of the color. (`number`)
- `blue` - The blue component of the color. (`number`)
- `alpha` - The alpha (opacity) component of the color. (`number`)

**See also:** Unit functions.


## UnitSex

Returns the gender of the given unit or player

**Signature:** `gender = UnitSex("unit") or UnitSex("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `gender` - The unit's gender (`number`) 

 - `1` - Neuter / Unknown
- `2` - Male
- `3` - Female


## UnitStat

Returns information about a basic character statistic for the player or pet

**Signature:** `stat, effectiveStat, posBuff, negBuff = UnitStat("unit", statIndex)`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)
- `statIndex` - Index of a basic statistic (`number`) 

 - `1` - Strength
- `2` - Agility
- `3` - Stamina
- `4` - Intellect
- `5` - Spirit

**Returns:**
- `stat` - Current value of the statistic (`number`)
- `effectiveStat` - Effective value of the statistic (`number`)
- `posBuff` - Positive modifiers to the statistic (`number`)
- `negBuff` - Negative modifiers to the statistic (`number`)

**See also:** Stat information functions.


## UnitSwitchToVehicleSeat

Moves the player to another seat within his current vehicle

**Signature:** `UnitSwitchToVehicleSeat("unit", seat)`

**Arguments:**
- `unit` - Unit to move (only valid for `player`) (`string`, unitID)
- `seat` - Index of a seat to switch to (`number`)


## UnitTargetsVehicleInRaidUI

Returns whether attempts to target a unit should target its vehicle. The unit can still be targeted: this flag is used to provide a convenience in the default UI for certain cases (such as the Malygos encounter) such that clicking a unit in the raid UI targets its vehicle (e.g. so players can use their drakes to heal other players' drakes).

**Signature:** `targetVehicle = UnitTargetsVehicleInRaidUI("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `targetVehicle` - True if clicking the unit's raid UI representation should target the unit's vehicle instead of the unit itself; otherwise false (`boolean`)

**See also:** Vehicle functions, Raid functions.


## UnitThreatSituation

Returns the general threat status of a unit. See `UnitDetailedThreatSituation` for details about threat values.

Threat information for a pair of units is only returned if the player has threat against the NPC unit in question. (For example, no threat data is provided if the player's pet is attacking an NPC but the player himself has taken no action, even though the pet has threat against the NPC.)

**Signature:** `status = UnitThreatSituation(unit [, mobUnit]) or UnitThreatSituation("name" [, mobUnit])`

**Arguments:**
- `unit` - The unit whose threat situation is being requested (`unitid`)
- `name` - The name of a unit to query. Only valid for the player, pet, and party/raid members. (`string`)
- `mobUnit` - An NPC unit the first unit may have threat against; if nil, returned values reflect whichever NPC unit the first unit has the highest threat against. (`unitid`)

**Returns:**
- `status` - A threat status category (`number`) 

 - `0` - Unit has less than 100% raw threat (default UI shows no indicator)
- `1` - Unit has 100% or higher raw threat but isn't `mobUnit`'s primary target (default UI shows yellow indicator)
- `2` - Unit is `mobUnit`'s primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
- `3` - Unit is `mobUnit`'s primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)

**See also:** Threat functions.


## UnitUsingVehicle

Returns whether a unit is using a vehicle. Unlike similar functions, `UnitUsingVehicle()` also returns `true` while the unit is transitioning between seats in a vehicle.

**Signature:** `usingVehicle = UnitUsingVehicle("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `usingVehicle` - `1` if the unit is using a vehicle; otherwise `nil` (`1nil`)

**See also:** Unit functions, Vehicle functions.


## UnitVehicleSeatCount

Returns the number of seats in a unit's vehicle. Note: returns 0 for multi-passenger mounts even thought multiple seats are available.

**Signature:** `numSeats = UnitVehicleSeatCount("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `numSeats` - Number of seats in the unit's vehicle (`number`)

**See also:** Vehicle functions.


## UnitVehicleSeatInfo

Returns information about seats in a vehicle. Note: multi-passenger mounts appear as vehicles for passengers but not for the owner; seat information applies only to the passenger seats.

**Signature:** `controlType, occupantName, occupantRealm, canEject, canSwitchSeats = UnitVehicleSeatInfo("unit", seat)`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `seat` - Index of a seat in the unit's vehicle (`number`)

**Returns:**
- `controlType` - Type of control for the seat (`string`) 

 - `Child` - Unit in this seat controls part of the vehicle but not its movement (e.g. a gun turret)
- `None` - Unit in this seat has no control over the vehicle
- `Root` - Unit in this seat controls the movement of the vehicle
- `occupantName` - Name of the unit in the seat, or nil if the seat is empty (`string`)
- `occupantRealm` - Home realm of the unit in the seat; nil if the seat is empty or its occupant is from the same realm as the player (`string`)
- `canEject` - True if the vehicle's driver can eject the occupant of the seat (`boolean`)
- `canSwitchSeats` - True if the player can switch to this seat. (`boolean`)

**See also:** Vehicle functions.


## UnitVehicleSkin

Returns the style of vehicle UI to display for a unit

**Signature:** `skin = UnitVehicleSkin("unit") or UnitVehicleSkin("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - Name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `skin` - Token identifying the style of vehicle UI to display for the unit (`string`) 

 - `Mechanical` - Used for mechanical vehicles
- `Natural` - Used for creature mounts


## UnitXP

Returns the player's current amount of experience points

**Signature:** `currXP = UnitXP("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` (`string`, unitID)

**Returns:**
- `currXP` - Current amount of experience points (`number`)

**See also:** Player information functions, Experience (XP) functions.


## UnitXPMax

Return the total amount of experience points required for the player to gain a level

**Signature:** `playerMaxXP = UnitXPMax("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` (`string`, unitID)

**Returns:**
- `playerMaxXP` - Total amount of experience points required for the player to gain a level (`number`)

**See also:** Player information functions, Experience (XP) functions.


## unpack

Returns the list of elements in a table. Equivalent to 

` return t[i], t[i+1], ... t[j]
`

for an arbitrary number of elements.

**Signature:** `... = unpack(t [, i [, j]])`

**Arguments:**
- `t` - A table (`table`)
- `i` - A numeric index to the table; defaults to 1 if omitted (`number`)
- `j` - A numeric index to the table; defaults to `#t` if omitted (`number`)

**Returns:**
- `...` - The list of values in the table between indices `i` and `j` (`list`)

**See also:** Lua library functions.


## UnSilenceMember


## UnstablePet

_No snapshot available (page did not exist in archive)._


## UpdateAddOnCPUUsage

Updates addon CPU profiling information. Only has effect if the `scriptProfile` CVar is set to 1. See `GetAddOnCPUUsage()` for the updated data.

**Signature:** `UpdateAddOnCPUUsage()`


## UpdateAddOnMemoryUsage

Updates addon memory usage information. See `GetAddOnMemoryUsage()` for the updated data.

**Signature:** `UpdateAddOnMemoryUsage()`


## UpdateGMTicket

Updates the open GM ticket with new text

**Signature:** `UpdateGMTicket("text")`

**Arguments:**
- `text` - New text for the ticket (`string`)

**See also:** GM Ticket functions.


## UpdateInventoryAlertStatus

**Signature:** `UpdateInventoryAlertStatus()`


## UpdateMapHighlight

Returns information about the texture used for highlighting zones in a continent map on mouseover

**Signature:** `name, fileName, texCoordX, texCoordY, textureX, textureY, scrollChildX, scrollChildY = UpdateMapHighlight(cursorX, cursorY)`

**Arguments:**
- `cursorX` - Horizontal position of the mouse cursor relative to the current world map (0 = left edge, 1 = right edge) (`number`)
- `cursorY` - Vertical position of the unit relative to the current world map (0 = top, 1 = bottom) (`number`)

**Returns:**
- `name` - The name of the zone being highlighted (`string`)
- `fileName` - Unique part of the path to the highlight texture for the zone; full path follows the format `"Interface\\WorldMap\\"..fileName.."\\"..fileName.."Highlight"` (`string`)
- `texCoordX` - Right texCoord value for the highlight texture (`number`)
- `texCoordY` - Bottom texCoord value for the highlight texture (`number`)
- `textureX` - Width of the texture as a proportion of the world map's width (`number`)
- `textureY` - Height of the texture as a proportion of the world map's height (`number`)
- `scrollChildX` - Horizontal position of the texture's top left corner relative to the current world map (0 = left edge, 1 = right edge) (`number`)
- `scrollChildY` - Vertical position of the texture's top left corner relative to the current world map (0 = top, 1 = bottom) (`number`)


## UpdateSpells

_No snapshot available (page did not exist in archive)._


## UpdateWorldMapArrowFrames


## UploadSettings

Stores a backup of game settings on the server. 

Does nothing unless server-side settings have been disabled by setting the synchronizeSettings CVar to 0.

**Signature:** `UploadSettings()`

**See also:** Client control and information functions.


## UseAction

Uses an action

**Signature:** `UseAction(slot [, target [, button]])`

**Arguments:**
- `slot` - The action to use (1-132) (`number`)
- `target` - The desired target of the action (`unitid`)
- `button` - The mouse button used to activate the action (`string`)


## UseContainerItem

Activate (as with right-clicking) an item in one of the player's bags. Has the same effect as right-clicking an item in the default UI; therefore, results may vary by context. In cases of conflict, conditions listed first override those below:

 
 - If the bank or guild bank UI is open, moves the item into the bank or guild bank (or if the item is in the bank or guild bank, moves it into the player's inventory).
 
 - If the trade UI is open, puts the item into the first available trade slot (or if the item is soulbound, into the "will not be traded" slot).
 
 - If the merchant UI is open and not in repair mode, attempts to sell the item to the merchant.
 
 - If the Send Mail UI is open, puts the item into the first available slot for message attachments.
 
 - If an item is readable (e.g. Lament of the Highborne), opens it for reading.
 
 - If an item is lootable (e.g. Magically Wrapped Gift), opens it for looting
 
 - If an item can be equipped, attempts to equip the item (placing any currently equipped item of the same type into the container slot used).
 
 - If an item has a "Use:" effect, activates said effect. Under this condition only, the function is protected and can only be called by the Blizzard UI.
 
 - If none of the above conditions are true, nothing happens.

**Signature:** `UseContainerItem(container, slot [, "target"])`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)
- `target` - A unit to be used as target for the action (`string`, unitID)

**See also:** Container functions.


## UseEquipmentSet

Equips the items in an equipment set

**Signature:** `equipped = UseEquipmentSet("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)

**Returns:**
- `equipped` - true if the set was equipped; otherwise nil (`boolean`)

**See also:** Equipment Manager functions.


## UseInventoryItem

Activate (as with right-clicking) an equipped item. If the `inventoryID` passed refers to an empty slot or a slot containing an item without a "Use:" action, this function is not protected (i.e. usable only by the Blizzard UI), but also has no effect.

**Signature:** `UseInventoryItem(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)


## UseItemByName

Uses an item, optionally on a specified target

**Signature:** `UseItemByName("name", "target")`

**Arguments:**
- `name` - The name of the item to use (`string`)
- `target` - The unit to use as the target of the item, if applicable (`unitId`)


## UseQuestLogSpecialItem

Uses the item associated with a current quest. Available for a number of quests which involve using an item (i.e. "Use the MacGuffin to summon and defeat the boss", "Use this saw to fell 12 trees", etc.)

**Signature:** `UseQuestLogSpecialItem(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest log entry with an associated usable item (between 1 and `GetNumQuestLogEntries()`) (`number`)

**See also:** Quest functions, Objectives tracking functions.


## UseSoulstone

Instantly resurrects the player in place, if possible. Usable if the player is dead (and has not yet released his or her spirit to the graveyard) and has the ability to instantly resurrect (provided by a Warlock's Soulstone or a Shaman's Reincarnation passive ability).

**Signature:** `UseSoulstone()`

**See also:** Player information functions.

