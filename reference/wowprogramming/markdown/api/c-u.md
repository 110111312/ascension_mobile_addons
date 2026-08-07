# WoW API — C (U*)

_5 functions_

---

## CursorCanGoInSlot

Returns whether the item on the cursor can be equipped in an inventory slot. Returns `nil` if the cursor is empty or contains something other than an item.

**Signature:** `canBePlaced = CursorCanGoInSlot(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `canBePlaced` - 1 if the item on the cursor can be equipped in the given slot; otherwise nil (`1nil`)

**See also:** Cursor functions, Inventory functions.



## CursorHasItem

Returns whether an item is on the cursor. See `GetCursorInfo()` for more detailed information.

**Signature:** `hasItem = CursorHasItem()`

**Returns:**
- `hasItem` - 1 if the cursor is currently holding an item; otherwise nil (`1nil`)



## CursorHasMacro

Returns whether a macro is on the cursor. See `GetCursorInfo()` for more detailed information.

**Signature:** `hasMacro = CursorHasMacro()`

**Returns:**
- `hasMacro` - 1 if the cursor is currently holding a macro; otherwise nil (`1nil`)



## CursorHasMoney

Returns whether an amount of the player's money is on the cursor. Returns `nil` if the cursor holds guild bank money. See `GetCursorInfo()` for more detailed information.

**Signature:** `hasMoney = CursorHasMoney()`

**Returns:**
- `hasMoney` - 1 if the cursor is currently holding an amount of the player's money; otherwise nil (`1nil`)



## CursorHasSpell

Returns whether a spell is on the cursor. See `GetCursorInfo()` for more detailed information.

**Signature:** `hasSpell = CursorHasSpell()`

**Returns:**
- `hasSpell` - 1 if the cursor is currently holding a spell; otherwise nil (`1nil`)

**See also:** Cursor functions, Spell functions.

