# WoW API — GetD*

_8 functions_

---

## GetDailyQuestsCompleted

Returns the number of daily quests the player has completed today. The daily quest period resets at or around 3:00 AM server time on most realms.

**Signature:** `dailyQuestsComplete = GetDailyQuestsCompleted()`

**Returns:**
- `dailyQuestsComplete` - Number of daily quests completed in the current period (`number`)

**See also:** Quest functions.




## GetDamageBonusStat

Returns the index of the basic statistic that provides increased physical damage. Unused in the default UI.

**Signature:** `bonusStat = GetDamageBonusStat()`

**Returns:**
- `bonusStat` - Index of the basic statistic which provides attack (`number`) 

 - `1` - Strength (Druids, Mages, Paladins, Priests, Shamans, Warlocks and Warriors)
- `2` - Agility (Hunters and Rogues)

**See also:** Stat information functions.




## GetDeathReleasePosition

Returns the location of the graveyard where the player's spirit will appear upon release. Returns `0,0` if the player is not dead or the graveyard's location is not visible on the current world map.

**Signature:** `graveyardX, graveyardY = GetDeathReleasePosition()`

**Returns:**
- `graveyardX` - Horizontal position of the graveyard relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `graveyardY` - Vertical position of the graveyard relative to the zone map (0 = top, 1 = bottom) (`number`)

**See also:** Map functions.




## GetDebugStats




## GetDebugZoneMap




## GetDefaultLanguage

_No snapshot available (page did not exist in archive)._




## GetDodgeChance

Returns the player's chance to dodge melee attacks

**Signature:** `chance = GetDodgeChance()`

**Returns:**
- `chance` - Percentage chance to dodge melee attacks (`number`)

**See also:** Stat information functions.




## GetDungeonDifficulty

Returns the 5 player selected dungeon difficulty

**Signature:** `difficulty = GetDungeonDifficulty()`

**Returns:**
- `difficulty` - The current 5 player dungeon difficulty (`number`) 

 - `1` - Normal
- `2` - Heroic



