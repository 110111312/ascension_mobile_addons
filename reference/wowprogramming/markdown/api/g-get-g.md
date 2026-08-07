# WoW API — GetG*

_35 functions_

---

## GetGameTime

Returns the current realm (server) time

**Signature:** `hour, minute = GetGameTime()`

**Returns:**
- `hour` - Hour portion of the time (on a 24-hour clock) (`number`)
- `minute` - Minute portion of the time (`number`)




## GetGamma

Returns the current display gamma setting. Gamma value determines the contrast between lighter and darker portions of the game display; for a detailed explanation see the Wikipedia entry on Gamma correction entry.

**Signature:** `gamma = GetGamma()`

**Returns:**
- `gamma` - Current gamma setting (`number`)

**See also:** Video functions.




## getglobal

Returns the value of a global variable. Often used in the default UI in cases where several similar names are systematically constructed. Examples:

 
 - 
In a script attached to a frame template, `getglobal(self:GetName().."Icon")` can refer to the Texture whose name is defined in XML as `$parentIcon`.

 
 - 
Several sets of localized string tokens follow standard formats: e.g. `getglobal("ITEM_QUALITY"..quality.."_DESC)` returns the name for the numeric `quality`.

Equivalent to `_G.name` or `_G["name"]`.

**Signature:** `value = getglobal("name")`

**Arguments:**
- `name` - Name of a global variable (`string`)

**Returns:**
- `value` - Value of the given variable (`value`)




## GetGlyphLink

Gets a hyperlink for the contents of a glyph socket. 
Glyph links are distinct from item and spell links: e.g. "|cff66bbff|Hglyph:21:361|h[Glyph of Hunter's Mark]|h|r".

**Signature:** `link = GetGlyphLink(socket, talentGroup)`

**Arguments:**
- `socket` - Which glyph socket to query (between 1 and `NUM_GLYPH_SLOTS`) (`number`, glyphIndex)
- `talentGroup` - Which set of glyphs to query, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `link` - A hyperlink for the glyph socket's contents, or "" if the socket is empty (`string`, hyperlink)

**See also:** Glyph functions, Hyperlink functions.




## GetGlyphSocketInfo

Returns information about a glyph socket and its contents. 
The spell ID referenced in the third return glyphSpell refers to the spell used to put the glyph in the socket -- not the Inscription spell that creates a glyph item, but the spell associated with that item's "Use:" effect.

**Signature:** `enabled, glyphType, glyphTooltipIndex, glyphSpell, icon = GetGlyphSocketInfo(socket, talentGroup)`

**Arguments:**
- `socket` - Which glyph socket to query (between 1 and `NUM_GLYPH_SLOTS`) (`number`, glyphIndex)
- `talentGroup` - Which set of glyphs to query, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `enabled` - True if the socket can be given a glyph at the player's current level; false if the socket is locked (`boolean`)
- `glyphType` - 1 for minor glyph sockets, 2 for major glyph sockets, 3 for prime glyph sockets (`number`)
- `glyphTooltipIndex` - Index to be used with `GLYPH_SLOT_TOOLTIP#` for the overlay (`number`)
- `glyphSpell` - Spell ID of the spell that inscribed a glyph into the socket, or nil if the socket is empty (`number`)
- `icon` - Path to a texture for the glyph inscribed into the socket, or nil if the socket is empty (`string`)

**See also:** Glyph functions.




## GetGMStatus




## GetGMTicket

Requests GM ticket status from the server. The `UPDATE_TICKET` event fires when data is ready.

**Signature:** `GetGMTicket()`




## GetGMTicketCategories

Returns a list of available GM ticket categories. No longer used in the current GM Help UI.

**Signature:** `... = GetGMTicketCategories()`

**Returns:**
- `...` - A variable number of categories (`string`)

**See also:** GM Ticket functions.




## GetGossipActiveQuests

