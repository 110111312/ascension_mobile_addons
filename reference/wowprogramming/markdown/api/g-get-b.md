# WoW API — GetB*

_37 functions_

---

## GetBackpackCurrencyInfo

Returns information about a currency marked for watching on the Backpack UI

**Signature:** `name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(index)`

**Arguments:**
- `index` - Index of a 'slot' for displaying currencies on the backpack (between 1 and `MAX_WATCHED_TOKENS`) (`number`)

**Returns:**
- `name` - Name of the currency type (`string`)
- `count` - Amount of the currency the player has (`number`)
- `extraCurrencyType` - Type of the currency (`number`) 

 - `0` - Item-based currency
- `1` - Arena points
- `2` - Honor points
- `icon` - Path to an icon texture representing the currency item (for Honor/Arena points, not the icon displayed in the default UI) (`string`)
- `itemID` - ID for the currency item (`number`)




## GetBagName

Returns the name of one of the player's bags. Returns nil for the bank and keyring, for bank bags while the player is not at the bank, and for empty bag or bank bag slots.

**Signature:** `name = GetBagName(container)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)

**Returns:**
- `name` - Name of the container (`string`)




## GetBankSlotCost

Returns the cost of the next purchasable bank bag slot. Returns `999999999` if the player owns all available slots.

**Signature:** `cost = GetBankSlotCost()`

**Returns:**
- `cost` - Cost of the next available bank bag slot (in copper) (`number`)

**See also:** Bank functions.




## GetBarberShopStyleInfo

Returns information about the selected barber shop style option

**Signature:** `name, unused, cost, isCurrent = GetBarberShopStyleInfo(styleIndex)`

**Arguments:**
- `styleIndex` - Index of a style option (`number`) 

 - `1` - Hair (or Horn) Style
- `2` - Hair (or Horn) Color
- `3` - Varies by race and gender: Facial Hair, Earrings, Features, Hair, Horns, Markings, Normal, Piercings, or Tusks

**Returns:**
- `name` - Name of the style option, or nil if the style is not named (`string`)
- `unused` - Currently unused (`string`)
- `cost` - Price of applying the style option, not including changes to other style options (in copper) (`number`)
- `isCurrent` - 1 if the style option matches the character's existing style; otherwise nil (`1nil`)

**See also:** Barbershop functions.




## GetBarberShopTotalCost

Returns the total price of selected barber shop style changes

**Signature:** `cost = GetBarberShopTotalCost()`

**Returns:**
- `cost` - Price of the barber shop style change (in copper) (`number`)




## GetBaseMip

_No snapshot available (page did not exist in archive)._




## GetBattlefieldArenaFaction




## GetBattlefieldEstimatedWaitTime

Returns the estimated wait time on a battleground or arena queue

**Signature:** `waitTime = GetBattlefieldEstimatedWaitTime(index)`

**Arguments:**
- `index` - Index of a battleground/arena queue the player has joined (between 1 and `MAX_BATTLEFIELD_QUEUES`) (`number`)

**Returns:**
- `waitTime` - Estimated wait time to join the battleground/arena (in milliseconds) (`number`)

**See also:** Battlefield functions.




## GetBattlefieldFlagPosition

Returns the position of a flag in a battleground

**Signature:** `flagX, flagY, flagToken = GetBattlefieldFlagPosition(index)`

**Arguments:**
- `index` - Index of a flag (between 1 and `GetNumBattlefieldFlagPositions()`) (`number`)

**Returns:**
- `flagX` - Horizontal (X) coordinate of the flag's position relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `flagY` - Vertical (Y) coordinate of the flag's position relative to the zone map (0 = bottom edge, 1 = top edge) (`number`)
- `flagToken` - Unique portion of the path to a texure for the flag; preface with `"Interface\\WorldStateFrame\"` for the full path (`string`)

**See also:** Battlefield functions.




## GetBattlefieldInfo

_No snapshot available (page did not exist in archive)._




## GetBattlefieldInstanceExpiration

Returns the amount of time remaining before all players are removed from the instance, if in a battleground instance where the match has completed

**Signature:** `timeLeft = GetBattlefieldInstanceExpiration()`

**Returns:**
- `timeLeft` - Amount of time remaining (in milliseconds) before all players are removed from the instance, if in a battleground instance where the match has completed; otherwise 0. (`number`)




