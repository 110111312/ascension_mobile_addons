# Widget: GameTooltip

---

## GameTooltip

GameTooltips are used to display explanatory information relevant to a particular element of the game world. They offer almost innumerable methods for setting the specific object, creature or ability the tooltip should describe, and a smaller number of methods for querying what it is that the tooltip is currently describing.

GameTooltips are sufficiently complicated that an entire chapter is dedicated to describing them. In addition to methods for setting their contents, they also support options controlling their positioning and visibility on screen, as well as methods to facilitate adding more text to them (for instance, an addon that displays, in the tooltip for a soul shard created by a warlock, the name of the player or monster from which the shard was collected).

While most of the heavy lifting is done by the frame called simply GameTooltip, there is also one called ItemRefTooltip that does the work of displaying information about items linked in chat when they are clicked.

### Methods

### GameTooltip:AddDoubleLine

Adds a line to the tooltip with both left-side and right-side portions. The tooltip is not automatically resized to fit the added line; to do so, call the tooltip's `:Show()` method after adding lines.

**Signature:** `GameTooltip:AddDoubleLine("textLeft", "textRight" [, rL [, gL [, bL [, rR [, gR [, bR]]]]]])`

**Arguments:**
- `textLeft` - Text to be displayed on the left side of the new line (`string`)
- `textRight` - Text to be displayed on the right side of the new line (`string`)
- `rL` - Red component of the color for the left-side text (0.0 - 1.0) (`number`)
- `gL` - Green component of the color for the left-side text (0.0 - 1.0) (`number`)
- `bL` - Blue component of the color for the left-side text (0.0 - 1.0) (`number`)
- `rR` - Red component of the color for the right-side text (0.0 - 1.0) (`number`)
- `gR` - Green component of the color for the right-side text (0.0 - 1.0) (`number`)
- `bR` - Blue component of the color for the right-side text (0.0 - 1.0) (`number`)

### GameTooltip:AddFontStrings

Adds fontstrings to the tooltip, dynamically expanding the number of lines

**Signature:** `GameTooltip:AddFontStrings()`

### GameTooltip:AddLine

Adds a line of text to the tooltip. The tooltip is not automatically resized to fit the added line (and wrap it, if applicable); to do so, call the tooltip's `:Show()` method after adding lines.

**Signature:** `GameTooltip:AddLine("text" [, r [, g [, b [, wrap]]]])`

**Arguments:**
- `text` - Text to be added as a new line in the tooltip (`string`)
- `r` - Red component of the text color (0.0 - 1.0) (`number`)
- `g` - Green component of the text color (0.0 - 1.0) (`number`)
- `b` - Blue component of the text color (0.0 - 1.0) (`number`)
- `wrap` - True to cause the line to wrap if it is longer than other, non-wrapping lines in the tooltip or longer than the tooltip's forced width (`boolean`)

### GameTooltip:AddTexture

Adds a texture to the last tooltip line. The texture is sized to match the height of the line's text and positioned to the left of the text (indenting the text to provide room).

**Signature:** `GameTooltip:AddTexture("texture")`

**Arguments:**
- `texture` - Path to a texture image file (`string`)

### GameTooltip:AppendText

Adds text to the first line of the tooltip

**Signature:** `GameTooltip:AppendText("text")`

**Arguments:**
- `text` - Text to be appended to the tooltip's first line (`string`)

### GameTooltip:ClearLines

Clears the tooltip's contents. Scripts scanning the tooltip contents should be aware that this method clears the text of all the tooltip's left-side font strings but hides the right-side font strings without clearing their text.

**Signature:** `GameTooltip:ClearLines()`

### GameTooltip:FadeOut

Causes the tooltip to begin fading out

**Signature:** `GameTooltip:FadeOut()`

### GameTooltip:GetAnchorType

Returns the method for anchoring the tooltip relative to its owner

**Signature:** `anchor = GameTooltip:GetAnchorType()`

**Returns:**
- `anchor` - Token identifying the method for anchoring the tooltip relative to its owner frame (`string`) 

 - `ANCHOR_BOTTOMLEFT` - Align the top right of the tooltip with the bottom left of the owner
