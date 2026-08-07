# WoW API Functions — I

_140 functions_

---

## InboxItemCanDelete

Returns whether a message in the player's inbox can be deleted

**Signature:** `canDelete = InboxItemCanDelete(mailID)`

**Arguments:**
- `mailID` - Index of a message in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**Returns:**
- `canDelete` - 1 if the message can be deleted; otherwise nil (`1nil`)


## InCinematic

Returns whether an in-game cinematic is playing. Applies to in-game-engine cinematics (such as when logging into a new character for the first time), not prerecorded movies.

**Signature:** `inCinematic = InCinematic()`

**Returns:**
- `inCinematic` - 1 if an in-game cinematic is playing; otherwise nil (`1nil`)

**See also:** In-game movie playback functions.


## InCombatLockdown

Returns whether the user interface is protected due to combat. Non-Blizzard code is allowed to perform certain UI actions (such as changing secure template attributes or moving/showing/hiding secure frames) only if the player is not in combat; this function can be used to determine whether such actions are currently available.

**Signature:** `inLockdown = InCombatLockdown()`

**Returns:**
- `inLockdown` - 1 if the user interface is protected due to combat; otherwise nil (`1nil`)

**See also:** Secure execution utility functions.


## InitiateTrade

Offers to trade with a given unit. The trade process does not begin immediately; once the server has determined both clients can trade, the `TRADE_SHOW` event fires.

**Signature:** `InitiateTrade("unit") or InitiateTrade("name")`

**Arguments:**
- `unit` - A unit with which to trade (`string`, unitID)
- `name` - The name of a unit with which to trade; only valid for nearby units in the player's party/raid (`string`)

**See also:** Trade functions.


## InitWorldMapPing

Initializes the frame used to display the character location "ping" on the World Map

**Signature:** `InitWorldMapPing()`


## InRepairMode

Returns whether the item repair cursor mode is currently active. Repair mode is entered by calling `ShowRepairCursor()` and exited by calling `HideRepairCursor()`; while in repair mode, calling `PickupContainerItem()` or `PickupInventoryItem()` will attempt to repair the item (and deduct the cost of such from the player's savings) instead of putting it on the cursor.

**Signature:** `inRepair = InRepairMode()`

**Returns:**
- `inRepair` - 1 if repair mode is currently active; otherwise nil (`1nil`)

**See also:** Merchant functions, Cursor functions.


## InteractUnit

Interacts with (as with right-clicking on) a unit

**Signature:** `InteractUnit(unit)`

**Arguments:**
- `unit` - The unit to interact with (`unitid`)

**See also:** Movement functions.


## InterfaceOptions_AddCategory

Registers a panel to be displayed in the Interface Options window. The following members and methods are used by the Interface Options frame to display and organize panels:

 
 - 
`panel.name` - `string` (required) - The name of the AddOn or group of configuration options. This is the text that will display in the AddOn options list.

 
 - 
`panel.parent` - `string` (optional) - Name of the parent of the AddOn or group of configuration options. This identifies "panel" as the child of another category. If the parent category doesn't exist, "panel" will be displayed as a regular category.

 
 - 
`panel.okay` - `function` (optional) - This method will run when the player clicks "okay" in the Interface Options. 

 
 - 
`panel.cancel` - `function` (optional) - This method will run when the player clicks "cancel" in the Interface Options. Use this to revert their changes.

 
 - 
`panel.default` - `function` (optional) - This method will run when the player clicks "defaults". Use this to revert their changes to your defaults.

 
 - 
`panel.refresh` - `function` (optional) - This method will run when the Interface Options frame calls its OnShow function and after defaults have been applied via the panel.default method described above. Use this to refresh your panel's UI in case settings were changed without player interaction.

**Signature:** `InterfaceOptions_AddCategory(panel)`

**Arguments:**
- `panel` - A Frame object (`table`)

> **Note:** This function is not a C API but a Lua function declared in Blizzard's default user interface. Its implementation can be viewed by extracting the addon data using the Addon Kit provided by Blizzard.

**See also:** Addon-related functions.


## InterfaceOptionsFrame_OpenToCategory

Opens the Interface Options window and displays a given panel within it

**Signature:** `InterfaceOptionsFrame_OpenToCategory("panelName") or InterfaceOptionsFrame_OpenToCategory(panel)`

**Arguments:**
- `panelName` - The registered name of an options panel (`string`)
- `panel` - A Frame object already registered as an options panel (`table`)


## InviteUnit

Invites a character to the player's party or raid

**Signature:** `InviteUnit("name")`

**Arguments:**
- `name` - Name of a character to invite (`string`)


## ipairs

Returns an iterator function for integer keys in a table. Return values are such that the construction

` for k,v in ipairs(t) do
 -- body
 end
`

will iterate over the pairs `1,t[1]`, `2,t[2]`, etc, up to the first integer key absent from the table.

**Signature:** `iterator, t, index = ipairs(t)`

**Arguments:**
- `t` - A table (`table`)

**Returns:**
- `iterator` - An iterator (`function`)
- `t` - The table provided (`table`)
- `index` - Always 0; used internally (`number`)

**See also:** Lua library functions.


## IsActionInRange

Returns whether the player's target is in range of an action

**Signature:** `inRange = IsActionInRange(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `inRange` - 1 if the player's target is in range for the action or 0 if out of range; nil if the action cannot be used on the player's target regardless of range (`number`)


## IsActiveBattlefieldArena

Returns whether the player is currently in an arena match

**Signature:** `isArena, isRegistered = IsActiveBattlefieldArena()`

**Returns:**
- `isArena` - 1 if player is in an Arena match; otherwise nil (`1nil`)
- `isRegistered` - 1 if the current arena match is a ranked match; otherwise nil (`1nil`)

**See also:** Battlefield functions, Arena functions.


## IsActiveQuestTrivial

Returns whether a quest which can be turned in to the current Quest NPC is trivial at the player's level. Only returns valid information after a `QUEST_GREETING` event. Used in the default UI to display "(low level)" when listing the quest.

Note: Most quest NPCs present active quests using the `GetGossipActiveQuests()` instead of this function.

**Signature:** `trivial = IsActiveQuestTrivial(index)`

**Arguments:**
- `index` - Index of a quest which can be turned in to the current Quest NPC (between 1 and `GetNumActiveQuests()`) (`number`)

**Returns:**
- `trivial` - 1 if the quest is trivial at the player's level; otherwise nil (`1nil`)


## IsAddOnLoaded

Returns whether an addon is currently loaded

**Signature:** `loaded = IsAddOnLoaded("name") or IsAddOnLoaded(index)`

**Arguments:**
- `name` - Name of an addon (name of the addon's folder and TOC file, not the Title found in the TOC) (`string`)
- `index` - Index of an addon in the addon list (between 1 and `GetNumAddOns()`) (`number`)

**Returns:**
- `loaded` - 1 if the addon is loaded; otherwise nil (`1nil`)


## IsAddOnLoadOnDemand

Returns whether an addon can be loaded without restarting the UI

**Signature:** `isLod = IsAddOnLoadOnDemand("name") or IsAddOnLoadOnDemand(index)`

**Arguments:**
- `name` - Name of an addon (name of the addon's folder and TOC file, not the Title found in the TOC) (`string`)
- `index` - Index of an addon in the addon list (between 1 and `GetNumAddOns()`) (`number`)

**Returns:**
- `isLod` - 1 if the addon is LoadOnDemand-capable; otherwise nil (`1nil`)

**See also:** Addon-related functions.


## IsAltKeyDown

Returns whether an Alt key on the keyboard is held down.

**Signature:** `isDown = IsAltKeyDown()`

**Returns:**
- `isDown` - 1 if an Alt key on the keyboard is currently held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsArenaTeamCaptain

Returns whether the player is the captain of an arena team. Also returns 1 if the player is not on a team of the given `arenaTeamID`.

**Signature:** `isCaptain = IsArenaTeamCaptain(team)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)

