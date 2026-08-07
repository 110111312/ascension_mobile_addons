# WoW API — S (A*)

_3 functions_

---

## SaveBindings

Saves the current set of key bindings

**Signature:** `SaveBindings(set)`

**Arguments:**
- `set` - A set to which to save the current bindings (`number`) 

 - `1` - Account-wide key bindings
- `2` - Character-specific key bindings



## SaveEquipmentSet

Saves or creates an equipment set with the player's currently equipped items. If a set with the same name already exists, that set's contents are overwritten. 

Set names are case sensitive: if a "Fishing" set already exists, saving a "fishing" set will create a new set instead of overwriting the "Fishing" set.

**Signature:** `SaveEquipmentSet("name", icon)`

**Arguments:**
- `name` - Name of the set (`string`)
- `icon` - Index of an icon to associate with the set: between `1` and `GetNumMacroIcons()` for an icon from the set of macro icons; values between `-INVSLOT_FIRST_EQUIPPED` and `-INVSLOT_LAST_EQUIPPED` for the icon of an item in the equipment set at that (negative) `inventoryID` (`number`)

**See also:** Equipment Manager functions.



## SaveView

Saves the current camera settings. There are five "slots" for saved camera settings, indexed 1-5. These views can be set and accessed directly using `SaveView()` and `SetView()`, and cycled through using `NextView()` and `PrevView()`.

**Signature:** `SaveView(index)`

**Arguments:**
- `index` - Index of a saved camera setting (between 1 and 5) (`number`)

**See also:** Camera functions.