- `ANCHOR_CURSOR` - Toolip follows the mouse cursor
- `ANCHOR_LEFT` - Align the bottom right of the tooltip with the top left of the owner
- `ANCHOR_NONE` - Tooltip appears in the default position
- `ANCHOR_PRESERVE` - Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
- `ANCHOR_RIGHT` - Align the bottom left of the tooltip with the top right of the owner
- `ANCHOR_TOPLEFT` - Align the bottom left of the tooltip with the top left of the owner
- `ANCHOR_TOPRIGHT` - Align the bottom right of the tooltip with the top right of the owner

### GameTooltip:GetItem

Returns the name and hyperlink for the item displayed in the tooltip

**Signature:** `name, link = GameTooltip:GetItem()`

**Returns:**
- `name` - Name of the item whose information is displayed in the tooltip, or nil. (`string`)
- `link` - A hyperlink for the item (`string`, hyperlink)

### GameTooltip:GetMinimumWidth

Returns the minimum width of the tooltip

**Signature:** `width = GameTooltip:GetMinimumWidth()`

**Returns:**
- `width` - Minimum width of the tooltip frame (in pixels) (`number`)

### GameTooltip:GetOwner

Returns the frame to which the tooltip refers and is anchored

**Signature:** `owner = GameTooltip:GetOwner()`

**Returns:**
- `owner` - Reference to the `Frame` object to which the tooltip is anchored (`frame`)

### GameTooltip:GetPadding

Returns the amount of space between tooltip's text and its right-side edge

**Signature:** `padding = GameTooltip:GetPadding()`

**Returns:**
- `padding` - Amount of space between the right-side edge of the tooltip's text and the right-side edge of the tooltip frame (in pixels) (`number`)

### GameTooltip:GetSpell

Returns information about the spell displayed in the tooltip

**Signature:** `spellName, spellRank, spellID = GameTooltip:GetSpell()`

**Returns:**
- `spellName` - Name of the spell, or nil if the information in the tooltip is not for a spell. (`string`)
- `spellRank` - Secondary text associated with the spell name (often a rank, e.g. `"Rank 8"`) (`string`)
- `spellID` - Numeric identifier for the spell and rank (`number`, spellID)

### GameTooltip:GetUnit

Returns information about the unit displayed in the tooltip

**Signature:** `name, unit = GameTooltip:GetUnit()`

**Returns:**
- `name` - Name of the unit displayed in the tooltip, or nil (`string`)
- `unit` - Unit identifier of the unit, or `nil` if the unit cannot be referenced by a `unitID` (`string`, unitID)

### GameTooltip:IsEquippedItem

Returns whether the tooltip is displaying an item currently equipped by the player

**Signature:** `enabled = GameTooltip:IsEquippedItem()`

**Returns:**
- `enabled` - `1` if the tooltip is displaying information about an item currently equipped by the player; otherwise `nil` (`1nil`)

### GameTooltip:IsOwned

Returns whether the tooltip has an owner frame

**Signature:** `hasOwner = GameTooltip:IsOwned()`

**Returns:**
- `hasOwner` - `1` if the tooltip has an owner frame; otherwise `nil` (`1nil`)

### GameTooltip:IsUnit

Returns whether the tooltip is displaying information for a given unit

