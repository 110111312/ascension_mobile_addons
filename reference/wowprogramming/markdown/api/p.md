# WoW API Functions — P

_58 functions_

---

## pairs

Returns an iterator function for a table. Return values are such that the construction

` for k,v in pairs(t)
 -- body
 end
`

will iterate over all key/value pairs in the table.

**Signature:** `iterator, t, index = pairs(t)`

**Arguments:**
- `t` - A table (`table`)

**Returns:**
- `iterator` - The `next()` function (`function`)
- `t` - The table provided (`table`)
- `index` - Always nil; used internally (`number`)

**See also:** Lua library functions.


## PartialPlayTime

Returns whether the player is near the allowed play time limit. When in this state, the player receives half the normal amount of money and XP from kills and quests and cannot use trade skills; returning to normal requires logging out of the game for a period of time (see `GetBillingTimeRested`).

Only used in locales where the length of play sessions is restricted (e.g. mainland China).

**Signature:** `partialPlayTime = PartialPlayTime()`

**Returns:**
- `partialPlayTime` - 1 if the character gains only partial xp, nil if not. (`1nil`)

**See also:** Limited play time functions.


## PartyLFGStartBackfill


## pcall

Executes a function in protected mode. When running a function in protected mode, any errors do not propagate beyond the function (i.e. they do not stop all execution and call the default error handler).

**Signature:** `status, ... = pcall(f, ...)`

**Arguments:**
- `f` - A function (`function`)
- `...` - Arguments to be passed to the function (`list`)

**Returns:**
- `status` - True if the function succeeded without errors; false otherwise (`boolean`)
- `...` - If `status` is `false`, the error message produced by the function; if `status` is `true`, the return values from the function (`list or string`)

**See also:** Lua library functions.


## PetAbandon

Releases the player's pet. For Hunter pets, this function sends the pet away, never to return (in the default UI, it's called when accepting the "Are you sure you want to permanently abandon your pet?" dialog). For other pets, this function is equivalent to `PetDismiss()`.

**Signature:** `PetAbandon()`

**See also:** Pet functions.


## PetAggressiveMode

Enables aggressive mode for the player's pet. In this mode, the pet automatically attacks any nearby hostile targets.

**Signature:** `PetAggressiveMode()`


## PetAttack

Instructs the pet to attack. The pet will attack the player's current target if no unit is specified.

**Signature:** `PetAttack(["unit"]) or PetAttack(["name"])`

**Arguments:**
- `unit` - A unit to attack (`string`, unitID)
- `name` - The name of a unit to attack (`string`)


## PetCanBeAbandoned

Returns whether the player's pet can be abandoned. Only Hunter pets can be permanently abandoned.

**Signature:** `canAbandon = PetCanBeAbandoned()`

**Returns:**
- `canAbandon` - 1 if the player's pet can be abandoned, otherwise nil (`1nil`)


## PetCanBeDismissed

Returns whether a Dismiss Pet command should be available for the player's pet. Returns 1 for hunter pets even though they use the Dismiss Pet (cast) spell instead of a Dismiss Pet (instant) command; the value of `PetCanBeAbandoned()` overrides this in causing the default UI to hide the command. Currently unused, but may be used in the future for other pets.

**Signature:** `canDismiss = PetCanBeDismissed()`

**Returns:**
- `canDismiss` - 1 if a Dismiss Pet command should be available for the player's pet; otherwise nil (`1nil`)


## PetCanBeRenamed

Returns whether the player's pet can be renamed. Only hunter pets can be renamed, and only once (barring use of a Certificate of Ownership).

**Signature:** `canRename = PetCanBeRenamed()`

**Returns:**
- `canRename` - 1 if the player can rename the currently controlled pet, otherwise nil (`1nil`)

**See also:** Pet functions.


## PetDefensiveMode

Enables defensive mode for the player's pet. In this mode, the pet automatically attacks only units which attack it or the player or units the player is attacking.

**Signature:** `PetDefensiveMode()`


## PetDismiss

Dismisses the currently controlled pet. Used for dismissing Warlock pets, Mind Control targets, etc. Has no effect for Hunter pets, which can only be dismissed using the Dismiss Pet spell.

