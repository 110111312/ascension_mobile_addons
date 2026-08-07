# WoW API — GetT*

_64 functions_

---

## GetTabardCreationCost

Returns the cost to create a guild tabard. Only returns valid data if the player is interacting with a tabard designer (i.e. between the `OPEN_TABARD_FRAME` and `CLOSE_TABARD_FRAME` events).

**Signature:** `cost = GetTabardCreationCost()`

**Returns:**
- `cost` - The cost of creating a guild tabard, in copper (`number`)




## GetTabardInfo

**Signature:** `GetTabardInfo()`




## GetTalentInfo

Returns information about a talent option

**Signature:** `name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq, previewRank, meetsPreviewPrereq = GetTalentInfo(tabIndex, talentIndex, inspect, pet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `talentIndex` - Index of a talent option (between 1 and `GetNumTalents()`) (`number`)
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `name` - Name of the talent (`string`)
- `iconTexture` - The icon texture of the talent. (`string`)
- `tier` - Row in which the talent should be displayed (1 = top) (`number`)
- `column` - Column in which the talent should be displayed (1 = left) (`number`)
- `rank` - Number of points spent in the talent (`number`)
- `maxRank` - Maximum number of points that can be spent in the talent (`number`)
- `isExceptional` - 1 if the talent confers a new ability (spell); otherwise nil (`1nil`)
- `meetsPrereq` - 1 if the prerequisites to learning the talent have been met; otherwise nil (`1nil`)
- `previewRank` - Number of points spent in the talent in preview mode (`number`)
- `meetsPreviewPrereq` - 1 if the prerequisites to learning the talent have been met in preview mode; otherwise nil (`1nil`)




## GetTalentLink

Returns a hyperlink for a talent

**Signature:** `link = GetTalentLink(tabIndex, talentIndex, inspect, pet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `talentIndex` - Index of a talent option (between 1 and `GetNumTalents()`) (`number`)
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `link` - A hyperlink representing the talent and the number of points spent in it (`string`, hyperlink)




## GetTalentPrereqs

Returns information about prerequisites to learning a talent

**Signature:** `tier, column, isLearnable, isPreviewLearnable, ... = GetTalentPrereqs(tabIndex, talentIndex, inspect, pet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `talentIndex` - Index of a talent option (between 1 and `GetNumTalents()`) (`number`)
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `tier` - Row in which the talent's prerequisite is displayed (1 = top) (`number`)
- `column` - Column in which the talent's prerequisite is displayed (1 = left) (`number`)
- `isLearnable` - 1 if the talent is learnable; otherwise nil (`1nil`)
- `isPreviewLearnable` - 1 if the talent is learnable in preview mode; otherwise nil (`1nil`)
- `...` - Additional sets of `tier, column, isLearnable, isPreviewLearnable` values for each prerequisite to learning the talent (`list`)

**See also:** Talent functions.




## GetTalentTabInfo

Returns information about a talent tab

**Signature:** `id, name, description, icon, points, background, previewPoints, isUnlocked = GetTalentTabInfo(tabIndex, inspect, pet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**Returns:**
- `id` - ID of the talent tab (`number`, blizzid)
- `name` - Name of the talent tab (`string`)
- `description` - Localized summary of the talent tab (`string`)
- `icon` - Path to an icon texture for the talent tab (`string`)
- `points` - Number of points spent in the talent tab (`number`)
- `background` - Path to a background texture for the talent tab (`string`)
- `previewPoints` - Number of points spent in the talent tab in preview mode (`number`)
- `isUnlocked` - Whether the player can put points into the talent tab or not (`boolean`)

**See also:** Talent functions.




## GetTargetTradeMoney

Returns the amount of money offered for trade by the target

**Signature:** `amount = GetTargetTradeMoney()`

**Returns:**
- `amount` - Amount of money offered for trade by the target (in copper) (`number`)




## GetTaxiBenchmarkMode

Returns whether flight path benchmark mode is enabled

**Signature:** `isBenchmark = GetTaxiBenchmarkMode()`

**Returns:**
- `isBenchmark` - 1 if taxi benchmark mode is enabled; otherwise nil (`1nil`)

**See also:** Taxi/Flight functions, Debugging and Profiling functions.




## GetTerrainMip

Returns the level of terrain detail displayed. Corresponds to the "Terrain Blending" slider in the default UI's Video Options pane.

**Signature:** `terrainDetail = GetTerrainMip()`

**Returns:**
- `terrainDetail` - Level of terrain detail displayed (`number`) 

 - `0` - Low detail
- `1` - High detail




## GetTexLodBias

_No snapshot available (page did not exist in archive)._




## GetText

_No content available._




## GetThreatStatusColor

Returns color values for a given threat status. Color component values are floating point numbers between 0 and 1, with 1 representing full intensity.

**Signature:** `red, green, blue = GetThreatStatusColor(status)`

**Arguments:**
- `status` - A threat status category, as returned by `UnitThreatSituation` or `UnitDetailedThreatSituation` (`number`)

**Returns:**
- `red` - Red component of the color (`number`)
- `green` - Green component of the color (`number`)
- `blue` - Blue component of the color (`number`)




## GetTime

Returns a number representing the current time (with millisecond precision). Unlike with `time()`, the number returned by this function has no meaning of its own and may not be comparable across clients; however, since it also provides higher resolution it can be compared against itself for high-precision time measurements.

**Signature:** `time = GetTime()`

**Returns:**
- `time` - A number that represents the current time in seconds (with millisecond precision) (`number`)




## GetTimeToWellRested




## GetTitleName

Returns the text of an available player title

**Signature:** `titleName = GetTitleName(titleIndex)`

**Arguments:**
- `titleIndex` - Index of a title available to the player (between 1 and `GetNumTitles()`) (`integer`)

**Returns:**
- `titleName` - The text of the title (`string`)

**See also:** Player information functions.




## GetTitleText

Returns the title text for the quest presented by a questgiver. Only valid following the `QUEST_DETAIL`, `QUEST_PROGRESS`, or `QUEST_COMPLETE` events; otherwise may return nil or a value from the most recently displayed quest.

**Signature:** `text = GetTitleText()`

**Returns:**
- `text` - Title text for the quest (`string`)

**See also:** Quest functions.




## GetTotalAchievementPoints

Returns the player's total achievement points earned

**Signature:** `points = GetTotalAchievementPoints()`

**Returns:**
- `points` - Total number of achievement points earned by the player (`number`)

**See also:** Achievement functions.




## GetTotemInfo

Returns information on a currently active totem (or ghoul). Totem functions are also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).

**Signature:** `haveTotem, name, startTime, duration, icon = GetTotemInfo(slot)`

**Arguments:**
- `slot` - Which totem to query (`number`) 

 - `1` - Fire (or Death Knight's ghoul)
- `2` - Earth
- `3` - Water
- `4` - Air

**Returns:**
- `haveTotem` - True if a totem of the given type is active (`boolean`)
- `name` - The name of the totem (`string`)
- `startTime` - The value of GetTime() when the totem was created (`number`)
- `duration` - The total duration the totem will last (in seconds) (`number`)
- `icon` - Path to a texture to use as the totem's icon (`string`)




## GetTotemTimeLeft

Returns the time remaining before a totem (or ghoul) automatically disappears. 
Using `GetTime()` and the third and fourth returns (`startTime `and `duration`) of `GetTotemInfo()` instead of this function is recommended if frequent updates are needed.

Totem functions are also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).

**Signature:** `seconds = GetTotemTimeLeft(slot)`

**Arguments:**
- `slot` - Which totem to query (`number`) 

 - `1` - Fire (or Death Knight's ghoul)
- `2` - Earth
- `3` - Water
- `4` - Air

**Returns:**
- `seconds` - Time remaining before the totem/ghoul is automatically destroyed (`number`)




## GetTrackedAchievements

Returns numeric IDs of the achievements flagged for display in the objectives tracker UI

**Signature:** `... = GetTrackedAchievements()`

**Returns:**
- `...` - List of numeric IDs for the achievements being tracked (`list`)




## GetTrackingInfo

Returns information about a given tracking option

**Signature:** `name, texture, active, category = GetTrackingInfo(index)`

**Arguments:**
- `index` - Index of a tracking ability to query (between 1 and `GetNumTrackingTypes()`) (`number`)

**Returns:**
- `name` - Localized name of the tracking ability (`string`)
- `texture` - Path to an icon texture for the tracking ability (`string`)
- `active` - 1 if the tracking abilty is active; otherwise nil (`1nil`)
- `category` - Category of the tracking ability; used in the default UI to determine whether to strip the border from the ability's icon texture, and also indicates when the ability can be used: (`string`) 

 - `other` - Ability is available to all players and can be used at any time
- `spell` - Ability is a spell from the player's spellbook; using it may be subject to spell casting restrictions




## GetTrackingTexture

_No snapshot available (page did not exist in archive)._




## GetTradePlayerItemInfo

Returns information about an item offered for trade by the player

**Signature:** `name, texture, numItems, quality, isUsable, enchantment = GetTradePlayerItemInfo(index)`

**Arguments:**
- `index` - Index of an item slot on the player's side of the trade window (between 1 and `MAX_TRADE_ITEMS`) (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `numItems` - Number of stacked items in the slot (`number`)
- `quality` - Quality (rarity) level of the item (`number`, itemQuality)
- `isUsable` - 1 if the player character can use or equip the item; otherwise nil (`1nil`)
- `enchantment` - Name of the enchantment being applied to the item through trade; otherwise nil (`string`)




## GetTradePlayerItemLink

Returns a hyperlink for an item offered for trade by the player

**Signature:** `link = GetTradePlayerItemLink(index)`

**Arguments:**
- `index` - Index of an item offered for trade by the player (between 1 and `MAX_TRADE_ITEMS`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)

**See also:** Trade functions, Hyperlink functions.




## GetTradeSkillCooldown

Returns the time remaining on a trade skill recipe's cooldown

**Signature:** `cooldown = GetTradeSkillCooldown(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `cooldown` - Time remaining before the recipe can be performed again (in seconds), or nil if the recipe is currently available or has no cooldown (`number`)




## GetTradeSkillDescription

Returns descriptive text for a tradeskill recipe. Most recipes that create items don't provide descriptive text; it's more often used for enchants and special recipes such as inscription or alchemy research.

**Signature:** `description = GetTradeSkillDescription(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `description` - Descriptive text for the tradeskill recipe, or nil if no text is associated with the recipe (`string`)

**See also:** Tradeskill functions.




## GetTradeSkillIcon

Returns the icon for a trade skill recipe. For recipes which create an item, this is generally the icon of the item created; for other recipes (such as enchants and alchemy/inscription research) a generic icon is used.

**Signature:** `texturePath = GetTradeSkillIcon(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `texturePath` - Path to an icon texture for the recipe (`string`)

**See also:** Tradeskill functions.




## GetTradeSkillInfo

Returns information about a trade skill header or recipe

**Signature:** `skillName, skillType, numAvailable, isExpanded, serviceType = GetTradeSkillInfo(index)`

**Arguments:**
- `index` - Index of an entry in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `skillName` - Name of the entry (`string`)
- `skillType` - Indicates whether the entry is a header or recipe and difficulty of recipes (`string`) 

 - `easy` - Low chance for the player to gain skill by performing the recipe (displayed as green in the default UI
- `header` - This entry is a header and not an actual trade skill recipe
- `medium` - Moderate chance for the player to gain skill by performing the recipe (displayed as yellow in the default UI
- `optimal` - High chance for the player to gain skill by performing the recipe (displayed as orange in the default UI
- `trivial` - No chance for the player to gain skill by performing the recipe (displayed as gray in the default UI
- `numAvailable` - Number of times the player can repeat the recipe given available reagents (`number`)
- `isExpanded` - 1 if the entry is a header and is expanded; otherwise nil (`1nil`)
- `serviceType` - Indicates what type of service the recipe provides (items, enhancements,...) (`string`) 

 - `Emboss` - Applies an emboss (letherworkers)
- `Embrodier` - Applies an embroider (tailors)
- `Enchant` - Applies an enchant (enchanters)
- `Engrave` - Engraves a rune (runeforging)
- `Inscribe` - Puts an inscription (scribers)
- `Modify` - Puts a socket (blacksmiths)
- `Tinker` - Puts a device like webbing or flexweave (engineers)
- `nil` - Produces an item




## GetTradeSkillInvSlotFilter

Returns whether the trade skill listing is filtered by a given item equipment slot

**Signature:** `enabled = GetTradeSkillInvSlotFilter(index)`

**Arguments:**
- `index` - Index of an item equipment slot (in the list returned by `GetTradeSkillInvSlots()`), or `0` for the "All" filter (`number`)

**Returns:**
- `enabled` - 1 if the filter is enabled; otherwise nil (`1nil`)

**See also:** Tradeskill functions.




## GetTradeSkillInvSlots

Returns a list of recipe equipment slots for the current trade skill. These inventory types correspond to those of the items produced (see `GetItemInfo()` and `GetAuctionItemInvTypes()`) and can be used to filter the recipe list.

**Signature:** `... = GetTradeSkillInvSlots()`

**Returns:**
- `...` - A list of strings, each the localized name of an inventory type applicable to the current trade skill listing (`list`)

**See also:** Tradeskill functions.




## GetTradeSkillItemLevelFilter

Returns the current settings for filtering the trade skill listing by required level of items produced

**Signature:** `minLevel, maxLevel = GetTradeSkillItemLevelFilter()`

**Returns:**
- `minLevel` - Lowest required level of items to show in the filtered list (`number`)
- `maxLevel` - Highest required level of items to show in the filtered list (`number`)




## GetTradeSkillItemLink

Returns a hyperlink for the item created by a tradeskill recipe. The tooltip produced when resolving the link describes only the item created by the recipe. For a link which describes the recipe itself (its reagents and description), see `GetTradeSkillRecipeLink()`.

If the recipe does not create an item, this function returns the same hyperlink as does `GetTradeSkillRecipeLink()` (though the text of the link may differ).

**Signature:** `link = GetTradeSkillItemLink(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `link` - A hyperlink for the item created by the recipe (`string`)

**See also:** Tradeskill functions, Hyperlink functions.




## GetTradeSkillItemNameFilter

Returns the current search text for filtering the trade skill listing by name

**Signature:** `text = GetTradeSkillItemNameFilter()`

**Returns:**
- `text` - Text to search for in recipe names, produced item names or descriptions, or reagents; nil if no search filter is in use (`string`)

**See also:** Tradeskill functions.




## GetTradeSkillLine

Returns information about the current trade skill

**Signature:** `tradeskillName, rank, maxLevel = GetTradeSkillLine()`

**Returns:**
- `tradeskillName` - Name of the trade skill, or "UNKNOWN" if no trade skill window is open (`string`)
- `rank` - The character's current rank in the trade skill (`number`)
- `maxLevel` - The character's current maximum rank in the trade skill (e.g. 300 for a character of Artisan status) (`number`)

**See also:** Tradeskill functions.




## GetTradeSkillListLink

Returns a hyperlink to the player's list of recipes for the current trade skill

**Signature:** `link = GetTradeSkillListLink()`

**Returns:**
- `link` - A hyperlink other players can resolve to see the player's full list of tradeskill recipes (`string`, hyperlink)




## GetTradeSkillNumMade

Returns the number of items created when performing a tradeskill recipe

**Signature:** `minMade, maxMade = GetTradeSkillNumMade(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `minMade` - Minimum number of items created when performing the recipe (`number`)
- `maxMade` - Maximum number of items created when performing the recipe (`number`)

**See also:** Tradeskill functions.




## GetTradeSkillNumReagents

Returns the number of different reagents required for a trade skill recipe

**Signature:** `numReagents = GetTradeSkillNumReagents(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `numReagents` - Number of different reagents required for the recipe (`number`)

**See also:** Tradeskill functions.




## GetTradeSkillReagentInfo

Returns information about a reagent in a trade skill recipe

**Signature:** `reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(skillIndex, reagentIndex)`

**Arguments:**
- `skillIndex` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)
- `reagentIndex` - Index of a reagent in the recipe (between 1 and `GetTradeSkillNumReagents()`) (`number`)

**Returns:**
- `reagentName` - Name of the reagent (`string`)
- `reagentTexture` - Path to an icon texture for the reagent (`string`)
- `reagentCount` - Quantity of the reagent required to perform the recipe (`number`)
- `playerReagentCount` - Quantity of the reagent in the player's possession (`number`)

**See also:** Tradeskill functions.




## GetTradeSkillReagentItemLink

Returns a hyperlink for a reagent in a tradeskill recipe

**Signature:** `link = GetTradeSkillReagentItemLink(skillIndex, reagentIndex)`

**Arguments:**
- `skillIndex` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)
- `reagentIndex` - Index of a reagent in the recipe (between 1 and `GetTradeSkillNumReagents()`) (`number`)

**Returns:**
- `link` - A hyperlink for the reagent item (`string`, hyperlink)




## GetTradeSkillRecipeLink

Returns hyperlink for a tradeskill recipe. The tooltip produced when resolving the link describes the recipe itself -- its reagents and (if present) description -- in addition to (if applicable) the item created. For a link which only describes the created item, see `GetTradeSkillItemLink()`.

**Signature:** `link = GetTradeSkillRecipeLink(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `link` - A hyperlink for the trade skill recipe (`string`)




## GetTradeskillRepeatCount

Returns the number of times the trade skill recipe currently being performed will repeat. Returns 1 if a recipe is not being performed; after `DoTradeSkill()` is called, returns the number of repetitions queued (which decrements as each repetition is finished).

**Signature:** `repeatCount = GetTradeskillRepeatCount()`

**Returns:**
- `repeatCount` - Number of times the current recipe will repeat (`number`)

**See also:** Tradeskill functions.




## GetTradeSkillSelectionIndex

Returns the index of the currently selected trade skill recipe. Selection in the recipe list is used only for display in the default UI and has no effect on other Trade Skill APIs.

**Signature:** `index = GetTradeSkillSelectionIndex()`

**Returns:**
- `index` - Index of the selected recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)




## GetTradeSkillSubClasses

Returns a list of recipe subclasses for the current trade skill. These subclasses correspond to those of the items produced (see `GetItemInfo()` and `GetAuctionItemSubClasses()`) and can be used to filter the recipe list.

**Signature:** `... = GetTradeSkillSubClasses()`

**Returns:**
- `...` - A list of strings, each the localized name of an item or recipe subclass applicable to the current trade skill listing (`list`)

**See also:** Tradeskill functions.




## GetTradeSkillSubClassFilter

Returns whether the trade skill listing is filtered by a given item subclass

**Signature:** `enabled = GetTradeSkillSubClassFilter(index)`

**Arguments:**
- `index` - Index of an item subclass (in the list returned by `GetTradeSkillSubClasses()`), or `0` for the "All" filter (`number`)

**Returns:**
- `enabled` - 1 if the filter is enabled; otherwise nil (`1nil`)

**See also:** Tradeskill functions.




## GetTradeSkillTools

Returns a list of required tools for a trade skill recipe. A tool may be an item (e.g. Blacksmith Hammer, Virtuoso Inking Set) the player must possess, or a description of a generic (e.g. near an Anvil, in a Moonwell) or specific (e.g. Netherstorm, Emerald Dragonshrine) location to which the player must travel in order to perform the recipe. The `hasTool` return is only valid for the former.

**Signature:** `toolName, hasTool, ... = GetTradeSkillTools(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**Returns:**
- `toolName` - Name of the required tool (`string`)
- `hasTool` - 1 if the tool is an item in the player's possession; otherwise nil (`1nil`)
- `...` - An additional `toolName, hasTool` pair for each tool required (`list`)

**See also:** Tradeskill functions.




## GetTradeTargetItemInfo

Returns information about an item offered for trade by the target

**Signature:** `name, texture, numItems, quality, isUsable, enchantment = GetTradeTargetItemInfo(index)`

**Arguments:**
- `index` - Index of an item slot on the player's side of the trade window (between 1 and `MAX_TRADE_ITEMS`) (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `numItems` - Number of stacked items in the slot (`number`)
- `quality` - Quality (rarity) level of the item (`number`, itemQuality)
- `isUsable` - 1 if the player character can use or equip the item; otherwise nil (`1nil`)
- `enchantment` - Name of the enchantment being applied to the item through trade; otherwise nil (`string`)




## GetTradeTargetItemLink

Returns a hyperlink for an item offered for trade by the target

**Signature:** `link = GetTradeTargetItemLink(index)`

**Arguments:**
- `index` - Index of an item offered for trade by the target (between 1 and `MAX_TRADE_ITEMS`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)




## GetTrainerGreetingText

Returns the current trainer's greeting text. In the default UI, this text is displayed at the top of the trainer window.

May return the empty string or the last used trainer's greeting text if called while not interacting with a trainer.

**Signature:** `text = GetTrainerGreetingText()`

**Returns:**
- `text` - Greeting text for the trainer with whom the player is currently interacting (`string`)




## GetTrainerSelectionIndex

Returns the index of the currently selected trainer service. Selection in the recipe list is used only for display in the default UI and has no effect on other Trade Skill APIs.

**Signature:** `selectionIndex = GetTrainerSelectionIndex()`

**Returns:**
- `selectionIndex` - Index of the selected entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**See also:** Trainer functions.




## GetTrainerServiceAbilityReq

Returns information about an ability required for purchasing a trainer service

**Signature:** `ability, hasReq = GetTrainerServiceAbilityReq(index, abilityIndex)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)
- `abilityIndex` - Index of one of the service's ability requirements (between 1 and `GetTrainerServiceNumAbilityReq(index)`) (`number`)

**Returns:**
- `ability` - Name of the required ability (`string`)
- `hasReq` - 1 if the player has the required ability; otherwise nil (`1nil`)




## GetTrainerServiceCost

Returns the cost to purchase a trainer service

**Signature:** `moneyCost, talentCost, skillCost = GetTrainerServiceCost(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `moneyCost` - Amount of money required to purchase the service (in copper) (`number`)
- `talentCost` - Number of talent points required to purchase the service (generally unused) (`number`)
- `skillCost` - 1 if purchasing the service counts against the player's limit of learnable professions; otherwise 0 (`number`)

**See also:** Trainer functions.




## GetTrainerServiceDescription

Returns the description of a trainer service. Generally returns the same description found in the spell's tooltip for spells purchased from a class trainer; returns nil for trade skills and recipes.

**Signature:** `text = GetTrainerServiceDescription(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `text` - Description of the service (`string`)

**See also:** Trainer functions.




## GetTrainerServiceIcon

Returns the icon for a trainer service

**Signature:** `icon = GetTrainerServiceIcon(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `icon` - Path to an icon texture for the service (`string`)

**See also:** Trainer functions.




## GetTrainerServiceInfo

Returns information about an entry in the trainer service listing

**Signature:** `serviceName, serviceSubText, serviceType, isExpanded = GetTrainerServiceInfo(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `serviceName` - Name of the service (`string`)
- `serviceSubText` - Secondary text associated with the service (often a spell rank; e.g. "(Rank 4)") (`string`)
- `serviceType` - Type of service entry (`string`) 

 - `available` - The player can currently use this service
- `header` - This entry is a group header, not a trainer service
- `unavailable` - The player cannot currently use this service
- `used` - The player has already used this service
- `isExpanded` - 1 if the entry is a header which is currently expanded, or if the header containing the entry is expanded; otherwise nil (`1nil`)

**See also:** Trainer functions.




## GetTrainerServiceItemLink

Returns a hyperlink for the item associated with a trainer service. Currently only returns item links for trainer services which teach trade skill recipes which produce items; does not return spell or recipe links.

**Signature:** `link = GetTrainerServiceItemLink(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `link` - A hyperlink for the item associated with a trainer service (`string`, hyperlink)




## GetTrainerServiceLevelReq

Returns the character level required to purchase a trainer service

**Signature:** `reqLevel = GetTrainerServiceLevelReq(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `reqLevel` - Level required to purchase the service, or nil if the service has no level requirement (`number`)




## GetTrainerServiceNumAbilityReq

Returns the number of ability requirements for purchasing a trainer service. Ability requirements are often used for ranked class spells purchased from the trainer: e.g. learning Blood Strike (Rank 3) requires having learned Blood Strike (Rank 2). See `GetTrainerServiceAbilityReq()` for information about specific ability requirements.

**Signature:** `numRequirements = GetTrainerServiceNumAbilityReq(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `numRequirements` - Number of different ability requirements for the trainer service (`number`)

**See also:** Trainer functions.




## GetTrainerServiceSkillLine

_No snapshot available (page did not exist in archive)._




## GetTrainerServiceSkillReq

Returns information about the skill requirement for a trainer service. Often used for trade skill recipes: e.g. Netherweave Bag requires Tailoring (315).

**Signature:** `skill, rank, hasReq = GetTrainerServiceSkillReq(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**Returns:**
- `skill` - Name of the required skill (`string`)
- `rank` - Rank required in the skill (`number`)
- `hasReq` - 1 if the player has the required skill and rank; otherwise nil (`1nil`)

**See also:** Trainer functions.




## GetTrainerServiceStepIncrease

_No snapshot available (page did not exist in archive)._




## GetTrainerServiceStepReq

**Signature:** `GetTrainerServiceStepReq()`




## GetTrainerServiceTypeFilter

Returns whether the trainer service listing is filtered by a service status

**Signature:** `isEnabled = GetTrainerServiceTypeFilter("type")`

**Arguments:**
- `type` - A trainer service status (`string`) 

 - `available` - Services the player can use
- `unavailable` - Services the player cannot currently use
- `used` - Services the player has already used

**Returns:**
- `isEnabled` - 1 if services matching the filter type are shown in the listing; otherwise nil (`1nil`)

**See also:** Trainer functions.




## GetTrainerSkillLineFilter

_No snapshot available (page did not exist in archive)._




## GetTrainerSkillLines

_No snapshot available (page did not exist in archive)._