**Signature:** `isUnit = GameTooltip:IsUnit("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)

**Returns:**
- `isUnit` - `1` if the tooltip is displaying information for the unit; otherwise `nil` (`1nil`)

### GameTooltip:NumLines

Returns the number of lines of text currently shown in the tooltip

**Signature:** `numLines = GameTooltip:NumLines()`

**Returns:**
- `numLines` - Number of lines currently shown in the tooltip (`number`)

### GameTooltip:SetAction

Fills the tooltip with information about the contents of an action slot

**Signature:** `GameTooltip:SetAction(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

### GameTooltip:SetAnchorType

Sets the method for anchoring the tooltip relative to its owner

**Signature:** `GameTooltip:SetAnchorType("anchor" [, xOffset [, yOffset]])`

**Arguments:**
- `anchor` - Token identifying the positioning method for the tooltip relative to its owner frame (`string`) 

 - `ANCHOR_BOTTOMLEFT` - Align the top right of the tooltip with the bottom left of the owner
- `ANCHOR_CURSOR` - Toolip follows the mouse cursor
- `ANCHOR_LEFT` - Align the bottom right of the tooltip with the top left of the owner
- `ANCHOR_NONE` - Tooltip appears in the default position
- `ANCHOR_PRESERVE` - Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
- `ANCHOR_RIGHT` - Align the bottom left of the tooltip with the top right of the owner
- `ANCHOR_TOPLEFT` - Align the bottom left of the tooltip with the top left of the owner
- `ANCHOR_TOPRIGHT` - Align the bottom right of the tooltip with the top right of the owner
- `xOffset` - Horizontal distance from the anchor to the tooltip (`number`)
- `yOffset` - Vertical distance from the anchor to the tooltip (`number`)

### GameTooltip:SetAuctionItem

Fills the tooltip with information about an item in the auction house

**Signature:** `GameTooltip:SetAuctionItem("list", index)`

**Arguments:**
- `list` - Type of auction listing (`string`, ah-list-type) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of an auction in the listing (`number`)

### GameTooltip:SetAuctionSellItem

Fills the tooltip with information about the item currently being set up for auction

**Signature:** `GameTooltip:SetAuctionSellItem()`

### GameTooltip:SetBackpackToken

Fills the tooltip with information about a currency marked for watching on the Backpack UI

**Signature:** `GameTooltip:SetBackpackToken(index)`

**Arguments:**
- `index` - Index of a 'slot' for displaying currencies on the backpack (between 1 and `MAX_WATCHED_TOKENS`) (`number`)

### GameTooltip:SetBagItem

Sets the GameTooltip to show the item from the given bag and slot

**Signature:** `hasCooldown, repairCost = GameTooltip:SetBagItem(bag,item)`

### GameTooltip:SetBuybackItem

Fills the tooltip with information about item recently sold to a vendor and available to be repurchased

**Signature:** `GameTooltip:SetBuybackItem(index)`

**Arguments:**
- `index` - Index of an item in the buyback listing (between 1 and `GetNumBuybackItems()`) (`number`)

### GameTooltip:SetCurrencyToken

Fills the tooltip with information about a special currency type. Note that passing the index of a header will crash the client.

**Signature:** `GameTooltip:SetCurrencyToken(index)`

**Arguments:**
- `index` - Index of a currency type in the currency list (between 1 and `GetCurrencyListSize()`) (`number`)

### GameTooltip:SetEquipmentSet

Fills the tooltip with information about an equipment set

**Signature:** `GameTooltip:SetEquipmentSet("name")`

**Arguments:**
- `name` - Name of the equipment set (`string`)

### GameTooltip:SetExistingSocketGem

Fills the tooltip with information about a permanently socketed gem

**Signature:** `GameTooltip:SetExistingSocketGem(index, toDestroy)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)
- `toDestroy` - True to alter the tooltip display to indicate that this gem will be destroyed by socketing a new gem; false to show the normal tooltip for the gem (`boolean`)

### GameTooltip:SetFrameStack

Fills the tooltip with a list of frames under the mouse cursor. Not relevant outside of addon development and debugging.

**Signature:** `GameTooltip:SetFrameStack(includeHidden)`

**Arguments:**
- `includeHidden` - True to include hidden frames in the list; false to list only visible frames (`boolean`)

### GameTooltip:SetGlyph

Fills the tooltip with information about one of the player's glyphs

**Signature:** `GameTooltip:SetGlyph(socket, talentGroup)`

**Arguments:**
- `socket` - Which socket's glyph to display (between 1 and `NUM_GLYPH_SLOTS`) (`number`, glyphIndex)
- `talentGroup` - Which set of glyphs to display, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

### GameTooltip:SetGuildBankItem

Fills the tooltip with information about an item in the guild bank. Information is only available if the guild bank tab has been opened in the current play session.

**Signature:** `GameTooltip:SetGuildBankItem(tab, slot)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `slot` - Index of an item slot in the guild bank tab (between 1 and `MAX_GUILDBANK_SLOTS_PER_TAB`) (`number`)

### GameTooltip:SetHyperlink

Fills the tooltip with information about an item, quest, spell, or other entity represented by a hyperlink

**Signature:** `GameTooltip:SetHyperlink("hyperlink")`

**Arguments:**
- `hyperlink` - A full hyperlink, or the `linktype:linkdata` portion thereof (`string`, hyperlink)

### GameTooltip:SetHyperlinkCompareItem

Fills the tooltip with information about the item currently equipped in the slot used the supplied item

**Signature:** `success = GameTooltip:SetHyperlinkCompareItem("hyperlink" [, index])`

**Arguments:**
- `hyperlink` - A full hyperlink, or the `linktype:linkdata` portion thereof, for an item to compare against the player's equipped similar item (`string`, hyperlink)
- `index` - Index of the slot to compare against (1, 2, or 3), if more than one item of the equipment type can be equipped at once (e.g. rings and trinkets) (`number`)

**Returns:**
- `success` - `1` if an item's information was loaded into the tooltip; otherwise `nil` (`number`, 1nil)

### GameTooltip:SetInboxItem

Fills the tooltip with information about an item attached to a message in the player's inbox

**Signature:** `GameTooltip:SetInboxItem(mailID, attachmentIndex)`

**Arguments:**
- `mailID` - Index of a message in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)
- `attachmentIndex` - Index of an attachment to the message (between 1 and `select(8,``GetInboxHeaderInfo(mailID)``)`) (`number`)

