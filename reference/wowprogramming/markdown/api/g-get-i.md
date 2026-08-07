# WoW API — GetI*

_37 functions_

---

## GetIgnoreName

Returns the name of a character on the ignore list

**Signature:** `name = GetIgnoreName("index")`

**Arguments:**
- `index` - Index of an entry in the ignore list (between 1 and `GetNumIgnores()`) (`string`)

**Returns:**
- `name` - Name of the ignored character (`string`)




## GetInboxHeaderInfo

Returns information about a mail in the player's inbox

**Signature:** `packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, itemCount, wasRead, wasReturned, textCreated, canReply, isGM, itemQuantity = GetInboxHeaderInfo(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**Returns:**
- `packageIcon` - Path to an icon texture for the message if it contains an item; nil for other messages (`string`)
- `stationeryIcon` - Path to an icon texture for the message (`string`)
- `sender` - Name of the mail's sender (`string`)
- `subject` - Subject text of the mail (`string`)
- `money` - Amount of money attached to the mail (in copper) (`number`)
- `CODAmount` - Cash-On-Delivery cost to take any items attached to the mail (in copper) (`number`)
- `daysLeft` - Number of days remaining before the mail is automatically returned or deleted (`number`)
- `itemCount` - Number of item attachments to the mail (`number`)
- `wasRead` - 1 if the player has read the mail; otherwise nil (`1nil`)
- `wasReturned` - 1 if the mail was sent by the player to another character and returned by the recipient; otherwise nil (`1nil`)
- `textCreated` - 1 if the player has saved a copy of the mail text as an item; otherwise nil (`1nil`)
- `canReply` - 1 if the player can reply to the mail; otherwise nil (`1nil`)
- `isGM` - 1 if the mail is from a game master; otherwise nil (`1nil`)
- `itemQuantity` - Number of stacked items attached to the mail if the mail has one attachment; nil if the mail has zero or multiple attachments (`number`)

**See also:** Mail functions.




## GetInboxInvoiceInfo

Returns auction house invoice information for a mail message

**Signature:** `invoiceType, itemName, playerName, bid, buyout, deposit, consignment, moneyDelay, etaHour, etaMin = GetInboxInvoiceInfo(index)`

**Arguments:**
- `index` - Index of the mail message in the inbox (between 1 and `GetInboxNumItems()`) (`number`)

**Returns:**
- `invoiceType` - Type of invoice (`string`) 

 - `buyer` - An invoice for an item the player won
- `seller` - An invoice for an item the player sold
- `seller_temp_invoice` - A temporary invoice for an item sold by the player but for which payment has not yet been delivered
- `itemName` - Name of the item (`string`)
- `playerName` - Name of the player who bought or sold the item (`string`)
- `bid` - Amount of the winning bid or buyout (`number`)
- `buyout` - Amount of buyout (if the auction was bought out) (`number`)
- `deposit` - Amount of money paid in deposit (`number`)
- `consignment` - Amount withheld from the deposit by the auction house as charge for running the auction (`number`)
- `moneyDelay` - Delay for delivery of payment on a temporary invoice (in minutes; generally 60) (`number`)
- `etaHour` - Hour portion (on a 24-hour clock) of the estimated time for delivery of payment on a temporary invoice (`number`)
- `etaMin` - Minute portion of the estimated time for delivery of payment on a temporary invoice (`number`)




## GetInboxItem

Returns information for an item attached to a message in the player's inbox

**Signature:** `name, itemTexture, count, quality, canUse = GetInboxItem(mailID, attachmentIndex)`

**Arguments:**
- `mailID` - Index of a message in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)
- `attachmentIndex` - Index of an attachment to the message (between 1 and `select(8,``GetInboxHeaderInfo(mailID)``)`) (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `itemTexture` - Path to an icon texture for the item (`string`)
- `count` - Number of stacked items (`number`)
- `quality` - Quality (rarity) of the item (`number`, itemQuality)
- `canUse` - 1 if the player can use or equip the item; otherwise nil (`1nil`)




## GetInboxItemLink

Returns a hyperlink for an item attached to a mail in the player's inbox

**Signature:** `itemlink = GetInboxItemLink(mailID, attachmentIndex)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)
- `attachmentIndex` - Index of an attachment to the mail (between 1 and `ATTACHMENTS_MAX_RECEIVE`) (`number`)

