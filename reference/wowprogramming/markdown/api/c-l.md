# WoW API — C (L*)

_42 functions_

---

## ClearAchievementComparisonUnit

Disables comparing achievements/statistics with another player

**Signature:** `ClearAchievementComparisonUnit()`



## ClearAllLFGDungeons



## ClearChannelWatch

**Signature:** `ClearChannelWatch()`



## ClearCursor

Clears any contents attached to the cursor. If the cursor contains an item picked up from inventory (equipment slots) or a container, the item returns to its point of origin and the inventory or container slot is unlocked. (To destroy an item, see `DeleteCursorItem()`).

If the cursor contains an action, that action is deleted (but not the spell, item, macro, etc that it represents).

If the cursor contains any other data type, nothing happens other than the cursor being reverted to its default state -- picking up such objects has no effect on their points of origin.

**Signature:** `ClearCursor()`

**See also:** Cursor functions.



## ClearFocus

Clears the player's focus unit

**Signature:** `ClearFocus()`



## ClearInspectPlayer

Ends inspection of another character. After this function is called, data about the inspected unit may not be available or valid.

Used in the default UI when the InspectFrame is hidden.

**Signature:** `ClearInspectPlayer()`

**See also:** Inspect functions.



## ClearLFGDungeon



## ClearOverrideBindings

Clears any registered override bindings for a given owner. An override binding is a temporary key or click binding that can be used to override the default bindings. The bound key will revert to its normal setting once the override has been removed.

**Signature:** `ClearOverrideBindings(owner)`

**Arguments:**
- `owner` - A Frame (or other widget) object for which override bindings are registered (`table`)

**See also:** Keybind functions.



## ClearPartyAssignment

Removes a group role assignment from a member of the player's party or raid. If no unit (or name) is given, removes the role assignment from all members of the party or raid.

**Signature:** `ClearPartyAssignment("assignment" [, "unit"]) or ClearPartyAssignment("assignment" [, "name" [, exactMatch]])`

**Arguments:**
- `assignment` - A group role to assign to the unit (`string`) 

 - `MAINASSIST` - Remove the main assist role
- `MAINTANK` - Remove the main tank role
- `unit` - A unit in the player's party or raid (`string`, unitID)
- `name` - Name of a unit in the player's party or raid (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Party functions, Raid functions.



## ClearSendMail

Clears any text, items, or money from the mail message to be sent

**Signature:** `ClearSendMail()`



## ClearTarget

Clears the player's current target

**Signature:** `ClearTarget()`

**See also:** Targeting functions.



## ClearTutorials

Disables contextual tutorial display

**Signature:** `ClearTutorials()`

**See also:** Tutorial functions.



## ClickAuctionSellItemButton

Picks up an item from or puts an item into the "Create Auction" slot. If the cursor is empty and the slot contains an item, that item is put onto the cursor. If the cursor contains an item and the slot is empty, the item is placed into the slot. If both the cursor and the slot contain items, the contents of the cursor and the slot are exchanged.

Only has effect if the player is interacting with an auctioneer (i.e. between the `AUCTION_HOUSE_SHOW` and `AUCTION_HOUSE_CLOSED` events). Causes an error message (`UI_ERROR_MESSAGE`) if the item on the cursor cannot be put up for auction (e.g. if the item is soulbound).

**Signature:** `ClickAuctionSellItemButton()`

**See also:** Auction functions, Cursor functions.



## ClickLandmark

Processes a hyperlink associated with a map landmark. Possible landmarks include PvP objectives (both in battlegrounds and in world PvP areas), town and city markers on continent maps, and special markers such as those used during the Scourge Invasion world event. Some landmarks (such as those for towns on a zone map) exist but are not visible in the default UI.

Hyperlinks are not used for any of the landmarks currently in the game; this function does nothing when called with a landmark which does not have a hyperlink.

**Signature:** `ClickLandmark(mapLinkID)`

**Arguments:**
- `mapLinkID` - Hyperlink ID associated with a map landmark, as retrieved from GetMapLandmarkInfo() (`number`)

**See also:** Map functions.



## ClickPetitionButton

**Signature:** `ClickPetitionButton()`



## ClickSendMailItemButton

Picks up an item from or puts an item into an attachment slot for sending mail. If the cursor is empty and the mail attachment slot contains an item, that item is put onto the cursor. If the cursor contains an item and the slot is empty, the item is placed into the slot. If both the cursor and the slot contain items, the contents of the cursor and the mail attachment slot are exchanged.