**Returns:**
- `isCaptain` - 1 if the player is the captain of the given team; otherwise nil. (`1nil`)

**See also:** Arena functions.


## IsAtStableMaster

Returns whether the player is interacting with a Stable Master NPC. The Pet Stable UI/API can be active without an NPC if the player is using the Call Stabled Pet ability. New stable slots can only be purchased while talking to an NPC -- the default UI uses this function to determine whether to show UI elements related to purchasing slots.

**Signature:** `isAtNPC = IsAtStableMaster()`

**Returns:**
- `isAtNPC` - True if the player is interacting with a Stable Master NPC; otherwise false (`boolean`)

**See also:** Pet Stable functions.


## IsAttackAction

Returns whether an action is the standard melee Attack action. Used in the default UI to flash the action button while auto-attack is active. Does not apply to other repeating actions such as Auto Shot (for hunters) and Shoot (for wand users); for those, see `IsAutoRepeatAction`.

**Signature:** `isAttack = IsAttackAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isAttack` - 1 if the action enables/disables melee auto-attack; otherwise nil (`1nil`)

**See also:** Action functions.


## IsAttackSpell

Returns whether a spell is the standard melee Attack spell

**Signature:** `isAttack = IsAttackSpell(index, "bookType") or IsAttackSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isAttack` - 1 if the spell enables/disables melee auto-attack; otherwise nil (`1nil`)

**See also:** Spell functions.


## IsAuctionSortReversed

Returns whether a sort criterion is applied in reverse order. No longer used in the default UI; see `GetAuctionSort()` instead.

**Signature:** `isReversed, isSorted = IsAuctionSortReversed("list", "sort")`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `sort` - A sort criterion (`string`)

**Returns:**
- `isReversed` - 1 if the criterion is applied in reverse order; otherwise nil (`1nil`)
- `isSorted` - 1 if the criterion is currently used for the given listing; otherwise nil (`1nil`)


## IsAutoRepeatAction

Returns whether an action is an automatically repeating action. Used in the default UI to flash the action button while the action is repeating. Applies to actions such as Auto Shot (for hunters) and Shoot (for wand and other ranged weapon users) but not to the standard melee Attack action; for it, see `IsAttackAction`.

**Signature:** `isRepeating = IsAutoRepeatAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isRepeating` - 1 if the action is an auto-repeat action; otherwise nil (`1nil`)

**See also:** Action functions.


## IsAutoRepeatSpell

Returns whether a spell is an automatically repeating spell

**Signature:** `isAutoRepeat = IsAutoRepeatSpell("spellName")`

**Arguments:**
- `spellName` - The name of the spell to query (`string`)

**Returns:**
- `isAutoRepeat` - If the spell is an auto-repeating spell (`1nil`)


## IsAvailableQuestTrivial

Returns whether a quest available from the current Quest NPC is trivial at the player's level. Only returns valid information after a `QUEST_GREETING` event. Used in the default UI to display "(low level)" when listing the quest.

Note: Most quest NPCs present available quests using the `GetGossipAvailableQuests()` instead of this function.

**Signature:** `trivial = IsAvailableQuestTrivial(index)`

**Arguments:**
- `index` - Index of a quest available from the current Quest NPC (between 1 and `GetNumAvailableQuests()`) (`number`)

**Returns:**
- `trivial` - 1 if the quest is trivial at the player's level; otherwise nil (`1nil`)

**See also:** Quest functions.


## IsBattlefieldArena

_No snapshot available (page did not exist in archive)._


## IsBNLogin


## IsConsumableAction

Returns whether using an action consumes an item. Applies both to consumable items (such as food and potions) and to spells which use a reagent (e.g. Prayer of Fortitude, Divine Intervention, Water Walking, Portal: Dalaran).

**Signature:** `isConsumable = IsConsumableAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isConsumable` - 1 if using the action consumes an item; otherwise nil (`1nil`)

**See also:** Action functions.


## IsConsumableItem

Returns whether an item is consumable. Indicates whether the item is destroyed upon use, not necessarily whether it belongs to the "Consumable" type/class.