Returns a list of quests which can be turned in to the current Gossip NPC. These quests are displayed with a question mark icon in the default UI's GossipFrame.

**Signature:** `name, level, isTrivial, ... = GetGossipActiveQuests()`

**Returns:**
- `name` - Name of the quest (`string`)
- `level` - Suggested character level for attempting the quest (`number`)
- `isTrivial` - 1 if the quest is considered "trivial" at the player's level (rewards no XP); otherwise nil (`1nil`)
- `...` - Additional `name, level, isTrivial` values if more than one quest is active (`list`)




## GetGossipAvailableQuests

Returns a list of quests available from the current Gossip NPC. For quests which can be turned in to the NPC, see `GetGossipActiveQuests()`.

**Signature:** `name, level, isTrivial, isDaily, isRepeatable, ... = GetGossipAvailableQuests()`

**Returns:**
- `name` - Name of the quest (`string`)
- `level` - Suggested character level for attempting the quest (`number`)
- `isTrivial` - 1 if the quest is considered "trivial" at the player's level (rewards no XP); otherwise nil (`1nil`)
- `isDaily` - 1 if the quest may be repeated only once per day; otherwise nil (`1nil`)
- `isRepeatable` - 1 if the quest may be repeated at any time; otherwise nil (`1nil`)
- `...` - Additional `name, level, isTrivial, isDaily, isRepeatable` values for each available quest (`list`)

**See also:** Quest functions, NPC "Gossip" Dialog functions.




## GetGossipOptions

Returns a list of interaction options for the Gossip NPC

**Signature:** `text, gossipType, ... = GetGossipOptions()`

**Returns:**
- `text` - Text to be displayed for the gossip option (`string`)
- `gossipType` - Non-localized string indicating the type of gossip option (`string`) 

 - `Banker` - Begin a Bank interaction
- `BattleMaster` - Queue for a battleground instance
- `Binder` - Set the player's Hearthstone location
- `Gossip` - Talk to the NPC
- `Tabard` - Begin a Tabard design interaction
- `Taxi` - Begin a Taxi (flight master) interaction
- `Trainer` - Begin a Trainer interaction
- `Vendor` - Begin a Merchant interaction
- `...` - Additional `text, gossipType` values for each gossip option available (`list`)

**See also:** NPC "Gossip" Dialog functions.




## GetGossipText

Returns greeting or other text to be displayed in an NPC dialog

**Signature:** `text = GetGossipText()`

**Returns:**
- `text` - Text to be displayed for the NPC conversation (`string`)




## GetGreetingText

Returns the greeting text displayed for quest NPCs with multiple quests. Not used often; most quest NPCs offering multiple quests (and/or other options) use the Gossip functions to provide a greeting (see `GetGossipText()`).

**Signature:** `greetingText = GetGreetingText()`

**Returns:**
- `greetingText` - Text to be displayed before choosing from among the NPC's multiple quests (`string`)

**See also:** Quest functions.




## GetGroupPreviewTalentPointsSpent

Returns the total number of points spent in the Talent UI's preview mode. 
This function only counts points spent in the preview mode, not those actually learned.

**Signature:** `pointsSpent = GetGroupPreviewTalentPointsSpent(isPet, talentGroup)`

**Arguments:**
- `isPet` - true to query talent info for the player's pet, false to query talent info for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `pointsSpent` - Number of points spent in preview mode (`number`)




## GetGuildBankItemInfo

Returns information about the contents of a guild bank item slot

**Signature:** `texture, count, locked = GetGuildBankItemInfo(tab, slot)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `slot` - Index of an item slot in the guild bank tab (between 1 and `MAX_GUILDBANK_SLOTS_PER_TAB`) (`number`)

**Returns:**
- `texture` - Path to an icon texture for the item (`string`)
- `count` - Number of stacked items in the slot (`number`)
- `locked` - 1 if the slot is locked (as when a guild member has picked up an item and not yet deposited it elsewhere); otherwise nil (`1nil`)

**See also:** Guild bank functions.




## GetGuildBankItemLink

Returns a hyperlink for an item in the guild bank

**Signature:** `item = GetGuildBankItemLink(tab, slot)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `slot` - Index of an item slot in the guild bank tab (between 1 and `MAX_GUILDBANK_SLOTS_PER_TAB`) (`number`)

