# WoW API — GetU*

_9 functions_

---

## GetUnitHealthModifier

Returns the health modifier for the player's pet

**Signature:** `modifier = GetUnitHealthModifier("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `pet` (`string`, unitID)

**Returns:**
- `modifier` - Factor modifying the unit's health value (`number`)

**See also:** Stat information functions.




## GetUnitHealthRegenRateFromSpirit

Returns the increase in health regeneration rate provided by Spirit

**Signature:** `regen = GetUnitHealthRegenRateFromSpirit("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `regen` - Increase in non-combat health regeneration per second provided by Spirit (`number`)

**See also:** Stat information functions.




## GetUnitManaRegenRateFromSpirit

Returns the increase in mana regeneration rate provided by Spirit

**Signature:** `regen = GetUnitManaRegenRateFromSpirit("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `player` or `pet` (`string`, unitID)

**Returns:**
- `regen` - Increase in inactive (non-casting) mana regeneration per second provided by Spirit (`number`)

**See also:** Stat information functions.




## GetUnitMaxHealthModifier

Returns the maximum health modifier for the player's pet

**Signature:** `modifier = GetUnitMaxHealthModifier("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `pet` (`string`, unitID)

**Returns:**
- `modifier` - Factor modifying the unit's maximum health value (`number`)




## GetUnitName

Returns a string summarizing a unit's name and server

**Signature:** `nameString = GetUnitName("unit", showServerName)`

**Arguments:**
- `unit` - Unit to query (`string`, unitID)
- `showServerName` - True to include the server name in the return value if the unit is not from the same server as the player; false to only include a short label in such circumstances (`boolean`)

**Returns:**
- `nameString` - The unit's name, possibly followed by the name of the unit's home server or a label indicating the unit is not from the player's server (`string`)

> **Note:** This function is not a C API but a Lua function declared in Blizzard's default user interface. Its implementation can be viewed by extracting the addon data using the Addon Kit provided by Blizzard.

**See also:** Unit functions.




## GetUnitPitch

Returns the player's current pitch (slope or angle of movement). Only valid for the unitID "player". The slope returned here reflects only the direction of movement for swimming or flying, not the current orientation of the player model or camera. (When on solid ground, GetUnitPitch indicates what the angle of flight would be were the player to start flying.)

The returned value is in radians, with positive values indicating upward slope, negative values indicating downward slope, and 0 indicating perfectly level flight (or swimming).

**Signature:** `pitch = GetUnitPitch("unit")`

**Arguments:**
- `unit` - Unit to query; only valid for `player` (`string`, unitID)

**Returns:**
- `pitch` - Unit's slope of movement in radians (`number`)




## GetUnitPowerModifier

Returns the mana modifier for the player's pet

**Signature:** `modifier = GetUnitPowerModifier("unit")`

**Arguments:**
- `unit` - A unit to query; only valid for `pet` (`string`, unitID)

**Returns:**
- `modifier` - Factor modifying the unit's mana value (`number`)




## GetUnitSpeed

Returns a unit's current speed. Valid for all observable units. Values returned indicate the current movement speed in yards per second. (It's not relative to facing or ground position; i.e. you won't see a smaller value when flying up at an angle or a negative value when backing up.) Does not indicate falling speed or the speed of boats, zeppelins, and some forms of quest-related transportation, but does indicate current speed on taxi flights and when moving due to combat effects such as Disengage, Death Grip, or various knockback abilities.

Examples: Normal running: 7; Walking: 2.5; Running backwards: 4.5; Epic flying mount: 26.6

**Signature:** `speed = GetUnitSpeed(unit)`

**Arguments:**
- `unit` - Unit to query (`unitid`)

**Returns:**
- `speed` - Unit's current speed in yards per second (`number`)




## GetUnspentTalentPoints

Returns the number of unused talent points

**Signature:** `points = GetUnspentTalentPoints(inspect, pet, talentGroup)`

**Arguments:**
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `points` - Number of points available for spending (`number`)



