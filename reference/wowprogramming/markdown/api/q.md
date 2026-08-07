# WoW API Functions — Q

_19 functions_

---

## QueryAuctionItems

Requests data from the server for the list of auctions meeting given search criteria. If any search criterion is omitted or `nil`, the search will include all possible values for that criterion.

Search queries are throttled, preventing abuse of the server by clients sending too many queries in short succession. Normal queries can be sent once every few seconds; mass queries return all results in the auction house instead of one "page" at a time, and can only be sent once every several minutes.

Query results are not returned immediately: the `AUCTION_ITEM_LIST_UPDATE` event fires once data is available; listing information can then be retrieved using `GetAuctionItemInfo()` or other Auction APIs.

**Signature:** `QueryAuctionItems(["name" [, minLevel [, maxLevel [, invTypeIndex [, classIndex [, subClassIndex [, page [, isUsable [, minQuality [, getAll]]]]]]]]]])`

**Arguments:**
- `name` - Full or partial item name to limit search results; will match any item whose name contains this string (`string`)
- `minLevel` - Maximum required character level of items to limit search results (`number`)
- `maxLevel` - Maximum required character level of items to limit search results (`number`)
- `invTypeIndex` - Index of an item inventory type to limit search results (note that `GetAuctionInvTypes(classIndex, subClassIndex)` returns a list of `token, display` pairs for each inventory type; thus, to convert a token index from that list for use here, divide by 2 and round up) (`number`)
- `classIndex` - Index of an item class to limit search results (in the list returned by `GetAuctionItemClasses()`) (`number`)
- `subClassIndex` - Index of an item subclass to limit search results (in the list returned by `GetAuctionItemSubClasses(classIndex)`) (`number`)
- `page` - Which "page" of search results to list, if more than `NUM_AUCTION_ITEMS_PER_PAGE` (50) auctions are available; nil to query the first (or only) page (`number`)
- `isUsable` - True to limit search results to only items which can be used or equipped by the player character; otherwise false (`boolean`)
- `minQuality` - Minimum quality (rarity) level of items to limit search results (`itemQuality`)
- `getAll` - True to perform a mass query (returning all listings at once); false to perform a normal query (returning a large number of listings in "pages" of `NUM_AUCTION_ITEMS_PER_PAGE` [50] at a time) (`boolean`)


## QueryGuildBankLog

Requests the item transaction log for a guild bank tab from the server. Fires the `GUILDBANKLOG_UPDATE` event when transaction log information becomes available.

**Signature:** `QueryGuildBankLog(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**See also:** Guild bank functions.


## QueryGuildBankTab

Requests information about the contents of a guild bank tab from the server. Fires the `GUILDBANKBAGSLOTS_CHANGED` event when information about the tab's contents becomes available.

**Signature:** `QueryGuildBankTab(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**See also:** Guild bank functions.


## QueryGuildBankText

Requests guild bank tab info text from the server. The text is not returned immediately; the `GUILDBANK_UPDATE_TEXT` event fires when text is available for retrieval by the `GetGuildBankText()` function.

**Signature:** `QueryGuildBankText(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**See also:** Guild bank functions.


## QueryGuildEventLog

Requests guild event log information from the server. Fires the `GUILD_EVENT_LOG_UPDATE` event when event log information becomes available.

**Signature:** `QueryGuildEventLog()`


## QueryQuestsCompleted

Queries the server for the player's completed quest information. This function is throttled by the server and can currently only be called every 15 minutes. This function will return immediately, and the `QUEST_QUERY_COMPLETE` will fire when the information is available from the server. At that point, it can be obtained using the GetQuestsCompleted function.

**Signature:** `QueryQuestsCompleted()`


## QuestChooseRewardError

Causes the default UI to display an error message indicating that the player must choose a reward to complete the quest presented by a questgiver. Fires a `UI_ERROR_MESSAGE` event containing a localized message identified by the global variable `ERR_QUEST_MUST_CHOOSE`. Choose wisely.

**Signature:** `QuestChooseRewardError()`

**See also:** Quest functions.


## QuestFlagsPVP

Returns whether accepting the offered quest will flag the player for PvP. Only valid when the questgiver UI is showing the accept/decline stage of a quest dialog (between the `QUEST_DETAIL` and `QUEST_FINISHED` events); otherwise may return nil or a value from the most recently displayed quest.

**Signature:** `questFlag = QuestFlagsPVP()`

**Returns:**
- `questFlag` - 1 if accepting the quest will flag the player for PvP for as long as it remains in the quest log; otherwise nil (`1nil`)

**See also:** Quest functions, PvP functions.


## QuestGetAutoAccept


## QuestIsDaily


## QuestIsWeekly


## QuestLogPushQuest

Shares a quest with other group members

**Signature:** `QuestLogPushQuest([questIndex])`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`); if omitted, defaults to the selected quest (`number`)

**See also:** Quest functions.


## QuestMapUpdateAllQuests


## QuestPOIGetIconInfo


## QuestPOIGetQuestIDByIndex


## QuestPOIGetQuestIDByVisibleIndex


## QuestPOIUpdateIcons


## QuestPOIUpdateTexture

_No snapshot available (page did not exist in archive)._


## Quit

Attempts to exit the World of Warcraft client. Results vary based on current conditions:

 
 - If the player is in combat or under other temporary restrictions (e.g. falling), fires the `UI_ERROR_MESSAGE` event with a message indicating the player cannot log out at the moment.
 
 - If the player is not in an inn, major city, or other "rest" area (i.e. `IsResting()` returns `nil`), fires the `PLAYER_QUITING` event, causing the default UI to show a countdown, quitting WoW after a period of time if not canceled.
 
 - If the player is in a "rest" area, quits the game immediately.

**Signature:** `Quit()`

