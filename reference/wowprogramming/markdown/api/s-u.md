# WoW API — S (U*)

_2 functions_

---

## SummonFriend

Summons a unit whose account is linked to the player's via the Recruit-a-Friend program. Does not instantly teleport the unit -- calling this function begins casting the Summon Friend "spell", and once it completes the unit is prompted to accept or decline the summon.

**Signature:** `SummonFriend("name") or SummonFriend("unit")`

**Arguments:**
- `name` - Exact name of a player to summon (only applies to units in the player's party or raid) (`string`)
- `unit` - A unit to summon (`string`, unitID)

**See also:** Recruit-a-friend functions.



## SummonRandomCritter

Summons a random critter companion

**Signature:** `SummonRandomCritter()`

**See also:** Companion functions.


