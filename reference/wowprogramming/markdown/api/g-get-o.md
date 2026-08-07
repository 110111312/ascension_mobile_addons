# WoW API — GetO*

_3 functions_

---

## GetObjectiveText

Returns a summary of objectives for the quest offered by a questgiver. Only valid when the questgiver UI is showing the accept/decline stage of a quest dialog (between the `QUEST_COMPLETE` and `QUEST_FINISHED` events); otherwise may return the empty string or a value from the most recently displayed quest.

**Signature:** `questObjective = GetObjectiveText()`

**Returns:**
- `questObjective` - The objective text for the currently displayed quest (`string`)

**See also:** Quest functions.




## GetOptOutOfLoot

Returns whether the player has opted out of loot rolls. When opting out, no prompt will be shown for loot which ordinarily would prompt the player to roll (need/greed) or pass; the loot rolling process will continue for other group members as if the player had chosen to pass on every roll.

**Signature:** `isOptOut = GetOptOutOfLoot()`

**Returns:**
- `isOptOut` - 1 if the has opted out of loot rolls; otherwise nil (`1nil`)




## GetOwnerAuctionItems

Requests data from the server for the list of auctions created by the player. The `AUCTION_OWNED_LIST_UPDATE` event fires if new data is available; listing information can then be retrieved using `GetAuctionItemInfo()` or other Auction APIs.

**Signature:** `GetOwnerAuctionItems()`

**See also:** Auction functions.



