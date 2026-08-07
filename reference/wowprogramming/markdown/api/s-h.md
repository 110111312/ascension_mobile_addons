# WoW API — S (H*)

_13 functions_

---

## ShiftQuestWatches



## ShowBuybackSellCursor

Changes the cursor to prepare for repurchasing an item recently sold to a vendor. Only changes the cursor image and mode if the given `index` contains an item.

**Signature:** `ShowBuybackSellCursor(index)`

**Arguments:**
- `index` - Index of an item in the buyback listing (between 1 and `GetNumBuybackItems()`) (`number`)

**See also:** Cursor functions.



## ShowCloak

Enables or disables display of the player's cloak. Only affects the player's appearance; does not change the other effects of having the cloak equipped. Determines not only the appearance of the player character on the local client, but the way other players see the character as well.

**Signature:** `ShowCloak(show)`

**Arguments:**
- `show` - 1 to display the player's cloak; nil to hide it (`1nil`)

**See also:** UI/Visual functions, Player information functions.



## ShowContainerSellCursor

Changes the cursor to prepare for selling an item in the player's bags to a vendor. Only changes the cursor image and mode if the given `container` and `slot` contain an item.

While the cursor is in "sell" mode, `UseContainerItem()` sells the item to the vendor instead of using it.

**Signature:** `ShowContainerSellCursor(container, slot)`

**Arguments:**
- `container` - Index of one of the player's bags or other containers (`number`, containerID)
- `slot` - Index of an item slot within the container (`number`, containerSlotID)

**See also:** Cursor functions, Merchant functions.



## ShowFriends

Requests friends/ignore list information from the server. Information is not returned immediately; the `FRIENDLIST_UPDATE` event fires when data becomes available for use by Friends/Ignore API functions.

**Signature:** `ShowFriends()`



## ShowHelm

Enables or disables display of the player's headgear. Only affects the player's appearance; does not change the other effects of having the headgear equipped. Determines not only the appearance of the player character on the local client, but the way other players see the character as well.

**Signature:** `ShowHelm(show)`

**Arguments:**
- `show` - 1 to display the player's headgear; nil to hide it (`1nil`)

**See also:** UI/Visual functions, Player information functions.



## ShowingCloak

Returns whether the player's cloak is displayed. Determines not only the appearance of the player character on the local client, but the way other players see the character as well.

**Signature:** `isShown = ShowingCloak()`

**Returns:**
- `isShown` - 1 if the player's cloak is shown; otherwise nil (`1nil`)



## ShowingHelm

Returns whether the player's headgear is displayed. Determines not only the appearance of the player character on the local client, but the way other players see the character as well.

**Signature:** `isShown = ShowingHelm()`

**Returns:**
- `isShown` - 1 if the player's headgear is shown; otherwise nil (`1nil`)

**See also:** UI/Visual functions, Player information functions.



## ShowInventorySellCursor

Changes the cursor to prepare for selling an equipped item to a vendor. Only changes the cursor image and mode if the given `slot` contains an item. 

(Unlike `ShowContainerSellCursor()`, does not change the behavior of other functions to enable selling of items. Unused in the default UI.)

**Signature:** `ShowInventorySellCursor(slot)`

**Arguments:**
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)



## ShowMerchantSellCursor

Changes the cursor to prepare for buying an item from a vendor. Only changes the cursor image and mode if the given `index` contains an item.

**Signature:** `ShowMerchantSellCursor(index)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)

**See also:** Cursor functions.



## ShowMiniWorldMapArrowFrame

Shows or hides the battlefield minimap's player arrow

**Signature:** `ShowMiniWorldMapArrowFrame(show)`

**Arguments:**
- `show` - If the battlefield minimap's player arrow should be shown (`boolean`)

**See also:** Battlefield functions.



## ShowRepairCursor

Puts the cursor in item repair mode. Unlike most other cursor functions, this functions changes the behavior as well as the appearance of the mouse cursor: while repair mode is active, calling `PickupContainerItem()` or `PickupInventoryItem()` will attempt to repair the item (and deduct the cost of such from the player's savings) instead of putting it on the cursor.

Only has effect while the player is interacting with a vendor which can perform repairs; i.e. between the `MERCHANT_SHOW` and `MERCHANT_CLOSED` events, and only if `CanMerchantRepair()` returns `1`.

**Signature:** `ShowRepairCursor()`

**See also:** Cursor functions, Merchant functions.



## ShowWorldMapArrowFrame


