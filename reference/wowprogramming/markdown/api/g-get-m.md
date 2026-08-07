# WoW API — GetM*

_42 functions_

---

## GetMacroBody

Returns the body text of a macro

**Signature:** `body = GetMacroBody(index) or GetMacroBody("name")`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**Returns:**
- `body` - Body text / commands of the macro (`string`)




## GetMacroIconInfo

Returns the texture for a macro icon option

**Signature:** `texture = GetMacroIconInfo(index)`

**Arguments:**
- `index` - Index of a macro icon option (between 1 and `GetNumMacroIcons()`) (`number`)

**Returns:**
- `texture` - Path to the icon texture (`string`)

**See also:** Macro functions.




## GetMacroIndexByName

Returns the index of a macro specified by name

**Signature:** `index = GetMacroIndexByName("name")`

**Arguments:**
- `name` - Name of a macro (`string`)

**Returns:**
- `index` - Index of the named macro, or 0 if no macro by that name exists (`number`, macroID)

**See also:** Macro functions.




## GetMacroInfo

Returns information about a macro

**Signature:** `name, texture, body = GetMacroInfo(index) or GetMacroInfo("name")`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**Returns:**
- `name` - Name of the macro (`string`)
- `texture` - Path to an icon texture for the macro (`string`)
- `body` - Body text / commands of the macro (`string`)

**See also:** Macro functions.




## GetMacroItem

Returns information about the item used by a macro. If a macro contains conditional, random, or sequence commands, this function returns the item which would currently be used if the macro were run.

**Signature:** `name, link = GetMacroItem(index) or GetMacroItem("name")`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**Returns:**
- `name` - Name of the item (`string`)
- `link` - A hyperlink for the item (`string`, hyperlink)

**See also:** Macro functions, Hyperlink functions, Item functions.




## GetMacroItemIconInfo

Returns the texture for an item icon. Despite the "macro" in the title, this function is only used by the default UI for providing tab icon options in the guild bank.

**Signature:** `texture = GetMacroItemIconInfo(index)`

**Arguments:**
- `index` - Index of an item icon option (between 1 and `GetNumMacroItemIcons()`) (`number`)

**Returns:**
- `texture` - Path to the icon texture (`string`)

**See also:** Macro functions, Item functions.




## GetMacroSpell

Returns information about the spell cast by a macro. If a macro contains conditional, random, or sequence commands, this function returns the spell which would currently be cast if the macro were run.

**Signature:** `name, rank = GetMacroSpell(index) or GetMacroSpell("name")`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**Returns:**
- `name` - Name of the spell (`string`)
- `rank` - Secondary text associated with the spell (e.g. "Rank 4", "Racial") (`string`)

**See also:** Macro functions.




## GetManaRegen

Returns information about the player's mana regeneration rate

**Signature:** `base, casting = GetManaRegen()`

**Returns:**
- `base` - Amount of mana regenerated per second while not casting (`number`)
- `casting` - Amount of mana regenerated per second while casting (`number`)




## GetMapContinents

Returns a list of map continents names

**Signature:** `... = GetMapContinents()`

**Returns:**
- `...` - A list of strings, each the localized name of a map continent (`list`)




## GetMapDebugObjectInfo




## GetMapInfo

Returns information about the current world map texture. World map images are broken into several tiles; the full texture paths follow the format `"Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..i`, where `i` is a number between 1 and `NUM_WORLDMAP_DETAIL_TILES` (or in a zone with multiple area images, `"Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName..dungeonLevel.."_"..i`, where `dungeonLevel` is a number between 1 and `GetNumDungeonMapLevels()`).

**Signature:** `mapFileName, textureHeight, textureWidth = GetMapInfo()`

**Returns:**
- `mapFileName` - Unique part of the path to the world map textures (`string`)
- `textureHeight` - Height of the combined map texture tiles (`number`)
- `textureWidth` - Width of the combined map texture tiles (`string`)




## GetMapLandmarkInfo

