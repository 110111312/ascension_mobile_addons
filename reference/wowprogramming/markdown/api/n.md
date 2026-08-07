# WoW API Functions — N

_8 functions_

---

## NewGMTicket

Opens a new GM support ticket. The default UI sets the `needResponse` flag to `true` for "Talk to a GM" and "Stuck" tickets, and `false` for "Report an issue" tickets.

**Signature:** `NewGMTicket("text", needResponse)`

**Arguments:**
- `text` - The text to be sent in the ticket (`string`)
- `needResponse` - `true` if the issue requires personal response from a GM; otherwise `false` (`boolean`)

**See also:** GM Ticket functions.


## newproxy

Creates a zero-length userdata with an optional metatable.. newproxy is a experimental, undocumented and unsupported function in the Lua base library. It can be used to create a zero-length userdata, with a optional proxy.

This function allows you to bypass the table type restriction on setmetatable, and thus create just a metatable. One of the main benefits from doing this is that you don't have to take the full overhead of creating a dummy table, and it's the only object that honors the metamethod __len.

**Signature:** `userdata = newproxy(boolean) or newproxy(userdata)`

**Arguments:**
- `boolean` - Controls if the returned userdata should have a metatable or not. (`boolean`)
- `userdata` - Needs to be a proxy. The metatable will be shared between the proxies. (`userdata`)

**Returns:**
- `userdata` - A zero-length user-data object. (`userdata`)

**See also:** Secure execution utility functions, Blizzard internal functions.


## next

Returns the next key/value pair in a table

**Signature:** `nextKey, nextValue = next(t [, key])`

**Arguments:**
- `t` - A table (`table`)
- `key` - A key in the table (`value`)

**Returns:**
- `nextKey` - The next key in the table `t` (`value`)
- `nextValue` - Value associated with the next key in the table `t` (`value`)

**See also:** Lua library functions.


## NextView

Moves the camera to the next predefined setting. There are five "slots" for saved camera settings, indexed 1-5. These views can be set and accessed directly using `SaveView()` and `SetView()`, and cycled through using `NextView()` and `PrevView()`.

**Signature:** `NextView()`


## NoPlayTime

Returns whether the player has exceeded the allowed play time limit. When in this state, the player is unable to gain loot or XP or complete quests and cannot use trade skills; returning to normal requires logging out of the game for a period of time (see `GetBillingTimeRested`).

Only used in locales where the length of play sessions is restricted (e.g. mainland China).

**Signature:** `hasNoTime = NoPlayTime()`

**Returns:**
- `hasNoTime` - 1 if the player is out of play time, otherwise nil (`1nil`)

**See also:** Limited play time functions.


## NotifyInspect

Marks a unit for inspection and requests talent data from the server. Information about the inspected item's equipment can be retrieved immediately using Inventory APIs (e.g. `GetInventoryItemLink("target",1)`). Talent data is not available immediately; the `INSPECT_TALENT_READY` event fires once the inspected unit's talent information can be retrieved using Talent APIs (e.g. `GetTalentInfo(1,1,true)`).

**Signature:** `NotifyInspect("unit")`

**Arguments:**
- `unit` - A unit to inspect (`string`, unitID)


## NotWhileDeadError

Causes the default UI to display an error message indicating that actions are disallowed while the player is dead. Fires a `UI_ERROR_MESSAGE` event containing a localized message identified by the global variable `ERR_PLAYER_DEAD`.

**Signature:** `NotWhileDeadError()`

**See also:** Client control and information functions.


## NumTaxiNodes

Returns the number of flight points on the taxi map. Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `numNodes = NumTaxiNodes()`

**Returns:**
- `numNodes` - Number of flight points on the taxi map (`number`)

**See also:** Taxi/Flight functions.

