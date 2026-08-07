# WoW API Functions — T

_61 functions_

---

## TakeInboxItem

Retrieves an item attachment from a message in the player's inbox (accepting COD charges if applicable)

**Signature:** `TakeInboxItem(mailID, attachmentIndex)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)
- `attachmentIndex` - Index of an attachment to the mail (between 1 and `select(8,``GetInboxHeaderInfo(mailID)``)`) (`number`)

**See also:** Mail functions.


## TakeInboxMoney

Retrieves any money attached to a mail in the player's inbox

**Signature:** `TakeInboxMoney(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**See also:** Mail functions.


## TakeInboxTextItem

Requests a copy of a mail's body text as an item. The text of an in-game mail can be retrieved as a readable "Plain Letter" item to store in the player's bags; this function sends a request to the server for this item, causing the standard inventory events to fire as the item is placed into the player's inventory.

**Signature:** `TakeInboxTextItem(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)


## TakeTaxiNode

Embarks on a taxi flight to a given destination. Only has effect while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `TakeTaxiNode(index)`

**Arguments:**
- `index` - Index of a flight point (between 1 and `NumTaxiNodes()`) (`number`)


## TargetDirectionEnemy


## TargetDirectionFinished


## TargetDirectionFriend


## TargetLastEnemy

Targets the most recently targeted enemy unit

**Signature:** `TargetLastEnemy()`

**See also:** Targeting functions.


## TargetLastFriend

Targets the most recently targeted friendly unit

**Signature:** `TargetLastFriend()`

**See also:** Targeting functions.


## TargetLastTarget

Targets the most recently targeted unit

**Signature:** `TargetLastTarget()`

**See also:** Targeting functions.


## TargetNearest

Cycles targets through nearest units regardless of reaction/affiliation

**Signature:** `TargetNearest([backward])`

**Arguments:**
- `backward` - Reverses direction of target cycling if true (as with the default TAB vs. SHIFT-TAB bindings) (`boolean`)

**See also:** Targeting functions.


## TargetNearestEnemy

Cycles your target through the nearest enemy units. 
This function can only be called once per hardware event.

**Signature:** `TargetNearestEnemy(backward)`

**Arguments:**
- `backward` - Reverses the direction of the cycling if true (e.g. TAB vs. SHIFT-TAB) (`boolean`)

**See also:** Targeting functions.


## TargetNearestEnemyPlayer

Cycles targets through nearby enemy player units

**Signature:** `TargetNearestEnemyPlayer(backward)`

**Arguments:**
- `backward` - Reverses direction of target cycling if true (as with the default TAB vs. SHIFT-TAB bindings) (`boolean`)

**See also:** Targeting functions.


## TargetNearestFriend

Cycles targets through nearby friendly units

**Signature:** `TargetNearestFriend(backward)`

**Arguments:**
- `backward` - Reverses direction of target cycling if true (as with the default TAB vs. SHIFT-TAB bindings) (`boolean`)


## TargetNearestFriendPlayer

Cycles targets through nearby friendly player units

**Signature:** `TargetNearestFriendPlayer(backward)`

**Arguments:**
- `backward` - Reverses direction of target cycling if true (as with the default TAB vs. SHIFT-TAB bindings) (`boolean`)

**See also:** Targeting functions.


## TargetNearestPartyMember

Cycles targets through nearby party members

**Signature:** `TargetNearestPartyMember(backward)`

**Arguments:**
- `backward` - Reverses direction of target cycling if true (as with the default TAB vs. SHIFT-TAB bindings) (`boolean`)


## TargetNearestRaidMember

Cycles targets through nearby raid members

**Signature:** `TargetNearestRaidMember(backward)`

**Arguments:**
- `backward` - Reverses direction of target cycling if true (as with the default TAB vs. SHIFT-TAB bindings) (`boolean`)


## TargetTotem

Targets one of the player's totems (or a Death Knight's ghoul). Totem functions are also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).

**Signature:** `TargetTotem(slot)`

**Arguments:**
- `slot` - Which totem to target (`number`) 

 - `1` - Fire (or Death Knight's ghoul)
- `2` - Earth
- `3` - Water
- `4` - Air


## TargetUnit

Targets a unit. Passing `nil` is equivalent to calling `ClearTarget()`).

**Signature:** `TargetUnit("unit") or TargetUnit("name" [, exactMatch])`

**Arguments:**
- `unit` - A unit to target (`string`, unitID)
- `name` - Name of a unit to target (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Targeting functions.


## TaxiGetDestX

Returns the horizontal coordinate of a taxi flight's destination node. Used in the default UI to draw lines between nodes; `TaxiNodeSetCurrent()` should be called first so the client can compute routes.

Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `dX = TaxiGetDestX(source, dest)`

**Arguments:**
- `source` - Index of the source flight point (between 1 and `NumTaxiNodes()`) (`number`)
- `dest` - Index of the destination flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `dX` - X coordinate of the destination taxi node (as a proportion of the taxi map's width; 0 = left edge, 1 = right edge) (`number`)


## TaxiGetDestY

Returns the vertical coordinate of a taxi flight's destination node. Used in the default UI to draw lines between nodes; `TaxiNodeSetCurrent()` should be called first so the client can compute routes.

Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `dY = TaxiGetDestY(source, dest)`

**Arguments:**
- `source` - Index of the source flight point (between 1 and `NumTaxiNodes()`) (`number`)
- `dest` - Index of the destination flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `dY` - Y coordinate of the destination taxi node (as a proportion of the taxi map's height; 0 = bottom, 1 = top) (`number`)


## TaxiGetSrcX

Returns the horizontal coordinate of a taxi flight's source node. Used in the default UI to draw lines between nodes; `TaxiNodeSetCurrent()` should be called first so the client can compute routes.

Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `sX = TaxiGetSrcX(source, dest)`

**Arguments:**
- `source` - Index of the source flight point (between 1 and `NumTaxiNodes()`) (`number`)
- `dest` - Index of the destination flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `sX` - X coordinate of the source taxi node (as a proportion of the taxi map's width; 0 = left edge, 1 = right edge) (`number`)


## TaxiGetSrcY

Returns the vertical coordinate of a taxi flight's source node. Used in the default UI to draw lines between nodes; `TaxiNodeSetCurrent()` should be called first so the client can compute routes.

Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `sY = TaxiGetSrcY(source, dest)`

**Arguments:**
- `source` - Index of the source flight point (between 1 and `NumTaxiNodes()`) (`number`)
- `dest` - Index of the destination flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `sY` - Y coordinate of the source taxi node (as a proportion of the taxi map's height; 0 = bottom, 1 = top) (`number`)

**See also:** Taxi/Flight functions.


## TaxiNodeCost

Returns the cost to fly to a given taxi node. Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `cost = TaxiNodeCost(index)`

**Arguments:**
- `index` - Index of a flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `cost` - Price of a flight to the given node (in copper) (`number`)


## TaxiNodeGetType

Returns the type of a flight pont. Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `type = TaxiNodeGetType(index)`

**Arguments:**
- `index` - Index of a flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `type` - Type of the flight point (`string`) 

 - `CURRENT` - The player's current location
- `DISTANT` - Unreachable from the current location
- `NONE` - Not currently in use
- `REACHABLE` - Reachable from the current location (directly or through other nodes)


## TaxiNodeName

Returns the name of a flight point. Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `name = TaxiNodeName(index)`

**Arguments:**
- `index` - Index of a flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `name` - Name of the taxi node (`string`)


## TaxiNodePosition

Returns the position of a flight point on the taxi map. Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `x, y = TaxiNodePosition(index)`

**Arguments:**
- `index` - Index of a flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `x` - Horizontal coordinate of the taxi node (as a proportion of the taxi map's width; 0 = left edge, 1 = right edge) (`number`)
- `y` - Vertical coordinate of the taxi node (as a proportion of the taxi map's height; 0 = bottom, 1 = top) (`number`)


## TaxiNodeSetCurrent

Sets the "current" flight path node. Used in the default UI when mousing over a node; tells the client to compute the route paths involving the node (see `TaxiGetSrcX()` et al).

**Signature:** `TaxiNodeSetCurrent(slot)`

**Arguments:**
- `slot` - The internal index of a flight path node (`number`)

**See also:** Taxi/Flight functions.


## TeleportToDebugObject

**Signature:** `TeleportToDebugObject()`


## time

Returns the numeric time value for a described date/time (or the current time). Alias for the standard library function `os.time`.

According to the Lua manual, the returned value may vary across different systems; however, the Lua libraries included with current WoW clients on both Mac and Windows share the same implementation.

For higher-precision time measurements not convertible to a date, see `GetTime()`.

**Signature:** `t = time([timeDesc])`

**Arguments:**
- `timeDesc` - Table describing a date and time, as returned by `date("*t")`; if omitted, uses the current time (`table`)

**Returns:**
- `t` - Number of seconds elapsed since midnight, January 1, 1970 UTC (`number`)

**See also:** Lua library functions.


## tinsert

Inserts a value into a table. Alias for the standard library function `table.insert`.

**Signature:** `tinsert(table [, position] value)`

**Arguments:**
- `table` - A table (`table`)
- `position` - Index in the table at which to insert the new value; if omitted, defaults to `#table + 1` (`number`)
- `value` - Any value (`value`)


## ToggleAutoRun

Starts or stops the player character automatically moving forward

**Signature:** `ToggleAutoRun()`

**See also:** Movement functions.


## ToggleCollision

**Signature:** `ToggleCollision()`


## ToggleCollisionDisplay


## TogglePerformanceDisplay

**Signature:** `TogglePerformanceDisplay()`


## TogglePerformancePause


## TogglePerformanceValues

**Signature:** `TogglePerformanceValues()`


## TogglePetAutocast

Turns autocast on or off for a pet action. Turns autocast on if not autocasting and vice versa.

**Signature:** `TogglePetAutocast(index)`

**Arguments:**
- `index` - Index of a pet action button (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)

**See also:** Action functions, Pet functions.


## TogglePlayerBounds


## TogglePortals

**Signature:** `TogglePortals()`


## TogglePVP

Switches the player's desired PvP status. If PvP is currently disabled for the player, it becomes enabled immediately. If PvP is enabled, it will become disabled after five minutes of no PvP activity.

**Signature:** `TogglePVP()`

**See also:** PvP functions.


## ToggleRun

Switches the character's ground movement mode between running and walking. If running, switches to walking, and vice versa. Has no effect on swimming or flying speed.

**Signature:** `ToggleRun()`


## ToggleSheath

Sheaths or unsheaths the player character's hand-held items. Calling repeatedly will cause the player character to draw his or her melee weapons, followed by his or her range weapon, followed by hiding all weapons.

**Signature:** `ToggleSheath()`


## ToggleSpellAutocast

Enables or disables automatic casting of a spell. Generally only pet spells can be autocast.

**Signature:** `ToggleSpellAutocast(index, "bookType") or ToggleSpellAutocast("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**See also:** Spell functions.


## ToggleTris


## tonumber

Returns the numeric value of a string

**Signature:** `numValue = tonumber(x [, base])`

**Arguments:**
- `x` - A string or number (`value`)
- `base` - Base in which to interpret the numeral (integer between 2 and 36); letters 'A-Z' can be used to denote place values 10 or above in bases greater than 10; defaults to 10 if omitted (`number`)

**Returns:**
- `numValue` - Numeric value of `x` in the given base, or nil if the value cannot be converted to a number (`number`)


## tostring

Returns a string representation of a value

**Signature:** `stringValue = tostring(value)`

**Arguments:**
- `value` - Any value (`value`)

**Returns:**
- `stringValue` - String representation of the given `value` (if `value` is an object with a `__tostring` metamethod, that method is used to produce the string representation) (`string`)


## TradeSkillOnlyShowMakeable

Filters the trade skill listing by whether the player currently has enough reagents for each recipe

**Signature:** `TradeSkillOnlyShowMakeable(filter)`

**Arguments:**
- `filter` - True to filter the recipe listing to show only recipes for which the player currently has enough reagents; false to show all recipes (`boolean`)

**See also:** Tradeskill functions.


## TradeSkillOnlyShowSkillUps

Filters the trade skill listing by whether the player can gain skill ranks from each recipe. The default UI does not provide controls for this filter, but it can nonetheless be used to alter the contents of the trade skill recipe listing.

**Signature:** `TradeSkillOnlyShowSkillUps(filter)`

**Arguments:**
- `filter` - True to filter the recipe listing to show only recipes which the player can gain skill ranks by performing; false to show all recipes (`boolean`)


## tremove

Removes an element from a table. Alias for the standard library function `table.remove`.

**Signature:** `tremove(table [, position])`

**Arguments:**
- `table` - A table (`table`)
- `position` - Index in the table from which to remove the value; if omitted, defaults to `#table` (`number`)


## TriggerTutorial


## TurnInArenaPetition

_No snapshot available (page did not exist in archive)._


## TurnInGuildCharter

Turns in a completed guild charter. Usable if the player is interacting with a guild registrar (i.e. between the `GUILD_REGISTRAR_SHOW` and `GUILD_REGISTRAR_CLOSED` events).

**Signature:** `TurnInGuildCharter()`

**See also:** Guild functions, Petition functions.


## TurnInPetition

**Signature:** `TurnInPetition()`


## TurnLeftStart

Begins turning the player character to the left. "Left" here is relative to the player's facing; i.e. if looking down at the character from above, he or she turns counter-clockwise.

Used by the `TURNLEFT` binding.

**Signature:** `TurnLeftStart()`


## TurnLeftStop

Ends movement initiated by `TurnLeftStart`

**Signature:** `TurnLeftStop()`

**See also:** Movement functions.


## TurnOrActionStart

Begins character steering or interaction (equivalent to right-clicking in the 3-D world). After calling this function (i.e. while the right mouse button is held), cursor movement rotates (or steers) the player character, altering yaw (facing) and/or pitch (vertical movement angle) as well as camera position. Final results vary by context and are determined when calling `TurnOrActionStop()` (i.e. releasing the right mouse button). 

Used by the `TURNORACTION` binding (not customizable in the default UI), which is bound to the right mouse button by default.

**Signature:** `TurnOrActionStart()`

**See also:** Movement functions.


## TurnOrActionStop

Ends action initiated by `TurnOrActionStart`. After calling this function (i.e. releasing the right mouse button), character steering stops and normal cursor movement resumes. If the cursor has not moved significantly since calling `TurnOrActionStart()` (i.e. pressing the right mouse button), results vary by context:

 
 - 
if the cursor is over a nearby unit, interacts with (or attacks) that unit, making it the player's target.

 
 - 
if the cursor is over a nearby interactable world object (e.g. mailbox, treasure chest, or quest object), interacts with (or uses) that object.

 
 - 
if the cursor is over a faraway unit or world object and the "Click-to-Move" option is enabled (i.e. the "autointeract" CVar is "1"), attempts to move the player character to the unit/object and interact with it once nearby.

 
 - 
if the cursor is over a faraway world object and the "Click-to-Move" option is disabled, fires a `UI_ERROR_MESSAGE` event indicating the player is too far away to interact with the object.

 
 - 
otherwise, does nothing.

Used by the `TURNORACTION` binding (not customizable in the default UI), which is bound to the right mouse button by default.

**Signature:** `TurnOrActionStop()`

**See also:** Movement functions.


## TurnRightStart

Begins turning the player character to the right. "Right" here is relative to the player's facing; i.e. if looking down at the character from above, he or she turns clockwise.

Used by the `TURNRIGHT` binding.

**Signature:** `TurnRightStart()`


## TurnRightStop

Ends movement initiated by `TurnRightStart`

**Signature:** `TurnRightStop()`

**See also:** Movement functions.


## type

Returns a string describing the data type of a value

**Signature:** `typeString = type(v)`

**Arguments:**
- `v` - Any value (`value`)

**Returns:**
- `typeString` - A string describing the type of value `v` (`string`) 

 - `boolean` - A boolean value (`true` or `false`)
- `function` - A function
- `nil` - The special value `nil`
- `number` - A numeric value
- `string` - A string
- `table` - A table
- `thread` - A coroutine thread
- `userdata` - Data external to the Lua environment (e.g. the main element of a Frame object)

**See also:** Lua library functions.