Returns information about a map landmark. Possible landmarks include PvP objectives (both in battlegrounds and in world PvP areas), town and city markers on continent maps, and special markers such as those used during the Scourge Invasion world event. Some landmarks (such as those for towns on a zone map) exist but are not visible in the default UI.

**Signature:** `name, description, textureIndex, x, y, mapLinkID, showInBattleMap = GetMapLandmarkInfo(index)`

**Arguments:**
- `index` - The index of a map landmark, from 1 to GetNumMapLandmarks() (`number`)

**Returns:**
- `name` - Name of the landmark (`string`)
- `description` - Secondary text associated with the landmark; often used to denote current status of PvP objectives (e.g. "Alliance Controlled") (`string`)
- `textureIndex` - The index of the texture to be used for the landmark. These indices map to segments of the Interface/MinimapPOI/Icons.blp graphic; the function WorldMap_GetPOITextureCoords(), defined in FrameXML/WorldMap.lua, can be used to resolve this index to a set of texture coordinates for displaying that segment. (`number`)
- `x` - Horizontal position of the landmark relative to the current world map (0 = left edge, 1 = right edge) (`number`)
- `y` - Vertical position of the landmark relative to the current world map (0 = top, 1 = bottom) (`number`)
- `mapLinkID` - A hyperlink ID allowing the game engine to take an action when the landmark is clicked (currently unused) (`number`)
- `showInBattleMap` - True if the landmark should be shown in the Battle Map (aka Zone Map) UI; false for landmarks which should only be shown on the World Map (`boolean`)




## GetMapOverlayInfo

Returns information about a world map overlay. Map overlays correspond to areas which are "discovered" when entered by the player, "filling in" the blank areas of the world map.

**Signature:** `textureName, textureWidth, textureHeight, offsetX, offsetY, mapPointX, mapPointY = GetMapOverlayInfo(index)`

**Arguments:**
- `index` - Index of a map overlay (between 1 and `GetNumMapOverlays()`) (`number`)

**Returns:**
- `textureName` - Path to the overlay texture (`string`)
- `textureWidth` - Width of the texture (in pixels) (`number`)
- `textureHeight` - Height of the texture (in pixels) (`number`)
- `offsetX` - Horizontal position of the overlay's top left corner relative to the zone map (0 = left edge, 1 = right edge) (`number`)
- `offsetY` - Vertical position of the overlay's top left corner relative to the zone map (0 = top, 1 = bottom) (`number`)
- `mapPointX` - Unused (`number`)
- `mapPointY` - Unused (`number`)




## GetMapZones

Returns the map zones for a given continent

**Signature:** `... = GetMapZones(continentIndex)`

**Arguments:**
- `continentIndex` - Index of a continent (in the list returned by `GetMapContinents()`) (`number`)

**Returns:**
- `...` - A list of strings, each the localized name of a zone within the continent (`list`)




## GetMasterLootCandidate

Returns information about a given loot candidate. Used in the default UI to build the popup menu used in master loot assignment. Only valid if the player is the master looter.

Not all party/raid members may be eligible for a given corpse's (or object's) loot: e.g. a member is ineligible for loot from a creature killed while that member was not in the immediate area. By repeatedly calling this function (with `index` incrementing from 1 to the total number of party/raid members, including the player), one can build a list of the names of members eligible for the current loot.

The index is cast in stone at the time the mob was killed. If you move raid members around prior to distributing loot, their original positions will be returned by this function. The expression `ceil(index/5)` will yield the group number (in a raid) and the expression `index % 5` will yield the group position number for an eligible raider.

**Signature:** `candidate = GetMasterLootCandidate(index)`

**Arguments:**
- `index` - Index of a member of the party or raid (not equivalent to the numeric part of a `party` or `raid` `unitID`) (`number`)

**Returns:**
- `candidate` - Name of the candidate (`string`)

**See also:** Loot functions.




## GetMaxArenaCurrency

Returns the maximum amount of arena points the player can accrue

**Signature:** `amount = GetMaxArenaCurrency()`

