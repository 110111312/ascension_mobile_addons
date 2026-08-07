# WoW API — GetC*

_65 functions_

---

## GetCategoryInfo

Returns information about an achievement/statistic category

**Signature:** `name, parentID, flags = GetCategoryInfo(id)`

**Arguments:**
- `id` - The numeric ID of an achievement/statistic category (`number`)

**Returns:**
- `name` - Name of the category (`string`)
- `parentID` - ID of the parent category of which this is a sub-category, or -1 if this is a top-level category (`number`)
- `flags` - Various additional information about the category; currently unused (0 for all existing categories) (`bitfield`)

**See also:** Achievement functions.




## GetCategoryList

Returns a list of all achievement categories

**Signature:** `categories = GetCategoryList()`

**Returns:**
- `categories` - A list of achievement category IDs (`table`)

**See also:** Achievement functions.




## GetCategoryNumAchievements

Returns the number of achievements/statistics to display in a category. 
Note this function does not return the total number of achievements in a category; it only returns the number to be displayed in the default UI. Achievements may belong to a category but not be counted for display: e.g. among those which are part of a series (100 Quests Completed, 500 Quests Completed), only the achievement most recently completed and the achievement following it in the series are shown.

**Signature:** `numItems, numCompleted = GetCategoryNumAchievements(id)`

**Arguments:**
- `id` - The numeric ID of an achievement/statistic category (`number`)

**Returns:**
- `numItems` - Number of achievements or statistics to display in the category (`number`)
- `numCompleted` - Number of completed achievements in the category (or 0 for statistics) (`number`)




## GetChannelDisplayInfo

Returns information about an entry in the channel list display

**Signature:** `name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(index)`

**Arguments:**
- `index` - Index of an entry in the channel list display (between 1 and `GetNumDisplayChannels()`) (`number`)

**Returns:**
- `name` - Name of the channel or header (`string`)
- `header` - 1 if the entry is a group header; otherwise nil (`1nil`)
- `collapsed` - 1 if the entry is a collapsed group header; otherwise nil (`1nil`)
- `channelNumber` - Number identifying the channel (as returned by `GetChannelList()` and used by `SendChatMessage()` and other channel functions) (`number`)
- `count` - Number of characters in the channel (`number`)
- `active` - 1 if the channel is currently active; otherwise nil. (Used for special server channels, e.g. "Trade" and "LookingForGroup", which can only be used under certain conditions) (`1nil`)
- `category` - Category to which the chat channel belongs (`string`) 

 - `CHANNEL_CATEGORY_CUSTOM` - Custom channels created by players
- `CHANNEL_CATEGORY_GROUP` - Group channels (party, raid, battleground)
- `CHANNEL_CATEGORY_WORLD` - World channels (General, Trade, etc.)
- `voiceEnabled` - 1 if voice chat is enabled for the channel; otherwise nil (`1nil`)
- `voiceActive` - 1 if voice chat is active for the channel; otherwise nil (`1nil`)




## GetChannelList

Returns the list of the channels the player has joined

**Signature:** `index, channel, ... = GetChannelList()`

**Returns:**
- `index` - Index of the channel (`number`)
- `channel` - Name of the channel (`string`)
- `...` - Additional `index, channel` pairs for each channel the player has joined (`list`)

**See also:** Channel functions.




## GetChannelName

Returns information about a chat channel

**Signature:** `channel, channelName, instanceID = GetChannelName(channelIndex) or GetChannelName("channelName")`

**Arguments:**
- `channelIndex` - A channel ID (`number`)
- `channelName` - A channel name (`string`)

**Returns:**
- `channel` - ID of the channel (`number`)
- `channelName` - Name of the channel (`string`)
- `instanceID` - The channel's instance ID, or 0 if there are not separate instances of the channel. (`number`)

**See also:** Channel functions.




## GetChannelRosterInfo

Returns information about a character in a chat channel in the channel list display

**Signature:** `name, owner, moderator, muted, active, enabled = GetChannelRosterInfo(index, rosterIndex)`

**Arguments:**
- `index` - Index of a channel in the channel list display (between 1 and `GetNumDisplayChannels()`) (`number`)
- `rosterIndex` - Index of a participant in the channel (between 1 and `count`, where `count = select(5,``GetChannelDisplayInfo``(index)`) (`number`)