## GetBattlefieldInstanceInfo

Returns a numeric ID for a battleground instance in the battleground queueing list. This number is seen in the instance names in said listings and elsewhere in the Battlegrounds UI (e.g. the 13 in "You are eligible to enter Warsong Gulch 13").

**Signature:** `instanceID = GetBattlefieldInstanceInfo(index)`

**Arguments:**
- `index` - Index in the battleground queue listing (1 for the first available instance, or between 2 and `GetNumBattlefields()` for other instances) (`number`)

**Returns:**
- `instanceID` - Numeric ID of the battleground instance (`number`)




## GetBattlefieldInstanceRunTime

Returns the amount of time since the current battleground instance opened

**Signature:** `time = GetBattlefieldInstanceRunTime()`

**Returns:**
- `time` - Amount of time since the current battleground instance opened (in milliseconds) (`number`)

**See also:** Battlefield functions.




## GetBattlefieldMapIconScale

Returns the scale to be used for displaying battleground map icons. Used in the default UI to determine the size of the point of interest icons (towers, graveyards, etc.) on the zone map (the small battle minimap). The default size of the icons is set by `DEFAULT_POI_ICON_SIZE` and the scale is used to grow or shrink them depending on the size of the map.

**Signature:** `scale = GetBattlefieldMapIconScale()`

**Returns:**
- `scale` - Scale factor for map icons (between 0 and 1) (`number`)

**See also:** Battlefield functions.




## GetBattlefieldPortExpiration

Returns the time left on a battleground or arena invitation

**Signature:** `expiration = GetBattlefieldPortExpiration(index)`

**Arguments:**
- `index` - Index of a battleground/arena queue the player has joined (between 1 and `MAX_BATTLEFIELD_QUEUES`) (`number`)

**Returns:**
- `expiration` - Time remaining before the player's invitation to enter the battleground/arena expires (in seconds); 0 if the player has not yet been invited to enter or is already in the battleground/arena instance (`number`)

**See also:** Battlefield functions.




## GetBattlefieldPosition

Returns the position of a battleground team member not in the player's group. Still used in the default UI but no longer useful; as all team members in a battleground match are automatically joined into a raid group. See `GetPlayerMapPosition()` instead.

**Signature:** `unitX, unitY, name = GetBattlefieldPosition(index)`

**Arguments:**
- `index` - Index of a team member (between 1 and `GetNumBattlefieldPositions()`) (`number`)

**Returns:**
- `unitX` - Horizontal (X) coordinate of the unit's position relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `unitY` - Vertical (Y) coordinate of the unit's position relative to the zone map (0 = bottom edge, 1 = top edge) (`number`)
- `name` - Name of the unit for display on the map (`string`)

**See also:** Battlefield functions.




## GetBattlefieldScore

Returns basic scoreboard information for a battleground/arena participant. Does not include battleground-specific score data (e.g. flags captured in Warsong Gulch, towers assaulted in Alterac Valley, etc); see `GetBattlefieldStatData()` for such information.

**Signature:** `name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(index)`

**Arguments:**
- `index` - Index of a participant in the battleground/arena scoreboard (between 1 and `GetNumBattlefieldScores()`) (`number`)

**Returns:**
- `name` - Name of the participant (`string`)
- `killingBlows` - Number of killing blows scored by the participant during the match (`number`)
- `honorableKills` - Number of honorable kills scored by the participant during the match (`number`)
- `deaths` - Number of times the participant died during the match (`number`)
- `honorGained` - Amount of honor points gained by the participant during the match (`number`)
- `faction` - Faction or team to which the participant belongs (`number`) 

 - `0` - Horde (Battleground) / Green Team (Arena)
- `1` - Alliance (Battleground) / Gold Team (Arena)
- `race` - Localized name of the participant's race (`string`)
- `class` - Localized token representing the participant's class (`string`)
- `classToken` - Non-localized token representing the participant's class (`string`)
- `damageDone` - Total amount of damage done by the participant during the match (`number`)
- `healingDone` - Total amount of healing done by the participant during the match (`number`)
- `bgRating` - Personal battleground rating at the start of the match (`number`)
- `ratingChange` - Amount of rating gained/lost during the match (`number`)
- `preMatchMMR` - After 4.2 update is always zero (`number`)
- `mmrChange` - After 4.2 update is always zero (`number`)
- `talentSpec` - Localized name of player build (`string`)