**Returns:**
- `amount` - The maximum amount of arena points the player can accrue (`number`)

**See also:** Arena functions, Currency functions.




## GetMaxCombatRatingBonus

Returns the maximum possible percentage bonus for a given combat rating. 
While this function can be applied to all combat ratings, it is currently only used in the default UI to account for the cap on (incoming) critical strike damage and mana drains provided by Resilience rating -- specifically, in generating the tooltip where Resilience rating is shown in the Character window (PaperDollFrame).

**Signature:** `max = GetMaxCombatRatingBonus(ratingIndex)`

**Arguments:**
- `ratingIndex` - Which rating to query; the following global constants can be used for standard values: (`number`) 

 - `CR_BLOCK` - Block skill
- `CR_CRIT_MELEE` - Melee critical strike chance
- `CR_CRIT_RANGED` - Ranged critical strike chance
- `CR_CRIT_SPELL` - Spell critical strike chance
- `CR_CRIT_TAKEN_MELEE` - Resilience (as applied to melee attacks)
- `CR_CRIT_TAKEN_RANGED` - Resilience (as applied to ranged attacks)
- `CR_CRIT_TAKEN_SPELL` - Resilience (as applied to spell effects
- `CR_DEFENSE_SKILL` - Defense skill
- `CR_DODGE` - Dodge skill
- `CR_HASTE_MELEE` - Melee haste
- `CR_HASTE_RANGED` - Ranged haste
- `CR_HASTE_SPELL` - Spell haste
- `CR_HIT_MELEE` - Melee chance to hit
- `CR_HIT_RANGED` - Ranged chance to hit
- `CR_HIT_SPELL` - Spell chance to hit
- `CR_HIT_TAKEN_MELEE` - Unused
- `CR_HIT_TAKEN_RANGED` - Unused
- `CR_HIT_TAKEN_SPELL` - Unused
- `CR_PARRY` - Parry skill
- `CR_WEAPON_SKILL` - Weapon skill
- `CR_WEAPON_SKILL_MAINHAND` - Main-hand weapon skill
- `CR_WEAPON_SKILL_OFFHAND` - Offhand weapon skill
- `CR_WEAPON_SKILL_RANGED` - Ranged weapon skill

**Returns:**
- `max` - The maximum possible percentage bonus for the given rating (`number`)

**See also:** Stat information functions.




## GetMaxDailyQuests

Returns the maximum number of daily quests that can be completed each day.

**Signature:** `max = GetMaxDailyQuests()`

**Returns:**
- `max` - The maximum number of daily quests that can be completed each day (`number`)

**See also:** Quest functions.




## GetMerchantItemCostInfo

Returns information about alternate currencies required to purchase an item from a vendor

**Signature:** `currencyCount = GetMerchantItemCostInfo(index)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)

**Returns:**
- `currencyCount` - Number of different currencies required to purchase the item (see `GetMerchantItemCostItem()` for amount of each item currency required) (`number`)

**See also:** Merchant functions.




## GetMerchantItemCostItem

Returns information about currency items required to purchase an item from a vendor

**Signature:** `texture, value, link, name = GetMerchantItemCostItem(index, currency)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)
- `currency` - Index of one of the item currencies required to purchase the item (between 1 and `GetMerchantItemCostInfo(index)`) (`number`)

**Returns:**
- `texture` - Path to an icon texture for the currency item (`string`)
- `value` - Amount of the currency required for purchase (`number`)
- `link` - A hyperlink for the currency item (`string`, hyperlink)
- `name` - The localized name of the currency (`string`)

**See also:** Merchant functions.




## GetMerchantItemInfo

Returns information about an item available for purchase from a vendor