**Returns:**
- `name` - Name of the character (`string`)
- `owner` - 1 if the character is the channel owner; otherwise nil (`1nil`)
- `moderator` - 1 if the character is a channel moderator; otherwise nil (`1nil`)
- `muted` - 1 if the character is muted; otherwise nil (`1nil`)
- `active` - 1 if the character is currently speaking in the channel; otherwise nil (`1nil`)
- `enabled` - 1 if the character has voice chat active for the channel; otherwise nil (`1nil`)

**See also:** Channel functions.




## GetChatTypeIndex

Returns the numeric index corresponding to a chat message type. These indices are used in the default UI to identify lines printed in a chat window, allowing (for example) their color to be changed to match changes in the player's color preferences.

**Signature:** `index = GetChatTypeIndex("messageGroup")`

**Arguments:**
- `messageGroup` - Token identifying a message type (`string`, chatMsgType)

**Returns:**
- `index` - Numeric index of the chat type (`number`)

**See also:** Chat functions.




## GetChatWindowChannels

Returns the saved list of channels to which a chat window is subscribed

**Signature:** `channelName, channelId, ... = GetChatWindowChannels(index)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)

**Returns:**
- `channelName` - Name of the channel (`string`)
- `channelId` - Numeric id for the channel (`number`)
- `...` - Additional `channelName, channelId` pairs for each channel belonging to the chat window (`list`)




## GetChatWindowInfo

Returns the saved settings for a chat window. These values reflect the settings saved between sessions, which are used by the default UI to set up the chat frames it displays.

**Signature:** `name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(index)`

**Arguments:**
- `index` - Index of the window you wish you get information on (starts at 1) (`number`)

**Returns:**
- `name` - Name of the chat window (`string`)
- `fontSize` - Font size for text displayed in the chat window (`number`)
- `r` - Red component of the window's background color (0.0 - 1.0) (`number`)
- `g` - Green component of the window's background color (0.0 - 1.0) (`number`)
- `b` - Blue component of the window's background color (0.0 - 1.0) (`number`)
- `alpha` - Alpha value (opacity) of the window's background (0 = fully transparent, 1 = fully opaque) (`number`)
- `shown` - 1 if the window should be shown; 0 if it should be hidden (`number`)
- `locked` - 1 if the window should be locked; 0 if it should be movable/resizable (`number`)
- `docked` - 1 if the window should be docked to the main chat window; otherwise 0 (`number`)
- `uninteractable` - 1 if the window should ignore all mouse events; otherwise 0 (`number`)

**See also:** Chat functions.




## GetChatWindowMessages

Returns the saved list of messages to which a chat window is subscribed

**Signature:** `... = GetChatWindowMessages(index)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)

**Returns:**
- `...` - A list of `chatMsgType`s for which the chat window is subscribed (`list`)

**See also:** Chat functions.




## GetChatWindowSavedDimensions




## GetChatWindowSavedPosition




## GetClickFrame

Returns the Frame object associated with the given name. 
Returns nil if there is no UI object with the name given, or if the named UI object is not a Frame.

**Signature:** `frame = GetClickFrame("name")`

**Arguments:**
- `name` - Name of a Frame or other UI object (`string`)

**Returns:**
- `frame` - A reference to the named frame (`table`)




## GetCoinIcon

Returns an icon representing an amount of money

**Signature:** `icon = GetCoinIcon(amount)`

**Arguments:**
- `amount` - Amount of money in copper (`number`)

**Returns:**
- `icon` - Path to an icon texture representing the amount (`string`) 

 - `Interface\Icons\INV_Misc_Coin_01` - Small amount of Gold
- `Interface\Icons\INV_Misc_Coin_02` - Large amount of Gold
- `Interface\Icons\INV_Misc_Coin_03` - Small amount of Silver
- `Interface\Icons\INV_Misc_Coin_04` - Large amount of Silver
- `Interface\Icons\INV_Misc_Coin_05` - Small amount of Copper
- `Interface\Icons\INV_Misc_Coin_06` - Large amount of Copper

**See also:** Money functions.




## GetCoinText

Returns a localized string describing an amount of money