**Signature:** `consumable = IsConsumableItem(itemID) or IsConsumableItem("itemName") or IsConsumableItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `consumable` - 1 if the item is consumable; otherwise nil (`1nil`)


## IsConsumableSpell

Returns whether casting a spell consumes a reagent item

**Signature:** `isConsumable = IsConsumableSpell(index, "bookType") or IsConsumableSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isConsumable` - 1 if casting the spell consumes a reagent item; otherwise nil (`1nil`)

**See also:** Spell functions.


## IsControlKeyDown

Returns whether a Control key on the keyboard is held down

**Signature:** `isDown = IsControlKeyDown()`

**Returns:**
- `isDown` - 1 if a Control key on the keyboard is currently held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsCurrentAction

Returns whether an action is currently being used

**Signature:** `isCurrent = IsCurrentAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isCurrent` - 1 if the action is currently being cast, is waiting for the user to choose a target, is a repeating action which is currently repeating, or is the open trade skill; otherwise nil (`1nil`)


## IsCurrentItem

_No snapshot available (page did not exist in archive)._


## IsCurrentQuestFailed

Returns whether the player has failed the selected quest in the quest log

**Signature:** `isFailed = IsCurrentQuestFailed()`

**Returns:**
- `isFailed` - 1 if the player has failed the quest; otherwise nil (`1nil`)

**See also:** Quest functions.


## IsCurrentSpell

Returns whether a spell is currently being used

**Signature:** `isCurrent = IsCurrentSpell(index, "bookType") or IsCurrentSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isCurrent` - 1 if the spell is currently being cast, is waiting for the user to choose a target, is a repeating spell which is currently repeating, or is the open trade skill; otherwise nil (`1nil`)

**See also:** Spell functions.


## IsDebugBuild

**Signature:** `IsDebugBuild()`


## IsDesaturateSupported

Returns whether the current hardware supports desaturated textures

**Signature:** `isSupported = IsDesaturateSupported()`

**Returns:**
- `isSupported` - 1 if texture desaturation is supported; otherwise nil (`1nil`)

**See also:** Video functions.


## IsDisplayChannelModerator

Returns whether the player is a moderator of the selected channel in the channel list display

**Signature:** `isModerator = IsDisplayChannelModerator()`

**Returns:**
- `isModerator` - 1 if the player is a moderator of the selected channel; otherwise nil (`1nil`)


## IsDisplayChannelOwner

Returns whether the player is the owner of the selected channel in the channel list display

**Signature:** `isOwner = IsDisplayChannelOwner()`

**Returns:**
- `isOwner` - 1 if the player is the owner of the selected channel; otherwise nil (`1nil`)

**See also:** Channel functions.


## IsDressableItem

Returns whether an item's appearance can be previewed using the Dressing Room feature

**Signature:** `isDressable = IsDressableItem(itemID) or IsDressableItem("itemName") or IsDressableItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `isDressable` - 1 if the item's appearance can be previewed using the Dressing Room feature; otherwise nil (`1nil`)


## IsEquippableItem

Returns whether an item can be equipped. Indicates whether an item is capable of being equipped on a character, not necessarily whether the player character is able to wear it.

**Signature:** `isEquippable = IsEquippableItem(itemID) or IsEquippableItem("itemName") or IsEquippableItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `isEquippable` - 1 if the item can be equipped, otherwise nil (`1nil`)

**See also:** Item functions.


## IsEquippedAction

Returns whether an action contains an equipped item. Applies to actions involving equippable items (not to consumables or other items with "Use:" effects) and indicates the effect of performing the action: if an action's item is not equipped, using the action will equip it; if the item is equipped and has a "Use:" effect, using the action will activate said effect.

**Signature:** `isEquipped = IsEquippedAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isEquipped` - 1 if the action contains an equipped item; otherwise nil (`1nil`)

**See also:** Action functions.


## IsEquippedItem

Returns whether an item is currently equipped

**Signature:** `isEquipped = IsEquippedItem(itemID) or IsEquippedItem("itemName") or IsEquippedItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `isEquipped` - 1 if the item is equipped on the player character; otherwise nil (`1nil`)


## IsEquippedItemType

Returns whether any items of a given type are currently equipped. Possible arguments include the localized names of item classes (as returned from `GetAuctionItemClasses`; e.g. "Weapon", "Armor"), subclasses (as returned from `GetAuctionItemSubClasses`; e.g. "One-handed axes", "Shields", "Cloth"), and the global tokens or localized names for equip locations (as returned from `GetAuctionInvTypes`; e.g. "INVTYPE_WEAPONMAINHAND", "Off Hand").

**Signature:** `isEquipped = IsEquippedItemType("type")`

**Arguments:**
- `type` - Name of an item class, subclass, or equip location (`string`)

**Returns:**
- `isEquipped` - 1 if the player has equipped any items of the given type; otherwise nil (`1nil`)


## IsFactionInactive

Returns whether a faction is flagged as "inactive". "Inactive" factions behave no differently; the distinction only exists to allow players to hide factions they don't care about from the main display. Factions thus marked are automatically moved to an "Inactive" group at the end of the faction list.

**Signature:** `isInactive = IsFactionInactive(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**Returns:**
- `isInactive` - 1 if the faction is currently flagged as "inactive"; otherwise nil (`1nil`)


## IsFalling

Returns whether the player is currently falling

**Signature:** `falling = IsFalling()`

**Returns:**
- `falling` - 1 if the player is falling; otherwise nil (`1nil`)

**See also:** Player information functions.


## IsFishingLoot

Returns whether the currently displayed loot came from fishing. Used in the default UI to play a fishing sound effect and change the appearance of the loot window.

**Signature:** `isFishing = IsFishingLoot()`

**Returns:**
- `isFishing` - 1 if the currently displayed loot is fishing loot; otherwise nil (`1nil`)

**See also:** Loot functions.


## IsFlyableArea

Returns whether or not the player's current location is a flyable area

**Signature:** `isFlyable = IsFlyableArea()`

**Returns:**
- `isFlyable` - 1 if the current area is a flyable area, otherwise nil (`1nil`)


## IsFlying

Returns whether the player is currently flying

**Signature:** `isFlying = IsFlying()`

**Returns:**
- `isFlying` - 1 if the player is currently flying; otherwise nil (`1nil`)

**See also:** Player information functions.


## IsGuildLeader

Returns whether or player is leader of his or her guild

**Signature:** `isLeader = IsGuildLeader()`

**Returns:**
- `isLeader` - 1 if the player is a guild leader; otherwise nil (`1nil`)


## IsHarmfulItem

Returns whether an item can be used against hostile units. Harmful items include grenades and various quest items ("Use this to zap 30 murlocs!").

**Signature:** `isHarmful = IsHarmfulItem(itemID) or IsHarmfulItem("itemName") or IsHarmfulItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `isHarmful` - 1 if the item can be used against hostile units; otherwise nil (`1nil`)

