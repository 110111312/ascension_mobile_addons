# WoW Events — B

_57 events_

---

## BAG_CLOSED

Fires when one of the player's containers is closed

**Payload:** `(bagID)`

**Arguments:**
- `bagID` - The ID of the bag that closed. (`number`)


## BAG_OPEN

Fires when one of the player's containers is opened

**Payload:** `(bagID)`

**Arguments:**
- `bagID` - The ID of the bag that opened. (`number`)


## BAG_UPDATE

Fires when the contents of one of the player's containers change. Container contents may change due to obtaining an item, consuming an item, moving an item between or within bags, etc. Note that containers also include the keyring, bank and bank bags.

Fires many times (once for each slot in each container) during the login / UI load process. An addon which does extensive processing for this event should register it only after `PLAYER_ENTERING_WORLD` has fired if they are not interested in processing each event individually during the load process.

**Payload:** `(bagID)`

**Arguments:**
- `bagID` - The id of the bag that is receiving an update. (`number`, containerID)


## BAG_UPDATE_COOLDOWN

Fires when the cooldown begins or ends for an item in one of the player's containers

**Payload:** `()`


## BANKFRAME_CLOSED

Fires when the player ends interaction with a bank

**Payload:** `()`


## BANKFRAME_OPENED

Fires when the player begins interaction with a bank

**Payload:** `()`


## BARBER_SHOP_APPEARANCE_APPLIED

_No snapshot available._


## BARBER_SHOP_CLOSE

Fires when the player ends interaction with a barber shop

**Payload:** `()`


## BARBER_SHOP_OPEN

Fires when the player begins interaction with a barber shop

**Payload:** `()`


## BARBER_SHOP_SUCCESS

Fires immediately when changes to the player's appearance have been purchased at a barber shop. Both this event and `BARBER_SHOP_APPEARANCE_APPLIED` fire when purchasing an appearance change; this event fires first (causing the default UI to play a sound effect), and the other fires afterward to update the state of the barber shop controls and cost indicator.

**Payload:** `()`


## BATTLEFIELD_MGR_EJECT_PENDING

Fires when the player will be removed from or cannot yet enter a queued world PvP zone (e.g. Wintergrasp)

**Payload:** `()`


## BATTLEFIELD_MGR_EJECTED

Fires when the player has been removed from a queued world PvP zone (e.g. Wintergrasp)

**Payload:** `()`


## BATTLEFIELD_MGR_ENTERED

Fires when the player has been accepted into a queued world PvP zone (e.g. Wintergrasp)

**Payload:** `()`


## BATTLEFIELD_MGR_ENTRY_INVITE

Fires when the player is invited to enter a queued world PvP zone (e.g. Wintergrasp)

**Payload:** `()`


## BATTLEFIELD_MGR_QUEUE_INVITE

Fires when the player is invited to queue for a world PvP zone (e.g. Wintergrasp)

**Payload:** `()`


## BATTLEFIELD_MGR_QUEUE_REQUEST_RESPONSE

Fires in response to the player's attempt to enter or queue for a world PvP zone (e.g. Wintergrasp). Indicates whether the player has been accepted into the zone or its queue.

**Payload:** `()`


## BATTLEFIELD_MGR_STATE_CHANGE

Fires when the player's state changes in the queue for a world PvP zone (e.g. Wintergrasp)

**Payload:** `()`


## BATTLEFIELDS_CLOSED

Fires when the UI is no longer available for queueing for an arena or specific battleground instance

**Payload:** `()`


## BATTLEFIELDS_SHOW

Fires when the UI becomes available for queueing for an arena or specific battleground instance

**Payload:** `()`


## BILLING_NAG_DIALOG

Fires when a message should be shown about the player's paid game time expiring soon

**Payload:** `(remaining)`

**Arguments:**
- `remaining` - The number in minuites until your play time runs out. (`number`)


## BIND_ENCHANT

Fires when the player attempts to an enchant an item which will become soulbound in the process

**Payload:** `()`


## BN_BLOCK_LIST_UPDATED


## BN_CHAT_CHANNEL_CLOSED


## BN_CHAT_CHANNEL_CREATE_FAILED


## BN_CHAT_CHANNEL_CREATE_SUCCEEDED


## BN_CHAT_CHANNEL_INVITE_FAILED


## BN_CHAT_CHANNEL_INVITE_SUCCEEDED


## BN_CHAT_CHANNEL_JOINED


## BN_CHAT_CHANNEL_LEFT


## BN_CHAT_CHANNEL_MEMBER_JOINED


## BN_CHAT_CHANNEL_MEMBER_LEFT


## BN_CHAT_CHANNEL_MEMBER_UPDATED


## BN_CHAT_CHANNEL_MESSAGE_BLOCKED


## BN_CHAT_CHANNEL_MESSAGE_UNDELIVERABLE


## BN_CHAT_WHISPER_UNDELIVERABLE


## BN_CONNECTED

Fires when the player connects to Battle.net

**Payload:** `()`


## BN_CUSTOM_MESSAGE_CHANGED

Fires when the player's Battle.net custom message (broadcast) is changed

**Payload:** `()`


## BN_CUSTOM_MESSAGE_LOADED


## BN_DISCONNECTED

Fires when the player disconnects from Battle.net

**Payload:** `()`


## BN_FRIEND_ACCOUNT_OFFLINE

Fires when one of your RealID friends logs off

**Payload:** `(presenceID)`

**Arguments:**
- `presenceID` - You can send this to BNGetFriendInfoByID (`number`)


## BN_FRIEND_ACCOUNT_ONLINE

Fires when one of your RealID friends log on

**Payload:** `(presenceID)`

**Arguments:**
- `presenceID` - You can send this to BNGetFriendInfoByID (`number`)


## BN_FRIEND_INFO_CHANGED


## BN_FRIEND_INVITE_ADDED


## BN_FRIEND_INVITE_LIST_INITIALIZED


## BN_FRIEND_INVITE_REMOVED


## BN_FRIEND_INVITE_SEND_RESULT


## BN_FRIEND_LIST_SIZE_CHANGED


## BN_FRIEND_TOON_OFFLINE


## BN_FRIEND_TOON_ONLINE


## BN_MATURE_LANGUAGE_FILTER

Fires whenever the battle.net mature language filter setting is changed.

**Payload:** `()`


## BN_NEW_PRESENCE

Fires when information about a new Battle.net presence is available

**Payload:** `(index, "name")`

**Arguments:**
- `index` - Index of the presence (`number`)
- `name` - Real name of the presence (`string`)


## BN_REQUEST_FOF_FAILED


## BN_REQUEST_FOF_SUCCEEDED


## BN_SELF_OFFLINE


## BN_SELF_ONLINE


## BN_SYSTEM_MESSAGE


## BN_TOON_NAME_UPDATED