**Signature:** `coinText = GetCoinText(amount, "separator")`

**Arguments:**
- `amount` - Amount of money in copper (`number`)
- `separator` - String to use as separator (', ' is used if nil) (`string`)

**Returns:**
- `coinText` - Text description of the amount using localized names for 'Gold', 'Silver' and 'Copper' (`string`)




## GetCoinTextureString

Returns a string with embedded coin icons describing an amount of money. As in most places where money amounts are shown in the UI, lesser denominations are only shown when non-zero.

**Signature:** `coinText = GetCoinTextureString(amount [, fontSize])`

**Arguments:**
- `amount` - Amount of money in copper (`number`)
- `fontSize` - Size of the money icons. Defaults to 14. (`number`)

**Returns:**
- `coinText` - Text description of the amount using embedded texture codes for gold, silver, and copper coin icons (`string`)

**See also:** Money functions.




## GetCombatRating

Returns the value of a combat rating for the player

**Signature:** `rating = GetCombatRating(ratingIndex)`

**Arguments:**
- `ratingIndex` - Index of a rating; the following global constants are provided for convenience (`number`) 

 - `CR_BLOCK` - Block skill
- `CR_CRIT_MELEE` - Melee critical strike chance
- `CR_CRIT_RANGED` - Ranged critical strike chance
- `CR_CRIT_SPELL` - Spell critical strike chance
- `CR_CRIT_TAKEN_MELEE` - Melee Resilience
- `CR_CRIT_TAKEN_RANGED` - Ranged Resilience
- `CR_CRIT_TAKEN_SPELL` - Spell Resilience
- `CR_DEFENSE_SKILL` - Defense skill
- `CR_DODGE` - Dodge skill
- `CR_HASTE_MELEE` - Melee haste
- `CR_HASTE_RANGED` - Ranged haste
- `CR_HASTE_SPELL` - Spell haste
- `CR_HIT_MELEE` - Melee chance to hit
- `CR_HIT_RANGED` - Ranged chance to hit
- `CR_HIT_SPELL` - Spell chance to hit
- `CR_HIT_TAKEN_MELEE` - Unused
- `CR_HIT_TAKEN_RANGED` - Unused
- `CR_HIT_TAKEN_SPELL` - Unused
- `CR_PARRY` - Parry skill
- `CR_WEAPON_SKILL` - Weapon skill
- `CR_WEAPON_SKILL_MAINHAND` - Main-hand weapon skill
- `CR_WEAPON_SKILL_OFFHAND` - Offhand weapon skill
- `CR_WEAPON_SKILL_RANGED` - Ranged weapon skill

**Returns:**
- `rating` - Value of the rating for the player (`number`)




## GetCombatRatingBonus

Returns the percentage effect for the player's current value of a given combat rating. Used in the default UI to show tooltips with actual percentage effects (such as increased parry chance or reduced critical strike damage taken) when mousing over rating information in the Character window.

**Signature:** `ratingBonus = GetCombatRatingBonus(ratingIndex)`

**Arguments:**
- `ratingIndex` - Index of a rating; the following global constants are provided for convenience (`number`) 

 - `CR_BLOCK` - Block skill
- `CR_CRIT_MELEE` - Melee critical strike chance
- `CR_CRIT_RANGED` - Ranged critical strike chance
- `CR_CRIT_SPELL` - Spell critical strike chance
- `CR_CRIT_TAKEN_MELEE` - Melee Resilience
- `CR_CRIT_TAKEN_RANGED` - Ranged Resilience
- `CR_CRIT_TAKEN_SPELL` - Spell Resilience
- `CR_DEFENSE_SKILL` - Defense skill
- `CR_DODGE` - Dodge skill
- `CR_HASTE_MELEE` - Melee haste
- `CR_HASTE_RANGED` - Ranged haste
- `CR_HASTE_SPELL` - Spell haste
- `CR_HIT_MELEE` - Melee chance to hit
- `CR_HIT_RANGED` - Ranged chance to hit
- `CR_HIT_SPELL` - Spell chance to hit
- `CR_HIT_TAKEN_MELEE` - Unused
- `CR_HIT_TAKEN_RANGED` - Unused
- `CR_HIT_TAKEN_SPELL` - Unused
- `CR_PARRY` - Parry skill
- `CR_WEAPON_SKILL` - Weapon skill
- `CR_WEAPON_SKILL_MAINHAND` - Main-hand weapon skill
- `CR_WEAPON_SKILL_OFFHAND` - Offhand weapon skill
- `CR_WEAPON_SKILL_RANGED` - Ranged weapon skill

