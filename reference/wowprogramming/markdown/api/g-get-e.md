# WoW API — GetE*

_13 functions_

---

## GetEquipmentSetInfo

Returns information about an equipment set (specified by index)

**Signature:** `name, icon, setID = GetEquipmentSetInfo(index)`

**Arguments:**
- `index` - Index of an equipment set (between 1 and `GetNumEquipmentSets()`) (`number`)

**Returns:**
- `name` - Name of the equipment set (`string`)
- `icon` - Path to an icon texture for the equipment set (`string`)
- `setID` - Internal ID number for the set (not used elsewhere in API) (`number`)




## GetEquipmentSetInfoByName

Returns information about an equipment set

**Signature:** `icon, setID = GetEquipmentSetInfoByName("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)

**Returns:**
- `icon` - Unique part of the path to an icon texture for the equipment set; prepend `"Interface\Icons\"` for the full path (`string`)
- `setID` - Internal ID number for the set (not used elsewhere in API) (`number`)

**See also:** Equipment Manager functions.




## GetEquipmentSetItemIDs

Returns a table listing the items in an equipment set

**Signature:** `itemIDs = GetEquipmentSetItemIDs("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)

**Returns:**
- `itemIDs` - A table listing the `itemID`s of the set's contents, keyed by `inventoryID` (`table`)




## GetEquipmentSetLocations

Returns a table listing the locations of the items in an equipment set

**Signature:** `itemIDs = GetEquipmentSetLocations("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)

**Returns:**
- `itemIDs` - A table listing the `itemLocation`s of the set's contents, keyed by `inventoryID` (`table`)

**See also:** Equipment Manager functions.




## geterrorhandler

Returns the current error handler function

**Signature:** `handler = geterrorhandler()`

**Returns:**
- `handler` - The current error handler (`function`)

**See also:** Debugging and Profiling functions.




## GetEventCPUUsage

Returns information about the CPU usage of an event. Only returns valid data if the `scriptProfile` CVar is set to 1; returns 0 otherwise.

**Signature:** `usage, numEvents = GetEventCPUUsage(["event"])`

**Arguments:**
- `event` - Name of an event; if omitted, returns usage information for all events (`string`)

**Returns:**
- `usage` - Amount of CPU time used by handlers for the event (in milliseconds) since the UI was loaded or `ResetCPUUsage()` was last called (`number`)
- `numEvents` - Number of times the event has fired this session (`number`)




## GetExistingLocales

Returns a list of installed localization packs for the WoW client

**Signature:** `... = GetExistingLocales()`

**Returns:**
- `...` - A list of strings, each the four-letter locale code (see `GetLocale()`) for an installed localization (`list`)

**See also:** Client control and information functions.




## GetExistingSocketInfo

Returns information about a permanently socketed gem. If the given socket contains a permanently socketed gem, returns information for that gem (even if a new gem has been dropped in the socket to overwrite the existing gem, but has not yet been confirmed). If the socket is empty, returns `nil`.

Only returns valid information when the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `name, texture, name = GetExistingSocketInfo(index)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)

**Returns:**
- `name` - Name of the socketed gem (`string`)
- `texture` - Path to an icon texture for the socketed gem (`string`)
- `name` - 1 if the gem matches the socket's color; otherwise nil (`1nil`)

**See also:** Socketing functions.




## GetExistingSocketLink

_No snapshot available (page did not exist in archive)._




## GetExpansionLevel




## GetExpertise

Returns the player's current expertise value

**Signature:** `expertise = GetExpertise()`

**Returns:**
- `expertise` - The player's expertise value (`number`)

**See also:** Stat information functions.




## GetExpertisePercent

Returns the reduction in chance to be dodged or parried conferred by the player's expertise value

**Signature:** `expertisePerc, offhandExpertisePercent = GetExpertisePercent()`

**Returns:**
- `expertisePerc` - Reduction in percentage chance for main hand attacks to be dodged or parried (`number`)
- `offhandExpertisePercent` - Reduction in percentage chance for off hand attacks to be dodged or parried (`number`)




## GetExtendedItemInfo