**Signature:** `PetDismiss()`


## PetFollow

Instructs the pet to follow the player. If the pet is currently attacking a target, the pet will stop attacking.

**Signature:** `PetFollow()`


## PetHasActionBar

Returns whether the player's current pet has an action bar

**Signature:** `hasActionBar = PetHasActionBar()`

**Returns:**
- `hasActionBar` - Returns 1 if the player's pet has an action bar; otherwise nil (`1nil`)

**See also:** Pet functions.


## PetPassiveMode

Enables passive mode for the player's pet. In this mode, the pet will not automatically attack any target.

**Signature:** `PetPassiveMode()`


## PetRename

Renames the currently controlled pet. Only Hunter pets can be renamed, and a given pet can only be renamed once (barring use of a Certificate of Ownership).

**Signature:** `PetRename("name" [, "genitive" [, "dative" [, "accusative" [, "instrumental" [, "prepositional"]]]]])`

**Arguments:**
- `name` - New name for the pet (nominative form on Russian clients) (`string`)
- `genitive` - Genitive form of the pet's new name; applies only on Russian clients (`string`)
- `dative` - Dative form of the pet's new name; applies only on Russian clients (`string`)
- `accusative` - Accusative form of the pet's new name; applies only on Russian clients (`string`)
- `instrumental` - Instrumental form of the pet's new name; applies only on Russian clients (`string`)
- `prepositional` - Prepositional form of the pet's new name; applies only on Russian clients (`string`)

**See also:** Pet functions.


## PetStopAttack

Instructs the pet to stop attacking

**Signature:** `PetStopAttack()`

**See also:** Pet functions.


## PetWait

Instructs the pet to stay at its current location. If the pet is currently attacking a target, the pet will stop attacking.

**Signature:** `PetWait()`

**See also:** Pet functions.


## PickupAction

Puts the contents of an action bar slot onto the cursor or the cursor contents into an action bar slot. After an action is picked up via this function, it can only be placed into other action bar slots (with `PlaceAction()` or by calling `PickupAction()` again), even if the action is an item which could otherwise be placed elsewhere. Unlike many other "pickup" cursor functions, this function removes the picked-up action from the source slot -- an action slot can be emptied by calling this function followed by `ClearCursor()`.

If the action slot is empty and the cursor already holds an action, a spell, a companion (mount or non-combat pet), a macro, an equipment set, or an item (with a "Use:" effect), it is put into the action slot. If both the cursor and the slot hold an action (or any of the above data types), the contents of the cursor and the slot are exchanged.

**Signature:** `PickupAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**See also:** Action functions, Cursor functions.


## PickupBagFromSlot

Puts an equipped container onto the cursor

**Signature:** `PickupBagFromSlot(slot)`

**Arguments:**
- `slot` - An inventory slot containing a bag (see `GetInventorySlotInfo()`, `ContainerIDToInventoryID()`) (`number`, inventoryID)

**See also:** Container functions, Cursor functions.


## PickupCompanion

Puts a non-combat pet or mount onto the cursor

**Signature:** `PickupCompanion("type", index)`

**Arguments:**
- `type` - Type of companion (`string`) 

 - `CRITTER` - A non-combat pet
- `MOUNT` - A mount
- `index` - Index of a companion (between 1 and `GetNumCompanions(type)`) (`number`)

**See also:** Companion functions, Cursor functions.


## PickupContainerItem

Picks up an item from or puts an item into a slot in one of the player's bags or other containers. If the cursor is empty and the referenced container slot contains an item, that item is put onto the cursor. If the cursor contains an item and the slot is empty, the item is placed into the slot. If both the cursor and the slot contain items, the contents of the cursor and the container slot are exchanged.

An item picked up from a container is not removed from its slot (until put elsewhere); when an item is picked up, the slot becomes locked, preventing other changes to its contents until the disposition (movement, trade, mailing, auctioning, destruction, etc) of the picked-up item is resolved.

**Signature:** `PickupContainerItem(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)


## PickupEquipmentSet

Puts an equipment set (specified by index) on the cursor. Can be used to place an equipment set in an action bar slot.