**Returns:**
- `ratingBonus` - Percentage change in the underlying statistic or mechanic conferred by the player's rating value (`number`)




## GetComboPoints

Returns the player's number of combo points on the target.

**Signature:** `comboPoints = GetComboPoints("unit" [, "target"])`

**Arguments:**
- `unit` - Either 'player' or 'vehicle' (`string`, unitID)
- `target` - Unit to check for combo points. (`string`, unitID)

**Returns:**
- `comboPoints` - Number of combo points (between 0 and `MAX_COMBO_POINTS`) (`number`)

**See also:** Player information functions.




## GetCompanionCooldown

Returns cooldown information for a non-combat pet or mount

**Signature:** `start, duration, enable = GetCompanionCooldown("type", index)`

**Arguments:**
- `type` - Type of companion (`string`) 

 - `CRITTER` - A non-combat pet
- `MOUNT` - A mount
- `index` - Index of a companion (between 1 and `GetNumCompanions(type)`) (`number`)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the companion is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the companion is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the companion is ready.) (`number`)




## GetCompanionInfo

Returns information about a non-combat pet or mount

**Signature:** `creatureID, creatureName, spellID, icon, active = GetCompanionInfo("type", index)`

**Arguments:**
- `type` - Type of companion (`string`) 

 - `CRITTER` - A non-combat pet
- `MOUNT` - A mount
- `index` - Index of a companion (between 1 and `GetNumCompanions(type)`) (`number`)

**Returns:**
- `creatureID` - Unique ID of the companion (usable with `PlayerModel:SetCreature`) (`number`)
- `creatureName` - Localized name of the companion (`string`)
- `spellID` - The "spell" for summoning the companion (usable with `GetSpellLink` et al) (`number`)
- `icon` - Path to an icon texture for the companion (`string`)
- `active` - 1 if the companion queried is currently summoned; otherwise nil (`1nil`)




## GetComparisonAchievementPoints

Returns the comparison unit's total achievement points earned. 
 

Only accurate once the `INSPECT_ACHIEVEMENT_READY `event has fired following a call to `SetAchievementComparisonUnit()`. No longer accurate once `ClearAchievementComparisonUnit()` is called.

**Signature:** `points = GetComparisonAchievementPoints()`

**Returns:**
- `points` - Total number of achievement points earned by the comparison unit (`number`)

**See also:** Achievement functions.




## GetComparisonCategoryNumAchievements

Returns the number of achievements completed by the comparison unit within a category. 
 

Only accurate once the `INSPECT_ACHIEVEMENT_READY `event has fired following a call to `SetAchievementComparisonUnit()`. No longer accurate once `ClearAchievementComparisonUnit()` is called.

**Signature:** `numCompleted = GetComparisonCategoryNumAchievements(id)`

**Arguments:**
- `id` - The numeric ID of an achievement category (`number`)

**Returns:**
- `numCompleted` - Number of achievements completed by the comparison unit in the category (`number`)

**See also:** Achievement functions.




## GetComparisonStatistic

Returns the comparison unit's data for a statistic. 
 

Only accurate once the `INSPECT_ACHIEVEMENT_READY `event has fired following a call to `SetAchievementComparisonUnit()`. No longer accurate once `ClearAchievementComparisonUnit()` is called.

**Signature:** `info = GetComparisonStatistic(id)`

**Arguments:**
- `id` - The numeric ID of a statistic (`number`)

**Returns:**
- `info` - The comparison unit's data for the statistic, or "--" if none has yet been recorded for it (`string`)

**See also:** Achievement functions.




## GetContainerFreeSlots