**Signature:** `name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)

**Returns:**
- `name` - Name of the item (`string`)
- `texture` - Path to an icon texture for the item (`string`)
- `price` - Current cost to purchase the item from this vendor (in copper) (`number`)
- `quantity` - Number of stacked items per purchase (`number`)
- `numAvailable` - Number of items available for purchase, if the vendor has a limited stock of the item; -1 if the vendor has an unlimited supply of the item (`number`)
- `isUsable` - 1 if the player can use or equip the item; otherwise nil (`1nil`)
- `extendedCost` - 1 if the item's price uses one or more alternate currencies (for which details can be found via `GetMerchantItemCostInfo(index)`); otherwise nil (`1nil`)




## GetMerchantItemLink

Returns a hyperlink for an item available for purchase from a vendor

**Signature:** `link = GetMerchantItemLink(index)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)

**Returns:**
- `link` - A hyperlink for the item (`string`, hyperlink)




## GetMerchantItemMaxStack

Returns the maximum number of an item allowed in a single purchase. Determines the largest value usable for the second argument (`quantity`) of `BuyMerchantItem()` when purchasing the item. For most items, this is the same as the maximum stack size of the item.

**Signature:** `maxStack = GetMerchantItemMaxStack(index)`

**Arguments:**
- `index` - Index of an item in the vendor's listing (between 1 and `GetMerchantNumItems()`) (`number`)

**Returns:**
- `maxStack` - Largest number of items allowed in a single purchase (`number`)

**See also:** Merchant functions.




## GetMerchantNumItems

Returns the number of different items available for purchase from a vendor

**Signature:** `numMerchantItems = GetMerchantNumItems()`

**Returns:**
- `numMerchantItems` - Number of different items available for purchase (`number`)




## getmetatable

Returns an object's metatable

**Signature:** `metatable = getmetatable(object)`

**Arguments:**
- `object` - Any table or userdata object (`value`)

**Returns:**
- `metatable` - Contents of the object's `__metatable` field, or nil if the object has no metatable (`value`)

**See also:** Lua library functions.




## GetMinigameState

**Signature:** `GetMinigameState()`




## GetMinigameType

_No snapshot available (page did not exist in archive)._




## GetMinimapZoneText

Returns the name of the current area (as displayed in the Minimap). Matches `GetSubZoneText()`, `GetRealZoneText()` or `GetZoneText()`.

**Signature:** `zoneText = GetMinimapZoneText()`

**Returns:**
- `zoneText` - Name of the area containing the player's current location (`string`)




## GetMirrorTimerInfo

Returns information about special countdown timers

**Signature:** `timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(index)`

**Arguments:**
- `index` - Index of an available timer (between 1 and `MIRRORTIMER_NUMTIMERS`) (`number`)

**Returns:**
- `timer` - Non-localized token identifying the type of timer (`string`) 

 - `BREATH` - Used for the Breath timer when swimming underwater
- `DEATH` - Currently unused
- `EXHAUSTION` - Used for the Fatigue timer when swimming far from shore
- `FEIGNDEATH` - Used for the Hunter Feign Death ability
- `value` - Number of seconds remaining before the timer expires (`number`)
- `maxvalue` - Maximum value of the timer (`number`)
- `scale` - Rate at which the timer bar should move (e.g. -1 for a slowly "emptying" bar, 10 for a quickly "filling" bar); unused in the default UI (`number`)
- `paused` - 1 if the timer is currently paused; otherwise 0 (`number`)
- `label` - Localized text to be displayed for the timer (`string`)

**See also:** Utility functions.




## GetMirrorTimerProgress

Returns a high-resolution value for a special countdown timer

**Signature:** `progress = GetMirrorTimerProgress("timer")`

**Arguments:**
- `timer` - Non-localized token identifying the type of timer (`string`) 

 - `BREATH` - Used for the Breath timer when swimming underwater
- `DEATH` - Currently unused
- `EXHAUSTION` - Used for the Fatigue timer when swimming far from shore
- `FEIGNDEATH` - Used for the Hunter Feign Death ability

**Returns:**
- `progress` - Number of milliseconds remaining before the timer expires (`number`)

**See also:** Utility functions.




## GetModifiedClick

Returns the keys/buttons bound for a modified click action

**Signature:** `binding = GetModifiedClick("name")`

