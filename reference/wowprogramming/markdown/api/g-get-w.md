# WoW API — GetW*

_7 functions_

---

## GetWatchedFactionInfo

Returns information about the "watched" faction (displayed on the XP bar in the default UI)

**Signature:** `name, standingID, barMin, barMax, barValue = GetWatchedFactionInfo()`

**Returns:**
- `name` - Name of the faction being watched (`string`)
- `standingID` - The player's current standing with the faction (`number`, standingID) 

 - `1` - Hated
- `2` - Hostile
- `3` - Unfriendly
- `4` - Neutral
- `5` - Friendly
- `6` - Honored
- `7` - Revered
- `8` - Exalted
- `barMin` - The minimum value for the faction status bar (`number`)
- `barMax` - The maximum value for the faction status bar (`number`)
- `barValue` - The current value for the faction status bar (`number`)

**See also:** Faction functions.




## GetWaterDetail

_No snapshot available (page did not exist in archive)._




## GetWeaponEnchantInfo

Returns information about temporary enchantments on the player's weapons. Does not return information about permanent enchantments added via Enchanting, Runeforging, etc; refers instead to temporary buffs such as wizard oils, sharpening stones, rogue poisons, and shaman weapon enhancements.

**Signature:** `hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()`

**Returns:**
- `hasMainHandEnchant` - 1 if the main hand weapon has a temporary enchant (`1nil`)
- `mainHandExpiration` - The time until the enchant expires, in milliseconds (`number`)
- `mainHandCharges` - The number of charges left on the enchantment (`number`)
- `hasOffHandEnchant` - 1 if the offhand weapon has a temporary enchant (`1nil`)
- `offHandExpiration` - The time until the enchant expires, in milliseconds (`number`)
- `offHandCharges` - The number of charges left on the enchantment (`number`)

**See also:** Buff functions.




## GetWhoInfo

Returns information about a character in the Who system query results

**Signature:** `name, guild, level, race, class, zone, filename = GetWhoInfo(index)`

**Arguments:**
- `index` - Index of an entry in the Who system query results (between 1 and `GetNumWhoResults()`) (`number`)

**Returns:**
- `name` - Name of the character (`string`)
- `guild` - Name of the character's guild (`string`)
- `level` - Level of the character (`number`)
- `race` - Localized name of the character's race (`string`)
- `class` - Localized name of the character's class (`string`)
- `zone` - Name of the zone in which the character was located when the query was performed (`string`)
- `filename` - A non-localized token representing the character's class (`string`)




## GetWintergraspWaitTime

_No snapshot available (page did not exist in archive)._




## GetWorldPVPQueueStatus

Returns information on the players queue for a world PvP zone

**Signature:** `status, mapName, queueID = GetWorldPVPQueueStatus(index)`

**Arguments:**
- `index` - Index of the queue to get data for (between 1 and `MAX_WORLD_PVP_QUEUES`) (`number`)

**Returns:**
- `status` - Returns the status of the players queue (`string`) 

 - `confirm` - The player can enter the pvp zone
- `none` - No world pvp queue at this index
- `queued` - The player is queued for this pvp zone
- `mapName` - Map name they are queued for (e.g Wintergrasp) (`string`)
- `queueID` - Queue ID, used for BattlefieldMgrExitRequest() and BattlefieldMgrEntryInviteResponse() (`number`)

**See also:** PvP functions.




## GetWorldStateUIInfo

Returns information about a world state UI element. World State UI elements include PvP, instance, and quest objective information (displayed at the top center of the screen in the default UI) as well as more specific information for "control point" style PvP objectives. Examples: the Horde/Alliance score in Arathi Basin, the tower status and capture progress bars in Hellfire Peninsula, the progress text in the Black Morass and Violet Hold instances, and the event status text for quests The Light of Dawn and The Battle For The Undercity.

**Signature:** `uiType, state, text, icon, dynamicIcon, tooltip, dynamicTooltip, extendedUI, extendedUIState1, extendedUIState2, extendedUIState3 = GetWorldStateUIInfo(index)`

**Arguments:**
- `index` - Index of a world state UI element (between 1 and `GetNumWorldStateUI()`) (`number`)

**Returns:**
- `uiType` - 1 if the element should be conditionally displayed (based on the state of the "Show World PvP Objectives" setting and the player's location); any other value if the element is always displayed (`number`)
- `state` - State of the element: 0 always indicates the element should be hidden; other possible states vary by context (e.g. in Warsong Gulch, state 2 indicates the team holds the enemy flag) (`number`)
- `text` - Text to be displayed for the element (`string`)
- `icon` - Path to a texture for the element's main icon (usually describing the element itself: e.g. a Horde or Alliance icon for elements displaying a battleground score) (`string`)
- `dynamicIcon` - Path to a texture for a secondary icon (usually describing transient status: e.g. a flag icon in Warsong Gulch) (`string`)
- `tooltip` - Text to be displayed when mousing over the UI element (`string`)
- `dynamicTooltip` - Text to be displayed when mousing over the element's `dynamicIcon` (`string`)
- `extendedUI` - Identifies the type of additional UI elements to display if applicable (`string`) 

 - `""` - No additional UI should be displayed
- `"CAPTUREPOINT"` - A capture progress bar should be displayed for the element
- `extendedUIState1` - Index of the capture progress bar corresponding to the element (`number`)
- `extendedUIState2` - Position of the capture bar (0 = left/Horde edge, 100 = right/Alliance edge) (`number`)
- `extendedUIState3` - Width of the neutral section of the capture bar: e.g. if 50, the `extendedUIState2` values 0-25 correspond to Horde ownership of the objective, values 76-100 to Alliance ownership, and values 26-75 to no ownership (`number`)



