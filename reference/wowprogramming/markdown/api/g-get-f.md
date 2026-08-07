# WoW API — GetF*

_11 functions_

---

## GetFacialHairCustomization

Returns a token used for displaying facial feature customization options. The token referred to by this function can be used to look up a global variable containing localized names for the customization options available to the player's race at character creation time and in the Barbershop UI; see example.

**Signature:** `token = GetFacialHairCustomization()`

**Returns:**
- `token` - Part of a localized string token for displaying facial feature options for the player's race (`string`)

**See also:** Barbershop functions.




## GetFactionInfo

Returns information about a faction or header listing

**Signature:** `name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(index)`

**Arguments:**
- `index` - The index of the faction in the Reputation window (`number`)

**Returns:**
- `name` - Name of the faction (`string`)
- `description` - Brief description of the faction, as displayed in the default UI's detail window for a selected faction (`string`)
- `standingID` - Current standing with the given faction (`number`, standingID) 

 - `1` - Hated
- `2` - Hostile
- `3` - Unfriendly
- `4` - Neutral
- `5` - Friendly
- `6` - Honored
- `7` - Revered
- `8` - Exalted
- `barMin` - The minimum value of the reputation bar at the given standing (`number`)
- `barMax` - The maximum value of the reputation bar at the given standing (`number`)
- `barValue` - The player's current reputation with the faction (`number`)
- `atWarWith` - 1 if the player is at war with the given faction, otherwise nil (`1nil`)
- `canToggleAtWar` - 1 if the player can declare war with the given faction, otherwise nil (`1nil`)
- `isHeader` - 1 if the index refers to a faction group header (`1nil`)
- `isCollapsed` - 1 if the index refers to a faction group header and currently collapsed (`1nil`)
- `hasRep` - 1 if the index refers to a faction group header whose reputation value should be displayed (`1nil`)
- `isWatched` - 1 if the faction is currently being watched (i.e. displayed above the experience bar) (`1nil`)
- `isChild` - 1 if the index refers to a faction sub-group header within another group, or to an individual faction within a sub-group (`1nil`)




## GetFactionInfoByID

Returns information about a faction or header listing. Returns information about a faction regardless of whether the faction is known to the player (indeed, even for factions only available to the opposing alliance); see `GetFactionInfo` for information about factions listed in the player's Reputation UI.

Faction IDs used by this function match those found on database sites (e.g. Guardians of Hyjal) and are also returned by `GetQuestLogRewardFactionInfo`.

**Signature:** `name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfoByID(factionID)`

**Arguments:**
- `factionID` - Unique numeric identifier for a faction (`number`)

**Returns:**
- `name` - Name of the faction (`string`)
- `description` - Brief description of the faction, as displayed in the default UI's detail window for a selected faction (`string`)
- `standingID` - Current standing with the given faction (`number`, standingID) 

 - `1` - Hated
- `2` - Hostile
- `3` - Unfriendly
- `4` - Neutral
- `5` - Friendly
- `6` - Honored
- `7` - Revered
- `8` - Exalted
- `barMin` - The minimum value of the reputation bar at the given standing (`number`)
- `barMax` - The maximum value of the reputation bar at the given standing (`number`)
- `barValue` - The player's current reputation with the faction (`number`)
- `atWarWith` - 1 if the player is at war with the given faction, otherwise nil (`1nil`)
- `canToggleAtWar` - 1 if the player can declare war with the given faction, otherwise nil (`1nil`)
- `isHeader` - 1 if the index refers to a faction group header (`1nil`)
- `isCollapsed` - 1 if the index refers to a faction group header and currently collapsed (`1nil`)
- `hasRep` - 1 if the index refers to a faction group header whose reputation value should be displayed (`1nil`)
- `isWatched` - 1 if the faction is currently being watched (i.e. displayed above the experience bar) (`1nil`)
- `isChild` - 1 if the index refers to a faction sub-group header within another group, or to an individual faction within a sub-group (`1nil`)

**See also:** Faction functions.