**Signature:** `PickupEquipmentSet(index)`

**Arguments:**
- `index` - Index of an equipment set (between 1 and `GetNumEquipmentSets()`) (`number`)

**See also:** Equipment Manager functions.


## PickupEquipmentSetByName

Puts an equipment set on the cursor. Can be used to place an equipment set in an action bar slot.

**Signature:** `PickupEquipmentSetByName("name")`

**Arguments:**
- `name` - Name of an equipment set (case sensitive) (`string`)

**See also:** Equipment Manager functions.


## PickupGuildBankItem

Picks up an item from or puts an item into the guild bank. If the cursor is empty and the referenced guild bank slot contains an item, that item is put onto the cursor. If the cursor contains an item and the slot is empty, the item is placed into the slot. If both the cursor and the slot contain items, the contents of the cursor and the guild bank slot are exchanged.

**Signature:** `PickupGuildBankItem(tab, slot)`

**Arguments:**
- `tab` - Index of a guild bank tab (`number`)
- `slot` - Index of an item slot in the guild bank tab (`number`)


## PickupGuildBankMoney

Puts money from the guild bank onto the cursor. Money is not actually withdrawn from the guild bank; in the default UI, when the cursor "puts" the money into one of the player's bags, it calls `WithdrawGuildBankMoney()`.

**Signature:** `PickupGuildBankMoney(amount)`

**Arguments:**
- `amount` - Amount of money to pick up (in copper) (`number`)


## PickupInventoryItem

Picks up an item from or puts an item into an equipment slot. If the cursor is empty and the referenced inventory slot contains an item, that item is put onto the cursor. If the cursor contains an item (which can be equipped in the slot) and the slot is empty, the item is placed into the slot. If both the cursor and the slot contain items, the contents of the cursor and the inventory slot are exchanged.

An item picked up from an inventory slot is not removed from the slot (until put elsewhere); when an item is picked up, the slot becomes locked, preventing other changes to its contents until the disposition (movement, trade, destruction, etc) of the picked-up item is resolved.

**Signature:** `PickupInventoryItem(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)


## PickupItem

Puts an arbitrary item onto the cursor. Puts an item onto the cursor regardless of its location (equipped, bags, bank or not even in the player's possession); can be used to put an item into an action slot (see `PlaceAction()`) even if the player does not currently hold the item. Since the item is not picked up from a specific location, this function cannot be used to move an item to another bag, trade it to another player, attach it to a mail message, destroyed, etc.

**Signature:** `PickupItem(itemID) or PickupItem("itemName") or PickupItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**See also:** Item functions, Cursor functions.


## PickupMacro

Puts a macro onto the cursor

**Signature:** `PickupMacro(index) or PickupMacro("name")`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**See also:** Macro functions, Cursor functions.


## PickupMerchantItem

Puts an item available for purchase from a vendor onto the cursor