**See also:** Battlefield functions.




## GetBattlefieldStatData

Returns battleground-specific scoreboard information for a battleground participant. Battleground-specific statistics include flags captured in Warsong Gulch, towers assaulted in Alterac Valley, etc. For the name and icon associated with each statistic, see `GetBattlefieldStatInfo()`. For basic battleground score information, see `GetBattlefieldScore()`.

**Signature:** `columnData = GetBattlefieldStatData(index, statIndex)`

**Arguments:**
- `index` - Index of a participant in the battleground/arena scoreboard (between 1 and `GetNumBattlefieldScores()`) (`number`)
- `statIndex` - Index of a battleground-specific statistic (between 1 and `GetNumBattlefieldStats()`) (`number`)

**Returns:**
- `columnData` - The participant's score for the statistic (`number`)

**See also:** Battlefield functions.




## GetBattlefieldStatInfo

Returns information about a battleground-specific scoreboard column. Battleground-specific statistics include flags captured in Warsong Gulch, towers assaulted in Alterac Valley, etc.

**Signature:** `text, icon, tooltip = GetBattlefieldStatInfo(statIndex)`

**Arguments:**
- `statIndex` - Index of a battleground-specific statistic (between 1 and `GetNumBattlefieldStats()`) (`number`)

**Returns:**
- `text` - Name to display for the statistic's scoreboard column header (`string`)
- `icon` - Path to an icon texture for the statistic (`string`)
- `tooltip` - Text to be displayed as a tooltip when mousing over the scoreboard column (`string`)

**See also:** Battlefield functions.




## GetBattlefieldStatus

Returns information about an active or queued battleground/arena instance

**Signature:** `status, mapName, instanceID, bracketMin, bracketMax, teamSize, registeredMatch = GetBattlefieldStatus(index)`

**Arguments:**
- `index` - Index of a battleground/arena queue the player has joined (between 1 and `GetMaxBattlefieldID()`) (`number`)

**Returns:**
- `status` - Status of the player with respect to the battleground (`string`) 

 - `active` - The player is currently playing in this battleground
- `confirm` - The player has been invited to enter this battleground but has not done so yet
- `none` - No battleground or queue at this index
- `queued` - The player is queued for this battleground
- `mapName` - Name of the battleground (e.g. "Alterac Valley") or arena ("All Arenas" while `queued`; "Eastern Kingdoms" regardless of destination while status is `confirm`, e.g. "Dalaran Sewers" while `active`) (`string`)
- `instanceID` - If in a battleground or queued for a specific instance, the number identifying that instance (e.g. 13 in "Warsong Gulch 13"); otherwise 0 (`number`)
- `bracketMin` - Lowest level of characters in the player's level bracket for the battleground (`number`)
- `bracketMax` - Highest level of characters in the player's level bracket for the battleground (`number`)
- `teamSize` - Number of players per team for an arena match (`number`) 

 - `0` - Not an arena match
- `2` - 2v2 Arena
- `3` - 3v3 Arena
- `5` - 5v5 Arena
- `registeredMatch` - 1 if a rated arena match; otherwise nil (`1nil`)

**See also:** Battlefield functions.




## GetBattlefieldTeamInfo

Returns info about teams and their ratings in a rated arena match.. Usable following the `UPDATE_BATTLEFIELD_SCORE` event.

**Signature:** `teamName, teamRating, newTeamRating = GetBattlefieldTeamInfo(index)`

**Arguments:**
- `index` - Index of a team in the arena match (`number`) 

 - `0` - Green Team
- `1` - Gold Team

**Returns:**
- `teamName` - Name of the team (`string`)
- `teamRating` - The team's rating at the start of the match (`number`)
- `newTeamRating` - New rating for the team when the match is complete (`number`)




## GetBattlefieldTimeWaited

Returns the amount of time elapsed since the player joined the queue for a battleground/arena

**Signature:** `timeInQueue = GetBattlefieldTimeWaited(index)`

**Arguments:**
- `index` - Index of a battleground/arena queue the player has joined (between 1 and `MAX_BATTLEFIELD_QUEUES`) (`number`)

