# WoW API Functions — F

_17 functions_

---

## FactionToggleAtWar

Toggles "at war" status for a faction. 
"At War" status determines whether members of a faction can be attacked. Normal interactions (as with merchants, questgivers, etc.) are not available if the player is "at war" with an NPC's faction.

This function does nothing for faction headers or factions for which changing "at war" status is not currently allowed; i.e., factions for which the eighth (`canToggleAtWar`) return of `GetFactionInfo `is false or nil.

**Signature:** `FactionToggleAtWar(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**See also:** Faction functions.


## FillLocalizedClassList

Fills a table with localized class names keyed by non-localized class tokens. Note that while localized class names have no gender in English, other locales have different names for each gender.

**Signature:** `FillLocalizedClassList(table [, female])`

**Arguments:**
- `table` - An empty table to be filled (`number`)
- `female` - True to fill the table with female class names; false or omitted to fill it with male class names (`boolean`)


## FindSpellBookSlotByID


## FlagTutorial

Marks a contextual tutorial as displayed so it doesn't appear again

**Signature:** `FlagTutorial("tutorial")`

**Arguments:**
- `tutorial` - Numeric identifier for the tutorial step (as string); supplied in the `TUTORIAL_TRIGGER` event (`string`)

**See also:** Tutorial functions.


## FlipCameraYaw

Rotates the camera around the player

**Signature:** `FlipCameraYaw(degrees)`

**Arguments:**
- `degrees` - The number of degrees to rotate; positive for counter-clockwise, negative for clockwise. (`number`)


## floor

Returns the largest integer smaller than or equal to a number. Alias for the standard library function `math.floor`.

**Signature:** `floor = floor(x)`

**Arguments:**
- `x` - A number (`number`)

**Returns:**
- `floor` - Largest integer smaller than or equal to `x` (`number`)


## FocusUnit

Changes the `focus` unitID to refer to a new unit

**Signature:** `FocusUnit("unit") or FocusUnit("name")`

**Arguments:**
- `unit` - A unit to focus (`string`, unitID)
- `name` - The name of a unit to focus; only valid for `player`, `pet`, and party/raid members (`string`)


## FollowUnit

Causes the player character to automatically follow another unit. Only friendly player units can be followed.

**Signature:** `FollowUnit("unit") or FollowUnit("name" [, strict])`

**Arguments:**
- `unit` - A unit to follow (`string`, unitID)
- `name` - Name of a unit to follow (`string`)
- `strict` - True if only an exact match for the given name should be allowed; false to allow partial matches (`boolean`)


## ForceGossip


## forceinsecure

Causes the current execution path to continue outside the secure environment. Meaningless when called from outside of the secure environment.

**Signature:** `forceinsecure()`

**See also:** Secure execution utility functions.


## ForceLogout

Forces the client to logout. Not usable in the current WoW client; causes an error message to be displayed.

**Signature:** `ForceLogout()`

**See also:** Client control and information functions.


## ForceQuit

Immediately exits World of Warcraft. Unlike `Quit()`, this function exits the game application regardless of current conditions.

Used in the default UI when the player chooses "Exit now" in the dialog that appears if the player attempts to quit while not in an inn, major city, or other "rest" area.

**Signature:** `ForceQuit()`

**See also:** Client control and information functions.


## foreach

. Alias for the standard library function `table.foreach`. Deprecated in Lua 5.1; use a `for` loop and the `pairs` function instead (see example).

**Signature:** `foreach()`

> **Note:** This function is deprecated and is no longer in use


## foreachi


## format

Returns a formatted string containing specified values. Alias for the standard library function `string.format`. This version, however, includes the positional argument specifiers from Lua 4.0.

Lua does not support the ANSI C formate specifiers `*`, `l`, `L`, `n`, `p`, and `h` but includes an extra specifier, `q`, which formats a string in a form suitable to be safely read back by the Lua interpreter: the string is written between double quotes, and all double quotes, newlines, embedded zeros, and backslashes in the string are correctly escaped when written.

**Signature:** `formatted = format("formatString", ...)`

**Arguments:**
- `formatString` - A string containing format specifiers as per the ANSI C `printf` function (`string`)
- `...` - A list of values to be included in the formatted string (`list`)

**Returns:**
- `formatted` - The formatted string (`number`)


## FrameXML_Debug

Enables or disables logging of XML loading. When logging is enabled, status and error text will be saved to the file `Logs/FrameXML.log` (path is relative to the folder containing the World of Warcraft client) as the client parses and loads XML files in the default UI and addons.

**Signature:** `FrameXML_Debug(enable)`

**Arguments:**
- `enable` - True to enable verbose XML logging; false to disable (`boolean`)

**See also:** Debugging and Profiling functions.


## frexp

Returns the normalized fraction and base-2 exponent for a number. Alias for the standard library function `math.frexp`.

**Signature:** `m, e = frexp(x)`

**Arguments:**
- `x` - A number (`number`)

**Returns:**
- `m` - A number whose absolute value is in the range [0.5, 1), or 0 if `x` is 0 (`number`)
- `e` - An integer, such that `x = m * 2 ^ e` (`number`)

**See also:** Lua library functions.