**Signature:** `PickupMerchantItem(index)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)

**See also:** Merchant functions, Cursor functions.


## PickupPetAction

Puts the contents of a pet action slot onto the cursor or the cursor contents into a pet action slot. Only pet actions and spells from the "pet" portion of the spellbook can be placed into pet action slots.

If the cursor is empty and the referenced pet action slot contains an action, that action is put onto the cursor (but remains in the slot). If the cursor contains a pet action or pet spell and the slot is empty, the action/spell is placed into the slot. If both the cursor and the slot contain pet actions, the contents of the cursor and the pet action slot are exchanged.

**Signature:** `PickupPetAction(index)`

**Arguments:**
- `index` - Index of a pet action (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)

**See also:** Pet functions, Action functions, Cursor functions.


## PickupPlayerMoney

Puts an amount of the player's money onto the cursor. Money is not immediately deducted from the player's total savings (though it appears such on the default UI's money displays, which generally show `GetMoney()``-``GetCursorMoney()`).

**Signature:** `PickupPlayerMoney(amount)`

**Arguments:**
- `amount` - Amount of money to put on the cursor (in copper) (`number`)

**See also:** Money functions, Cursor functions.


## PickupSpell

Puts a spell from the player's or pet's spellbook onto the cursor

**Signature:** `PickupSpell(id, "bookType")`

**Arguments:**
- `id` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook


## PickupStablePet

Puts a pet from the stables onto the cursor. Use with `ClickStablePet` to move pets between stabled and active status.

**Signature:** `PickupStablePet(index)`

**Arguments:**
- `index` - Index of a stable slot (`number`) 

 - `0` - Active pet
- `1 to NUM_PET_STABLE_SLOTS` - A stable slot

**See also:** Pet Stable functions, Cursor functions.


## PickupTradeMoney

Puts money offered by the player for trade onto the cursor. Money put onto the cursor is subtracted from the amount offered for trade (see `GetPlayerTradeMoney()`).

**Signature:** `PickupTradeMoney(amount)`

**Arguments:**
- `amount` - Amount of money to take from the trade window (in copper) (`number`)

**See also:** Trade functions, Money functions, Cursor functions.


## PitchDownStart

Begins adjusting the player character's angle of vertical movement downward. Affects only the angle or slope of movement for swimming or flying; has no immediately visible effect if the player is not moving, but alters the trajectory followed as soon as the player begins moving. Continuously adjusts pitch until the minimum angle is reached or `PitchDownStop()` is called.

Used by the `PITCHDOWN` binding.

**Signature:** `PitchDownStart()`

**See also:** Movement functions.


## PitchDownStop

Ends movement initiated by `PitchDownStart`

**Signature:** `PitchDownStop()`

**See also:** Movement functions.


## PitchUpStart

Begins adjusting the player character's angle of vertical movement upward. Affects only the angle or slope of movement for swimming or flying; has no immediately visible effect if the player is not moving, but alters the trajectory followed as soon as the player begins moving. Continuously adjusts pitch until the maximum angle is reached or `PitchUpStop()` is called.

Used by the `PITCHUP` binding.

**Signature:** `PitchUpStart()`


## PitchUpStop

Ends movement initiated by `PitchUpStart`

**Signature:** `PitchUpStop()`


## PlaceAction

Puts the contents of the cursor into an action bar slot. If the action slot is empty and the cursor already holds an action, a spell, a companion (mount or non-combat pet), a macro, an equipment set, or an item (with a "Use:" effect), it is put into the action slot. If both the cursor and the slot hold an action (or any of the above data types), the contents of the cursor and the slot are exchanged.

Does nothing if the cursor is empty.

**Signature:** `PlaceAction(slot)`

**Arguments:**
- `slot` - Destination action bar slot (`number`, actionID)

**See also:** Action functions, Cursor functions.


## PlaceAuctionBid

Places a bid on (or buys out) an auction item. Attempting to bid an amount equal to or greater than the auction's buyout price will buy out the auction (spending only the exact buyout price) instead of placing a bid.

**Signature:** `PlaceAuctionBid("list", index, bid)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of an auction in the listing (`number`)
- `bid` - Amount to bid (in copper) (`number`)


## PlaceGlyphInSocket

Applies the glyph currently awaiting a target to a socket. Only valid during glyph application: when the player has activated the glyph item but before she has chosen the glyph slot to put it in (i.e. the glowing hand cursor is showing).

This function does not ask for confirmation before overwriting an existing glyph. However, calling this function only begins the "spellcast" that applies the glyph, so canceling glyph application is still possible.

**Signature:** `PlaceGlyphInSocket(socket)`

**Arguments:**
- `socket` - Which glyph socket to apply the glyph to (between 1 and `NUM_GLYPH_SLOTS`) (`number`, glyphIndex)

**See also:** Glyph functions.


## PlayDance

**Signature:** `PlayDance()`


## PlayerCanTeleport

Returns whether the player can accept a summons

**Signature:** `amount = PlayerCanTeleport()`

**Returns:**
- `amount` - True if the player is currently allowed to accept a summons (`boolean`)

**See also:** Summoning functions.


## PlayerIsPVPInactive

Returns whether a battleground participant is inactive (and eligible for reporting as AFK)

**Signature:** `isInactive = PlayerIsPVPInactive("name") or PlayerIsPVPInactive("unit")`