**Returns:**
- `item` - A hyperlink for the contents of the slot (`string`, hyperlink)

**See also:** Guild bank functions, Hyperlink functions.




## GetGuildBankMoney

_No snapshot available (page did not exist in archive)._




## GetGuildBankMoneyTransaction

Returns information about a transaction in the guild bank money log

**Signature:** `type, name, year, month, day, hour = GetGuildBankMoneyTransaction(index)`

**Arguments:**
- `index` - Index of a transaction in the money log (between 1 and `GetNumGuildBankMoneyTransactions()`) (`number`)

**Returns:**
- `type` - Type of log event (`string`) 

 - `deposit` - Deposit into the guildbank
- `repair` - Repair cost withdrawal from the guildbank
- `withdraw` - Withdrawal from the guildbank
- `name` - Name of the guild member responsible for the event, or nil if the name is unknown (`string`)
- `year` - Number of years since the event occurred (`number`)
- `month` - Number of months since the event occurred (`number`)
- `day` - Number of days since the event occurred (`number`)
- `hour` - Number of hours since the event occurred (`number`)

**See also:** Guild bank functions.




## GetGuildBankTabCost

Returns the cost of the next available guild bank tab

**Signature:** `tabCost = GetGuildBankTabCost()`

**Returns:**
- `tabCost` - Cost to purchase the next guild bank tab (in copper) (`number`)

**See also:** Guild bank functions.




## GetGuildBankTabInfo

Returns information about a guild bank tab

