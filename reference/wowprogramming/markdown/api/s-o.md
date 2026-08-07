# WoW API — S (O*)

_22 functions_

---

## SocketContainerItem

Opens an item from the player's bags for socketing

**Signature:** `SocketContainerItem(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**See also:** Socketing functions, Container functions.



## SocketInventoryItem

Opens an equipped item for socketing

**Signature:** `SocketInventoryItem(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**See also:** Socketing functions, Inventory functions.



## sort

Sorts a table. Alias for the standard library function `table.sort`.

**Signature:** `sort(table [, comparator])`

**Arguments:**
- `table` - A table (`number`)
- `comparator` - A function to compare table elements during the sort; takes two arguments and returns `true` if the first argument should be ordered before the second in the sorted table; equivalent to `function(a,b) return a < b end` if omitted (`function`)



## SortArenaTeamRoster

Sorts the selected arena team's roster. Affects the ordering of member information returned by `GetArenaTeamRosterInfo`. Sorting by the same criterion repeatedly reverses the sort order.

**Signature:** `SortArenaTeamRoster("sortType")`

**Arguments:**
- `sortType` - Criterion for sorting the roster (`string`) 

 - `class` - Sort by class
- `name` - Sort by name
- `played` - Sort by number of games played in the current week
- `rating` - Sort by personal rating
- `seasonplayed` - Sort by number of games played in the current arena season
- `seasonwon` - Sort by number of games won in the current arena season
- `won` - Sort by number of games won in the current week



## SortAuctionApplySort

Applies a set of auction listing sort criteria set via `SortAuctionSetSort`. Sort criteria are applied server-side, affecting not only the order of items within one "page" of listings but the order in which items are collected into pages.

Any currently displayed listings are re-sorted server-side: the `AUCTION_ITEM_LIST_UPDATE`, `AUCTION_BIDDER_LIST_UPDATE`, or `AUCTION_OWNED_LIST_UPDATE` event fires once the re-sorted data is available to the client; listing information can then be retrieved using `GetAuctionItemInfo()` or other Auction APIs.

**Signature:** `SortAuctionApplySort("list")`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed



## SortAuctionClearSort

Clears any current sorting rules for an auction house listing

**Signature:** `SortAuctionClearSort("list")`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed

**See also:** Auction functions.



## SortAuctionItems

Sorts the auction house listing. No longer used in the default UI; see `SortAuctionClearSort()`, `SortAuctionSetSort()`, and `SortAuctionApplySort()` instead.

**Signature:** `SortAuctionItems("type", "sort")`

**Arguments:**
- `type` - The type of auction listing to sort (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Standard auction house listing
- `owner` - Auctions the player has placed
- `sort` - Criterion for sorting the list (`string`) 

 - `bid` - Amount of the current or minimum bid on the item
- `buyout` - Buyout price of the item
- `duration` - Time remaining before the auction expires
- `level` - Required character level to use or equip the item
- `minbidbuyout` - Buyout price, or minimum bid if no buyout price is available
- `name` - Name of the item
- `quality` - itemQuality of the item
- `quantity` - Number of stacked items in the auction
- `seller` - Name of the character who created of the auction (or in the `owner` listing, the current high bidder)
- `status` - Status of the auction (e.g. in the `bidder` listing, whether the player has been outbid)



## SortAuctionSetSort

Builds a list of sort criteria for auction listings. Has no effect until `SortAuctionApplySort(type)` is called; thus, this function can be called repeatedly to build a complex set of sort criteria. Sort criteria are applied server-side, affecting not only the order of items within one "page" of listings but the order in which items are collected into pages.

Criteria are applied in the order set by this function; i.e. the last criterion set becomes the primary sort criterion (see example).

**Signature:** `SortAuctionSetSort("list", "sort", reversed)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `sort` - Criterion to add to the sort (`string`) 

 - `bid` - Amount of the current or minimum bid on the item
- `buyout` - Buyout price of the item
- `duration` - Time remaining before the auction expires
- `level` - Required character level to use or equip the item
- `minbidbuyout` - Buyout price, or minimum bid if no buyout price is available
- `name` - Name of the item
- `quality` - itemQuality of the item
- `quantity` - Number of stacked items in the auction
- `seller` - Name of the character who created of the auction (or in the `owner` listing, the current high bidder)
- `status` - Status of the auction (e.g. in the `bidder` listing, whether the player has been outbid)
- `reversed` - True to sort in reverse order; otherwise false. "Reverse" here is relative to the default order, not to absolute value: e.g. the default order for `quality` is descending (Epic, Rare, Uncommon, etc), but the default order for `level` is ascending (1-80) (`boolean`)

**See also:** Auction functions.



## SortBattlefieldScoreData

Sorts the battleground scoreboard. Battleground-specific statistics include flags captured in Warsong Gulch, towers assaulted in Alterac Valley, etc. For the name and icon associated with each statistic, see `GetBattlefieldStatInfo()`.

**Signature:** `SortBattlefieldScoreData("sortType")`

**Arguments:**
- `sortType` - Criterion for sorting the scoreboard data (`string`) 

 - `class` - Sort by character class
- `cp` - Sorts by honor points gained
- `damage` - Sorts by damage done
- `deaths` - Sort by number of deaths
- `healing` - Sorts by healing done
- `hk` - Sorts by number of honor kills
- `kills` - Sort by number of kills
- `name` - Sort by participant name
- `stat1` - Battlefield-specific statistic 1
- `stat2` - Battlefield-specific statistic 2
- `stat3` - Battlefield-specific statistic 3
- `stat4` - Battlefield-specific statistic 4
- `stat5` - Battlefield-specific statistic 5
- `stat6` - Battlefield-specific statistic 6
- `stat7` - Battlefield-specific statistic 7
- `team` - Sort by team name

**See also:** Battlefield functions.



## SortBGList



## SortGuildRoster

Sorts the guild roster. Sorting repeatedly by the same criterion will reverse the sort order. Previous sorts are reused when a new criterion is applied: to sort by two criteria, sort first by the secondary criterion and then by the primary criterion.

**Signature:** `SortGuildRoster("type")`

**Arguments:**
- `type` - Criterion by which to sort the roster (`string`) 

 - `class` - Sort by class name
- `level` - Sort by character level
- `name` - Sort by name
- `note` - Sort by guild note
- `online` - Sory by last online time
- `rank` - Sort by guild rank
- `zone` - Sort by current zone name



## SortQuestWatches

Sorts the quests listed in the watch frame based on the set criteria

**Signature:** `changed = SortQuestWatches()`

**Returns:**
- `changed` - `true` if the quest watches were re-ordered during the sort, otherwise `false` (`boolean`)

**See also:** Quest functions, Objectives tracking functions.



## SortWho

Sorts the Who system query results list. Sorting by the same criterion twice will reverse the sort order.

**Signature:** `SortWho("sortType")`

**Arguments:**
- `sortType` - Criterion for sorting the list (`string`) 

 - `class` - Sort by class name
- `guild` - Sort by guild name
- `level` - Sort by player level
- `name` - Sort by player name
- `race` - Sort by race name
- `zone` - Sort by current zone name



## Sound_ChatSystem_GetInputDriverNameByIndex

Returns the name of the given chat system sound input driver

**Signature:** `Sound_ChatSystem_GetInputDriverNameByIndex(index)`

**Arguments:**
- `index` - The desired index (`number`)



## Sound_ChatSystem_GetNumInputDrivers

Returns the number of chat system sound input drivers

**Signature:** `Sound_ChatSystem_GetNumInputDrivers()`

**See also:** Sound functions.



## Sound_ChatSystem_GetNumOutputDrivers

Returns the number of chat system sound output drivers

**Signature:** `Sound_ChatSystem_GetNumOutputDrivers()`

**See also:** Sound functions.



## Sound_ChatSystem_GetOutputDriverNameByIndex

Returns the name of the given chat system sound output driver

**Signature:** `Sound_ChatSystem_GetOutputDriverNameByIndex(index)`

**Arguments:**
- `index` - The desired index (`number`)



## Sound_GameSystem_GetInputDriverNameByIndex

Returns the name of the given game sound input driver

**Signature:** `Sound_GameSystem_GetInputDriverNameByIndex(index)`

**Arguments:**
- `index` - The desired index (`number`)



## Sound_GameSystem_GetNumInputDrivers

Returns the number of game sound input drivers

**Signature:** `Sound_GameSystem_GetNumInputDrivers()`

**See also:** Sound functions.



## Sound_GameSystem_GetNumOutputDrivers

Returns the number of game sound output drivers

**Signature:** `Sound_GameSystem_GetNumOutputDrivers()`



## Sound_GameSystem_GetOutputDriverNameByIndex

Returns the name of the given game sound output driver

**Signature:** `Sound_GameSystem_GetOutputDriverNameByIndex(index)`

**Arguments:**
- `index` - The desired index (`number`)



## Sound_GameSystem_RestartSoundSystem

Restarts the game's sound systems

**Signature:** `Sound_GameSystem_RestartSoundSystem()`

**See also:** Sound functions.