Returns a list of open slots in a container. The optional argument `returnTable` allows for performance optimization in cases where this function is expected to be called repeatedly. Rather than creating new tables each time the function is called (eventually requiring garbage collection), an existing table can be recycled. (Note, however, that this function does not clear the table's contents; use `wipe()` first to guarantee consistent results.)

**Signature:** `slotTable = GetContainerFreeSlots(container [, returnTable])`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `returnTable` - Reference to a table to be filled with return values (`table`)

**Returns:**
- `slotTable` - A table listing the indices of open slots in the given container (`table`)

**See also:** Container functions.




## GetContainerItemCooldown

Returns cooldown information about an item in the player's bags

**Signature:** `start, duration, enable = GetContainerItemCooldown(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**Returns:**
- `start` - The value of `GetTime()` at the moment the cooldown began, or 0 if the item is ready (`number`)
- `duration` - The length of the cooldown, or 0 if the item is ready (`number`)
- `enable` - 1 if a Cooldown UI element should be used to display the cooldown, otherwise 0. (Does not always correlate with whether the item is ready.) (`number`)




## GetContainerItemDurability

Returns durability status for an item in the player's bags

**Signature:** `durability, max = GetContainerItemDurability(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**Returns:**
- `durability` - The item's current durability (`number`)
- `max` - The item's maximum durability (`number`)

**See also:** Container functions.




## GetContainerItemGems

Returns the gems socketed in an item in the player's bags. The IDs returned refer to the gems themselves (not the enchantments they provide), and thus can be passed to `GetItemInfo()` to get a gem's name, quality, icon, etc.

**Signature:** `gem1, gem2, gem3 = GetContainerItemGems(container, slot)`

**Arguments:**
- `container` - The index of the container (`bagID`)
- `slot` - The slot within the given container; slots are numbered left-to-right, top-to-bottom, starting with the leftmost slot on the top row (`number`)

**Returns:**
- `gem1` - Item ID of the first gem socketed in the item (`itemID`)
- `gem2` - Item ID of the second gem socketed in the item (`itemID`)
- `gem3` - Item ID of the third gem socketed in the item (`itemID`)




## GetContainerItemID

Returns the item ID of an item in the player's bags

**Signature:** `id = GetContainerItemID(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**Returns:**
- `id` - Numeric ID of the item in the given slot (`itemID`)




## GetContainerItemInfo

Returns information about an item in the player's bags

**Signature:** `texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**Returns:**
- `texture` - Path to the icon texture for the item (`string`)
- `count` - Number of items in the slot (`number`)
- `locked` - 1 if the item is locked; otherwise nil. Items become locked while being moved, split, or placed into other UI elements (such as the mail, trade, and auction windows). (`1nil`)
- `quality` - Quality (or rarity) of the item (`number`, itemQuality)
- `readable` - 1 if the item is readable; otherwise nil. This value is used by the default UI to show a special cursor over items such as books and scrolls which can be read by right-clicking. (`1nil`)
- `lootable` - 1 if the item is a temporary container containing items that can be looted; otherwise nil. Examples include the Bag of Fishing Treasures and Small Spice Bag rewarded by daily quests, lockboxes (once unlocked), and the trunks occasionally found while fishing. (`1nil`)
- `link` - A hyperlink for the item (`itemLink`)




## GetContainerItemLink

Returns a hyperlink for an item in the player's bags

**Signature:** `link = GetContainerItemLink(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)

**See also:** Container functions, Hyperlink functions.




## GetContainerItemPurchaseInfo

Returns information about alternate currencies refunded for returning an item to vendors. 
Items bought with alternate currency (honor points, arena points, or special items such as Emblems of Heroism and Dalaran Cooking Awards) can be returned to a vendor for a full refund, but only within a limited time after the original purchase.

If the given container slot is empty, contains an item which cannot be returned for an alternate currency refund, or contains an item for which the refund grace period has expired, all returns are `nil`.

**Signature:** `money, itemCount, refundSec, currecycount, hasEnchants = GetContainerItemPurchaseInfo(container, slot, IsEquipped)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)
- `IsEquipped` - wheather to get an equipped item info (`boolean`)

**Returns:**
- `money` - Amount of copper to be refunded (`number`)
- `itemCount` - Number of different item currencies to be refunded (e.g. the price a PvP mount is in 3 currencies, as it requires multiple battlegrounds' Marks of Honor) (`number`)
- `refundSec` - Seconds remaining until this item is no longer eligible to be returned for a refund (`number`)
- `currecycount` - Amount of currency to be refunded (`number`)
- `hasEnchants` - weather the item is enchanted (`number`)

**See also:** Container functions, Merchant functions, Currency functions.




## GetContainerItemPurchaseItem

Returns information about a specific currency refunded for returning an item to vendors. See `GetContainerItemPurchaseInfo` for more information about alternate currency refunds.

**Signature:** `texture, quantity, link = GetContainerItemPurchaseItem(container, slot, index)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)
- `index` - Index of the currency type; between 1 and `itemCount`, where `itemCount` is the 4th return from `GetContainerItemPurchaseInfo()` for the same container and slot (`number`)

**Returns:**
- `texture` - Path to an icon texture for the currency item (`string`)
- `quantity` - Quantity of the currency item to be refunded (`number`)
- `link` - Hyperlink for the currency item (`itemLink`)




## GetContainerItemQuestInfo

Returns quest information about an item in the player's bags

**Signature:** `isQuest, questId, isActive = GetContainerItemQuestInfo(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**Returns:**
- `isQuest` - true if the item is a quest item, nil otherwise. (`boolean`)
- `questId` - ID of the quest started by the item, nil if the item does not start a quest. (`number`)
- `isActive` - 1 if the quest started by the item is in the player's quest log, nil otherwise. (`1nil`)

**See also:** Container functions, Quest functions.




## GetContainerNumFreeSlots

Returns the number of free slots in a container and the types of items it can hold

**Signature:** `freeSlots, bagType = GetContainerNumFreeSlots(container)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)

**Returns:**
- `freeSlots` - Number of empty slots in the bag (`number`)
- `bagType` - Bitwise OR of the item families that can be put into the container; see `GetItemFamily` for details (`number`, bitfield)

**See also:** Container functions.




## GetContainerNumSlots

Returns the number of slots in one of the player's bags

**Signature:** `numSlots = GetContainerNumSlots(container)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)

**Returns:**
- `numSlots` - Number of item slots in the container (`number`)

**See also:** Container functions.




## GetCorpseMapPosition

Returns the position of the player's corpse on the world map. Returns `0,0` if the location of the player's corpse is not visible on the current world map.

**Signature:** `corpseX, corpseY = GetCorpseMapPosition()`

**Returns:**
- `corpseX` - Horizontal position of the player's corpse relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `corpseY` - Vertical position of the player's corpse relative to the zone map (0 = top, 1 = bottom) (`number`)




## GetCorpseRecoveryDelay

Returns the amount of time left until the player can recover their corpse. Applies to resurrection spells offered by other units, resurrecting by returning to the player's corpse as a ghost, and to resurrecting at a graveyard's spirit healer, if the player has recently died several times in short succession.

**Signature:** `timeLeft = GetCorpseRecoveryDelay()`

**Returns:**
- `timeLeft` - Amount of time remaining before the player can resurrect (in seconds); 0 if the player can resurrect immediately (`number`)

**See also:** Player information functions.




## GetCritChance

Returns the player's melee critical strike chance

**Signature:** `critChance = GetCritChance()`

**Returns:**
- `critChance` - The player's percentage critical strike chance for melee attacks (`number`)

**See also:** Stat information functions.




## GetCritChanceFromAgility

Returns additional critical strike chance provided by Agility

**Signature:** `critChance = GetCritChanceFromAgility(["unit"])`

**Arguments:**
- `unit` - A unit to query; only valid for `player` and `pet`, defaults to `player` if omitted (`string`, unitID)

**Returns:**
- `critChance` - Additional percentage chance of critical strikes conferred by the unit's Agility statistic (`number`)

**See also:** Stat information functions.




## GetCurrencyListInfo

Returns information about a currency type (or headers in the Currency UI)

**Signature:** `name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID = GetCurrencyListInfo(index)`

**Arguments:**
- `index` - Index of a currency type in the currency list (between 1 and `GetCurrencyListSize()`) (`number`)

**Returns:**
- `name` - Name of the currency type or category header (`string`)
- `isHeader` - True if this listing is a category header, false for actual currencies (`boolean`)
- `isExpanded` - True if this listing is a category header whose contents are shown, false for collapsed headers and actual currencies (`boolean`)
- `isUnused` - True if the player has marked this currency as Unused (`boolean`)
- `isWatched` - True if the player has marked this currency to be watched on the backpack UI (`boolean`)
- `count` - Amount of the currency the player has (`number`)
- `extraCurrencyType` - 1 for Arena points, 2 for Honor points, 0 for other currencies (`number`)
- `icon` - Path to a texture representing the currency item (not applicable for Arena/Honor points) (`string`)
- `itemID` - ID for the currency item (`number`)




## GetCurrencyListSize

Returns the number of list entries to show in the Currency UI

**Signature:** `numEntries = GetCurrencyListSize()`

**Returns:**
- `numEntries` - Number of currency types (including category headers) to be shown in the Currency UI (`number`)




## GetCurrentArenaSeason

Returns a number identifying the current arena season. New arena seasons begin every few months, resetting team rankings and providing new rewards.

**Signature:** `season = GetCurrentArenaSeason()`

**Returns:**
- `season` - Number identifying the current arena season (`number`)

**See also:** Arena functions.




## GetCurrentBindingSet

Returns which set of key bindings is currently in use

**Signature:** `bindingSet = GetCurrentBindingSet()`

**Returns:**
- `bindingSet` - Set of bindings currently in use (`number`) 

 - `1` - Key bindings shared by all characters
- `2` - Character specific key bindings

**See also:** Keybind functions.




## GetCurrentGuildBankTab

Returns the currently selected guild bank tab

**Signature:** `GetCurrentGuildBankTab(currentTab)`

**Arguments:**
- `currentTab` - Index of the selected guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**See also:** Guild bank functions.




## GetCurrentKeyBoardFocus

Returns the frame currently handling keyboard input. Typically an EditBox

**Signature:** `frame = GetCurrentKeyBoardFocus()`

**Returns:**
- `frame` - Frame currently handling keyboard input, or nil if no frame is currently focused (`table`)




## GetCurrentMapAreaID

Returns an ID number for the current map zone. 
Currently only used in the default UI to determine whether the Wintergrasp map is showing (and if so, display the time remaining until the next battle).

**Signature:** `areaID = GetCurrentMapAreaID()`

**Returns:**
- `areaID` - A number identifying the current map zone (`number`)

**See also:** Map functions.




## GetCurrentMapContinent

Returns the current world map continent

**Signature:** `continent = GetCurrentMapContinent()`

**Returns:**
- `continent` - Index of the world map's current continent (in the list returned by `GetMapContinents()`, or one of the following values) (`number`) 

 - `-1` - Cosmic map
- `0` - Azeroth
- `1` - Kalimdor
- `2` - Eastern Kingdoms
- `3` - Outland
- `4` - Northrend
- `5` - The Maelstrom

**See also:** Map functions.




## GetCurrentMapDungeonLevel

Returns which map image is currently selected on the world map (for zones which use more than one map image). Used in zones with more than one "floor" or area, such as Dalaran and several Wrath of the Lich King dungeons and raids. More than one map image may contain the player's current location; if the world map has not been explicitly set to show a particular area, this returns whichever is the "best" match.

**Signature:** `level = GetCurrentMapDungeonLevel()`

**Returns:**
- `level` - Index of the current map image (`number`)




## GetCurrentMapZone

Returns the current world map zone

**Signature:** `zone = GetCurrentMapZone()`

**Returns:**
- `zone` - Index of a zone within the continent (in the list returned by `GetMapZones``(``GetCurrentMapContinent()``)`), or 0 for the continent map (`number`)




## GetCurrentMultisampleFormat

Returns the index of the currently selected multi-sample format

**Signature:** `index = GetCurrentMultisampleFormat()`

**Returns:**
- `index` - The index of the currently selected multi-sample format. (`number`)




## GetCurrentResolution

Returns the index of the current resolution setting. For the dimensions of a resolution setting, use `GetScreenResolutions()`.

**Signature:** `index = GetCurrentResolution()`

**Returns:**
- `index` - Index of the current resolution setting (`number`)




## GetCurrentTitle

Returns the currently selected player title

**Signature:** `currentTitle = GetCurrentTitle()`

**Returns:**
- `currentTitle` - Index of the player's current title (between 1 and `GetNumTitles()`) (`integer`)

**See also:** Player information functions.




## GetCursorInfo

Returns information about the contents of the cursor

**Signature:** `type, data, subType = GetCursorInfo()`

**Returns:**
- `type` - Type of data attached to the cursor (`string`) 

 - `companion`
- `equipmentset`
- `guildbankmoney`
- `item`
- `macro`
- `merchant`
- `money`
- `spell`
- `data` - Identifier for the data on the cursor; varies by type: (`value`) 

 - `companion` - Index of the companion in the non-combat pet or mount list (`number`)
- `equipmentset` - Name of the equipment set (`string`)
- `guildbankmoney` - Amount of the money from the guild bank (in copper) (`number`)
- `item` - Numeric identifier for the item (`number`, `itemID`)
- `macro` - Index of the macro in the macro listing (`number`, `macroID`)
- `merchant` - Index of the item in the vendor's listings (`number`)
- `money` - Amount of the player's money (in copper) (`number`)
- `spell` - Index of the spell in the player's spellbook (`number`, `spellbookID`)
- `subType` - Secondary identifier for the data on the cursor; used only for certain types: (`string`) 

 - `companion` - `"CRITTER"` or `"MOUNT"`, indicating whether the returned `data` is an index in the non-combat pet or mount list
- `item` - A complete `hyperlink` for the item
- `spell` - `"spell"` or `"pet"`, indicating whether the returned `data` is an index in the player's or pet's spellbook




## GetCursorMoney

Returns the amount of money currently on the cursor

**Signature:** `cursorMoney = GetCursorMoney()`

**Returns:**
- `cursorMoney` - Amount of money currently on the cursor (in copper) (`number`)




## GetCursorPosition

Returns the absolute position of the mouse cursor

**Signature:** `cursorX, cursorY = GetCursorPosition()`

**Returns:**
- `cursorX` - Scale-independent X coordinate of the cursor's current position (`number`)
- `cursorY` - Scale-independent Y coordinate of the cursor's current position (`number`)




## GetCVar

_No content available._




## GetCVarAbsoluteMax

_No snapshot available (page did not exist in archive)._




## GetCVarAbsoluteMin

Returns the absolute minimum value allowed for a configuration variable

**Signature:** `min = GetCVarAbsoluteMin("cvar")`

**Arguments:**
- `cvar` - Name of a CVar (`string`)

**Returns:**
- `min` - Absolute minimum value allowed for the CVar (`number`)




## GetCVarBool

Returns the value of a configuration variable in a format compatible with Lua conditional expressions. All configuration variables are stored as strings; many CVars represent the state of a binary flag and are stored as either `"1"` or `"0"`. This function provides a convenient way to test the state of such variables without the extra syntax required to explicitly check for `"1"` or `"0"` values.

**Signature:** `value = GetCVarBool("cvar")`

**Arguments:**
- `cvar` - Name of a CVar (`string`)

**Returns:**
- `value` - 1 if the CVar's value should be treated as `true`; nil if it should be treated as `false` (`1nil`)




## GetCVarDefault

_No content available._




## GetCVarInfo

Returns information about a configuration variable

**Signature:** `value, defaultValue, serverStoredAccountWide, serverStoredPerCharacter = GetCVarInfo("cvar")`

**Arguments:**
- `cvar` - Name of a CVar (`string`)

**Returns:**
- `value` - Current value of the CVar (`string`)
- `defaultValue` - Default value of the CVar (`string`)
- `serverStoredAccountWide` - 1 if the CVar's value is saved on the server and shared by all characters on the player's account; otherwise nil (`1nil`)
- `serverStoredPerCharacter` - 1 if the CVar's value is saved on the server and specific to the current cahracter; otherwise nil (`1nil`)

**See also:** CVar functions.




## GetCVarMax

_No snapshot available (page did not exist in archive)._




## GetCVarMin

Returns the minimum recommended value for a configuration variable. Used in the default UI to set the lower bounds for options controlled by slider widgets.

**Signature:** `min = GetCVarMin("cvar")`

**Arguments:**
- `cvar` - Name of a CVar (`string`)

**Returns:**
- `min` - Minimum value allowed for the CVar (`number`)