**See also:** Item functions.


## IsHarmfulSpell

Returns whether a spell can be used against hostile units

**Signature:** `isHarmful = IsHarmfulSpell(index, "bookType") or IsHarmfulSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isHarmful` - 1 if the spell can be used against hostile units; otherwise nil (`1nil`)


## IsHelpfulItem

Returns whether an item can be used on the player or friendly units. Helpful items include potions, scrolls, food and drink.

**Signature:** `isHarmful = IsHelpfulItem(itemID) or IsHelpfulItem("itemName") or IsHelpfulItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `isHarmful` - 1 if the item can be used on the player or friendly units; otherwise nil (`1nil`)

**See also:** Item functions.


## IsHelpfulSpell

Returns whether an item can be used on the player or friendly units

**Signature:** `isHarmful = IsHelpfulSpell(index, "bookType") or IsHelpfulSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isHarmful` - 1 if the spell can be used on the player or friendly units; otherwise nil (`1nil`)


## IsIgnored

Returns whether a unit is on the player's ignore list

**Signature:** `isIgnored = IsIgnored("unit") or IsIgnored("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query (`string`)

**Returns:**
- `isIgnored` - 1 if the unit is on the player's ignore list; otherwise nil (`1nil`)


## IsIgnoredOrMuted

Returns whether a unit can be heard due to ignored/muted status

**Signature:** `isIgnoredOrMuted = IsIgnoredOrMuted("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isIgnoredOrMuted` - 1 if the unit is ignored or muted, nil otherwise (`1nil`)

**See also:** Unit functions, Voice functions.


## IsInArenaTeam

Returns whether the player is on an arena team

**Signature:** `isInTeam = IsInArenaTeam()`

**Returns:**
- `isInTeam` - True if the player is on any arena teams; false otherwise (`boolean`)

**See also:** Arena functions.


## IsIndoors

_No snapshot available (page did not exist in archive)._


## IsInGuild

Returns whether the player is in a guild

**Signature:** `inGuild = IsInGuild()`

**Returns:**
- `inGuild` - 1 if the player is in a guild; otherwise nil (`1nil`)


## IsInInstance

Returns whether the player is in an instance (and its type if applicable)

**Signature:** `isInstance, instanceType = IsInInstance()`

**Returns:**
- `isInstance` - 1 if the player is in an instance, otherwise nil (`1nil`)
- `instanceType` - The type of instance the player is in (`string`) 

 - `arena` - Player versus player arena
- `none` - Not inside an instance
- `party` - 5-man instance
- `pvp` - Player versus player battleground
- `raid` - Raid instance


## IsInLFGDungeon


## IsInventoryItemLocked

Returns whether an inventory slot is locked. Items become locked while being moved, split, or placed into other UI elements (such as the mail, trade, and auction windows); the item is unlocked once such an action is completed.

**Signature:** `isLocked = IsInventoryItemLocked(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `isLocked` - 1 if the item in the inventory slot is locked; otherwise nil (`1nil`)

**See also:** Inventory functions.


## IsItemInRange

Returns whether the player is in range to use an item on a unit

**Signature:** `inRange = IsItemInRange(itemID, "unit") or IsItemInRange("itemName", "unit") or IsItemInRange("itemLink", "unit")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)
- `unit` - A unit on which to use the item (`string`, unitID)

**Returns:**
- `inRange` - 1 if the player is near enough to use the item on the unit; 0 if not in range; nil if the unit is not a valid target for the item (`1nil`)


## IsLeftAltKeyDown

Returns whether the left Alt key is currently held down. (Note: The Mac WoW client does not distingish between left and right modifier keys, so both Alt keys are reported as Left Alt.)

**Signature:** `isDown = IsLeftAltKeyDown()`

**Returns:**
- `isDown` - 1 if the left Alt key on the keyboard is currently held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsLeftControlKeyDown

Returns whether the left Control key is held down. (Note: The Mac WoW client does not distingish between left and right modifier keys, so both Control keys are reported as Left Control.)

**Signature:** `isDown = IsLeftControlKeyDown()`

**Returns:**
- `isDown` - 1 if the left Control key is held down; otherwise nil (`1nil`)


## IsLeftShiftKeyDown

Returns whether the left Shift key on the keyboard is held down. (Note: The Mac WoW client does not distingish between left and right modifier keys, so both Shift keys are reported as Left Shift.)

**Signature:** `isDown = IsLeftShiftKeyDown()`

**Returns:**
- `isDown` - 1 if the left Shift key on the keyboard is currently held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsLFGDungeonJoinable


## IsLinuxClient

Returns whether the player is using the Linux game client. Does not indicate whether the player is running a Windows clint on Linux with virtualization software. Blizzard has not released an official WoW client for Linux, but this function is included just in case that situation changes.

**Signature:** `isLinux = IsLinuxClient()`

**Returns:**
- `isLinux` - 1 if running the Linux client; otherwise nil (`1nil`)


## IsListedInLFR

Returns whether the player is currently listed in the Raid Browser

**Signature:** `listedInLFR = IsListedInLFR()`

**Returns:**
- `listedInLFR` - `true` if the player is listed in the raid browser; otherwise `false` (`boolean`)

**See also:** Raid functions, Looking for group functions.


## IsLoggedIn

Returns whether the login process has completed. The `PLAYER_LOGIN` event provides similar information; this function presents an alternative that can be used across UI reloads.

**Signature:** `loggedIn = IsLoggedIn()`