**Returns:**
- `timeInQueue` - Time elapsed since the player joined the queue (in milliseconds) (`number`)

**See also:** Battlefield functions.




## GetBattlefieldVehicleInfo

Returns information about special vehicles in the current zone. Used only for certain vehicles in certain zones: includes the airships in Icecrown as well as vehicles used in Ulduar, Wintergrasp, and Strand of the Ancients.

**Signature:** `vehicleX, vehicleY, unitName, isPossessed, vehicleType, orientation, isPlayer, isAlive = GetBattlefieldVehicleInfo(index)`

**Arguments:**
- `index` - Index of a special vehicle (between 1 and `GetNumBattlefieldVehicles()`) (`number`)

**Returns:**
- `vehicleX` - Horizontal position of the vehicle relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `vehicleY` - Vertical position of the vehicle relative to the zone map (0 = top, 1 = bottom) (`number`)
- `unitName` - Localized name of the vehicle (`string`)
- `isPossessed` - True if the vehicle is controlled by another unit (`boolean`)
- `vehicleType` - Token indicating type of vehicle; some types can be used as keys to the global `VEHICLE_TEXTURES` table to get display texture information for the vehicle (`string`) 

 - `Airship Alliance` - The Alliance flying quest hub in Icecrown
- `Airship Horde` - The Horde flying quest hub in Icecrown
- `Drive` - A land vehicle such as a siege engine
- `Fly` - A flying vehicle
- `Idle` - A non-moving vehicle (e.g. an artillery turret)
- `orientation` - Facing angle of the vehicle ((in radians, 0 = north, values increasing counterclockwise) (`number`)
- `isPlayer` - True if the vehicle is controlled by the player (`boolean`)
- `isAlive` - True if the vehicle has not been destroyed (`boolean`)




## GetBattlefieldWinner

Returns the winner of the current battleground or arena match

**Signature:** `winner = GetBattlefieldWinner()`

**Returns:**
- `winner` - Index of the winning team if in a completed match; otherwise nil (`number`) 

 - `0` - Horde (Battleground) / Green Team (Arena)
- `1` - Alliance (Battleground) / Gold Team (Arena)

**See also:** Battlefield functions.




## GetBattlegroundInfo

Returns information about available battlegrounds

**Signature:** `name, canEnter, isHoliday, minlevel = GetBattlegroundInfo(index)`

**Arguments:**
- `index` - Index of a battleground (between 1 and `NUM_BATTLEGROUNDS`) (`number`)

**Returns:**
- `name` - Localized name of the battleground (Alterac Valley, Warsong Gulch, etc.) (`string`)
- `canEnter` - 1 if the player can enter the battleground; otherwise nil (`1nil`)
- `isHoliday` - 1 if a "holiday" offering bonus honor is currently active for the battleground; otherwise nil (`1nil`)
- `minlevel` - Minimum character level required to enter the battleground (`number`)




## GetBidderAuctionItems

Requests data from the server for the list of auctions bid on by the player. The `AUCTION_BIDDER_LIST_UPDATE` event fires if new data is available; listing information can then be retrieved using `GetAuctionItemInfo()` or other Auction APIs.

**Signature:** `GetBidderAuctionItems()`

**See also:** Auction functions.




## GetBillingTimeRested

Returns the amount of time for which the player must be offline in order to lift play time restrictions. After playing for a number of hours, restrictions may be placed on the player's ability to gain loot or XP, complete quests, or use trade skills; if in such a state, the player must log off for the period of time specified by this function in order to return to normal play.

Only used in locales where the length of play sessions is restricted (e.g. mainland China).

**Signature:** `time = GetBillingTimeRested()`

**Returns:**
- `time` - Offline time required to lift play time restrictions (in minutes) (`number`)




## GetBinding

Returns information about a key binding

**Signature:** `commandName, binding1, binding2 = GetBinding(index)`

**Arguments:**
- `index` - Index in the key bindings list (between 1 and `GetNumBindings()`) (`number`)

**Returns:**
- `commandName` - Name of the binding command (`string`)
- `binding1` - First key binding for the command, or nil if no key is bound (`string`, binding)
- `binding2` - Second key binding for the command, or nil if no key is bound (`string`, binding)




## GetBindingAction

Returns the action bound to a key or key combination

**Signature:** `action = GetBindingAction("key" [, checkOverride])`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `checkOverride` - True to check possible override bindings for the `key`, false or omitted to check only normal bindings (`boolean`)

**Returns:**
- `action` - Name of the action associated with the key, or the empty string (`""`) if the key is not bound to an action (`string`)

**See also:** Keybind functions.




## GetBindingByKey

Returns the action bound to a key or key combination

**Signature:** `action = GetBindingByKey("key")`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)