## GetFarclip

Returns the maximum distance at which terrain is drawn. Corresponds to the "View Distance" slider in the default UI's Video Options pane, which allows settings between 177 and 1277 yards.

Functional but no longer used by the default UI; see the `farclip` CVar instead.

**Signature:** `distance = GetFarclip()`

**Returns:**
- `distance` - Maximum distance at which terrain is drawn (in yards) (`number`)




## getfenv

Returns the environment for a function (or the global environment). If the environment has a `__environment` metatable, that value is returned instead.

**Signature:** `env = getfenv([f]) or getfenv([stackLevel])`

**Arguments:**
- `f` - A function (`function`)
- `stackLevel` - Level of a function in the calling stack (`number`)

**Returns:**
- `env` - Table containing all variables in the function's environment, or the global environment if `f` or `stackLevel` is omitted (`table`)




## GetFirstTradeSkill

Returns the index of the first non-header in the trade skill listing

**Signature:** `index = GetFirstTradeSkill()`

**Returns:**
- `index` - Index of the first trade skill recipe (as opposed to group headers) (`number`)

**See also:** Tradeskill functions.




## GetFrameCPUUsage

Returns information about CPU usage by a frame's script handlers. Only returns valid data if the `scriptProfile` CVar is set to 1; returns 0 otherwise.

**Signature:** `usage, calls = GetFrameCPUUsage(frame, includeChildren)`

**Arguments:**
- `frame` - A Frame object (`table`)
- `includeChildren` - True to include CPU usage by children of the frame; false to include only the frame itself (`boolean`)

**Returns:**
- `usage` - Amount of CPU time used by the frame's script handlers (in milliseconds) since the UI was loaded or `ResetCPUUsage()` was last called (`number`)
- `calls` - Number of function calls made from the frame's script handlers (`number`)




## GetFramerate

Returns the number of frames per second rendered by the client

**Signature:** `framerate = GetFramerate()`

**Returns:**
- `framerate` - Number of frames per second rendered by the client (`number`)




## GetFramesRegisteredForEvent

Returns all frames registered for a given event

**Signature:** `... = GetFramesRegisteredForEvent("event")`

**Arguments:**
- `event` - An event name (`string`)

**Returns:**
- `...` - A list of tables, each a reference to a frame registered for the event (`list`)




## GetFriendInfo

Returns information about a character on the player's friends list

**Signature:** `name, level, class, area, connected, status, note, RAF = GetFriendInfo(index)`

**Arguments:**
- `index` - Index of a character in the Friends list (between 1 and `GetNumFriends()`) (`number`)

**Returns:**
- `name` - Name of the friend (`string`)
- `level` - Character level of the friend, if online; otherwise 0 (`number`)
- `class` - Localized name of the friend's class, if online; otherwise `UNKNOWN` (`string`)
- `area` - Name of the zone in which the friend is located, if online; otherwise `UNKNOWN` (`string`)
- `connected` - 1 if the friend is online; otherwise nil (`1nil`)
- `status` - A label indicating the friend's status (`"<AFK>"` or `"<DND>"`), or the empty string (`""`) if not applicable (`string`)
- `note` - Note text associated with the friend (`string`)
- `RAF` - 1 if the friend's account is linked to the player's via the Recruit-A-Friend program; otherwise nil (`1nil`)




## GetFunctionCPUUsage

Returns information about CPU usage by a function. Only returns valid data if the `scriptProfile` CVar is set to 1; returns 0 otherwise.

**Signature:** `usage, calls = GetFunctionCPUUsage(function, includeSubroutines)`

**Arguments:**
- `function` - A function reference (`function`)
- `includeSubroutines` - True to include time spent in other functions called by the given function; false to count only time spent in the function body (`boolean`)

**Returns:**
- `usage` - Amount of CPU time used by the function (in milliseconds) since the UI was loaded or `ResetCPUUsage()` was last called (`number`)
- `calls` - Number times the function was called (`number`)

**See also:** Debugging and Profiling functions.