**Returns:**
- `loggedIn` - 1 if the login process has completed; otherwise nil (`1nil`)

**See also:** Utility functions.


## IsMacClient

Returns whether the player is using the Mac OS X game client

**Signature:** `isMac = IsMacClient()`

**Returns:**
- `isMac` - 1 if running the Mac OS X client; otherwise nil (`1nil`)


## IsModifiedClick

Determines if the modifiers specified in the click-type had been held down while the button click occurred.. If called from a click handler (`OnMouseDown`, `OnMouseUp`, `OnClick`, `OnDoubleClick`, `PreClick`, or `PostClick`), checks mouse buttons included in the binding; otherwise checks modifiers only (see example).

**Signature:** `modifiedClick = IsModifiedClick("type")`

**Arguments:**
- `type` - Token identifying a modified click action (`string`)

**Returns:**
- `modifiedClick` - 1 if the modifier key set bound to the action is active (i.e. the keys are held down); otherwise nil (`1nil`)

**See also:** Modified click functions.


## IsModifierKeyDown

Returns whether a modifier key is held down. Modifier keys include shift, control or alt on either side of the keyboard. WoW does not recognize platform-specific modifier keys (such as fn, meta, Windows, or Command).

**Signature:** `isDown = IsModifierKeyDown()`

**Returns:**
- `isDown` - 1 if any modifier key is held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsMounted

Returns whether or not your character is mounted.

**Signature:** `mounted = IsMounted()`

**Returns:**
- `mounted` - 1 if the player is mounted, otherwise nil (`1nil`)


## IsMouseButtonDown

Returns whether a given mouse button is held down. If no button is specified, returns 1 if any mouse button is held down.

**Signature:** `isDown = IsMouseButtonDown([button])`

**Arguments:**
- `button` - Number or name of a mouse button (`number,string`) 

 - `1 or LeftButton` - Primary mouse button
- `2 or RightButton` - Secondary mouse button
- `3 or MiddleButton` - Third mouse button (or clickable scroll control)
- `4 or Button4` - Fourth mouse button
- `5 or Button5` - Fifth mouse button

**Returns:**
- `isDown` - 1 if the mouse button is down; otherwise nil (`1nil`)


## IsMouselooking

Returns whether mouselook mode is active

**Signature:** `isLooking = IsMouselooking()`

**Returns:**
- `isLooking` - True if mouselook mode is active; otherwise false (`boolean`)


## IsMuted

Returns whether a character has been muted by the player

