# WoW API Functions — E

_28 functions_

---

## EditMacro

Changes the name, icon, and/or body of a macro. After patch 4.3 then the numeric 'icon' argument has been replaced by 'iconTexture'.

Furthermore, the function always prepend 'Interface\Icons' to the 'iconTexture' string.

**Signature:** `newIndex = EditMacro(index, "name", "iconTexture", "body")`

**Arguments:**
- `index` - Existing index of the macro (`number`, macroID)
- `name` - New name for the macro (up to 16 characters); nil to keep an existing name (`string`)
- `iconTexture` - name of icon texture; nil to keep an existing texture (`string`)
- `body` - Body of the macro (up to 255 characters); nil to keep the existing body (`string`)

**Returns:**
- `newIndex` - Index at which the macro is now saved (may differ from input `index` if the macro's name was changed, as macros are saved in alphabetical order) (`number`, macroID)

**See also:** Macro functions.


## EjectPassengerFromSeat

Ejects the occupant of a seat in the player's vehicle

**Signature:** `EjectPassengerFromSeat(seat)`

**Arguments:**
- `seat` - Index of a seat in the player's vehicle (`number`)

**See also:** Vehicle functions.


## EnableAddOn

Marks an addon as enabled. The addon will remain inactive until the player logs out and back in or reloads the UI (see `ReloadUI()`).

Changes to the enabled/disabled state of addons while in-game are saved on a per-character basis.

**Signature:** `EnableAddOn(index) or EnableAddOn("name")`

**Arguments:**
- `index` - The index of the addon to be enabled (`number`)
- `name` - The name of the addon to be enabled (`string`)

**See also:** Addon-related functions.


## EnableAllAddOns

Marks all addons as enabled. Addons will remain inactive until the player logs out and back in or reloads the UI (see `ReloadUI()`).

Changes to the enabled/disabled state of addons while in-game are saved on a per-character basis.

**Signature:** `EnableAllAddOns()`


## EnableSpellAutocast

Enables automatic casting of a pet spell

**Signature:** `EnableSpellAutocast("spell")`

**Arguments:**
- `spell` - Name of a pet spell (`string`)


## EndBoundTradeable

Confirms taking an action which renders a looted Bind on Pickup item non-tradeable. A Bind on Pickup item looted by the player can be traded to other characters who were originally eligible to loot it, but only within a limited time after looting. This period can be ended prematurely if the player attempts certain actions (such as enchanting the item).

**Signature:** `EndBoundTradeable(id)`

**Arguments:**
- `id` - Number identifying the item (as provided by the `END_BOUND_TRADEABLE` event) (`number`)


## EndRefund

Confirms taking an action which renders a purchased item non-refundable. Items bought with alternate currency (honor points, arena points, or special items such as Emblems of Heroism and Dalaran Cooking Awards) can be returned to a vendor for a full refund, but only within a limited time after the original purchase. This period can be ended prematurely if the player attempts certain actions (such as enchanting the item).

**Signature:** `EndRefund(id)`

**Arguments:**
- `id` - Number identifying the item (as provided by the `END_REFUND` event) (`number`)

**See also:** Item functions, Merchant functions.


## EnumerateFrames

Returns the next frame following the frame passed, or nil if no more frames exist

**Signature:** `nextFrame = EnumerateFrames([currentFrame])`

**Arguments:**
- `currentFrame` - The current frame to get the next frame, or nil to get the first frame (`table`)

**Returns:**
- `nextFrame` - The frame following currentFrame or nil if no more frames exist, or the first frame if nil was passed (`table`)

**See also:** Utility functions.


## EnumerateServerChannels

Returns the available server channel names

**Signature:** `... = EnumerateServerChannels()`

**Returns:**
- `...` - A list of strings, each the name of an available server channel (e.g. "General", "Trade", "WorldDefense", "GuildRecruitment", "LookingForGroup") (`string`)

**See also:** Channel functions.


## EquipCursorItem

Puts the item on the cursor into a specific equipment slot. If the item on the cursor can be equipped but does not fit in the given slot, the item is automatically equipped in the first available slot in which it fits (as with `AutoEquipCursorItem()`). Thus, this function is most useful when dealing with items which can be equipped in more than one slot: containers, rings, trinkets, and (for dual-wielding characters) one-handed weapons.

Causes an error message (`UI_ERROR_MESSAGE`) if the item on the cursor cannot be equipped. Does nothing if the cursor does not contain an item.

**Signature:** `EquipCursorItem(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)


## EquipItemByName

_No content available._


## EquipmentManager_UnpackLocation

Unpacks an inventory location bitfield into usable components

**Signature:** `player, bank, bags, location or slot, bag = EquipmentManager_UnpackLocation(location)`

**Arguments:**
- `location` - A bit field that represents an item's location in the player's possession. This bit field can be obtained using the `GetInventoryItemsForSlot` function. (`number`)

**Returns:**
- `player` - A flag indicating whether or not the item exists in the player's inventory (i.e. an equipped item). (`boolean`)
- `bank` - A flag indicating whether or not the item exists in the payer's bank. (`boolean`)
- `bags` - A flag indicating whether or not the item exists in the player's bags. (`boolean`)
- `location or slot` - The inventory slot that contains the item, or the container slot that contains the item, if the item is in the player's bags. (`number`)
- `bag` - The bagID of the container that contains the item. (`number`)

**See also:** Inventory functions, Bank functions, Container functions, Equipment Manager functions.


## EquipmentManagerClearIgnoredSlotsForSave

Clears the list of equipment slots to be ignored when saving sets

**Signature:** `EquipmentManagerClearIgnoredSlotsForSave()`

**See also:** Equipment Manager functions.


## EquipmentManagerIgnoreSlotForSave

Adds an equipment slot to the list of those ignored when saving sets. Creating or saving a set with `SaveEquipmentSet()` will ignore any slots on the list, allowing the player to create sets which only switch certain items (e.g. to equip a fishing pole and hat while leaving non-fishing-related items equipped).

**Signature:** `EquipmentManagerIgnoreSlotForSave(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**See also:** Equipment Manager functions.


## EquipmentManagerIsSlotIgnoredForSave

Returns whether the contents of an equipment slot will be included when saving sets

**Signature:** `isIgnored = EquipmentManagerIsSlotIgnoredForSave(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `isIgnored` - True if the contents of the slot will not be included when next creating or saving an equipment set; otherwise false (`boolean`)

**See also:** Equipment Manager functions.


## EquipmentManagerUnignoreSlotForSave

Removes an equipment slot from the list of those ignored when saving sets. Creating or saving a set with `SaveEquipmentSet()` will ignore any slots on the list, allowing the player to create sets which only switch certain items (e.g. to equip a fishing pole and hat while leaving non-fishing-related items equipped).

**Signature:** `EquipmentManagerUnignoreSlotForSave(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**See also:** Equipment Manager functions.


## EquipmentSetContainsLockedItems

Returns whether an equipment set contains locked items. Locked items are those in a transient state -- e.g. on the cursor for moving within the player's bags, placed in the Send Mail or Trade UIs, etc. -- for which the default UI displays the item's icon as grayed out. A set cannot be equipped if it contains locked items.

**Signature:** `isLocked = EquipmentSetContainsLockedItems("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)

**Returns:**
- `isLocked` - True if the equipment set contains locked items (`boolean`)

**See also:** Equipment Manager functions.


## EquipPendingItem

Confirms equipping a bind-on-equip item. Usable following the `EQUIP_BIND_CONFIRM` or `AUTOEQUIP_BIND_CONFIRM`, which fires when the player attempts to equip a bind-on-equip item

**Signature:** `EquipPendingItem(index)`

**Arguments:**
- `index` - Index provided by the `EQUIP_BIND_CONFIRM` or `AUTOEQUIP_BIND_CONFIRM` event; currently always 0 (`number`)

**See also:** Inventory functions, Item functions.


## error

Causes a Lua error message

**Signature:** `error("message" [, level])`

**Arguments:**
- `message` - An error message to be displayed (`string`)
- `level` - Level in the function stack at which the error message begins providing function information; e.g. 1 (the default, if omitted) to start at the position where `error()` was called, 2 to start at the function which called `error()`, 3 to start at the function which called that function, etc. (`number`)

**See also:** Lua library functions.


## exp

Returns the value of the exponential function for a number. Alias for the standard library function `math.exp`.

**Signature:** `exp = exp(x)`

**Arguments:**
- `x` - A number (`number`)

**Returns:**
- `exp` - Value of the mathematical constant e (Euler's number) raised to the `x`th power (`number`)

**See also:** Lua library functions.


## ExpandAllFactionHeaders

Expands all headers and sub-headers in the Reputation UI. Expands headers for both major groups (Classic, Burning Crusade, Wrath of the Lich King, Inactive, etc.) and the sub-groups within them (Alliance Forces, Steamwheedle Cartel, Horde Expedition, Shattrath City, etc.).

**Signature:** `ExpandAllFactionHeaders()`

**See also:** Faction functions.


## ExpandChannelHeader

Expands a group header in the chat channel listing

**Signature:** `ExpandChannelHeader(index)`

**Arguments:**
- `index` - Index of a header in the display channel list (between 1 and `GetNumDisplayChannels()`) (`number`)

**See also:** Channel functions.


## ExpandCurrencyList

Expands or collapses a list header in the Currency UI

**Signature:** `ExpandCurrencyList(index, shouldExpand)`

**Arguments:**
- `index` - Index of a header in the currency list (between 1 and GetCurrencyListSize()) (`number`)
- `shouldExpand` - 1 to expand the header, showing its contents; 0 to collapse the header, hiding its contents (`number`)

**See also:** Currency functions.


## ExpandFactionHeader

Expands a given faction header or sub-header in the Reputation UI. 
Faction headers include both major groups (Classic, Burning Crusade, Wrath of the Lich King, Inactive, etc.) and the sub-groups within them (Alliance Forces, Steamwheedle Cartel, Horde Expedition, Shattrath City, etc.).

**Signature:** `ExpandFactionHeader(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**See also:** Faction functions.


## ExpandQuestHeader

Expands a quest header in the quest log

**Signature:** `ExpandQuestHeader(questIndex)`

**Arguments:**
- `questIndex` - Index of a header in the quest log (between 1 and `GetNumQuestLogEntries()`), or 0 to expand all headers (`number`)

**See also:** Quest functions.


## ExpandSkillHeader

Expands a group header in the Skills UI

**Signature:** `ExpandSkillHeader(index)`

**Arguments:**
- `index` - Index of an entry in the skills list (between 1 and `GetNumSkillLines()`) (`number`)


## ExpandTradeSkillSubClass

Expands a group header in the trade skill listing. Causes an error if `index` does not refer to a header.

**Signature:** `ExpandTradeSkillSubClass(index)`

**Arguments:**
- `index` - Index of a header in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**See also:** Tradeskill functions.


## ExpandTrainerSkillLine

_No snapshot available (page did not exist in archive)._

