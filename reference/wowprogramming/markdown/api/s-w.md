# WoW API — S (W*)

_1 functions_

---

## SwapRaidSubgroup

Swaps two raid members between subgroups in the raid. Only has effect if the player is the raid leader or a raid assistant. To move a member into a non-full subgroup without switching places with another member, see `SetRaidSubgroup()`.

**Signature:** `SwapRaidSubgroup(index1, index2)`

**Arguments:**
- `index1` - Index of the first raid member (between 1 and `GetNumRaidMembers()`); matches the numeric part of the unit's `raid` `unitID`, e.g. 21 for `raid21` (`number`)
- `index2` - Index of the other raid member (`number`)

**See also:** Raid functions.