**Signature:** `muted = IsMuted("unit") or IsMuted("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query (`string`)

**Returns:**
- `muted` - 1 if the unit is muted; otherwise nil (`1nil`)


## IsOutdoors

Returns whether the player is currently outdoors. "Outdoors" as defined by this function corresponds to the ability to use a mount in that specific location, not necessarily whether there is a roof above the player character's head. For example, returns 1 in Ironforge, Undercity, and the Caverns of Time, but nil in the nominally outdoor areas of instances such as Stratholme, Drak'tharon Keep, and Hellfire Ramparts. (Note that even in "outdoor" areas, standing on top of certain objects may interfere with the player's ability to mount up.)

**Signature:** `isOutdoors = IsOutdoors()`

**Returns:**
- `isOutdoors` - 1 if the player is currently outdoors; otherwise nil (`1nil`)

**See also:** Player information functions.


## IsOutOfBounds

Returns whether the player is currently outside the bounds of the world. Used in the default UI (in conjunction with `IsFalling()`) to allow the player to release to a graveyard if the character has encountered a bug and fallen underneath the world geometry.

**Signature:** `outOfBounds = IsOutOfBounds()`

**Returns:**
- `outOfBounds` - 1 if the player is currently outside the bounds of the world; otherwise nil (`1nil`)

**See also:** Player information functions.


## IsPartyLeader

Returns whether or not a unit is the current party leader

**Signature:** `isLeader = IsPartyLeader(unit)`

**Arguments:**
- `unit` - The unit to query (`unitid`)

**Returns:**
- `isLeader` - 1 if the unit is the party leader, otherwise nil (`1nil`)


## IsPartyLFG


## IsPassiveSpell

Returns whether a spell is passive (cannot be cast)

**Signature:** `isPassive = IsPassiveSpell(index, "bookType") or IsPassiveSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isPassive` - 1 if the spell is passive; otherwise nil (`1nil`)

**See also:** Spell functions.


## IsPetAttackAction


## IsPetAttackActive

Returns whether the pet's attack action is currently active

**Signature:** `isActive = IsPetAttackActive()`

**Returns:**
- `isActive` - 1 if the pet's attack action is currently active; otherwise nil (`1nil`)

**See also:** Pet functions.


## IsPlayerResolutionAvailable

Returns whether the current hardware supports high resolution player textures

**Signature:** `isAvailable = IsPlayerResolutionAvailable()`

**Returns:**
- `isAvailable` - 1 if high-resolution player textures can be enabled; otherwise nil (`1nil`)


## IsPossessBarVisible

Returns whether a special action bar should be shown while the player possesses another unit. Used in the default UI to switch between using the ShapeshiftBarFrame or PossessBarFrame to show actions belonging to the possessed unit.

**Signature:** `isVisible = IsPossessBarVisible()`

**Returns:**
- `isVisible` - 1 if the possessed unit's actions should be shown on a special action bar (`1nil`)

**See also:** ActionBar functions.


## IsPVPTimerRunning

Returns whether the player's PvP flag will expire after a period of time. 
If in a zone that flags the player for PvP, or if the player has manually enabled PvP, the flag will not expire. Once not in such a zone, or once the player has manually disabled PvP, or if the player has been flagged by attacking an enemy unit, the timer starts running and the player's PvP flag will expire after some time.

**Signature:** `isRunning = IsPVPTimerRunning()`

**Returns:**
- `isRunning` - 1 if the player's PvP flag will expire; otherwise nil (`1nil`)


## IsQuestCompletable

Returns whether the player can complete the quest presented by a questgiver

**Signature:** `isCompletable = IsQuestCompletable()`

**Returns:**
- `isCompletable` - 1 if the player currently meets the requirements (e.g. number of items collected) complete the quest; otherwise nil (`1nil`)

**See also:** Quest functions.


## IsQuestLogSpecialItemInRange

Returns whether the player's target is in range for using an item associated with a current quest. Available for a number of quests which involve using an item (i.e. "Use the MacGuffin to summon and defeat the boss", "Use this saw to fell 12 trees", etc.)

**Signature:** `inRange = IsQuestLogSpecialItemInRange(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest log entry with an associated usable item (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `inRange` - 1 if the player is close enough to the target to use the item; 0 if the target is out of range; nil if the quest item does not require a target (`number`)

**See also:** Quest functions, Objectives tracking functions.


## IsQuestWatched

Returns whether a quest from the quest log is listed in the objectives tracker

**Signature:** `isWatched = IsQuestWatched(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**Returns:**
- `isWatched` - 1 if the quest is being watched; otherwise nil (`1nil`)


## IsRaidLeader

Returns whether the player is the raid leader

**Signature:** `isLeader = IsRaidLeader()`

**Returns:**
- `isLeader` - 1 if the player is the raid leader; otherwise nil (`1nil`)

**See also:** Raid functions.


## IsRaidOfficer

Returns whether the player is a raid assistant

**Signature:** `isRaidOfficer = IsRaidOfficer()`

**Returns:**
- `isRaidOfficer` - 1 if the player is a raid assistant; otherwise nil (`boolean`)


## IsRealPartyLeader

Returns whether the player is the leader of a non-battleground party. When the player is in a party/raid and joins a battleground or arena, the normal party/raid functions refer to the battleground's party/raid, but the game still keeps track of the player's place in a non-battleground party/raid.

**Signature:** `isLeader = IsRealPartyLeader()`

**Returns:**
- `isLeader` - 1 if the player is the leader of a non-battleground party; otherwise nil (`1nil`)

**See also:** Party functions, Battlefield functions.


## IsRealRaidLeader

Returns whether the player is the leader of a non-battleground raid. When the player is in a party/raid and joins a battleground or arena, the normal party/raid functions refer to the battleground's party/raid, but the game still keeps track of the player's place in a non-battleground party/raid.

**Signature:** `isLeader = IsRealRaidLeader()`

**Returns:**
- `isLeader` - 1 if the player is the leader of a non-battleground raid; otherwise nil (`1nil`)

**See also:** Raid functions, Battlefield functions.


## IsReferAFriendLinked

Returns whether a unit's account is linked to the player's via the Recruit-a-Friend program

**Signature:** `isLinked = IsReferAFriendLinked("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isLinked` - 1 if the unit's account is linked to the player's (`1nil`)


## IsResting

Returns whether the player is currently resting. Rest state is provided in Inns and major cities and allows the player to log out immediately (instead of after a brief delay) and accrue bonus XP to be awarded for kills.

**Signature:** `resting = IsResting()`

**Returns:**
- `resting` - 1 if the player is resting; otherwise nil (`boolean`)


## IsRightAltKeyDown

Returns whether the right Alt key is currently held down. (Note: The Mac WoW client does not distingish between left and right modifier keys, so both Alt keys are reported as Left Alt.)

**Signature:** `isDown = IsRightAltKeyDown()`

**Returns:**
- `isDown` - 1 if the right Alt key on the keyboard is currently held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsRightControlKeyDown

Returns whether the right Control key on the keyboard is held down. (Note: The Mac WoW client does not distingish between left and right modifier keys, so both Control keys are reported as Left Control.)

**Signature:** `isDown = IsRightControlKeyDown()`

**Returns:**
- `isDown` - 1 if the right Control key on the keyboard is held down; otherwise nil (`1nil`)

**See also:** Keyboard functions.


## IsRightShiftKeyDown

Returns whether the right shift key on the keyboard is held down. (Note: The Mac WoW client does not distingish between left and right modifier keys, so both Shift keys are reported as Left Shift.)

**Signature:** `isDown = IsRightShiftKeyDown()`

**Returns:**
- `isDown` - 1 if the right shift key on the keyboard is currently held down; otherwise nil (`1nil`)


## issecure

Returns whether the current execution path is secure. Meaningless when called from outside of the secure environment: always returns `nil` in such situations.

**Signature:** `secure = issecure()`

**Returns:**
- `secure` - 1 if the current execution path is secure; otherwise nil (`1nil`)


## issecurevariable

Returns whether a variable is secure (and if not, which addon tainted it)

**Signature:** `issecure, taint = issecurevariable([table,] "variable")`

**Arguments:**
- `table` - A table to be used when checking table elements (`table`)
- `variable` - The name of a variable to check. In order to check the status of a table element, you should specify the table, and then the key of the element (`string`)

**Returns:**
- `issecure` - 1 if the variable is secure; otherwise nil (`1nil`)
- `taint` - Name of the addon that tainted the variable, or nil if the variable is secure (`string`)

**See also:** Secure execution utility functions, Debugging and Profiling functions.


## IsSelectedSpell

_No snapshot available (page did not exist in archive)._


## IsShiftKeyDown

Returns whether a Shift key on the keyboard is held down

**Signature:** `isDown = IsShiftKeyDown()`

**Returns:**
- `isDown` - 1 if a Shift key on the keyboard is currently held down; otherwise nil (`1nil`)


## IsSilenced

Returns whether a character is silenced on a chat channel

**Signature:** `isSilenced = IsSilenced("name", "channel")`

**Arguments:**
- `name` - Name of a character (`string`)
- `channel` - Name of a chat channel (`string`)

**Returns:**
- `isSilenced` - 1 if the character is silenced on the given channel; otherwise nil (`1nil`)

**See also:** Voice functions, Channel functions.


## IsSpellInRange

Returns whether the player is in range to cast a spell on a unit

**Signature:** `inRange = IsSpellInRange(index, "bookType", "unit") or IsSpellInRange("name", "unit")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)
- `unit` - A unit to target with the spell (`string`, unitID)

**Returns:**
- `inRange` - 1 if the player is near enough to cast the spell on the unit; 0 if not in range; nil if the unit is not a valid target for the spell (`1nil`)


## IsSpellKnown

Returns whether the player (or pet) knows a spell

**Signature:** `isKnown = IsSpellKnown(spellID [, isPet])`

**Arguments:**
- `spellID` - Numeric ID of a spell (`number`, spellID)
- `isPet` - True to check only spells known to the player's pet; false or omitted to check only spells known to the player (`boolean`)

**Returns:**
- `isKnown` - True if the player (or pet) knows the given spell; false otherwise (`boolean`)

**See also:** Spell functions.


## IsStackableAction

Returns whether an action uses stackable items. Applies to consumable items such as potions, wizard oils, food and drink; not used for spells which consume reagents (for those, see `IsConsumableAction`).

**Signature:** `isStackable = IsStackableAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isStackable` - 1 if the action uses stackable items; otherwise nil (`1nil`)

**See also:** Action functions.


## IsStealthed

Returns whether the player is currently stealthed

**Signature:** `stealthed = IsStealthed()`

**Returns:**
- `stealthed` - 1 if rogue Stealth, druid cat form Prowl, or a similar ability is active on the player; otherwise nil (`1nil`)


## IsStereoVideoAvailable

Returns whether the current system supports stereoscopic 3D display

**Signature:** `isAvailable = IsStereoVideoAvailable()`

**Returns:**
- `isAvailable` - 1 if video options for stereoscopic 3D display should be shown; otherwise nil (`1nil`)

**See also:** Video functions.


## IsSubZonePVPPOI

Returns whether the current area has PvP (or other) objectives to be displayed. Used in the default UI when the "Display World PVP Objectives\ setting is set to \Dynamic\, in which case objective information is only shown when the player is near an objective. Examples include the towers in Eastern Plaguelands and Hellfire Peninsula as well as non-PvP objectives such as in the Old Hillsbrad instance, the Death Knight starter quests, and the Battle for Undercity quest event.

**Signature:** `isPVPPOI = IsSubZonePVPPOI()`

**Returns:**
- `isPVPPOI` - 1 if the current subzone has objectives to display (`1nil`)


## IsSwimming

Returns whether the player is currently swimming. "Swimming" as defined by this function corresponds to the ability to use swimming abilities (such as druid Aquatic Form) or inability to use land-restricted abilities (such as eating or summoning a flying mount), not necessarily to whether the player is in water.

**Signature:** `isSwimming = IsSwimming()`

**Returns:**
- `isSwimming` - 1 if the player is currently swimming; otherwise nil (`1nil`)


## IsThreatWarningEnabled

Returns whether the default Aggro Warning UI should currently be shown. 
This function (and the `threatWarning` CVar that affects its behavior) has no effect on other threat APIs; it merely indicates whether Blizzard's threat warning UI should be displayed.

**Signature:** `enabled = IsThreatWarningEnabled()`

**Returns:**
- `enabled` - 1 if the Aggro Warning UI should be displayed; nil otherwise (`1nil`)


## IsTitleKnown

Returns whether the player has earned the ability to display a title

**Signature:** `isKnown = IsTitleKnown(titleIndex)`

**Arguments:**
- `titleIndex` - Index of a title available to the player (between 1 and `GetNumTitles()`) (`integer`)

**Returns:**
- `isKnown` - 1 if the player has earned the ability to display the title; otherwise nil (`1nil`)


## IsTrackedAchievement

Returns whether an achievement is flagged for display in the objectives tracker UI

**Signature:** `isTracked = IsTrackedAchievement(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**Returns:**
- `isTracked` - True if the achievement is flagged for tracking; otherwise false (`boolean`)


## IsTradeSkillLinked

Returns whether the TradeSkill UI is showing another player's skill

**Signature:** `isLinked, name = IsTradeSkillLinked()`

**Returns:**
- `isLinked` - 1 if the TradeSkill APIs currently reflect another character's tradeskill; nil if showing the player's tradeskill or if no skill is shown (`1nil`)
- `name` - If showing another character's skill, the name of that character (`string`)


## IsTradeskillTrainer

Returns whether the player is interacting with a trade skill trainer (as opposed to a class trainer)

**Signature:** `isTradeskill = IsTradeskillTrainer()`

**Returns:**
- `isTradeskill` - 1 if interacting with a trade skill trainer; otherwise nil (`1nil`)

**See also:** Trainer functions.


## IsTrainerServiceSkillStep

_No snapshot available (page did not exist in archive)._


## IsTutorialFlagged


## IsUnitOnQuest

Checks if a specified unit is on a quest from the players quest log.

**Signature:** `state = IsUnitOnQuest(index, "unit")`

**Arguments:**
- `index` - The quest index to query. (`number`)
- `unit` - The name of the unit to query. (`string`)

**Returns:**
- `state` - 1 if the unit is on that quest, nil otherwise (`1nil`)


## IsUsableAction

Returns whether an action is usable

**Signature:** `isUsable, notEnoughMana = IsUsableAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `isUsable` - 1 if the action is usable; otherwise nil (`1nil`)
- `notEnoughMana` - 1 if the player lacks the resources (e.g. mana, energy, runes) to use the action; otherwise nil (`1nil`)

**See also:** Action functions.


## IsUsableItem

Returns whether an item can currently be used. Does not account for item cooldowns (see `GetItemCooldown()` -- returns 1 if other conditions allow for using the item (e.g. if the item can only be used while outdoors).

**Signature:** `isUsable, notEnoughMana = IsUsableItem(itemID) or IsUsableItem("itemName") or IsUsableItem("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's link (`string`)

**Returns:**
- `isUsable` - 1 if the item is usable; otherwise nil (`1nil`)
- `notEnoughMana` - 1 if the player lacks the resources (e.g. mana, energy, runes) to use the item; otherwise nil (`1nil`)

**See also:** Item functions.


## IsUsableSpell

Returns whether or not a given spell is usable or cannot be used due to lack of mana. Does not account for spell cooldowns (see `GetSpellCooldown()` -- returns 1 if other conditions allow for casting the spell (e.g. if the spell can only be cast while outdoors).

**Signature:** `isUsable, notEnoughMana = IsUsableSpell(index, "bookType") or IsUsableSpell("name")`

**Arguments:**
- `index` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook
- `name` - Name of a spell (`string`)

**Returns:**
- `isUsable` - 1 if the spell is castable; otherwise nil (`1nil`)
- `notEnoughMana` - 1 if the player lacks the resources (e.g. mana, energy, runes) to cast the spell; otherwise nil (`1nil`)

**See also:** Spell functions.


## IsUsingVehicleControls


## IsVehicleAimAngleAdjustable

Returns whether the player is controlling a vehicle weapon with adjustable aim angle

**Signature:** `hasAngleControl = IsVehicleAimAngleAdjustable()`

**Returns:**
- `hasAngleControl` - 1 if the player is controlling a vehicle weapon with adjustable aim angle; otherwise nil (`1nil`)

**See also:** Vehicle functions.


## IsVehicleAimPowerAdjustable


## IsVoiceChatAllowed

Returns whether the player is allowed to enable the voice chat feature

**Signature:** `isAllowed = IsVoiceChatAllowed()`

**Returns:**
- `isAllowed` - 1 if voice chat is allowed; otherwise nil (`1nil`)


## IsVoiceChatAllowedByServer

Returns whether voice chat is supported by the realm server

**Signature:** `IsVoiceChatAllowedByServer()`


## IsVoiceChatEnabled

Returns whether the voice chat system is enabled

**Signature:** `isEnabled = IsVoiceChatEnabled()`

**Returns:**
- `isEnabled` - 1 if the voice chat system is enabled; otherwise nil (`1nil`)

**See also:** Voice functions.


## IsWindowsClient

Returns whether the player is using the Windows game client

**Signature:** `isWindows = IsWindowsClient()`

**Returns:**
- `isWindows` - 1 if running the Windows client; otherwise nil (`1nil`)


## IsXPUserDisabled

Returns whether experience gain has been disabled for the player

**Signature:** `isDisabled = IsXPUserDisabled()`

**Returns:**
- `isDisabled` - True if experience gain has been disabled for the player; false otherwise (`boolean`)


## IsZoomOutAvailable


## ItemHasRange

Returns whether an item has a range limitation for its use. For example, Mistletoe can only be used on another character within a given range of the player, but a Hearthstone has no target and thus no range restriction. Returns nil for items which have a range restriction but are area-targeted and not unit-targeted (e.g. grenades).

**Signature:** `hasRange = ItemHasRange(itemID) or ItemHasRange("itemName") or ItemHasRange("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `hasRange` - 1 if the item has an effective range; otherwise nil. (`1nil`)


## ItemTextGetCreator

Returns the original author of the currently viewed text item. Used for mail messages sent by other players; when the player makes a permanent copy of a letter and reads it from inventory, the default UI uses this function to display a signature (e.g. "From, Leeroy") at the end of the message text.

**Signature:** `creator = ItemTextGetCreator()`

**Returns:**
- `creator` - Creator of the text item, or nil if not available (`string`)


## ItemTextGetItem

Returns the name of the currently viewed text item. Used for readable world objects (plaques, books on tables, etc) and readable inventory items (looted books/parchments/scrolls/etc, saved copies of mail messages). For saved mail messages the name returned is always "Plain Letter" (or localized equivalent); the message subject is lost when saving a copy.

**Signature:** `text = ItemTextGetItem()`

**Returns:**
- `text` - Name of the text item (`string`)


## ItemTextGetMaterial

Returns display style information for the currently viewed text item. The value returned can be used to look up background textures and text colors for display:

 
 - Background textures displayed in the default UI can be found by prepending `"Interface\\ItemTextFrame\\ItemText-"` and appending `"-TopLeft"`, `"-TopRight"`, `"-BotLeft"`, `"-BotRight"` to the material string (e.g. `"Interface\\ItemTextFrame\\ItemText-Stone-TopLeft"`).
 
 - Colors for body and title text can be found by calling `GetMaterialTextColors(material)` (a Lua function implemented in the Blizzard UI).

In cases where this function returns nil, the default UI uses the colors and textures for "Parchment".

**Signature:** `material = ItemTextGetMaterial()`

**Returns:**
- `material` - String identifying a display style for the current text item, or nil for the default style (`string`) 

 - `Bronze` - Colored metallic background
- `Marble` - Light stone background
- `Parchment` - Yellowed parchment background (default)
- `Silver` - Gray metallic background
- `Stone` - Dark stone background


## ItemTextGetPage

Returns the current page number in the currently viewed text item

**Signature:** `page = ItemTextGetPage()`

**Returns:**
- `page` - Number of the currently displayed page (`number`)

**See also:** Item Text functions.


## ItemTextGetText

Returns the text of the currently viewed text item. Used for readable world objects (plaques, books on tables, etc) and readable inventory items (looted books/parchments/scrolls/etc, saved copies of mail messages). Returns valid data only between the `ITEM_TEXT_BEGIN` and `ITEM_TEXT_CLOSED` events, with the `ITEM_TEXT_READY` event indicating when new text is available (as when changing pages).

**Signature:** `text = ItemTextGetText()`

**Returns:**
- `text` - Text to be displayed for the current page of the currently viewed text item (`string`)

**See also:** Item Text functions.


## ItemTextHasNextPage

Returns whether the currently viewed text item has additional pages

**Signature:** `next = ItemTextHasNextPage()`

**Returns:**
- `next` - 1 if the currently viewed text item has one or more pages beyond the current page; otherwise nil (`1nil`)

**See also:** Item Text functions.


## ItemTextNextPage

Moves to the next page in the currently viewed text item. The `ITEM_TEXT_READY` event fires when text for the next page becomes available. Does nothing if already viewing the last page of text.

**Signature:** `ItemTextNextPage()`

**See also:** Item Text functions.


## ItemTextPrevPage

Moves to the previous page in the currently viewed text item. The `ITEM_TEXT_READY` event fires when text for the previous page becomes available. Does nothing if already viewing the first page of text.

**Signature:** `ItemTextPrevPage()`