**Returns:**
- `itemlink` - A hyperlink for the attachment item (`string`, hyperlink)

**See also:** Mail functions, Hyperlink functions.




## GetInboxNumItems

Returns the number of mails in the player's inbox

**Signature:** `numItems, totalItems = GetInboxNumItems()`

**Returns:**
- `numItems` - Number of mails in the player's inbox (`number`)
- `totalItems` - Total number of items both in the inbox and on the server. (`number`)

**See also:** Mail functions.




## GetInboxText

Returns information about the text of an inbox mail. Also marks the mail as read if it wasn't already.

**Signature:** `bodyText, texture, isTakeable, isInvoice = GetInboxText(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**Returns:**
- `bodyText` - Text of the mail (`string`)
- `texture` - Unique part of the path to a background texture to be displayed for the message; actual texture paths are `STATIONERY_PATH .. texture .. "1"` and `STATIONERY_PATH .. texture .. "2"` (`string`)
- `isTakeable` - 1 if the text of the mail can be saved as an item; otherwise nil (`1nil`)
- `isInvoice` - 1 if the mail is an auction house invoice; otherwise nil (`1nil`)

**See also:** Mail functions.




## GetInspectArenaTeamData

Returns arena team information about the currently inspected unit. Only available if data has been downloaded from the server; see `HasInspectHonorData()` and `RequestInspectHonorData()`.

**Signature:** `teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, bg_red, bg_green, bg_blue, emblem, emblem_red, emblem_green, emblem_blue, border, border_red, border_green, border_blue = GetInspectArenaTeamData(team)`

**Arguments:**
- `team` - Index of one of the unit's arena teams (`number`, arenaTeamID)

**Returns:**
- `teamName` - Name of the arena team (`string`)
- `teamSize` - Size of the team (2 for 2v2, 3 for 3v3, or 5 for 5v5) (`number`)
- `teamRating` - The team's current rating (`number`)
- `teamPlayed` - Number of games played by the team in the current week (`number`)
- `teamWins` - Number of games won by the team in the current week (`number`)
- `playerPlayed` - Number of games in which the unit has participated in the current week (`number`)
- `playerRating` - The unit's personal rating with this team (`number`)
- `bg_red` - Red component of the color value for the team banner's background (`number`)
- `bg_green` - Green component of the color value for the team banner's background (`number`)
- `bg_blue` - Blue component of the color value for the team banner's background (`number`)
- `emblem` - Index of the team's emblem graphic; full path to the emblem texture can be found using the format `"Interface\PVPFrame\Icons\PVP-Banner-Emblem-"..emblem` (`number`)
- `emblem_red` - Red component of the color value for the team banner's emblem (`number`)
- `emblem_green` - Green component of the color value for the team banner's emblem (`number`)
- `emblem_blue` - Blue component of the color value for the team banner's emblem (`number`)
- `border` - Index of the team's border graphic; full path to the border texture can be found by using the format `"Interface\PVPFrame\PVP-Banner-"..teamSize.."-Border-"..border` (`number`)
- `border_red` - Red component of the color value for the team banner's border (`number`)
- `border_green` - Green component of the color value for the team banner's border (`number`)
- `border_blue` - Blue component of the color value for the team banner's border (`number`)

**See also:** Inspect functions.




## GetInspectHonorData

Returns PvP honor information about the currently inspected unit. Only available if data has been downloaded from the server; see `HasInspectHonorData()` and `RequestInspectHonorData()`.

**Signature:** `todayHK, todayHonor, yesterdayHK, yesterdayHonor, lifetimeHK, lifetimeRank = GetInspectHonorData()`

**Returns:**
- `todayHK` - Number of honorable kills on the current day (`number`)
- `todayHonor` - Amount of honor points earned on the current day (`number`)
- `yesterdayHK` - Number of honorable kills on the previous day (`number`)
- `yesterdayHonor` - Amount of honor points earned on the previous day (`number`)
- `lifetimeHK` - Lifetime total of honorable kills scored (`number`)
- `lifetimeRank` - Highest rank earned in the pre-2.0 PvP reward system; see `GetPVPRankInfo()` for rank display information (`number`)




## GetInstanceBootTimeRemaining

Returns the amount of time left until the player is removed from the current instance. Used when the player is in an instance he doesn't own; e.g. if the player enters an instance with a group and is then removed from the group.

**Signature:** `timeleft = GetInstanceBootTimeRemaining()`

**Returns:**
- `timeleft` - The number of seconds until the player is booted from the current instance (`number`)

**See also:** Instance functions.




## GetInstanceDifficulty

Returns difficulty setting for the current dungeon/raid instance. 
This returns the difficulty setting for the instance the player is currently in; not to be confused with `GetCurrentDungeonDifficulty()`, which is the current group's setting for entering new instances, nor with `GetDefaultDungeonDifficulty()`, which is the player's preference for dungeon difficulty and may differ from that of the current party leader.

**Signature:** `difficulty = GetInstanceDifficulty()`

**Returns:**
- `difficulty` - The current instance's difficulty setting (`number`) 

 - `1` - Normal (5 or 10 players)
- `2` - Heroic (5 players) / Normal (25 players)
- `3` - Heroic (10 players)
- `4` - Heroic (25 players)

**See also:** Instance functions.




## GetInstanceInfo

Returns instance information about the current area

**Signature:** `name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()`

**Returns:**
- `name` - Name of the instance or world area (`string`)
- `type` - Type of the instance (`string`) 

 - `arena` - A PvP Arena instance
- `none` - Normal world area (e.g. Northrend, Kalimdor, Deeprun Tram)
- `party` - An instance for 5-man groups
- `pvp` - A PvP battleground instance
- `raid` - An instance for raid groups
- `difficulty` - Difficulty setting of the instance (`number`) 

 - `1` - In raids, this represents 10 Player. In instances, Normal.
- `2` - In raids, this represents 25 Player. In instances, Heroic.
- `3` - In raids, this represents 10 Player Heroic. In instances, Epic (unused for PvE instances but returned in some battlegrounds).
- `4` - In raids, this represents 25 Player Heroic. No corollary in instances.
- `difficultyName` - String representing the difficulty of the instance. E.g. "10 Player" (`string`)
- `maxPlayers` - Maximum number of players allowed in the instance (`number`)
- `playerDifficulty` - Unknown (`number`)
- `isDynamicInstance` - Unknown (`boolean`)

**See also:** Instance functions.




## GetInstanceLockTimeRemaining

Returns time remaining before the player is saved to a recently entered instance. 
Applies when the player enters an instance to which other members of her group are saved; if the player leaves the instance (normally or with `RespondInstanceLock(false)`) within this time limit she will not be saved to the instance.

**Signature:** `seconds = GetInstanceLockTimeRemaining()`

**Returns:**
- `seconds` - Time remaining before the player is saved to the instance (`number`)

**See also:** Instance functions.




## GetInstanceLockTimeRemainingEncounter




## GetInventoryAlertStatus

Returns the durability warning status of an equipped item. Looking up the status returned by this function in the `INVENTORY_ALERT_COLORS` table provides color values, used in the default UI to highlight parts of the DurabiltyFrame (i.e. the "armored man" image) that appears when durability is low.

**Signature:** `status = GetInventoryAlertStatus(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `status` - Alert status for the item in the given slot (`number`) 

 - `0` - No alert; the slot is empty, contains an item whose durability is above critical levels, or contains an item without a durability value
- `1` - The item's durability is dangerously low
- `2` - The item's durability is at zero (the item is broken)

**See also:** Inventory functions.




## GetInventoryItemBroken

Returns whether an equipped item is broken

**Signature:** `isBroken = GetInventoryItemBroken("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `isBroken` - 1 if the item is broken (durability zero); otherwise nil (`1nil`)

**See also:** Inventory functions.




## GetInventoryItemCooldown

Returns cooldown information about an equipped item

**Signature:** `start, duration, enable = GetInventoryItemCooldown("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the item is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the item is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the item is ready.) (`number`)

**See also:** Inventory functions.




## GetInventoryItemCount

Returns the number of items stacked in an inventory slot. 
Currently only returns meaningful information for the ammo slot.

**Signature:** `count = GetInventoryItemCount("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `count` - The amount of items stacked in the inventory slot (`number`)




## GetInventoryItemDurability

Returns the current durability level of an equipped item. If an item does not have durability (for example, heirlooms, tabards and some other items) then this function will simply return `nil`.

**Signature:** `durability, max = GetInventoryItemDurability(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `durability` - The item's current durability, the first number listed in the item's tooltip where it displays the durability information: for example 4 in 4/29. (`number`)
- `max` - The item's maximum durability, the first number listed in the item's tooltip where it displays the durability information: for example 29 in 4/29 (`number`)

**See also:** Inventory functions.




## GetInventoryItemGems

Returns the gems socketed in an equipped item. The IDs returned refer to the gems themselves (not the enchantments they provide), and thus can be passed to `GetItemInfo()` to get a gem's name, quality, icon, etc.

**Signature:** `gem1, gem2, gem3 = GetInventoryItemGems(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `gem1` - Item ID of the first gem socketed in the item (`itemID`)
- `gem2` - Item ID of the second gem socketed in the item (`itemID`)
- `gem3` - Item ID of the third gem socketed in the item (`itemID`)




## GetInventoryItemID

Returns the item ID of an equipped item

**Signature:** `id = GetInventoryItemID("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `id` - Numeric ID of the item in the given slot (`itemID`)




## GetInventoryItemLink

Returns an item link for an equipped item

**Signature:** `link = GetInventoryItemLink("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `link` - An item link for the given item (`string`, hyperlink)




## GetInventoryItemQuality

Returns the quality level of an equipped item

**Signature:** `quality = GetInventoryItemQuality("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `quality` - The quality level of the item (`number`, itemQuality)

**See also:** Inventory functions.




## GetInventoryItemsForSlot

Returns a list of items that can be equipped in a given inventory slot

**Signature:** `availableItems = GetInventoryItemsForSlot(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `availableItems` - A table listing `itemID`s of items which can be equipped in the slot, keyed by `itemLocation` (`table`)

**See also:** Inventory functions.




## GetInventoryItemTexture

Returns the icon texture for an equipped item

**Signature:** `texture = GetInventoryItemTexture("unit", slot)`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**Returns:**
- `texture` - Path to an icon texture for the item (`string`)

**See also:** Inventory functions.




## GetInventorySlotInfo

Returns information about an inventory slot

**Signature:** `id, texture, checkRelic = GetInventorySlotInfo("slotName")`

**Arguments:**
- `slotName` - Name of an inventory slot to query (`string`) 

 - `AmmoSlot` - Ranged ammunition slot
- `BackSlot` - Back (cloak) slot
- `Bag0Slot` - Backpack slot
- `Bag1Slot` - First bag slot
- `Bag2Slot` - Second bag slot
- `Bag3Slot` - Third bag slot
- `ChestSlot` - Chest slot
- `FeetSlot` - Feet (boots) slot
- `Finger0Slot` - First finger (ring) slot
- `Finger1Slot` - Second finger (ring) slot
- `HandsSlot` - Hand (gloves) slot
- `HeadSlot` - Head (helmet) slot
- `LegsSlot` - Legs (pants) slot
- `MainHandSlot` - Main hand weapon slot
- `NeckSlot` - Necklace slot
- `RangedSlot` - Ranged weapon or relic slot
- `SecondaryHandSlot` - Off-hand (weapon, shield, or held item) slot
- `ShirtSlot` - Shirt slot
- `ShoulderSlot` - Shoulder slot
- `TabardSlot` - Tabard slot
- `Trinket0Slot` - First trinket slot
- `Trinket1Slot` - Second trinket slot
- `WaistSlot` - Waist (belt) slot
- `WristSlot` - Wrist (bracers) slot

**Returns:**
- `id` - The numeric slotId usable in other Inventory functions (`number`)
- `texture` - The path to the texture to be displayed when this slot is empty (`string`)
- `checkRelic` - 1 if the slot might be the relic slot; otherwise nil. The ranged slot token is re-used for the relic slot; if this return is 1, `UnitHasRelicSlot` should be used to determine how the slot should be displayed. (`1nil`)




## GetItemCooldown

Returns cooldown information about an arbitrary item

**Signature:** `start, duration, enable = GetItemCooldown(itemID) or GetItemCooldown("itemName") or GetItemCooldown("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the item is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the item is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the item is ready.) (`number`)




## GetItemCount

Returns information about how many of a given item the player has or on remaining item charges. 
When the third argument `includeCharges` is true, the returned number indicates the total number of remaining charges for the item instead of how many of the item you have; e.g. if you have 3 Wizard Oils and one of them has been used twice, the returned value will be 13.

**Signature:** `itemCount = GetItemCount(itemId, includeBank, includeCharges) or GetItemCount("itemName", includeBank, includeCharges) or GetItemCount("itemLink", includeBank, includeCharges)`

**Arguments:**
- `itemId` - An item id (`number`)
- `itemName` - An item name (`string`)
- `itemLink` - An item link (`string`)
- `includeBank` - true to include items in the bank in the returned count, otherwise false (`boolean`)
- `includeCharges` - true to count charges for applicable items, otherwise false (`boolean`)

**Returns:**
- `itemCount` - The number of the given item the player has in possession (possibly including items in the bank), or the total number of charges on those items (`number`)

**See also:** Item functions.




## GetItemFamily

Returns information about special bag types that can hold a given item. The meaning of `bagType` varies depending on the item:

 
 - If the item is a container, `bagType` indicates which kinds of items the container is limited to holding; a `bagType` of 0 indicates the container can hold any kind of item.
 
 - If the item is not a container, `bagType` indicates which kinds of specialty containers can hold the item; a `bagType` of 0 indicates the item can only be put in general-purpose containers.

**Signature:** `bagType = GetItemFamily(itemID) or GetItemFamily("itemName") or GetItemFamily("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `bagType` - Bitwise OR of bag type flags: (`number`, bitfield) 

 - `0x0001` - Quiver
- `0x0002` - Ammo Pouch
- `0x0004` - Soul Bag
- `0x0008` - Leatherworking Bag
- `0x0010` - Inscription Bag
- `0x0020` - Herb Bag
- `0x0040` - Enchanting Bag
- `0x0080` - Engineering Bag
- `0x0100` - Keyring
- `0x0200` - Gem Bag
- `0x0400` - Mining Bag
- `0x0800` - Unused
- `0x1000` - Vanity Pets




## GetItemGem

Returns information about gems socketed in an item

**Signature:** `name, link = GetItemGem(itemID, index) or GetItemGem("itemName", index) or GetItemGem("itemLink", index)`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)
- `index` - Index of a socket on the item (`number`)

**Returns:**
- `name` - Name of the gem in the socket (`string`)
- `link` - A hyperlink for the gem in the socket (`string`, hyperlink)




## GetItemIcon

Returns the path to an icon texture for the item. Unlike `GetItemInfo`, this function always returns icons for valid items, even if the item is not in the client's cache.

**Signature:** `texture = GetItemIcon(itemID) or GetItemIcon("itemName") or GetItemIcon("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `texture` - Path to an icon texture for the item (`string`)




## GetItemInfo

Returns information about an item, by name, link or id. Only returns information for items in the WoW client's local cache; returns `nil` for items the client has not seen.

**Signature:** `name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemID) or GetItemInfo("itemName") or GetItemInfo("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`, itemID)
- `itemName` - An item's name. This value will only work if the player has the item in their bags. (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `name` - Name of the item (`string`)
- `link` - A hyperlink for the item (`string`, hyperlink)
- `quality` - Quality (rarity) level of the item. (`number`, itemQuality)
- `iLevel` - Internal level of the item; (`number`)
- `reqLevel` - Minimum character level required to use or equip the item (`number`)
- `class` - Localized name of the item's class/type (as in the list returned by `GetAuctionItemClasses()`) (`string`)
- `subclass` - Localized name of the item's subclass/subtype (as in the list returned by `GetAuctionItemSubClasses()`) (`string`)
- `maxStack` - Maximum stack size for the item (i.e. largest number of items that can be held in a single bag slot) (`number`)
- `equipSlot` - Non-localized token identifying the inventory type of the item (as in the list returned by `GetAuctionItemInvTypes()`); name of a global variable containing the localized name of the inventory type (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `vendorPrice` - Price an NPC vendor will pay to buy the item from the player. This value was added in patch 3.2. (`number`)




## GetItemQualityColor

Returns color values for use in displaying items of a given quality. Color components are floating-point values between 0 (no component) and 1 (full intensity of the component). 

Prior to 4.2 the hexColor return was prefixed with |c now it is just the hex codes for the color.

**Signature:** `redComponent, greenComponent, blueComponent, hexColor = GetItemQualityColor(quality)`

**Arguments:**
- `quality` - An numeric item quality (rarity) value (`number`, itemQuality)

**Returns:**
- `redComponent` - Red component of the color (`number`)
- `greenComponent` - Green component of the color (`number`)
- `blueComponent` - Blue component of the color (`number`)
- `hexColor` - Color value of a `colorString` for formatting text with the color (`string`)

**See also:** Item functions.




## GetItemSpell

Returns information about the spell cast by an item's "Use:" effect

**Signature:** `name, rank = GetItemSpell(itemID) or GetItemSpell("itemName") or GetItemSpell("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `name` - Name of the spell (`string`)
- `rank` - Secondary text associated with the spell (often a rank, e.g. "Rank 7"); or the empty string (`""`) if not applicable (`string`)

**See also:** Item functions, Spell functions.




## GetItemStatDelta

Returns a summary of the difference in stat bonuses between two items. Keys in the table returned are the names of global variables containing the localized names of the stats (e.g. `_G["ITEM_MOD_SPIRIT_SHORT"] = "Spirit"`, `_G["ITEM_MOD_HIT_RATING_SHORT"] = "Hit Rating"`).

The optional argument `returnTable` allows for performance optimization in cases where this function is expected to be called repeatedly. Rather than creating new tables each time the function is called (eventually requiring garbage collection), an existing table can be recycled. (Note, however, that this function does not clear the table's contents; use `wipe()` first to guarantee consistent results.)

**Signature:** `statTable = GetItemStatDelta("item1Link", "item2Link" [, returnTable])`

**Arguments:**
- `item1Link` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`, hyperlink)
- `item2Link` - Another item's hyperlink, or any string containing the `itemString` portion of an item link (`string`, hyperlink)
- `returnTable` - Reference to a table to be filled with return values (`table`)

**Returns:**
- `statTable` - A table listing the difference in stat bonuses provided by the items (i.e. if `item1Link` is equipped, what changes to the player's stats would occur if it is replaced by `item2Link`) (`table`)




## GetItemStats

Returns a summary of an item's stat bonuses. Keys in the table returned are the names of global variables containing the localized names of the stats (e.g. `_G["ITEM_MOD_SPIRIT_SHORT"] = "Spirit"`, `_G["ITEM_MOD_HIT_RATING_SHORT"] = "Hit Rating"`).

The optional argument `returnTable` allows for performance optimization in cases where this function is expected to be called repeatedly. Rather than creating new tables each time the function is called (eventually requiring garbage collection), an existing table can be recycled. (Note, however, that this function does not clear the table's contents; use `wipe()` first to guarantee consistent results.)

**Signature:** `statTable = GetItemStats("itemLink" [, returnTable])`

**Arguments:**
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`, hyperlink)
- `returnTable` - Reference to a table to be filled with return values (`table`)

**Returns:**
- `statTable` - A table listing the stat bonuses provided by the item (`table`)




## GetItemUniqueness

Returns information about uniqueness restrictions for equipping an item. 
Only applies to items with "Unique Equipped" restrictions upon how many similar items can be equipped -- returns nil for items which for which "Unique" restricts how many the player can have in her possession.

Also returns nil if the queried item is not currently in the WoW client's item cache.

**Signature:** `uniqueFamily, maxEquipped = GetItemUniqueness(itemID) or GetItemUniqueness("itemName") or GetItemUniqueness("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's link (`string`)

**Returns:**
- `uniqueFamily` - The family of items with special uniqueness restrictions to which the item belongs (`number`)
- `maxEquipped` - The maximum number of items under this restriction that can be equipped (`number`)