**Signature:** `name, icon, isViewable, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**Returns:**
- `name` - Name of the tab (`string`)
- `icon` - Path to the icon texture for the tab (`string`)
- `isViewable` - 1 if the player is allowed to view the contents of the tab; otherwise nil (`1nil`)
- `canDeposit` - 1 if the player is allowed to deposit items into the tab; otherwise nil (`1nil`)
- `numWithdrawals` - Maximum number of items (stacks) the player is allowed to withdraw from the tab per day (`number`)
- `remainingWithdrawals` - Maximum number of items (stacks) the player is currently allowed to withdraw from the tab (`number`)

**See also:** Guild bank functions.




## GetGuildBankTabPermissions

Returns information about guild bank tab privileges for the guild rank currently being edited. Used in the default UI's guild control panel.

**Signature:** `canView, canDeposit, canUpdateText, numWithdrawls = GetGuildBankTabPermissions(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**Returns:**
- `canView` - 1 if the guild rank has permission to view the tab's contents; otherwise nil. (`1nil`)
- `canDeposit` - 1 if the guild rank has permission to deposit items into the tab; otherwise nil. (`1nil`)
- `canUpdateText` - 1 if the guild rank can update the tab's info text; otherwise nil. (`1nil`)
- `numWithdrawls` - Maximum number of withdrawals per day the guild rank is allowed for the given tab. (`number`)

**See also:** Guild bank functions.




## GetGuildBankText

Returns text associated with a guild bank tab. Only returns valid data after `QueryGuildBankText()` has been called to retrieve the text from the server and the following `GUILDBANK_UPDATE_TEXT` event has fired.

**Signature:** `text = GetGuildBankText(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**Returns:**
- `text` - Info text provided for the tab (`string`)

**See also:** Guild bank functions.




## GetGuildBankTransaction

Returns information about a transaction in the log for a guild bank tab. Only returns valid information following the `GUILDBANKLOG_UPDATE` event which fires after calling `QueryGuildBankLog()`.

**Signature:** `type, name, itemLink, count, tab1, tab2, year, month, day, hour = GetGuildBankTransaction(tab, index)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `index` - Index of a log entry (between 1 and `GetNumGuildBankTransactions(tab)`) (`number`)

**Returns:**
- `type` - Type of transaction (`string`) 

 - `deposit`
- `move`
- `repair`
- `withdraw`
- `name` - Name of the guild member responsible for the transaction (`string`)
- `itemLink` - A hyperlink for the item involved in the transaction (`string`, hyperlink)
- `count` - Number of stacked items involved in the transaction (`number`)
- `tab1` - Index of the source tab, if the item was moved between tabs (`number`)
- `tab2` - Index of the destination tab, if the item was moved between tabs (`number`)
- `year` - Number of years since the event occurred (`number`)
- `month` - Number of months since the event occurred (`number`)
- `day` - Number of days since the event occurred (`number`)
- `hour` - Number of hours since the event occurred (`number`)




## GetGuildBankWithdrawLimit

Returns the guild bank money withdrawal limit for the guild rank currently being edited

**Signature:** `goldWithdrawLimit = GetGuildBankWithdrawLimit()`

**Returns:**
- `goldWithdrawLimit` - Amount of money the guild rank is allowed to withdraw from the guild bank per day (in copper), or -1 if the guild rank has unlimited withdrawal privileges (`number`)

**See also:** Guild bank functions.




## GetGuildBankWithdrawMoney

Returns the amount of money the player is allowed to withdraw from the guild bank per day

**Signature:** `withdrawLimit = GetGuildBankWithdrawMoney()`

**Returns:**
- `withdrawLimit` - Amount of money the player is allowed to withdraw from the guild bank per day (in copper), or -1 if the player has unlimited withdrawal privileges (`number`)




## GetGuildCharterCost

Returns the cost to purchase a guild charter. Usable if the player is interacting with a guild registrar (i.e. between the `GUILD_REGISTRAR_SHOW` and `GUILD_REGISTRAR_CLOSED` events).

**Signature:** `cost = GetGuildCharterCost()`

**Returns:**
- `cost` - Cost to purchase a guild charter (in copper) (`number`)

**See also:** Guild functions, Petition functions.




## GetGuildEventInfo

Returns information about an entry in the guild event log. Only returns valid data after calling `QueryGuildEventLog()` and the following `GUILD_EVENT_LOG_UPDATE` event has fired.

**Signature:** `type, player1, player2, rank, year, month, day, hour = GetGuildEventInfo(index)`

**Arguments:**
- `index` - Index of an entry in the guild event log (between 1 and `GetNumGuildEvents()`) (`number`)

**Returns:**
- `type` - Type of event (example descriptions from the default UI below) (`string`) 

 - `demote` - player1 demotes player2 to rank.
- `invite` - player1 invites player2 to the guild.
- `join` - player1 joins the guild.
- `promote` - player1 promotes player2 to rank.
- `quit` - player1 has quit the guild.
- `remove` - player1 removes player2 from the guild.
- `player1` - First actor in the event (`string`)
- `player2` - Second actor in the event, if applicable (`string`)
- `rank` - Name of the rank related to promote/demote events (`string`)
- `year` - Number of years since the event occurred (`number`)
- `month` - Number of months since the event occurred (`number`)
- `day` - Number of days since the event occurred (`number`)
- `hour` - Number of hours since the event occurred (`number`)




## GetGuildInfo

Returns a unit's guild affiliation

**Signature:** `guildName, guildRankName, guildRankIndex = GetGuildInfo("unit") or GetGuildInfo("name")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - The name of a unit to query; only valid for `player`, `pet`, and party/raid members (`string`)

**Returns:**
- `guildName` - Name of the character's guild (`string`)
- `guildRankName` - Name of the character's guild rank (`string`)
- `guildRankIndex` - Numeric guild rank of the character (0 = guild leader; higher numbers for lower ranks) (`number`)




## GetGuildInfoText

Returns guild information text. Only returns valid data after calling `GuildRoster()` and the following `GUILD_ROSTER_UPDATE` event has fired.

This text appears when clicking the "Guild Information" button in the default UI's Guild window.

**Signature:** `guildInfoText = GetGuildInfoText()`

**Returns:**
- `guildInfoText` - The guild information text (including newline characters) (`string`)




## GetGuildRosterInfo

Returns information about the selected player in your guild roster.

**Signature:** `name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(index)`

**Arguments:**
- `index` - The player index in the guild roster. (`number`)

**Returns:**
- `name` - The name of the player (`string`)
- `rank` - The rank of the player (`string`)
- `rankIndex` - The rankIndex of the player (`number`)
- `level` - The level of the player (`number`)
- `class` - The (localized) class of the player (`string`)
- `zone` - The last zone in which the player was seen (`string`)
- `note` - The public note of the player (`string`)
- `officernote` - The officer note of the player, if the player has permission to view it (`string`)
- `online` - 1 if the player is online, nil otherwise (`1nil`)
- `status` - The status of the player (`string`) 

 - `` - The player is currently away from keyboard.
- `` - The player does not want to be disturbed.
- `classFileName` - The class filename of the player - unlocalized (`string`)




## GetGuildRosterLastOnline

Returns the amount of time since a guild member was last online. Only returns valid data after calling `GuildRoster()` and the following `GUILD_ROSTER_UPDATE` event has fired.

**Signature:** `years, months, days, hours = GetGuildRosterLastOnline(index)`

**Arguments:**
- `index` - Index of a member in the guild roster (between 1 and `GetNumGuildMembers()`), or 0 for no selection (`number`)

**Returns:**
- `years` - Number of years since the member was last online (`number`)
- `months` - Number of months since the member was last online (`number`)
- `days` - Number of days since the member was last online (`number`)
- `hours` - Number of hours since the member was last online (`number`)

**See also:** Guild functions.




## GetGuildRosterMOTD

Returns the Message of the Day for the player's guild

**Signature:** `guildMOTD = GetGuildRosterMOTD()`

**Returns:**
- `guildMOTD` - The guild Message of the Day (`string`)

**See also:** Guild functions.




## GetGuildRosterSelection

Returns the index of the selected member in the guild roster. Selection in the guild roster is used only for display in the default UI and has no effect on other Guild APIs.

**Signature:** `index = GetGuildRosterSelection()`

**Returns:**
- `index` - Index of the selected member in the guild roster (between 1 and `GetNumGuildMembers()`), or 0 for no selection (`number`)




## GetGuildRosterShowOffline

Returns whether the guild roster lists offline members

**Signature:** `showOffline = GetGuildRosterShowOffline()`

**Returns:**
- `showOffline` - 1 if offline members are included in the guild roster listing; otherwise nil (`1nil`)

**See also:** Guild functions.




## GetGuildTabardFileNames

Returns the textures that comprise the player's guild tabard. Returns nil if the player is not in a guild.

**Signature:** `tabardBackgroundUpper, tabardBackgroundLower, tabardEmblemUpper, tabardEmblemLower, tabardBorderUpper, tabardBorderLower = GetGuildTabardFileNames()`

**Returns:**
- `tabardBackgroundUpper` - Path to the texture for the upper portion of the tabard's background (`string`)
- `tabardBackgroundLower` - Path to the texture for the lower portion of the tabard's background (`string`)
- `tabardEmblemUpper` - Path to the texture for the upper portion of the tabard's emblem (`string`)
- `tabardEmblemLower` - Path to the texture for the lower portion of the tabard's emblem (`string`)
- `tabardBorderUpper` - Path to the texture for the upper portion of the tabard's border (`string`)
- `tabardBorderLower` - Path to the texture for the lower portion of the tabard's border (`string`)

**See also:** Guild functions.