### GameTooltip:SetInventoryItem

Fills the tooltip with information about an equipped item

**Signature:** `hasItem, hasCooldown, repairCost = GameTooltip:SetInventoryItem("unit", slot [, nameOnly])`

**Arguments:**
- `unit` - A unit to query; only valid for 'player' or the unit currently being inspected (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)
- `nameOnly` - True to omit much of the item's information (stat bonuses, sockets, and binding) from the tooltip; false to show all of the item's information (`boolean`)

**Returns:**
- `hasItem` - `1` if the unit has an item in the given slot; otherwise `nil` (`number`, 1nil)
- `hasCooldown` - `1` if the item is currently on cooldown; otherwise `nil` (`number`, 1nil)
- `repairCost` - Cost to repair the item (in copper, ignoring faction discounts) (`number`)

### GameTooltip:SetLFGCompletionReward

### GameTooltip:SetLFGDungeonReward

### GameTooltip:SetLootItem

Fills the tooltip with information about an item available as loot

**Signature:** `GameTooltip:SetLootItem(slot)`

**Arguments:**
- `slot` - Index of a loot slot (between 1 and `GetNumLootItems()`) (`number`)

### GameTooltip:SetLootRollItem

Fills the tooltip with information about an item currently up for loot rolling

**Signature:** `GameTooltip:SetLootRollItem(id)`

**Arguments:**
- `id` - Index of an item currently up for loot rolling (as provided in the `START_LOOT_ROLL` event) (`number`)

### GameTooltip:SetMerchantCostItem

Fills the tooltip with information about an alternate currency required to purchase an item from a vendor. Only applies to item-based currencies, not honor or arena points.