Only has effect if the player is interacting with a mailbox (i.e. between the `MAIL_SHOW` and `MAIL_CLOSED` events). Causes an error message (`UI_ERROR_MESSAGE`) if an invalid mail attachment slot is specified or if the item on the cursor cannot be mailed (e.g. if the item is soulbound).

**Signature:** `ClickSendMailItemButton(index, autoReturn)`

**Arguments:**
- `index` - Index of a mail attachment slot (between 1 and `ATTACHMENTS_MAX_SEND`) (`number`)
- `autoReturn` - True to automatically return the item in the given attachment slot to the player's bags; false or omitted to put the item on the cursor (`boolean`)

**See also:** Mail functions, Cursor functions.



## ClickSocketButton

Picks up or places a gem in the Item Socketing UI. If the Item Socketing UI is open and the cursor contains a socketable gem, places the gem into socket `index`. If the cursor does not hold an item and socket `index` is not locked, picks up the gem in that socket.

Only has an effect while the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `ClickSocketButton(index)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)



## ClickStablePet

Inspects or moves a pet in the Pet Stable UI. Action taken depends on cursor contents as well as the `index` passed:

 
 - 
If the cursor does not contain a pet, selects the given pet slot.

 
 - 
If the cursor contains the active pet and `index` is a stable slot, places the pet into the stable (but not necessarily into the given slot). 

 
 - 
If the cursor contains a stabled pet, and `index` is 0, makes the stabled pet the active pet (and puts the active pet into the stable).

**Signature:** `selected = ClickStablePet(index)`

**Arguments:**
- `index` - Index of a stable slot (`number`) 

 - `0` - Active pet
- `1 to NUM_PET_STABLE_SLOTS` - A stable slot

**Returns:**
- `selected` - 1 if the function selected a stabled pet, rather than placed a pet in the stable slot (`1nil`)

**See also:** Pet Stable functions.



## ClickTargetTradeButton

Interacts with an item in a slot offered for trade by the target. Only meaningful when used with the last (7th) trade slot: if an enchantment-type spell is currently awaiting a target (i.e. the glowing hand cursor is showing), targets the item in the given trade slot for the enchantment. (The enchantment to be applied then shows for both parties in the trade, but is not actually performed until both parties accept the trade.)

**Signature:** `ClickTargetTradeButton(index)`

**Arguments:**
- `index` - Index of an item slot on the target's side of the trade window (between 1 and `MAX_TRADE_ITEMS`) (`number`)



## ClickTradeButton

Clicks a specific trade window button. This function can be used to place items in the trade window from the cursor, or to pick up an item from the trade window. If the cursor is currently holding an item, you can run ClickTradeButton(1) to place the item in the trade window, slot 1. If there is an item in the trade window slot 1, then you can run ClickTradeButton(1) to pickup that item and hold it on the cursor.

**Signature:** `ClickTradeButton(index)`

**Arguments:**
- `index` - The index of the trade button window to click (`number`)



## CloseArenaTeamRoster

Ends interaction with the Arena Team Roster. Called in the default UI when closing the Arena Team Roster frame. After this function is called, roster information functions may no longer return valid data.

**Signature:** `CloseArenaTeamRoster()`



## CloseAuctionHouse

Ends interaction with the Auction House UI. Causes the `AUCTION_HOUSE_CLOSED` event to fire, indicating that Auction-related APIs may be unavailable or no longer return valid data.

**Signature:** `CloseAuctionHouse()`

**See also:** Auction functions.



## CloseBankFrame

Ends interaction with the bank. Causes the `BANKFRAME_CLOSED` event to fire, indicating that APIs querying bank contents may no longer return valid results.

**Signature:** `CloseBankFrame()`

**See also:** Bank functions.



## CloseBattlefield

Ends interaction with the battleground queueing UI. Causes the `BATTLEFIELDS_CLOSED` event to fire, indicating that Battlefield queueing-related APIs may no longer have effects or return valid data.

**Signature:** `CloseBattlefield()`

**See also:** Battlefield functions.



## CloseGossip

Ends an NPC "gossip" interaction. Causes the `GOSSIP_CLOSED` event to fire, indicating that Gossip APIs may no longer have effects or return valid data.

**Signature:** `CloseGossip()`



## CloseGuildBankFrame

Ends interaction with the guild bank vault. Fires the `GUILDBANKFRAME_CLOSED` event, indicating that APIs related to the Guild Bank vault may no longer have effects or return valid data. (APIs related to guild bank permissions are still usable.)

**Signature:** `CloseGuildBankFrame()`



## CloseGuildRegistrar

Ends interaction with a guild registrar. Fires the `GUILD_REGISTRAR_CLOSED` event, indicating that guild registrar APIs may no longer have effects or return valid data.

**Signature:** `CloseGuildRegistrar()`

**See also:** Guild functions.



## CloseGuildRoster

**Signature:** `CloseGuildRoster()`



## CloseItemText

Ends interaction with a text object or item. Causes the `ITEM_TEXT_CLOSED` event to fire, indicating that ItemText APIs are no longer valid.

Called by the default UI when closing the ItemTextFrame, which is used for both readable world objects (books, plaques, gravestones, etc) and readable items (looted books, various quest-related scrolls and parchments, saved mail messages, etc).

**Signature:** `CloseItemText()`

**See also:** Item Text functions.



## CloseLoot

Ends interaction with a lootable corpse or object. Causes the `LOOT_CLOSED` event to fire, indicating that Loot APIs may no longer have effects or return valid data.

If the corpse was designated as the player's loot (via the Round Robin, Group Loot, or Need Before Greed loot methods), the corpse's loot becomes available to the rest of the group. If (and only if) the loot was generated from Disenchanting, Prospecting, Milling or similar, all loot items are automatically picked up.

**Signature:** `CloseLoot()`



## CloseMail

Ends interaction with a mailbox. Fires the `MAIL_CLOSED` event, indicating that Mail/Inbox APIs may no longer have effects or return valid data.

**Signature:** `CloseMail()`

**See also:** Mail functions.



## CloseMerchant

Ends interaction with a vendor. Causes the `MERCHANT_CLOSED` event to fire, indicating that Merchant APIs may no longer have effects or return valid data.

**Signature:** `CloseMerchant()`

**See also:** Merchant functions.



## ClosePetition

Ends interaction with a petition. Fires the `PETITION_CLOSED` event, indicating that Petition APIs may no longer have effects or return valid data.

**Signature:** `ClosePetition()`



## ClosePetitionVendor

_No snapshot available (page did not exist in archive)._



## ClosePetStables

Ends use of the Pet Stables UI/API. Causes the `PET_STABLE_CLOSED` event to fire, indicating that stables-related APIs are no longer valid.

**Signature:** `ClosePetStables()`

**See also:** Pet Stable functions.



## CloseQuest

Ends interaction with a questgiver. Fires the `QUEST_FINISHED` event, indicating that questgiver-related APIs may no longer have effects or return valid data.

**Signature:** `CloseQuest()`

**See also:** Quest functions.



## CloseSocketInfo

Ends interaction with the Item Socketing UI, discarding any changes made. Causes the `SOCKET_INFO_CLOSE` event to fire, indicating that Socket API functions may no longer have effects or return valid data.

**Signature:** `CloseSocketInfo()`



## CloseTabardCreation

Ends interaction with the guild tabard creator. Fires the `CLOSE_TABARD_FRAME` event, indicating that tabard creation APIs may no longer have effects or return valid data.

**Signature:** `CloseTabardCreation()`



## CloseTaxiMap

Ends interaction with the Taxi (flight master) UI. Causes the `TAXIMAP_CLOSED` event to fire, indicating that Taxi APIs may no longer have effects or return valid data.

**Signature:** `CloseTaxiMap()`



## CloseTrade

Ends interaction with the Trade UI, canceling any trade in progress. Causes the `TRADE_CLOSED` event to fire, indicating that Trade APIs may no longer have effects or return valid data.

**Signature:** `CloseTrade()`

**See also:** Trade functions.



## CloseTradeSkill

Ends interaction with the Trade Skill UI. Fires the `TRADE_SKILL_CLOSE` event, indicating that TradeSkill APIs may no longer have effects or return valid data.

**Signature:** `CloseTradeSkill()`

**See also:** Tradeskill functions.



## CloseTrainer

Ends interaction with a trainer. Fires the `TRAINER_CLOSED` event, indicating that Trainer APIs may no longer have effects or return valid data.

**Signature:** `CloseTrainer()`