**Returns:**
- `action` - Name of the action associated with the key, or the empty string (`""`) if the key is not bound to an action (`string`)

**See also:** Keybind functions.




## GetBindingKey

Returns the key combinations for a given binding command. Although the default UI only allows two combinations to be bound to a command, more than two can be set via the API.

**Signature:** `key1, ... = GetBindingKey("COMMAND")`

**Arguments:**
- `COMMAND` - Name of a binding command (`string`)

**Returns:**
- `key1` - First key binding for the command, or nil if no key is bound (`string`, binding)
- `...` - A list of additional bindings for the command (`list`)

**See also:** Keybind functions.




## GetBindLocation

Returns the name of the player's Hearthstone location

**Signature:** `location = GetBindLocation()`

**Returns:**
- `location` - Name of the player's Hearthstone location (`string`)

**See also:** Player information functions.




## GetBlockChance

Returns the player's percentage chance to block with a shield

**Signature:** `chance = GetBlockChance()`

**Returns:**
- `chance` - Percentage chance to block (`number`)

**See also:** Stat information functions.




## GetBonusBarOffset

Returns the current "stance" offset for use with the bonus action bar. This value corresponds to what "stance" the player is currently in, and more specifically which set of actions correspond to that stance. Action IDs for special stances start on action bar #7 (or `NUM_ACTIONBAR_PAGES + 1`), so the `offset` returned by this function corresponds to the number to be added to `NUM_ACTIONBAR_PAGES` in calculating action IDs for these action bars.

Note that the UI definition of "stance" includes not just warrior stances but also druid shapeshift forms, rogue/druid stealth, priest shadowform, and various other cases, but does not necessarily include all states normally presented in the default UI's stance/shapeshift bar (notable exclusions are paladin auras and death knight presences).

**Signature:** `offset = GetBonusBarOffset()`

**Returns:**
- `offset` - Offset of the stance's action bar in relation to `NUM_ACTIONBAR_PAGES` (`number`)




## GetBuildInfo

Returns the version information about the client

**Signature:** `version, internalVersion, date, uiVersion = GetBuildInfo()`

**Returns:**
- `version` - Display version number of the client (e.g. `"3.1.1"`) (`string`)
- `internalVersion` - Internal version number of the client (e.g. `"9835"`) (`string`)
- `date` - Date on which the client executable was built (e.g. `"Apr 24 2009"`); not necessarily the date it was released to the public (`string`)
- `uiVersion` - Version compatibility number for UI purposes (e.g. `30100`); generally, installed addons should have this number in the `Interface` header of their TOC files to avoid being marked as Out of Date and possibly not loaded (`number`)




## GetBuybackItemInfo

Returns information about an item recently sold to a vendor and available to be repurchased

**Signature:** `name, texture, price, quantity, numAvailable, isUsable = GetBuybackItemInfo(index)`

**Arguments:**
- `index` - Index of an item in the buyback listing (between 1 and `GetNumBuybackItems()`) (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `price` - Current cost to repurchase the item from this vendor (in copper) (`number`)
- `quantity` - Number of stacked items per purchase (`number`)
- `numAvailable` - Number of items available for purchase, if the vendor has a limited stock of the item; generally 0 for buyback items (`number`)
- `isUsable` - 1 if the player can use or equip the item; otherwise nil (`1nil`)

**See also:** Merchant functions.




## GetBuybackItemLink

Returns a hyperlink for an item recently sold to a vendor and available to be repurchased

**Signature:** `link = GetBuybackItemLink(index)`

**Arguments:**
- `index` - Index of an item in the buyback listing (between 1 and `GetNumBuybackItems()`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)

**See also:** Merchant functions, Hyperlink functions.