**Signature:** `GameTooltip:SetMerchantCostItem(index, currency)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)
- `currency` - Index of one of the item currencies required to purchase the item (between 1 and `select(3,``GetMerchantItemCostInfo(index)``)`) (`number`)

### GameTooltip:SetMerchantItem

Fills the tooltip with information about an item available for purchase from a vendor

**Signature:** `GameTooltip:SetMerchantItem(merchantIndex)`

**Arguments:**
- `merchantIndex` - The index of an item in the merchant window, between `1` and `GetMerchantNumItems()`. (`number`)

### GameTooltip:SetMinimumWidth

Sets the minimum width of the tooltip. Normally, a tooltip is automatically sized to match the width of its shortest line of text; setting a minimum width can be useful if the tooltip also contains non-text frames (such as an amount of money or a status bar).

The tooltip is not automatically resized to the new width; to do so, call the tooltip's `:Show()` method.

**Signature:** `GameTooltip:SetMinimumWidth(width)`

**Arguments:**
- `width` - Minimum width of the tooltip frame (in pixels) (`number`)

### GameTooltip:SetOwner

Sets the frame to which the tooltip refers and is anchored

**Signature:** `GameTooltip:SetOwner(frame [, "anchorType" [, xOffset [, yOffset]]])`

**Arguments:**
- `frame` - Reference to the `Frame` to which the tooltip refers (`frame`)
- `anchorType` - Token identifying the positioning method for the tooltip relative to its owner frame (`string`) 

 - `ANCHOR_BOTTOMLEFT` - Align the top right of the tooltip with the bottom left of the owner
- `ANCHOR_CURSOR` - Toolip follows the mouse cursor
- `ANCHOR_LEFT` - Align the bottom right of the tooltip with the top left of the owner
- `ANCHOR_NONE` - Tooltip appears in the default position
- `ANCHOR_PRESERVE` - Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
- `ANCHOR_RIGHT` - Align the bottom left of the tooltip with the top right of the owner
- `ANCHOR_TOPLEFT` - Align the bottom left of the tooltip with the top left of the owner
- `ANCHOR_TOPRIGHT` - Align the bottom right of the tooltip with the top right of the owner
- `xOffset` - The horizontal offset for the tooltip anchor (`number`)
- `yOffset` - The vertical offset for the tooltip anchor (`number`)

### GameTooltip:SetPadding

Sets the amount of space between tooltip's text and its right-side edge. Used in the default UI's ItemRefTooltip to provide space for a close button.

**Signature:** `GameTooltip:SetPadding(padding)`

**Arguments:**
- `padding` - Amount of space between the right-side edge of the tooltip's text and the right-side edge of the tooltip frame (in pixels) (`number`)

### GameTooltip:SetPetAction

Fills the tooltip with information about a pet action. Only provides information for pet action slots containing pet spells -- in the default UI, the standard pet actions (attack, follow, passive, aggressive, etc) are special-cased to show specific tooltip text.

**Signature:** `GameTooltip:SetPetAction(index)`

**Arguments:**
- `index` - Index of a pet action button (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)

### GameTooltip:SetPossession

Fills the tooltip with information about one of the special actions available while the player possesses another unit

**Signature:** `GameTooltip:SetPossession(index)`

**Arguments:**
- `index` - Index of a possession bar action (between 1 and `NUM_POSSESS_SLOTS`) (`number`)

### GameTooltip:SetQuestItem

Fills the tooltip with information about an item in a questgiver dialog

**Signature:** `GameTooltip:SetQuestItem("itemType", index)`

**Arguments:**
- `itemType` - Token identifying one of the possible sets of items (`string`) 

 - `choice` - Items from which the player may choose a reward
- `required` - Items required to complete the quest
- `reward` - Items given as reward for the quest
- `index` - Index of an item in the set (between 1 and `GetNumQuestChoices()`, `GetNumQuestItems()`, or `GetNumQuestRewards()`, according to `itemType`) (`number`)

### GameTooltip:SetQuestLogItem

Fills the tooltip with information about an item related to the selected quest in the quest log

**Signature:** `GameTooltip:SetQuestLogItem("itemType", index)`

**Arguments:**
- `itemType` - Token identifying one of the possible sets of items (`string`) 

 - `choice` - Items from which the player may choose a reward
- `reward` - Items always given as reward for the quest
- `index` - Index of an item in the set (between 1 and `GetNumQuestLogChoices()` or `GetNumQuestLogRewards()`, according to `itemType`) (`number`)

### GameTooltip:SetQuestLogRewardSpell

Fills the tooltip with information about the reward spell for the selected quest in the quest log

**Signature:** `GameTooltip:SetQuestLogRewardSpell()`

### GameTooltip:SetQuestLogSpecialItem

Fills the tooltip with information about a usable item associated with a current quest

**Signature:** `GameTooltip:SetQuestLogSpecialItem(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest log entry with an associated usable item (between 1 and `GetNumQuestLogEntries()`) (`number`)

### GameTooltip:SetQuestRewardSpell

Fills the tooltip with information about the spell reward in a questgiver dialog

**Signature:** `GameTooltip:SetQuestRewardSpell()`

### GameTooltip:SetSendMailItem

Fills the tooltip with information about an item attached to the outgoing mail message

**Signature:** `GameTooltip:SetSendMailItem(slot)`

**Arguments:**
- `slot` - Index of an outgoing attachment slot (between 1 and `ATTACHMENTS_MAX_SEND`) (`number`)

### GameTooltip:SetShapeshift

Fills the tooltip with information about an ability on the stance/shapeshift bar

**Signature:** `GameTooltip:SetShapeshift(index)`

**Arguments:**
- `index` - Index of an ability on the stance/shapeshift bar (between 1 and `GetNumShapeshiftForms()`) (`number`)

### GameTooltip:SetSocketedItem

Fills the tooltip with information about the item currently being socketed

**Signature:** `GameTooltip:SetSocketedItem()`

### GameTooltip:SetSocketGem

Fills the tooltip with information about a gem added to a socket

**Signature:** `GameTooltip:SetSocketGem(index)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)

### GameTooltip:SetSpellByID

Fills the tooltip with information about a spell specified by ID

**Signature:** `GameTooltip:SetSpellByID(id)`

**Arguments:**
- `id` - Numeric ID of a spell (`number`, spellID)

### GameTooltip:SetTalent

Fills the tooltip with information about a talent

**Signature:** `GameTooltip:SetTalent(tabIndex, talentIndex, inspect, pet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `talentIndex` - Index of a talent option (between 1 and `GetNumTalents()`) (`number`)
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

### GameTooltip:SetText

Sets the tooltip's text. Any other content currently displayed in the tooltip will be removed or hidden, and the tooltip's size will be adjusted to fit the new text.

**Signature:** `GameTooltip:SetText("text" [, r [, g [, b [, a]]]])`

**Arguments:**
- `text` - Text to be displayed in the tooltip (`string`)
- `r` - Red component of the text color (0.0 - 1.0) (`number`)
- `g` - Green component of the text color (0.0 - 1.0) (`number`)
- `b` - Blue component of the text color (0.0 - 1.0) (`number`)
- `a` - Alpha (opacity) for the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### GameTooltip:SetTotem

Fills the tooltip with information about one of the player's active totems.. Totem functions are also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).

**Signature:** `GameTooltip:SetTotem(slot)`

**Arguments:**
- `slot` - Which totem to query (`number`) 

 - `1` - Fire (or Death Knight's ghoul)
- `2` - Earth
- `3` - Water
- `4` - Air

### GameTooltip:SetTradePlayerItem

Fills the tooltip with information about an item offered for trade by the player. See `:SetTradeTargetItem()` for items to be received from the trade.

**Signature:** `GameTooltip:SetTradePlayerItem(index)`

**Arguments:**
- `index` - Index of an item offered for trade by the player (between 1 and `MAX_TRADE_ITEMS`) (`number`)

### GameTooltip:SetTradeSkillItem

Fills the tooltip with information about an item created by a trade skill recipe or a reagent in the recipe

**Signature:** `GameTooltip:SetTradeSkillItem(skillIndex [, reagentIndex])`

**Arguments:**
- `skillIndex` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)
- `reagentIndex` - Index of a reagent in the recipe (between 1 and `GetTradeSkillNumReagents()`); if omitted, displays a tooltip for the item created by the recipe (`number`)

### GameTooltip:SetTradeTargetItem

Fills the tooltip with information about an item offered for trade by the target. See `:SetTradePlayerItem()` for items to be traded away by the player.

**Signature:** `GameTooltip:SetTradeTargetItem(index)`

**Arguments:**
- `index` - Index of an item offered for trade by the target (between 1 and `MAX_TRADE_ITEMS`) (`number`)

### GameTooltip:SetTrainerService

Fills the tooltip with information about a trainer service

**Signature:** `GameTooltip:SetTrainerService(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

### GameTooltip:SetUnit

Fills the tooltip with information about a unit

**Signature:** `GameTooltip:SetUnit("unit")`

**Arguments:**
- `unit` - A unit to query (`string`, unitid)

### GameTooltip:SetUnitAura

Fills the tooltip with information about a buff or debuff on a unit

**Signature:** `GameTooltip:SetUnitAura("unit", index [, "filter"])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `index` - Index of a buff or debuff on the unit (`number`)
- `filter` - A list of filters to use when resolving the index, separated by the pipe '|' character; e.g. `"RAID|PLAYER"` will query group buffs cast by the player (`string`) 

 - `CANCELABLE` - Show auras that can be cancelled
- `HARMFUL` - Show debuffs only
- `HELPFUL` - Show buffs only
- `NOT_CANCELABLE` - Show auras that cannot be cancelled
- `PLAYER` - Show auras the player has cast
- `RAID` - Show auras the player can cast on party/raid members (as opposed to self buffs)

### GameTooltip:SetUnitBuff

Fills the tooltip with information about a buff on a unit. This method is an alias for `:SetUnitAura()` with a built-in `HELPFUL` filter (which cannot be removed or negated with the `HARMFUL` filter).

**Signature:** `GameTooltip:SetUnitBuff("unit", index [, "filter"])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `index` - Index of a buff or debuff on the unit (`number`)
- `filter` - A list of filters to use when resolving the index, separated by the pipe '|' character; e.g. `"RAID|PLAYER"` will query group buffs cast by the player (`string`) 

 - `CANCELABLE` - Show auras that can be cancelled
- `NOT_CANCELABLE` - Show auras that cannot be cancelled
- `PLAYER` - Show auras the player has cast
- `RAID` - Show auras the player can cast on party/raid members (as opposed to self buffs)

### GameTooltip:SetUnitDebuff

Fills the tooltip with information about a debuff on a unit. This method is an alias for `:SetUnitAura()` with a built-in `HARMFUL` filter (which cannot be removed or negated with the `HELPFUL` filter).

**Signature:** `GameTooltip:SetUnitDebuff("unit", index [, "filter"])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `index` - Index of a buff or debuff on the unit (`number`)
- `filter` - A list of filters to use when resolving the index, separated by the pipe '|' character; e.g. `"CANCELABLE|PLAYER"` will query cancelable debuffs cast by the player (`string`) 

 - `CANCELABLE` - Show auras that can be cancelled
- `NOT_CANCELABLE` - Show auras that cannot be cancelled
- `PLAYER` - Show auras the player has cast
- `RAID` - Show auras the player can cast on party/raid members (as opposed to self buffs)

### Script Handlers

- OnAttributeChanged(self, "name", value) - Run when a frame attribute is changed
- OnChar(self, "text") - Run for each text character typed in the frame
- OnDisable(self) - Run when the frame is disabled
- OnDragStart(self, "button") - Run when the mouse is dragged starting in the frame
- OnDragStop(self) - Run when the mouse button is released after a drag started in the frame
- OnEnable(self) - Run when the frame is enabled
- OnEnter(self, motion) - Run when the mouse cursor enters the frame's interactive area
- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnHide(self) - Run when the frame's visbility changes to hidden
- OnKeyDown(self, "key") - Run when a keyboard key is pressed if the frame is keyboard enabled
- OnKeyUp(self, "key") - Run when a keyboard key is released if the frame is keyboard enabled
- OnLeave(self, motion) - Run when the mouse cursor leaves the frame's interactive area
- OnLoad(self) - Run when the frame is created
- OnMouseDown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- OnMouseUp(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- OnMouseWheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnTooltipAddMoney(self, amount, maxAmount) - Run when an amount of money should be added to the tooltip
- OnTooltipCleared(self) - Run when the tooltip is hidden or its content is cleared
- OnTooltipSetAchievement(self) - Run when the tooltip is filled with information about an achievement
- OnTooltipSetDefaultAnchor(self) - Run when the tooltip is repositioned to its default anchor location
- OnTooltipSetEquipmentSet(self) - Run when the tooltip is filled with information about an equipment set
- OnTooltipSetFrameStack(self) - Run when the tooltip is filled with a list of frames under the mouse cursor
- OnTooltipSetItem(self) - Run when the tooltip is filled with information about an item
- OnTooltipSetQuest(self) - Run when the tooltip is filled with information about a quest
- OnTooltipSetSpell(self) - Run when the tooltip is filled with information about a spell
- OnTooltipSetUnit(self) - Run when the tooltip is filled with information about a unit
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

