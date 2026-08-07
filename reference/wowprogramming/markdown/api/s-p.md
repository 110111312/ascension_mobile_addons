# WoW API — S (P*)

_11 functions_

---

## SpellCanTargetGlyph

Returns whether the spell currently awaiting a target requires a glyph slot to be chosen. 

Only applies when the player has attempted to cast a spell -- in this case, the "spell" cast when one uses a glyph item -- but the spell requires a target before it can begin casting (i.e. the glowing hand cursor is showing).

**Signature:** `canTarget = SpellCanTargetGlyph()`

**Returns:**
- `canTarget` - 1 if the spell can target glyph slots (`1nil`)

**See also:** Spell functions, Glyph functions.



## SpellCanTargetItem

Returns whether the spell currently awaiting a target requires an item to be chosen. Only applies when the player has attempted to cast a spell but the spell requires a target before it can begin casting (i.e. the glowing hand cursor is showing).

**Signature:** `canTarget = SpellCanTargetItem()`

**Returns:**
- `canTarget` - 1 if the spell can target an item; otherwise nil (`1nil`)

**See also:** Spell functions, Item functions.



## SpellCanTargetUnit

Returns whether the spell currently awaiting a target can target a given unit. Only applies when the player has attempted to cast a spell but the spell requires a target before it can begin casting (i.e. the glowing hand cursor is showing).

**Signature:** `canTarget = SpellCanTargetUnit("unit") or SpellCanTargetUnit("name")`

**Arguments:**
- `unit` - A unit to target (`string`, unitID)
- `name` - The name of a unit to target; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `canTarget` - 1 if the spell currently awaiting targeting can target the given unit (`1nil`)



## SpellHasRange

Returns whether an item has a range limitation for its use. For example: Shadowbolt can only be used on a unit within a given range of the player; Ritual of Summoning requires a target but has no range restriction; Fel Armor has no target and thus no range restriction.

**Signature:** `hasRange = SpellHasRange(index, "bookType") or SpellHasRange("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `hasRange` - 1 if the spell has an effective range; otherwise nil. (`1nil`)



## SpellIsTargeting

Returns whether a spell is currently awaiting a target

**Signature:** `isTargeting = SpellIsTargeting()`

**Returns:**
- `isTargeting` - 1 if a spell is currently awaiting a target; otherwise nil (`1nil`)

**See also:** Spell functions.



## SpellStopCasting

Stops casting or targeting the spell in progress

**Signature:** `SpellStopCasting()`

**See also:** Spell functions.



## SpellStopTargeting

Cancels the spell currently awaiting a target. When auto-self cast is not enabled and the player casts a spell that requires a target, the cursor changes to a glowing hand so the user can select a target. This function cancels targeting mode so the player can cast another spell.

**Signature:** `SpellStopTargeting()`

**See also:** Spell functions.



## SpellTargetItem

Casts the spell currently awaiting a target on an item. Usable when the player has attempted to cast a spell (e.g. an Enchanting recipe or the "Use:" effect of a sharpening stone or fishing lure) but the spell requires a target before it can begin casting (i.e. the glowing hand cursor is showing).

**Signature:** `SpellTargetItem(itemID) or SpellTargetItem("itemName") or SpellTargetItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**See also:** Spell functions, Item functions.



## SpellTargetUnit

Casts the spell currently awaiting a target on a unit

**Signature:** `SpellTargetUnit("unit") or SpellTargetUnit("name")`

**Arguments:**
- `unit` - A unit to target (`string`, unitID)
- `name` - The name of a unit to target; only valid for `player`, `pet`, and party/raid members (`string`)



## SplitContainerItem

Picks up only part of a stack of items from one of the player's bags or other containers. Has no effect if the given `amount` is greater than the number of items stacked in the slot.

**Signature:** `SplitContainerItem(container, slot, amount)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)
- `amount` - Number of items from the stack to pick up (`number`)



## SplitGuildBankItem

Picks up only part of a stack of items from the guild bank. Has no effect if the given `amount` is greater than the number of items stacked in the slot.

**Signature:** `SplitGuildBankItem(tab, slot, amount)`

**Arguments:**
- `tab` - Index of a guild bank tab (`number`)
- `slot` - Index of an item slot in the guild bank tab (`number`)
- `amount` - Number of items from the stack to pick up (`number`)

**See also:** Guild bank functions, Cursor functions.