**Arguments:**
- `name` - Token identifying a modified click action (`string`)

**Returns:**
- `binding` - The set of modifiers (and mouse button, if applicable) registered for the action (`string`, binding)




## GetModifiedClickAction

Returns the token identifying a modified click action

**Signature:** `action = GetModifiedClickAction(index)`

**Arguments:**
- `index` - Index of a modified click action (between 1 and `GetNumModifiedClickActions()`) (`number`)

**Returns:**
- `action` - Token identifying the modified click action, or `nil` if no action is defined at the given `index` (`string`)




## GetMoney

Returns the total amount of money currently in the player's possession

**Signature:** `money = GetMoney()`

**Returns:**
- `money` - Amount of money currently in the player's possession (in copper) (`number`)

**See also:** Money functions.




## GetMouseButtonClicked

Returns which mouse button triggered the current script. If called in a line of execution that started with a click handler (OnMouseDown, OnMouseUp, OnClick, OnDoubleClick, PreClick, or PostClick), returns a string identifying which mouse button triggered the handler. Otherwise, returns nil.

**Signature:** `button = GetMouseButtonClicked()`

**Returns:**
- `button` - Name of the mouse button that triggered the current script (`string`)

**See also:** Utility functions.




## GetMouseButtonName

Returns the name for a mouse button specified by number

**Signature:** `buttonName = GetMouseButtonName(buttonNumber)`

**Arguments:**
- `buttonNumber` - A mouse button number (1-5) (`number`)

**Returns:**
- `buttonName` - The name of the given mouse button (`string`) 

 - `Button4`
- `Button5`
- `LeftButton`
- `MiddleButton`
- `RightButton`

**See also:** Utility functions.




## GetMouseFocus

Returns the frame that is currently under the mouse, and has mouse input enabled.

**Signature:** `frame = GetMouseFocus()`

**Returns:**
- `frame` - The frame that currently has the mouse focus (`table`)




## GetMovieResolution

Returns the horizontal resolution available for displaying movie content

**Signature:** `resolution = GetMovieResolution()`

**Returns:**
- `resolution` - Horizontal resolution (in pixels) available for displaying movie content (`number`)

**See also:** In-game movie playback functions.




## GetMultiCastBarOffset




## GetMultiCastTotemSpells




## GetMultisampleFormats

Returns a list of available multisample settings. Used in the default UI to provide descriptions of multisample settings (e.g. "24-bit color 24-bit depth 6x multisample").

Indices used by `GetCurrentMultisampleFormat()` and `SetMultisampleFormat()` refer to the groups of `color`, `depth` and `multisample` values returned by this function; e.g. index 1 refers to values 1 through 3, index 2 to values 4 through 6, etc.

**Signature:** `color, depth, multisample, ... = GetMultisampleFormats()`

**Returns:**
- `color` - Color depth (in bits) (`number`)
- `depth` - Video depth (in bits) (`number`)
- `multisample` - Number of samples per pixel (`number`)
- `...` - Additional sets of `color`, `depth` and `multisample` values, one for each multisample setting (`list`)




## GetMuteName

Returns the name of a character on the mute list

**Signature:** `name = GetMuteName(index)`

**Arguments:**
- `index` - Index of an entry in the mute listing (between 1 and `GetNumMutes()`) (`number`)

**Returns:**
- `name` - Name of the muted character (`string`)

**See also:** Voice functions, Utility functions.




## GetMuteStatus

Returns whether a character is muted or silenced. If the `channel` argument is specified, this function checks the given character's voice/silence status on the channel as well as for whether the character is on the player's Muted list.

**Signature:** `muteStatus = GetMuteStatus("unit" [, "channel"]) or GetMuteStatus("name" [, "channel"])`

**Arguments:**
- `unit` - A unit to query (`string`, unitID)
- `name` - Name of a character to query (`string`)
- `channel` - Name of a voice channel (`string`)

**Returns:**
- `muteStatus` - 1 if the character is muted; otherwise nil (`1nil`)