**Arguments:**
- `name` - Name of a friendly player unit in the current battleground (`string`)
- `unit` - A friendly player unit in the current battleground (`string`, unitID)

**Returns:**
- `isInactive` - True if the unit can be reported as AFK; otherwise false (`boolean`)

**See also:** Battlefield functions, Complaint functions.


## PlayMusic

Plays an audio file as background music. Any other background music that is currently playing will be faded out as the new music begins; if the `Sound_ZoneMusicNoDelay` is set, music will loop continuously until `StopMusic()` is called.

WoW supports WAV, MP3 and Ogg audio formats.

**Signature:** `PlayMusic("musicfile")`

**Arguments:**
- `musicfile` - Path to a music file (`string`)

**See also:** Sound functions.


## PlaySound

Plays one of WoW's built-in sound effects. Only supports sounds found in the `Sound\Interface` directory within WoW's MPQ files; to play other built-in sounds or sounds in an addon directory, use `PlaySoundFile()`.

**Signature:** `PlaySound("sound")`

**Arguments:**
- `sound` - Name of a built-in sound effect (`string`)


## PlaySoundFile

Plays an audio file at a given path. For a shorter way to specify one of WoW's built-in UI sound effects, see `PlaySound()`.

WoW supports WAV, MP3 and Ogg audio formats.

**Signature:** `PlaySoundFile("soundFile")`

**Arguments:**
- `soundFile` - A path to the sound file to be played (`string`)


## PositionMiniWorldMapArrowFrame


## PositionWorldMapArrowFrame


## PrevView

Moves the camera to the previous predefined setting. There are five "slots" for saved camera settings, indexed 1-5. These views can be set and accessed directly using `SaveView()` and `SetView()`, and cycled through using `NextView()` and `PrevView()`.

**Signature:** `PrevView()`


## ProcessMapClick

Possibly changes the WorldMap based on a mouse click. May change the map zone or zoom based on the click location: e.g. if the world map shows Dragonblight and one clicks in the area labeled "Wintergrasp" on the map, the current map zone changes to show Wintergrasp.

**Signature:** `ProcessMapClick(clickX, clickY)`

**Arguments:**
- `clickX` - Horizontal position of the click relative to the current world map (0 = left edge, 1 = right edge) (`number`)
- `clickY` - Vertical position of the click relative to the current world map (0 = top, 1 = bottom) (`number`)

**See also:** Map functions.


## ProcessQuestLogRewardFactions


## PromoteToAssistant

Promotes a raid member to raid assistant

**Signature:** `PromoteToAssistant("unit") or PromoteToAssistant("name" [, exactMatch])`

**Arguments:**
- `unit` - A unit in the raid (`string`, unitID)
- `name` - Name of a unit in the raid (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Raid functions.


## PromoteToLeader

Promotes a player to party/raid leader

**Signature:** `PromoteToLeader("unit") or PromoteToLeader("name" [, exactMatch])`

**Arguments:**
- `unit` - A unit in the party or raid (`string`, unitID)
- `name` - Name of a party member (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Party functions, Raid functions.


## PurchaseSlot

Purchases the next available bank slot. Only available while interacting with a banker NPC (i.e. between the `BANKFRAME_OPENED` and `BANKFRAME_CLOSED` events).

**Signature:** `PurchaseSlot()`


## PutItemInBackpack

Puts the item on the cursor into the player's backpack. The item will be placed in the lowest numbered slot (`containerSlotID`) in the player's backpack.

Causes an error message (`UI_ERROR_MESSAGE`) if the backpack is full.

**Signature:** `hadItem = PutItemInBackpack()`

**Returns:**
- `hadItem` - 1 if the cursor had a item; otherwise nil (`1nil`)


## PutItemInBag

Puts the item on the cursor into one of the player's bags or other containers. The item will be placed in the lowest numbered slot (`containerSlotID`) in the container.

Causes an error message (`UI_ERROR_MESSAGE`) if the container is full. Cannot be used to place an item into the player's backpack; see `PutItemInBackpack()`.

**Signature:** `hadItem = PutItemInBag(container)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)

**Returns:**
- `hadItem` - 1 if the cursor had a item; otherwise nil (`1nil`)

