# WoW API Functions — H

_16 functions_

---

## HasAction

Returns whether an action slot contains an action

**Signature:** `hasAction = HasAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `hasAction` - 1 if the slot contains an action; otherwise nil (`1nil`)

**See also:** Action functions.


## HasCompletedAnyAchievement

Checks if the player has completed at least 1 achievement. Used to determine whether or not the achievements frame should be loaded, and if the Achievements button on the micro menu should be enabled or not.

**Signature:** `state = HasCompletedAnyAchievement()`

**Returns:**
- `state` - 1 if the player has completed at least one achievement, nil otherwise. (`boolean`)

**See also:** Achievement functions.


## HasDebugZoneMap


## HasFilledPetition

_No snapshot available (page did not exist in archive)._


## HasFullControl

Returns whether the player character can be controlled

**Signature:** `hasControl = HasFullControl()`

**Returns:**
- `hasControl` - 1 if the player character can be controlled (i.e. isn't feared, charmed, etc); otherwise nil (`1nil`)

**See also:** Player information functions.


## HasInspectHonorData

Returns whether PvP honor and arena data for the currently inspected unit has been downloaded from the server. See `RequestInspectHonorData()` to request PvP data from the server.

**Signature:** `hasData = HasInspectHonorData()`

**Returns:**
- `hasData` - 1 if the client has PvP data for the currently inspected player; otherwise nil (`1nil`)

**See also:** Inspect functions.


## HasKey

Returns whether the player has any keys stored in the Keyring container. Used in the default UI to show or hide the UI for the Keyring container

**Signature:** `hasKey = HasKey()`

**Returns:**
- `hasKey` - Returns 1 if the player has any keys stored in the Keyring container; otherwise nil (`1nil`)

**See also:** Player information functions.


## HasLFGRestrictions


## HasNewMail

Returns whether the player has received new mail since last visiting a mailbox

**Signature:** `hasMail = HasNewMail()`

**Returns:**
- `hasMail` - 1 if the player has received new mail since last visiting a mailbox; otherwise nil (`1nil`)


## HasPetSpells

Returns whether the player's current pet has a spellbook

**Signature:** `hasPetSpells, petType = HasPetSpells()`

**Returns:**
- `hasPetSpells` - 1 if the player currently has an active pet with spells/abilities; otherwise nil (`1nil`)
- `petType` - Non-localized token identifying the type of pet (`string`) 

 - `DEMON` - A warlock's demonic minion
- `PET` - A hunter's beast


## HasPetUI

Returns whether the pet UI should be displayed for the player's pet. Special quest-related pets, vehicles, and possessed units all count as pets but do not use the pet UI or associated functions.

**Signature:** `hasPetUI, isHunterPet = HasPetUI()`

**Returns:**
- `hasPetUI` - 1 if the pet UI should be displayed for the player's pet (`1nil`)
- `isHunterPet` - 1 if the player's pet is a hunter pet (`1nil`)

**See also:** Pet functions.


## HasSoulstone

Returns whether the player can instantly resurrect in place. Only returns valid information while the player is dead and has not yet released his or her spirit to the graveyard.

**Signature:** `text = HasSoulstone()`

**Returns:**
- `text` - If the player can resurrect in place, the text to be displayed on the dialog button for such (e.g. "Use Soulstone", "Reincarnate"); otherwise nil (`string`)

**See also:** Player information functions.


## HasWandEquipped

Returns whether the player has a wand equipped

**Signature:** `isEquipped = HasWandEquipped()`

**Returns:**
- `isEquipped` - 1 if a wand is equipped; otherwise nil (`1nil`)

**See also:** Player information functions.


## HearthAndResurrectFromArea

Instantly exits the current world PvP zone, returning to the player's Hearthstone location. 
Resets the player's Hearthstone cooldown, and also returns the player to life if dead. Only usable if the player is in a world PvP combat zone (i.e. Wintergrasp).

**Signature:** `HearthAndResurrectFromArea()`

**See also:** PvP functions.


## HideRepairCursor

Returns the cursor to normal mode after use of `ShowRepairCursor()`

**Signature:** `HideRepairCursor()`

**See also:** Cursor functions.


## hooksecurefunc

Add a function to be called after execution of a secure function. Allows one to "post-hook" a secure function without tainting the original.

The original function will still be called, but the function supplied will be called after the original, with the same arguments. Return values from the supplied function are discarded. Note that there is no API to remove a hook from a function: any hooks applied will remain in place until the UI is reloaded.

Only allows hooking of functions named by a global variable; to hook a script handler on a Frame object, see `Frame:HookScript()`.

**Signature:** `hooksecurefunc([table,] "function", hookfunc)`

**Arguments:**
- `table` - A table object that contains the function to be hooked (`table`)
- `function` - The name of the function to be hooked (`string`)
- `hookfunc` - The function to be called each time the original function is called (`function`)

**See also:** Secure execution utility functions.

