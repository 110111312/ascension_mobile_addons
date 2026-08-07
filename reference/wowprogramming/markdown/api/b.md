# WoW API Functions — B

_73 functions_

---

## BankButtonIDToInvSlotID

Returns the `inventoryID` corresponding to a bank item or bag slot

**Signature:** `inventoryID = BankButtonIDToInvSlotID(buttonID [, isBag])`

**Arguments:**
- `buttonID` - Numeric ID of an item or bag slot in the bank UI (`number`)
- `isBag` - 1 if the given ID corresponds to a bank bag slot; nil if the ID corresponds to an item slot (`1nil`)

**Returns:**
- `inventoryID` - An inventory slot ID usable with various Inventory API functions (`number`, inventoryID)


## BankButtonIDToInvSlotID_

_No snapshot available (page did not exist in archive)._


## BarberShopReset

Resets barber shop options to the currently worn styles. Changes the underlying data (and thus the character's appearance) only; the default barbershop UI does not update.

**Signature:** `BarberShopReset()`


## BattlefieldMgrEntryInviteResponse


## BattlefieldMgrExitRequest


## BattlefieldMgrQueueInviteResponse


## BattlefieldMgrQueueRequest


## BeginTrade


## BindEnchant

Confirms enchanting an item (when the item will become soulbound as a result). Usable following the `BIND_ENCHANT` event which fires upon attempting to perform an enchantment that would cause the target item to become soulbound.

**Signature:** `BindEnchant()`


## BNAcceptFriendInvite


## BNConnected

Returns whether or not the player is connected to Battle.net

**Signature:** `isOnline = BNConnected()`

**Returns:**
- `isOnline` - true if the player is connected to Battle.net; otherwise false (`boolean`)

**See also:** Battle.net functions.


## BNCreateConversation

Create a conversation between you and two friends

**Signature:** `result = BNCreateConversation(presenceID_1, presenceID_2)`

**Arguments:**
- `presenceID_1` - The presenceID of your first friend (`number`)
- `presenceID_2` - The presenceID of your second friend (`number`)

**Returns:**
- `result` - ASSUMPTION: If creation conversation was successful or not (`boolean`)

**See also:** Battle.net functions, Chat functions.


## BNDeclineFriendInvite


## BNFeaturesEnabled

Returns whether or not RealID services are disabled

**Signature:** `isEnabled = BNFeaturesEnabled()`

**Returns:**
- `isEnabled` - true if RealID is enabled; otherwise false (`boolean`)

**See also:** Battle.net functions.


## BNFeaturesEnabledAndConnected


## BNGetBlockedInfo


## BNGetBlockedToonInfo


## BNGetConversationInfo

Returns information about an existing battle.net conversation

**Signature:** `type = BNGetConversationInfo(channel)`

**Arguments:**
- `channel` - ID of channel you want to check (`number`)

**Returns:**
- `type` - Seems to be 'conversation' if the conversation exists, nil if not (`string`)

**See also:** Battle.net functions.


## BNGetConversationMemberInfo

Returns information about a member of a battle.net conversation

**Signature:** `presenceID, unknown, displayName = BNGetConversationMemberInfo(channel, memberIndex)`

**Arguments:**
- `channel` - The index of the channel you want member info for (`number`)
- `memberIndex` - The index of the member you want info for (`number`)

**Returns:**
- `presenceID` - This number seems to be the same as the presence ID of the RealID friend (`number`)
- `unknown` - Unknown (ID?) (`number`)
- `displayName` - The name that gets displayed with chat messages. Real name for friends, charname for FoF (`string`)

**See also:** Battle.net functions.


## BNGetCustomMessageTable


## BNGetFOFInfo

Returns information about the specified friend of a RealID friend

**Signature:** `presenceID, givenName, surname, isFriend = BNGetFOFInfo(presenceID, mutual, non-mutual, index)`

**Arguments:**
- `presenceID` - presenceID for the RealID friend for whom you are requesting friend info (`number`)
- `mutual` - Should the list include mutual friends (i.e. people who you and the person referenced by presenceID are both friends with). (`boolean`)
- `non-mutual` - Should the list include non-mutual friends. (`boolean`)
- `index` - The index of the entry in the list to retrieve (1 to BNGetNumFOF(...)) (`number`)

**Returns:**
- `presenceID` - a unique numeric identifier for this friend for this session (`number`)
- `givenName` - a |K Escape Sequence representing the friend's first/given name (`string`)
- `surname` - a |K Escape Sequence representing the friend's Surname/Family name (`string`)
- `isFriend` - true if this person is a direct friend of yours, false otherwise (`boolean`)

**See also:** Battle.net functions.


## BNGetFriendInfo

Returns information about a RealID friend by index

**Signature:** `presenceID, givenName, surname, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isFriend, unknown = BNGetFriendInfo(friendIndex)`

**Arguments:**
- `friendIndex` - Index (between 1 and `BNGetNumFriends()`) (`number`)

**Returns:**
- `presenceID` - auto incrementing ID, reset at each login. Persists across reload of UI, but not change of character (`number`)
- `givenName` - First name of the friend, as a new form of chatlink. Visually looks like a string, but only when rendered (`|K string`, Kstring)
- `surname` - Last name (surname) of the friend, as a new form of chatlink. Visually looks like a string, but only when rendered (`|K string`, Kstring)
- `toonName` - Name of the active character tied to the BNet account (`string`)
- `toonID` - (`number`)
- `client` - The name of the game the friend is currently playing, if any; Returns nil if not online. Returns initialism for World of Warcraft ('WoW') (`string`)
- `isOnline` - Online status (`boolean`)
- `lastOnline` - (`number`)
- `isAFK` - (`boolean`)
- `isDND` - (`boolean`)
- `messageText` - RealID broadcast message displayed below the user on your friends list (`string`)
- `noteText` - The player's personal note for the friend; nil for no note (`string`)
- `isFriend` - (`boolean`)
- `unknown` - (`number`)

**See also:** Battle.net functions.


## BNGetFriendInfoByID

Returns information about a RealID friend

**Signature:** `presenceID, givenName, surname, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isFriend, unknown = BNGetFriendInfoByID(presenceID)`

**Arguments:**
- `presenceID` - (`number`, presenceID)

**Returns:**
- `presenceID` - (`number`, presenceID)
- `givenName` - First name of the friend (`|K string`, Kstring)
- `surname` - Last name (surname) of the friend (`|K string`, Kstring)
- `toonName` - Name of the active character tied to the BNet account (`string`)
- `toonID` - (`number`)
- `client` - The name of the game the friend is currently playing, if any; Returns nil if not online. Returns initialism for World of Warcraft ('WoW') (`string`)
- `isOnline` - Online status (`boolean`)
- `lastOnline` - (`number`)
- `isAFK` - (`boolean`)
- `isDND` - (`boolean`)
- `messageText` - RealID broadcast message displayed below the user on your friends list (`string`)
- `noteText` - The player's personal note for the friend; nil for no note (`string`)
- `isFriend` - (`boolean`)
- `unknown` - (`number`)

**See also:** Battle.net functions.


## BNGetFriendInviteInfo


## BNGetFriendToonInfo

Returns information about a particular online toon tied to a RealID friend

**Signature:** `unknown, toonName, client, realmName, faction, race, class, unknown, zoneName, level, gameText, broadcastText, broadcastTime = BNGetFriendToonInfo(friendIndex, toonIndex)`

**Arguments:**
- `friendIndex` - Index (between 1 and `BNGetNumFriends()`) (`number`)
- `toonIndex` - Index (between 1 and `BNGetNumFriendToons(friendIndex)`) (`number`)

**Returns:**
- `unknown` - (`boolean`)
- `toonName` - The toon's name (`string`)
- `client` - The name of the game the friend is currently playing, if any; Returns initialism for World of Warcraft ('WoW') (`string`)
- `realmName` - The toon's realm name (`string`)
- `faction` - The toon's faction. Returns -1 for offline, 0 for Horde, 1 for Alliance (`number`)
- `race` - The toon's race (`string`)
- `class` - The toon's class (`string`)
- `unknown` - (`string`)
- `zoneName` - The toon's zone (location) (`string`)
- `level` - The toon's character level (`string`)
- `gameText` - The zone and server of the active toon separated by a hyphen (`string`)
- `broadcastText` - The user's RealID broadcast message (`string`)
- `broadcastTime` - The time the broadcast message was first set (`string`)

**See also:** Battle.net functions.


## BNGetInfo

Returns information about the player's RealID settings

**Signature:** `unknown, unknown, broadcastText, bnetAFK, bnetDND = BNGetInfo()`

**Returns:**
- `unknown` - (`number`)
- `unknown` - (`number`)
- `broadcastText` - The player's current broadcast message (entered at the top of the friends tab) (`string`)
- `bnetAFK` - (`boolean`)
- `bnetDND` - (`boolean`)

**See also:** Battle.net functions.


## BNGetMatureLanguageFilter

Returns boolean for the Mature Language Filter option's state.

**Signature:** `isEnabled = BNGetMatureLanguageFilter()`

**Returns:**
- `isEnabled` - Returns true if the Mature Language Filter interface option is enabled, otherwise false. (`boolean`)

**See also:** Battle.net functions.


## BNGetMaxPlayersInConversation

Returns the maximum number of realID friends you can have in one conversation

**Signature:** `count = BNGetMaxPlayersInConversation()`

**Returns:**
- `count` - The max number of players that can be in one conversation (`number`)

**See also:** Battle.net functions.


## BNGetNumBlocked


## BNGetNumBlockedToons


## BNGetNumConversationMembers

Returns the number of members in a battle.net conversation

**Signature:** `memberCount = BNGetNumConversationMembers(channel)`

**Arguments:**
- `channel` - The index of the conversation to get member count for (`number`)

**Returns:**
- `memberCount` - Number of members in the conversation you asked for. 0 for non-existing conversations (`number`)

**See also:** Battle.net functions.


## BNGetNumFOF


## BNGetNumFriendInvites


## BNGetNumFriends

Returns total number of RealID friends and currently online number of RealID friends

**Signature:** `totalBNet, numBNetOnline = BNGetNumFriends()`

**Returns:**
- `totalBNet` - Total number of RealID friends (`number`)
- `numBNetOnline` - Number of currently online RealID friends (`number`)

**See also:** Battle.net functions.


## BNGetNumFriendToons

Returns the number of online toons for a friend

**Signature:** `numToons = BNGetNumFriendToons(friendIndex)`

**Arguments:**
- `friendIndex` - The index of the friend to query (`number`)

**Returns:**
- `numToons` - The number of toons (`number`)

**See also:** Battle.net functions.


## BNGetSelectedBlock


## BNGetSelectedFriend

Returns the index of the selected user on your friend's list

**Signature:** `friendIndex = BNGetSelectedFriend()`

**Returns:**
- `friendIndex` - The index of the friend in the list (`number`)

**See also:** Battle.net functions.


## BNGetSelectedToonBlock


## BNGetToonInfo

Returns information about the active toon tied to a RealID friend

**Signature:** `unknown, toonName, client, realmName, realmID, faction, race, class, unknown, zoneName, level, gameText, broadcastText, broadcastTime = BNGetToonInfo(presenceID)`

**Arguments:**
- `presenceID` - (`number`)

**Returns:**
- `unknown` - (`boolean`)
- `toonName` - The toon's name (`string`)
- `client` - The name of the game the friend is currently playing, if any; Returns initialism for World of Warcraft ('WoW') (`string`)
- `realmName` - The toon's realm name (`string`)
- `realmID` - The toon's realm ID (not sure if unique per realm, or a weekly/session realmID identifier) (`number`)
- `faction` - The toon's faction. Returns -1 for offline, 0 for Horde, 1 for Alliance (`number`)
- `race` - The toon's race (`string`)
- `class` - The toon's class (`string`)
- `unknown` - (`string`)
- `zoneName` - The toon's zone (location) (`string`)
- `level` - The toon's character level (`string`)
- `gameText` - The zone and server of the active toon separated by a hyphen (`string`)
- `broadcastText` - The user's RealID broadcast message (`string`)
- `broadcastTime` - The time the broadcast message was first set (`string`)

**See also:** Battle.net functions.


## BNInviteToConversation

Invite a friend into an existing conversation

**Signature:** `BNInviteToConversation(channel, presenceID)`

**Arguments:**
- `channel` - The ID of the conversation to invite to (`number`)
- `presenceID` - The presenceID of the friend to invite (`number`)

**See also:** Battle.net functions.


## BNIsBlocked


## BNIsFriend


## BNIsSelf

Returns whether or not the presence ID is the one of the player

**Signature:** `isSelf = BNIsSelf(presenceID)`

**Arguments:**
- `presenceID` - (`number`)

**Returns:**
- `isSelf` - true if the presence ID is the one of the player; false otherwise (`boolean`)

**See also:** Battle.net functions.


## BNIsToonBlocked


## BNLeaveConversation


## BNListConversation


## BNRemoveFriend


## BNReportFriendInvite


## BNReportPlayer


## BNRequestFOFInfo


## BNSendConversationMessage


## BNSendFriendInvite


## BNSendFriendInviteByID


## BNSendWhisper


## BNSetAFK


## BNSetBlocked


## BNSetCustomMessage

Sets the player's current RealID broadcast message.

**Signature:** `BNSetCustomMessage("broadcastText")`

**Arguments:**
- `broadcastText` - Value that becomes your new broadcast message (`string`)

**See also:** Battle.net functions.


## BNSetDND


## BNSetFocus


## BNSetFriendNote

Changes the private note for a RealID friend

**Signature:** `BNSetFriendNote(presenceID, "note")`

**Arguments:**
- `presenceID` - The presenceID of the friend whose note you want to change (`number`)
- `note` - The new note for the friend (`string`)

**See also:** Battle.net functions.


## BNSetMatureLanguageFilter

Sets the Mature Language Filter option

**Signature:** `BNSetMatureLanguageFilter(enabled)`

**Arguments:**
- `enabled` - true to enable the Mature Language Filter; otherwise false (`boolean`)

**See also:** Battle.net functions.


## BNSetSelectedBlock


## BNSetSelectedFriend


## BNSetSelectedToonBlock


## BNSetToonBlocked


## BuybackItem

Repurchases an item recently sold to a vendor

**Signature:** `BuybackItem(index)`

**Arguments:**
- `index` - Index of an item in the buyback listing (between 1 and `GetNumBuybackItems()`) (`number`)


## BuyGuildBankTab

Purchases the next available guild bank tab

**Signature:** `BuyGuildBankTab()`

**See also:** Guild bank functions.


## BuyGuildCharter

Purchases a guild charter. Usable if the player is interacting with a guild registrar (i.e. between the `GUILD_REGISTRAR_SHOW` and `GUILD_REGISTRAR_CLOSED` events).

**Signature:** `BuyGuildCharter("guildName")`

**Arguments:**
- `guildName` - Name of the guild to be created (`string`)

**See also:** Guild functions, Petition functions.


## BuyMerchantItem

Purchases an item available from a vendor

**Signature:** `BuyMerchantItem(index, quantity)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)
- `quantity` - Number of items to purchase (between 1 and `GetMerchantItemMaxStack(index)`) (`number`)

**See also:** Merchant functions.


## BuyPetition

_No snapshot available (page did not exist in archive)._


## BuySkillTier

_No snapshot available (page did not exist in archive)._


## BuyStableSlot

Purchases the next available stable slot, without confirmation. Only available while interacting with a Stable Master NPC (between the `PET_STABLE_SHOW` and `PET_STABLE_CLOSED` events and only if `IsAtStableMaster()` returns true).

**Signature:** `BuyStableSlot()`


## BuyTrainerService

Purchases an ability or recipe available from a trainer

**Signature:** `BuyTrainerService(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**See also:** Trainer functions.

