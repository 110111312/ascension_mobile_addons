# WoW API — S (E*)

_155 functions_

---

## SearchLFGGetEncounterResults



## SearchLFGGetJoinedID



## SearchLFGGetNumResults



## SearchLFGGetPartyResults



## SearchLFGGetResults



## SearchLFGJoin



## SearchLFGLeave



## SearchLFGSort



## SecondsToTime

Returns a description of an amount of time in appropriate units. Output includes markup normally hidden when displayed in a FontString (see last example); this markup allows the client to automatically print the singular or plural form of a word depending on the value of the preceding number.

**Signature:** `time = SecondsToTime(seconds [, noSeconds [, notAbbreviated [, maxCount]]])`

**Arguments:**
- `seconds` - An amount of time (in seconds) (`number`)
- `noSeconds` - True to omit a seconds term in the description; false or omitted otherwise (`boolean`)
- `notAbbreviated` - True to use full unit names in the description (e.g. Hours, Minutes); false or omitted to use abbreviations (e.g. Hr, Min) (`boolean`)
- `maxCount` - Maximum number of terms to include in the description; defaults to 2 if omitted (`number`)

**Returns:**
- `time` - A description of the amount of time in appropriate units (see examples) (`string`)



## securecall

Calls a function without tainting the execution path. Meaningless when called from outside of the secure environment.

Used in Blizzard code to call functions which may be tainted or operate on potentially tainted variables. For example, consider the function `CloseSpecialWindows`, which iterates through the table `UISpecialFrames` and hides any frames named therein. Addon authors may put the names of their frames in that table to make them automatically close when the user presses the ESC key, but this taints `UISpecialFrames`. Were the default UI to then call `CloseSpecialWindows` normally, every frame in `UISpecialFrames` would become tainted, which could later lead to errors when handlers on those frames call protected functions.

Instead, the default UI uses `securecall(CloseSpecialWindows)`: within `CloseSpecialWindows` the execution path may become tainted, but afterward the environment remains secure.

**Signature:** `... = securecall(function, ...)`

**Arguments:**
- `function` - Function to be called (`function`)
- `...` - Arguments to the function (`list`)

**Returns:**
- `...` - Values returned after calling the function (`list`)

**See also:** Secure execution utility functions.



## SecureCmdOptionParse

Returns the action (and target, if applicable) for a secure macro command. Used in the default UI to parse macro conditionals.

**Signature:** `action, target = SecureCmdOptionParse("cmd")`

**Arguments:**
- `cmd` - A command to be parsed (typically the body of a macro, macrotext attribute or slash command (`string`)

**Returns:**
- `action` - Argument to the base macro command (e.g. the name of a spell for `/cast`), or the empty string (`""`) if the base command takes no arguments (e.g. `/stopattack`); nil if the command should not be executed (`string`)
- `target` - Unit or name to use as the target of the action (`string`)

**See also:** Macro functions.



## select

Returns one or more values from a list (`...`), or the number of values in a list

**Signature:** `... = select(index, ...) or select("#", ...)`

**Arguments:**
- `index` - Index of a value in the list (`number`)
- `#` - The string `"#"` (`string`)
- `...` - A list of values (`list`)

**Returns:**
- `...` - If called with a first argument of `"#"`, the number of values in the list; otherwise, all values in the list starting with the value at position `index` (`list`)



## SelectActiveQuest

Selects a quest which can be turned in to the current Quest NPC. Usable after a `QUEST_GREETING` event. Causes the `QUEST_PROGRESS` event to fire, in which it is determined whether the player can complete the quest.

Note: Most quest NPCs present active quests using the `GetGossipActiveQuests()` instead of this function.

**Signature:** `SelectActiveQuest(index)`

**Arguments:**
- `index` - Index of a quest which can be turned in to the current Quest NPC (between 1 and `GetNumActiveQuests()`) (`number`)



## SelectAvailableQuest

Chooses a quest available from the current Quest NPC. Causes the `QUEST_DETAIL` event to fire, in which the questgiver presents the player with the details of a quest and the option to accept or decline.

Note: Most quest NPCs present available quests using the `GetGossipAvailableQuests()` instead of this function.

**Signature:** `SelectAvailableQuest(index)`

**Arguments:**
- `index` - Index of a quest available from the current Quest NPC (between 1 and `GetNumAvailableQuests()`) (`number`)



## SelectGossipActiveQuest

Chooses a quest which can be turned in to the current Gossip NPC. Causes the `QUEST_PROGRESS` event to fire, in which it is determined whether the player can complete the quest.

**Signature:** `SelectGossipActiveQuest(index)`

**Arguments:**
- `index` - Index of a quest which can be turned in to the current Gossip NPC (between 1 and `GetNumGossipActiveQuests()`) (`number`)

**See also:** NPC "Gossip" Dialog functions, Quest functions.



## SelectGossipAvailableQuest

Chooses a quest available from the current Gossip NPC. Usable after a `QUEST_GREETING` event. Causes the `QUEST_DETAIL` event to fire, in which the questgiver presents the player with the details of a quest and the option to accept or decline.

**Signature:** `SelectGossipAvailableQuest(index)`

**Arguments:**
- `index` - Index of a quest available from the current Gossip NPC (between 1 and `GetNumGossipAvailableQuests()`) (`number`)



## SelectGossipOption

Chooses and activates an NPC dialog option. Results may vary according to the gossip option chosen; may end the gossip (firing a `GOSSIP_CLOSED` event) and start another interaction (firing a `MERCHANT_SHOW`, `TRAINER_SHOW`, `TAXIMAP_OPENED`, or similar event) or may continue the gossip with new text and new options (firing another `GOSSIP_SHOW` event).

Calling this function with only the first argument may cause the `GOSSIP_CONFIRM` event to fire, indicating that the player needs to provide confirmation (or additional information) before the option will be activated. Confirmation is needed for certain options requiring the character to spend (e.g. when activating Dual Talent Specialization); additional information is needed for options such as those used when redeeming a Loot Card code from the WoW trading card game to receive an in-game item. In either case, the confirmation and additional information can be provided (as by the popup dialog in the default UI) by calling this function again with all three arguments.

**Signature:** `SelectGossipOption(index [, "text" [, confirm]])`

**Arguments:**
- `index` - The option in the NPC gossip window to select, from 1 to GetNumGossipOptions() (`number`)
- `text` - Text to include when confirming the selection (`string`)
- `confirm` - true to confirm the selection; false or omitted otherwise (`boolean`)

**See also:** NPC "Gossip" Dialog functions.



## SelectPackage



## SelectQuestLogEntry

Selects a quest from the quest log. The selected quest is used by other functions which do not take a quest index as argument (e.g. `GetQuestLogQuestText()`).

**Signature:** `SelectQuestLogEntry(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

**See also:** Quest functions.



## SelectStationery

Selects a given stationery for usage when sending mail. Has no effect; the stationery feature for sending mail is not implemented in the current version of World of Warcraft.

**Signature:** `SelectStationery(index)`

**Arguments:**
- `index` - Index of a stationery type (between 1 and `GetNumStationeries()`) (`number`)

**See also:** Mail functions.



## SelectTradeSkill

Selects a recipe in the trade skill listing. Selection in the recipe list is used only for display in the default UI and has no effect on other Trade Skill APIs.

**Signature:** `SelectTradeSkill(index)`

**Arguments:**
- `index` - Index of a recipe in the trade skill list (between 1 and `GetNumTradeSkills()`) (`number`)

**See also:** Tradeskill functions.



## SelectTrainerService

Selects an entry in the trainer service listing. Selection in the service list is used only for display in the default UI and has no effect on other Trainer APIs.

**Signature:** `SelectTrainerService(index)`

**Arguments:**
- `index` - Index of an entry in the trainer service listing (between 1 and `GetNumTrainerServices()`) (`number`)

**See also:** Trainer functions.



## SendAddonMessage

Sends a chat-like message receivable by other addons. Allows for client-to-client addon communication.

Unlike with `SendChatMessage`, messages sent via `SendAddonMessage`:

 
 - do not appear in receiving players' chat windows (unless an addon explicitly prints them)
 
 - are not subject to strict server-side spam filtering/throttling (sending too many messages at once can still disconnect the user)
 
 - are not modified if the sending character is drunk

Messages are received via the `CHAT_MSG_ADDON` event.

**Signature:** `SendAddonMessage("prefix", "message" [, "type" [, "target"]])`

**Arguments:**
- `prefix` - An arbitrary label for the message. Allows receiving addons to filter incoming messages: for example, if an addon uses the same prefix for all messages it sends, an addon interested in only those messages can check for that prefix before handling the message content. Cannot contain the tab character (`\t`). (`string`)
- `message` - A message to send; combined length of `prefix` and `message` is limited to 254 characters (`string`)
- `type` - Scope in which to broadcast the message: (`string`) 

 - `BATTLEGROUND` - To all allied players in the current battleground instance
- `GUILD` - To all members of the player's guild
- `PARTY` - To all members of the player's party (used by default if no type is given)
- `RAID` - To all members of the player's raid group (automatically reverts to sending to party if the player is not in a raid group)
- `WHISPER` - To a specific player
- `target` - If type is `"WHISPER"`, the name of the target player (in cross-realm battlegrounds, the format "Name-Realm" can be used to target a player from another realm; e.g. "Thott-Cenarius") (`string`)



## SendChatMessage

Sends a chat message

**Signature:** `SendChatMessage("text" [, "chatType" [, "language" [, "channel"]]])`

**Arguments:**
- `text` - Message to be sent (up to 255 characters) (`string`)
- `chatType` - Channel on which to send the message (defaults to `SAY` if omitted) (`string`) 

 - `BATTLEGROUND` - Messages to a battleground raid group (sent with `/bg` in the default UI)
- `CHANNEL` - Message to a server or custom chat channel (sent with `/1`, `/2`, etc in the default UI); requires channel number for `channel` argument
- `DND` - Enables Away-From-Keyboard status for the player, with `text` as the custom message seen by others attempting to whisper the player
- `EMOTE` - Custom text emotes visible to nearby players (sent with `/e` in the default UI)
- `GUILD` - Messages to guild members (sent with `/g` in the default UI)
- `OFFICER` - Messages to guild officers (sent with `/o` in the default UI)
- `PARTY` - Messages to party members (sent with `/p` in the default UI)
- `RAID` - Messages to raid members (sent with `/ra` in the default UI)
- `RAID_WARNING` - Warning to raid members (sent with `/rw` in the default UI)
- `SAY` - Speech to nearby players (sent with `/s` in the default UI)
- `WHISPER` - Message to a specific character (sent with `/w` in the default UI); requires name of the character for `channel` argument
- `YELL` - Yell to not-so-nearby players (sent with `/y` in the default UI)
- `language` - Language in which to send the message; defaults to Common (for Alliance players) or Orcish (for Horde players) if omitted (`string`) 

 - `COMMON` - Alliance and Human language
- `DARNASSIAN` - Night Elf Language
- `DRAENEI` - Draenei Language
- `DWARVEN` - Dwarf Language
- `GNOMISH` - Gnome language
- `GUTTERSPEAK` - Undead language
- `ORCISH` - Horde and Orc Language
- `TAURAHE` - Tauren Language
- `THALASSIAN` - Night Elf Language
- `TROLL` - Troll language
- `channel` - If `chatType` is `WHISPER`, name of the target character; if `chatType` is `CHANNEL`, number identifying the target channel; ignored otherwise (`string`)

**See also:** Chat functions.



## SendMail

Sends the outgoing message. Any money or COD costs and attachments specified for the mail (via `SetSendMailMoney()`, `SetSendMailCOD()`, and `ClickSendMailItemButton()`) are included with the mail (and the values for such are reset for the next outgoing mail).

**Signature:** `SendMail("recipient", "subject", "body")`

**Arguments:**
- `recipient` - Name of the character to receive the mail (`string`)
- `subject` - Subject text of the mail (`string`)
- `body` - Body text of the mail (`string`)

**See also:** Mail functions.



## SendSystemMessage



## SendWho

Requests a list of characters meeting given search criteria from the server. Text in the query will match against any of the six searchable fields unless one of the specifiers below is used; multiple specifiers can be used in one query. Queries are case insensitive.

 
 - `n-"name"` - Search for characters whose name contains `name`
 
 - `c-"class"` - Search for characters whose class name contains `class`
 
 - `g-"guild"` - Search for characters in guilds whose name contains `guild`
 
 - `r-"race"` - Search for characters whose race name contains `race`
 
 - `z-"zone"` - Search for characters in zones whose name contains `zone`
 
 - `X` - Search for characters of level `X`
 
 - `X-` - Search for characters of level `X` or higher
 
 - `-X` - Search for characters of level `X` or lower
 
 - `X-Y` - Search for characters between levels `X` and `Y` (inclusive)

Results are not available immediately; the `CHAT_MSG_SYSTEM` or `WHO_LIST_UPDATE` event fires when data is available, as determined by the `SetWhoToUI()` function.

**Signature:** `SendWho("filter")`

**Arguments:**
- `filter` - A Who system search query (cannot be nil; use the empty string `""` to specify a blank query) (`string`)

**See also:** Social functions.



## SetAbandonQuest

Begins the process of abandoning a quest in the player's quest log. To finish abandoning the quest, call `AbandonQuest()`.

This function must be called to select a quest in order for `GetAbandonQuestItems()` or `GetAbandonQuestName()` to return valid data.

**Signature:** `SetAbandonQuest(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)



## SetAchievementComparisonUnit

Enables comparing achievements/statistics with another player. 
After a call to this function, the `INSPECTACHIEVEMENTREADY `event fires to indicate that achievement/statistic comparison functions will return valid data on the given unit.

**Signature:** `success = SetAchievementComparisonUnit(unit)`

**Arguments:**
- `unit` - ID of a unit to compare against (`unitID`)

**Returns:**
- `success` - 1 if the given unit is a valid unit. (Does not indicate whether the unit exists or can be compared against.) (`1nil`)

**See also:** Achievement functions.



## SetActionBarToggles

Configures display of additional ActionBars in the default UI

**Signature:** `SetActionBarToggles(bar1, bar2, bar3, bar4, alwaysShow)`

**Arguments:**
- `bar1` - 1 to show the bottom left ActionBar; otherwise nil (`1nil`)
- `bar2` - 1 to show the bottom right ActionBar; otherwise nil (`1nil`)
- `bar3` - 1 to show the right-side ActionBar; otherwise nil (`1nil`)
- `bar4` - 1 to show the second right-side ActionBar; otherwise nil (`1nil`)
- `alwaysShow` - 1 to always show ActionBar backgrounds even for empty slots; otherwise nil (`1nil`)



## SetActiveTalentGroup

Switches the player's active talent specialization. 
Calling this function with the index of an inactive talent group does not immediately perform the switch: it begins casting a spell ("Activate Primary/Secondary Spec"), and only once the spellcast is complete are the player's talents changed.

Calling this function with the index of the active talent group, or with any argument if the player has not purchased Dual Talent Specialization does nothing.

**Signature:** `SetActiveTalentGroup(talentGroup)`

**Arguments:**
- `talentGroup` - Index of the talent specialization to enable (`number`)

**See also:** Talent functions.



## SetActiveVoiceChannel

Sets the currently active voice channel

**Signature:** `SetActiveVoiceChannel(index)`

**Arguments:**
- `index` - Index of a channel in the chat display window (between 1 and `GetNumDisplayChannels()`) (`number`)

**See also:** Voice functions, Channel functions.



## SetActiveVoiceChannelBySessionID

Sets the currently active voice chat channel

**Signature:** `SetActiveVoiceChannelBySessionID(session)`

**Arguments:**
- `session` - Index of a voice session (between 1 and `GetNumVoiceSessions()`) (`number`)



## SetAllowLowLevelRaid

Enabling this if your character is below level 10 will allow you to join a raid group.

**Signature:** `SetAllowLowLevelRaid(enable)`

**Arguments:**
- `enable` - 1 to enable low level raids for this character, nil otherwise. (`boolean`)

**See also:** Raid functions.



## SetArenaTeamRosterSelection

Selects a member in an arena team roster. Selection in the arena team roster currently has no effect beyond highlighting list entry in the default UI.

**Signature:** `SetArenaTeamRosterSelection(team, index)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)
- `index` - Index of a team member to select (between 1 and `GetNumArenaTeamMembers(team)`) (`number`)

**See also:** Arena functions.



## SetArenaTeamRosterShowOffline

Enables or disables the inclusion of offline members in arena team roster listings. The "Show Offline" filter is not used in the default UI; if disabled, offline members are still shown.

**Signature:** `SetArenaTeamRosterShowOffline(enable)`

**Arguments:**
- `enable` - True to enable display of offline members; false to disable (`boolean`)

**See also:** Arena functions.



## SetAuctionsTabShowing



## SetBagPortraitTexture

Sets a Texture object to display the icon of one of the player's bags. Adapts the square item icon texture to fit within the circular "portrait" frames used in many default UI elements.

**Signature:** `SetBagPortraitTexture(texture, container)`

**Arguments:**
- `texture` - A Texture object (`table`)
- `container` - Index of one of the player's bags or other containers (`number`, containerID)

**See also:** Container functions.



## SetBaseMip

_No snapshot available (page did not exist in archive)._



## SetBattlefieldScoreFaction

Filters the battleground scoreboard by faction/team

**Signature:** `SetBattlefieldScoreFaction(faction)`

**Arguments:**
- `faction` - Faction for which to show battleground participant scores (`number`) 

 - `0` - Horde
- `1` - Alliance
- `nil` - All

**See also:** Battlefield functions.



## SetBinding

Binds a key combination to a binding command

**Signature:** `success = SetBinding("key" [, "command"])`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `command` - Name of a key binding command, or nil to unbind the key (`string`)

**Returns:**
- `success` - 1 if the key binding (or unbinding) was successful; otherwise nil (`1nil`)

**See also:** Keybind functions.



## SetBindingClick

Binds a key combination to "click" a Button object. When the binding is used, all of the relevant mouse handlers on the button (save for `OnEnter` and `OnLeave`) fire just as if the button were activated by the mouse (including `OnMouseDown` and `OnMouseUp` as the key is pressed and released).

**Signature:** `success = SetBindingClick("key", "buttonName" [, "mouseButton"])`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `buttonName` - Name of a Button object on which the binding simulates a click (`string`)
- `mouseButton` - Name of the mouse button with which the binding simulates a click (`string`)

**Returns:**
- `success` - 1 if the key binding was successful; otherwise nil (`1nil`)

**See also:** Keybind functions.



## SetBindingItem

Binds a key combination to use an item in the player's possession

**Signature:** `success = SetBindingItem("key", itemID) or SetBindingItem("key", "itemName") or SetBindingItem("key", "itemLink")`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**Returns:**
- `success` - 1 if the binding was successful; otherwise nil (`1nil`)



## SetBindingMacro

Binds a key combination to run a macro

**Signature:** `success = SetBindingMacro("key", index) or SetBindingMacro("key", "name")`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**Returns:**
- `success` - 1 if the key binding was successful; otherwise nil (`1nil`)



## SetBindingSpell

Binds a key combination to cast a spell

**Signature:** `success = SetBindingSpell("key", "spellname")`

**Arguments:**
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `spellname` - Name of a spell to bind (`string`)

**Returns:**
- `success` - 1 if the key binding was successful; otherwise nil (`1nil`)

**See also:** Keybind functions.



## SetChannelOwner

Gives channel ownership to another character. Has no effect unless the player is the owner of the given channel.

**Signature:** `SetChannelOwner("channel", "fullname")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `fullname` - Name of the character to make the new owner (`string`)

**See also:** Channel functions.



## SetChannelPassword

Sets a password on a custom chat channel

**Signature:** `SetChannelPassword("channel", "password")`

**Arguments:**
- `channel` - Name of the channel (`string`)
- `password` - Password to set for the channel (`string`)



## SetChannelWatch

**Signature:** `SetChannelWatch()`



## SetChatColorNameByClass

Sets whether the player names should be colored by class for a given chat type

**Signature:** `SetChatColorNameByClass("chatType", colorByName)`

**Arguments:**
- `chatType` - The chatType that is being set. This value of this is the same as the index of the global `ChatTypeInfo` table. (`string`)
- `colorByName` - Whether or not names should be colored by class for the given chat type. (`boolean`)

**See also:** Chat functions.



## SetChatWindowAlpha

Saves a chat window's background opacity setting. Used by the default UI's function `FCF_SetWindowAlpha()` which changes the opacity of a displayed FloatingChatFrame.

**Signature:** `SetChatWindowAlpha(index, alpha)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `alpha` - Alpha value (opacity) of the chat window background (0 = fully transparent, 1 = fully opaque) (`number`)

**See also:** Chat functions.



## SetChatWindowColor

Saves a chat window's background color setting. Used by the default UI's function `FCF_SetWindowColor()` which changes the colors of a displayed FloatingChatFrame.

**Signature:** `SetChatWindowColor(index, r, g, b)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `r` - Red component of the background color (0.0 - 1.0) (`number`)
- `g` - Green component of the background color (0.0 - 1.0) (`number`)
- `b` - Blue component of the background color (0.0 - 1.0) (`number`)

**See also:** Chat functions.



## SetChatWindowDocked

Saves whether a chat window should be docked with the main chat window. Used by the default UI's functions `FCF_DockFrame()` and `FCF_UnDockFrame()` which manage the positioning of FloatingChatFrames.

**Signature:** `SetChatWindowDocked(index, docked)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `docked` - True if the window should be docked with the main chat window; otherwise false (`boolean`)

**See also:** Chat functions.



## SetChatWindowLocked

Saves whether a chat window is locked. Used by the default UI's functions `FCF_OpenNewWindow()` and `FCF_SetLocked()` which manage the behavior of a FloatingChatFrame.

**Signature:** `SetChatWindowLocked(index, locked)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `locked` - True if the frame should be locked; otherwise false (`boolean`)

**See also:** Chat functions.



## SetChatWindowName

Saves a chat window's display name setting. Used by the default UI's function `FCF_SetWindowName()` which also handles setting the name displayed for a FloatingChatFrame.

**Signature:** `SetChatWindowName(index, "name")`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `name` - Name to be displayed for the chat window (`string`)



## SetChatWindowSavedDimensions



## SetChatWindowSavedPosition



## SetChatWindowShown

Saves whether a chat window should be shown. Used by the default UI's function `FCF_OpenNewWindow()` which initializes a displayed FloatingChatFrame.

**Signature:** `SetChatWindowShown(index, shown)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `shown` - True if the window should be shown, false otherwise (`boolean`)

**See also:** Chat functions.



## SetChatWindowSize

Saves a chat window's font size setting. Used by the default UI's function `FCF_SetChatWindowFontSize()` which also handles changing the font displayed in a FloatingChatFrame.

**Signature:** `SetChatWindowSize(index, size)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `size` - Font size for the chat window (in points) (`number`)



## SetChatWindowUninteractable

Saves whether a chat window is marked as non-interactive. Used by the default UI's function `FCF_SetUninteractable()` which also handles enabling/disabling mouse events in the FloatingChatFrame.

**Signature:** `SetChatWindowUninteractable(index, setUninteractable)`

**Arguments:**
- `index` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) (`number`)
- `setUninteractable` - True flag the window as non-interactive; false otherwise (`boolean`)

**See also:** Chat functions.



## SetConsoleKey

**Signature:** `SetConsoleKey()`



## SetCurrencyBackpack

Sets a currency type to be watched on the Backpack UI

**Signature:** `SetCurrencyBackpack(index, watch)`

**Arguments:**
- `index` - Index of a currency type or header in the currency list (between 1 and GetCurrencyListSize()) (`number`)
- `watch` - 1 to add this currency to the backpack UI; 0 to remove it from being watched (`number`)



## SetCurrencyUnused

Moves a currency type to or from the Unused currencies list. 
"Unused" currencies behave no differently; the distinction only exists to allow players to hide currencies they don't care about from the main display.

**Signature:** `SetCurrencyUnused(index, makeUnused)`

**Arguments:**
- `index` - Index of a currency type or header in the currency list (between 1 and GetCurrencyListSize()) (`number`)
- `makeUnused` - 1 to move this currency to the Unused category; 0 to return it to its original category (`number`)

**See also:** Currency functions.



## SetCurrentGuildBankTab

Selects a tab in the guild bank

**Signature:** `SetCurrentGuildBankTab(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**See also:** Guild bank functions.



## SetCurrentTitle

Changes a player's displayed title

**Signature:** `SetCurrentTitle(titleIndex)`

**Arguments:**
- `titleIndex` - Index of a title available to the player (between 1 and `GetNumTitles()`), or -1 to show no title (`integer`)

**See also:** Player information functions.



## SetCursor

Changes the mouse cursor image. Changes only the appearance of the mouse cursor, not its behavior (and has no effect if the cursor is holding an item, spell, or other data). Passing `nil` will revert the cursor to its default image. 

Normally used in a frame's `OnEnter` handler to change the cursor used while the mouse is over the frame. If used elsewhere, the cursor will likely be immediately reverted to default (due to the mouse handlers of other frames doing the same).

**Signature:** `SetCursor("cursor")`

**Arguments:**
- `cursor` - Path to a texture to use as the cursor image (must be 32x32 pixels) or one of the built-in cursor tokens. Valid cursor tokens can be found in the example code. (`string`)

**See also:** Cursor functions.



## SetCVar

Sets the value of a configuration variable

**Signature:** `SetCVar("cvar", value [, "raiseEvent"])`

**Arguments:**
- `cvar` - Name of the CVar to set (`string`)
- `value` - New value for the CVar (`any`)
- `raiseEvent` - If true, causes the `CVAR_UPDATE` event to fire (`string`)

**See also:** CVar functions.



## SetDungeonDifficulty

Sets the player's 5 player dungeon difficulty preference. 
Setting dungeon difficulty has no effect on the instance created when entering a portal if the player is not the party/raid leader. Changing difficulty while in an instance also has no effect.

Epic difficulty is currently unused; setting dungeon difficulty to 3 will cause instance portal graphics to disappear and may result in errors upon entering an instance portal.

**Signature:** `SetDungeonDifficulty(difficulty)`

**Arguments:**
- `difficulty` - A difficulty level (`number`) 

 - `1` - 5 Player (Normal)
- `2` - 5 Player (Heroic)



## SetDungeonMapLevel

Sets the world map to display a certain map image (for zones that use multiple map images). Used in zones with more than one "floor" or area such as Dalaran and several Wrath of the Lich King dungeons and raids.

**Signature:** `SetDungeonMapLevel(level)`

**Arguments:**
- `level` - Index of the map image to show in the world map (`number`)



## seterrorhandler

Changes the error handler to a specified function. The error handler is called by Lua's `error()` function, which in turn is called whenever a Lua error occurs. WoW's default error handler displays the error message, a stack trace and information about the local variables for the function. This dialog will only be shown if the "Show Lua errors" option is enabled in Interface Options.

**Signature:** `seterrorhandler(errHandler)`

**Arguments:**
- `errHandler` - A function to use as the error handler (`function`)

**See also:** Debugging and Profiling functions.



## SetEuropeanNumbers

Sets the decimal separator for displayed numbers. Affects the style not only of numbers displayed in the UI, but any string coercion of numbers with `tostring()` as well.

**Signature:** `SetEuropeanNumbers(enable)`

**Arguments:**
- `enable` - True to use comma (",") as the decimal separator; false to use period (".") as the decimal separator (`boolean`)

**See also:** Client control and information functions.



## SetFactionActive

Removes the "inactive" status from a faction. "Inactive" factions behave no differently; the distinction only exists to allow players to hide factions they don't care about from the main display. Factions thus marked are automatically moved to an "Inactive" group at the end of the faction list.

**Signature:** `SetFactionActive(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**See also:** Faction functions.



## SetFactionInactive

Flags a faction as inactive. "Inactive" factions behave no differently; the distinction only exists to allow players to hide factions they don't care about from the main display. Factions thus marked are automatically moved to an "Inactive" group at the end of the faction list.

**Signature:** `SetFactionInactive(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)

**See also:** Faction functions.



## SetFarclip

_No snapshot available (page did not exist in archive)._



## setfenv

Sets the environment to be used by a function. If the environment has a `__environment` metatable, this function will error.

**Signature:** `f = setfenv([f,] t) or setfenv([stackLevel,] t)`

**Arguments:**
- `f` - A function (`function`)
- `stackLevel` - Level of a function in the calling stack, or 0 to set the global environment (`number`)
- `t` - A table (`table`)

**Returns:**
- `f` - The input function `f` (`function`)

**See also:** Lua library functions.



## SetFriendNotes

Sets note text associated with a friends list entry. Setting a note to `nil` will result in an error; to remove a note, set it to the empty string (`""`).

**Signature:** `SetFriendNotes(index, "note") or SetFriendNotes("name", "note")`

**Arguments:**
- `index` - Index of a friends list entry (between 1 and `GetNumFriends()`) (`number`)
- `name` - Name of friend to modify (`string`)
- `note` - The note to set (`string`)

**See also:** Social functions.



## SetGamma

Changes the display gamma setting. Gamma value determines the contrast between lighter and darker portions of the game display; for a detailed explanation see the Wikipedia article on Gamma corection.

**Signature:** `SetGamma(value)`

**Arguments:**
- `value` - New gamma value (`number`)



## setglobal

Sets a global variable to a specified value. Allows setting the value of a global variable in contexts where its name might be overridden by that of a local variable; i.e. `setglobal(name, value)` is equivalent to `_G.name = value` or `_G["name"] = value`.

**Signature:** `setglobal("name", value)`

**Arguments:**
- `name` - Name of a global variable (`string`)
- `value` - New value for the variable (`value`)

**See also:** Utility functions.



## SetGuildBankTabInfo

Sets the name and icon for a guild bank tab

**Signature:** `SetGuildBankTabInfo(tab, "name", iconIndex)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `name` - New name for the tab (`string`)
- `iconIndex` - Index of an icon for the tab (between 1 and `GetNumMacroItemIcons()`) (`number`)

**See also:** Guild bank functions.



## SetGuildBankTabPermissions

Changes guild bank tab permissions for the guild rank being edited

**Signature:** `SetGuildBankTabPermissions(tab, permission, enabled)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `permission` - Index of a permission to edit (`number`) 

 - `1` - View tab
- `2` - Deposit items
- `enabled` - True to allow permission for the action to the guild rank; false to deny (`boolean`)



## SetGuildBankTabWithdraw

_No snapshot available (page did not exist in archive)._



## SetGuildBankText

Sets the info text for a guild bank tab

**Signature:** `SetGuildBankText(tab, "text")`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `text` - New info text for the tab (`string`)

**See also:** Guild bank functions.



## SetGuildBankWithdrawLimit

_No snapshot available (page did not exist in archive)._



## SetGuildInfoText

Sets the guild information text.. This text appears when clicking the "Guild Information" button in the default UI's Guild window.

**Signature:** `SetGuildInfoText("text")`

**Arguments:**
- `text` - New guild information text (`string`)

**See also:** Guild functions.



## SetGuildRosterSelection

Selects a member in the guild roster. Selection in the guild roster is used only for display in the default UI and has no effect on other Guild APIs.

**Signature:** `SetGuildRosterSelection(index)`

**Arguments:**
- `index` - Index of a member in the guild roster (between 1 and `GetNumGuildMembers()`), or 0 for no selection (`number`)



## SetGuildRosterShowOffline

Enables or disables inclusion of offline members in the guild roster listing

**Signature:** `SetGuildRosterShowOffline(showOffline)`

**Arguments:**
- `showOffline` - True to include offline members in the guild roster listing; false to list only those members currently online (`boolean`)



## SetInventoryPortraitTexture

Sets a Texture object to display the icon of an equipped item. Adapts the square item icon texture to fit within the circular "portrait" frames used in many default UI elements.

**Signature:** `SetInventoryPortraitTexture(texture, "unit", slot)`

**Arguments:**
- `texture` - A Texture object (`table`)
- `unit` - A unit whose item should be displayed; only valid for `player` (`string`, unitID)
- `slot` - An inventory slot number, as can be obtained from `GetInventorySlotInfo` (`number`, inventoryID)

**See also:** Inventory functions.



## SetLayoutMode



## SetLFGBootVote



## SetLFGComment

Associates a brief text comment with the player's listing in the LFG system. In the default UI, other players see this comment when mousing over the player's name in the Looking for More listing.

**Signature:** `SetLFGComment("comment")`

**Arguments:**
- `comment` - A comment to be associated with the player's listing in the LFG system (max 63 characters); or the empty string (`""`) to clear an existing comment (`string`)



## SetLFGDungeon

Sets a flag indicating that the player would like to join a given dungeon/queue. This function simply indicates that the player would like to join a given dungeon or queue. Joining the queue is accomplished using the `JoinLFG()` function. Clearing the dungeons that have been flagged is accomplished using the `ClearAllLFGDungeons` function.

**Signature:** `SetLFGDungeon(queueIndex)`

**Arguments:**
- `queueIndex` - A numeric identifier for the dungeon/queue being joined. For random queues this can be obtained using `/dump LFDQueueFrame.type` (`number`)

**See also:** Looking for group functions.



## SetLFGDungeonEnabled



## SetLFGHeaderCollapsed



## SetLFGRoles

Sets group roles for which to advertise the player in the LFG system. Passing `true` for a role the player's class does not support (e.g. healing on a warrior or tanking on a priest) has no effect: see example.

**Signature:** `SetLFGRoles(leader, tank, healer, damage)`

**Arguments:**
- `leader` - True if the player is willing to lead a group; otherwise false (`boolean`)
- `tank` - True if the player is willing to take on the role of protecting allies by drawing enemy attacks; otherwise false (`boolean`)
- `healer` - True if the player is willing to take on the role of healing allies who take damage; otherwise false (`boolean`)
- `damage` - True if the player is willing to take on the role of damaging enemies; otherwise false (`boolean`)



## SetLootMethod

Sets the loot method for a party or raid group. Has no effect if the player is not the party or raid leader.

See `SetLootThreshold` for the quality threshold used by Master Looter, Group Loot, and Need Before Greed methods.

**Signature:** `SetLootMethod("method" [, "master"])`

**Arguments:**
- `method` - Method to use for loot distribution (`string`) 

 - `freeforall` - Free for All - any group member can take any loot at any time
- `group` - Group Loot - like Round Robin, but items above a quality threshold are rolled on
- `master` - Master Looter - like Round Robin, but items above a quality threshold are left for a designated loot master to
- `needbeforegreed` - Need before Greed - like Group Loot, but members automatically pass on items
- `roundrobin` - Round Robin - group members take turns being able to loot
- `master` - Name or `unitID` of the master looter (`string`)

**See also:** Loot functions.



## SetLootPortrait

Sets a Texture object to show the appropriate portrait image when looting. Normally, the loot portrait image is the same as that of the creature being looted. Not used in the default UI -- a generic image for all loot is used instead.

**Signature:** `SetLootPortrait(texture)`

**Arguments:**
- `texture` - A Texture object (`table`)

**See also:** Loot functions.



## SetLootThreshold

Sets the threshold used for Master Looter, Group Loot, and Need Before Greed loot methods. Has no effect if the player is not the party or raid leader.

Items above the `threshold` quality will trigger the special behavior of the current loot method: for Group Loot and Need Before Greed, rolling will automatically begin once a group member loots the corpse or object holding the item; for Master Loot, the item will be invisible to all but the loot master tasked with assigning the loot.

The loot threshold defaults to `2` (Uncommon) when forming a new party/raid. Setting the threshold to `0` (Poor) or `1` (Common) has no effect -- qualities below Uncommon are always treated as below the threshold. The default UI only allows setting the threshold as high as `4` (Epic), but higher thresholds are allowed.

**Signature:** `SetLootThreshold(threshold)`

**Arguments:**
- `threshold` - Minimum item quality to trigger the loot method (`number`, itemQuality)

**See also:** Loot functions.



## SetMacroItem

_No snapshot available (page did not exist in archive)._



## SetMacroSpell

Changes the spell used for dynamic feedback for a macro. Normally a macro uses the item or spell specified by its commands to provide dynamic feedback when placed on an action button (through the Action APIs, e.g. `IsActionUsable()`): e.g. if the macro uses a consumable item, the button will show the number of items remaining; if the macro uses an item with a cooldown, the button will show the state of the cooldown. This function allows overriding the item or spell used by the macro with another item -- the given item's state will be used for such feedback instead of the item or spell used by the macro.

**Signature:** `SetMacroSpell(index, "spell" [, target]) or SetMacroSpell("name", "spell" [, target])`

**Arguments:**
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)
- `spell` - Name of a spell to use for the macro (`string`)
- `target` - A unit to use as target of the spell (affects the macro's range indicator) (`unitid`)

**See also:** Macro functions.



## SetMapByID

Sets the map based on a specified ID. For example, if you are an Undead character in the starting area, which is map ID 21, you can open your map and run SetMapByID(22) to change it to Western Plaguelands. In fact, you can run that anywhere If you are a fresh undead in tirisfal glades(MapAreaID:21), you get your map out, then you use SetMapByID(22) it will change to WPL

**Signature:** `SetMapByID(id)`

**Arguments:**
- `id` - The unique numeric map ID, can be obtained from `GetCurrentMapAreaID()` (`number`)



## SetMapToCurrentZone

Sets the world map to show the zone in which the player is located

**Signature:** `SetMapToCurrentZone()`

**See also:** Map functions.



## SetMapZoom

Sets the world map to show a specific zone or continent

**Signature:** `SetMapZoom(continentIndex [, zoneIndex])`

**Arguments:**
- `continentIndex` - Index of a continent to display (in the list returned by `GetMapContinents()`, or one of the following values) (`number`) 

 - `-1` - Cosmic map
- `0` - Entire Azeroth map
- `1` - Kalimdor
- `2` - Eastern Kingdoms
- `3` - Outland
- `4` - Northrend
- `zoneIndex` - Index of a zone within the continent to display (in the list returned by `GetMapZones(continentIndex)`), or omitted to show the continent map (`number`)



## setmetatable

Sets the metatable for a table

**Signature:** `t = setmetatable(t, metatable)`

**Arguments:**
- `t` - A table (`table`)
- `metatable` - A metatable for the table `t`, or nil to remove an existing metatable (`table`)

**Returns:**
- `t` - The input table `t` (`table`)



## SetModifiedClick

Sets a modified click for a given action

**Signature:** `SetModifiedClick("action", "binding")`

**Arguments:**
- `action` - Token identifying the modified click action (`string`)
- `binding` - The set of modifiers (and mouse button, if applicable) to register for the action (`string`, binding)

**See also:** Modified click functions.



## SetMouselookOverrideBinding

Overrides the default mouselook bindings to perform another binding with the mouse buttons

**Signature:** `SetMouselookOverrideBinding("key", "binding")`

**Arguments:**
- `key` - The mouselook key to override (`string`) 

 - `BUTTON1` - Override the left mouse button
- `BUTTON2` - Override the right mouse button
- `binding` - The binding to perform instead of mouselooking, or nil to clear the override (`string`)



## SetMultiCastSpell

Sets a multi-cast action slot to a given spell. This function is used to set up the multi-cast action slots, such as the totem bar that was introduced with WoW 3.2. The player is able to customize three different sets of totems that can then be cast with a single click.

**Signature:** `SetMultiCastSpell(action, spell)`

**Arguments:**
- `action` - The multi-cast action slot to set (`number`)
- `spell` - The numeric spellId to set to the given action slot (`number`)

**See also:** Multi-cast actions, Spell functions.



## SetMultisampleFormat

Changes the multisample setting. The `index` argument corresponds to the individual settings described by `GetMultisampleFormats()` (each a set of three values).

**Signature:** `SetMultisampleFormat(index)`

**Arguments:**
- `index` - Index of a multisample setting (`number`)



## SetNextBarberShopStyle

Selects the next style for a barber shop style option. Changes the underlying data (and thus the character's appearance) only; the default barbershop UI does not update.

**Signature:** `SetNextBarberShopStyle(styleIndex [, reverse])`

**Arguments:**
- `styleIndex` - Index of a style option (`number`) 

 - `1` - Hair (or Horn) Style
- `2` - Hair (or Horn) Color
- `3` - Varies by race and gender: Facial Hair, Earrings, Features, Hair, Horns, Markings, Normal, Piercings, or Tusks
- `reverse` - True to select the previous style; false or omitted to select the next (`boolean`)

**See also:** Barbershop functions.



## SetOptOutOfLoot

Changes the player's preference to opt out of loot rolls. When opting out, no prompt will be shown for loot which ordinarily would prompt the player to roll (need/greed) or pass; the loot rolling process will continue for other group members as if the player had chosen to pass on every roll.

**Signature:** `SetOptOutOfLoot(enable)`

**Arguments:**
- `enable` - True to opt out of loot, false to participate in loot rolls (`boolean`)

**See also:** Loot functions.



## SetOverrideBinding

Sets an override binding for a binding command. Override bindings are temporary. The bound key will revert to its normal setting once the override is removed. Priority overrides work the same way but will revert to the previous override binding (if present) rather than the base binding for the key. 

Call with a fourth argument of `nil` to remove the override binding for a specific key, or see `ClearOverrideBindings()` to remove all bindings associated with a given `owner`.

**Signature:** `SetOverrideBinding(owner, isPriority, "key", "command")`

**Arguments:**
- `owner` - The Frame (or other widget) object responsible for this override (`table`)
- `isPriority` - True if this binding takes higher priority than other override bindings; false otherwise (`boolean`)
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `command` - Name of a key binding command, or nil to remove the override binding (`string`)

**See also:** Keybind functions.



## SetOverrideBindingClick

Sets an override binding to "click" a Button object. Override bindings are temporary. The bound key will revert to its normal setting once the override is removed. Priority overrides work the same way but will revert to the previous override binding (if present) rather than the base binding for the key. 

Call with a fourth argument of `nil` to remove the override binding for a specific key, or see `ClearOverrideBindings()` to remove all bindings associated with a given `owner`.

**Signature:** `SetOverrideBindingClick(owner, isPriority, "key", "buttonName" [, "mouseButton"])`

**Arguments:**
- `owner` - The Frame (or other widget) object responsible for this override (`table`)
- `isPriority` - True if this binding takes higher priority than other override bindings; false otherwise (`boolean`)
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `buttonName` - Name of a Button object on which the binding simulates a click (`string`)
- `mouseButton` - Name of the mouse button with which the binding simulates a click (`string`)

**See also:** Keybind functions.



## SetOverrideBindingItem

Sets an override binding to use an item in the player's possession. Override bindings are temporary. The bound key will revert to its normal setting once the override is removed. Priority overrides work the same way but will revert to the previous override binding (if present) rather than the base binding for the key. 

Call with a fourth argument of `nil` to remove the override binding for a specific key, or see `ClearOverrideBindings()` to remove all bindings associated with a given `owner`.

**Signature:** `SetOverrideBindingItem(owner, isPriority, "key", itemID) or SetOverrideBindingItem(owner, isPriority, "key", "itemName") or SetOverrideBindingItem(owner, isPriority, "key", "itemLink")`

**Arguments:**
- `owner` - The Frame (or other widget) object responsible for this override (`table`)
- `isPriority` - True if this binding takes higher priority than other override bindings; false otherwise (`boolean`)
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

**See also:** Keybind functions, Item functions.



## SetOverrideBindingMacro

Sets an override binding to run a macro. Override bindings are temporary. The bound key will revert to its normal setting once the override is removed. Priority overrides work the same way but will revert to the previous override binding (if present) rather than the base binding for the key. 

Call with a fourth argument of `nil` to remove the override binding for a specific key, or see `ClearOverrideBindings()` to remove all bindings associated with a given `owner`.

**Signature:** `SetOverrideBindingMacro(owner, isPriority, "key", index) or SetOverrideBindingMacro(owner, isPriority, "key", "name")`

**Arguments:**
- `owner` - The Frame (or other widget) object responsible for this override (`table`)
- `isPriority` - True if this binding takes higher priority than other override bindings; false otherwise (`boolean`)
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `index` - Index of a macro (`number`, macroID)
- `name` - Name of a macro (`string`)

**See also:** Keybind functions.



## SetOverrideBindingSpell

Set an override binding to a specific spell. Override bindings are temporary. The bound key will revert to its normal setting once the override is removed. Priority overrides work the same way but will revert to the previous override binding (if present) rather than the base binding for the key. See `ClearOverrideBindings()` to remove bindings associated with a given `owner`.

**Signature:** `SetOverrideBindingSpell(owner, isPriority, "key", "spellname")`

**Arguments:**
- `owner` - The Frame (or other widget) object responsible for this override (`table`)
- `isPriority` - True if this binding takes higher priority than other override bindings; false otherwise (`boolean`)
- `key` - A key or key combination (e.g. "CTRL-2") (`string`, binding)
- `spellname` - Name of a spell, or nil to remove the override binding (`string`)

**See also:** Keybind functions.



## SetPartyAssignment

Assigns a group role to a member of the player's party or raid

**Signature:** `SetPartyAssignment("assignment", "unit") or SetPartyAssignment("assignment", "name" [, exactMatch])`

**Arguments:**
- `assignment` - A group role to assign to the unit (`string`) 

 - `MAINASSIST` - Assign the main assist role
- `MAINTANK` - Assign the main tank role
- `unit` - A unit in the player's party or raid (`string`, unitID)
- `name` - Name of a unit in the player's party or raid (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Party functions, Raid functions.



## SetPetStablePaperdoll

Sets the given Model to show the selected stabled pet

**Signature:** `SetPetStablePaperdoll(model)`

**Arguments:**
- `model` - A Model frame (`table`)



## SetPOIIconOverlapDistance



## SetPOIIconOverlapPushDistance



## SetPortraitTexture

Sets a Texture object to show a portrait of a unit. Causes the client to render a view of the unit's model from a standard perspective into a circular 2D image and display it in the given Texture object.

**Signature:** `SetPortraitTexture(texture, "unit")`

**Arguments:**
- `texture` - A Texture object (`table`)
- `unit` - A unit for which to display a portrait (`string`, unitID)

**See also:** Unit functions.



## SetPortraitToTexture

Sets a Texture object to display an arbitrary texture, altering it to fit a circular frame. Used in the default UI to display square textures (such as item icons) within the circular "portrait" frames used in many default UI elements.

**Signature:** `SetPortraitToTexture("frameName", "texturePath")`

**Arguments:**
- `frameName` - Name of a Texture object (`string`)
- `texturePath` - Path to a texture to display (`string`)

**See also:** Utility functions.



## SetPVP

Enables or disables the player's desired PvP status. Enabling PvP takes effect immediately; disabling PvP begins a five-minute countdown after which PvP status will be disabled (if the player has taken no PvP actions).

**Signature:** `SetPVP(state)`

**Arguments:**
- `state` - 1 to enable PVP, nil to disable (`1nil`)

**See also:** PvP functions.



## SetRaidDifficulty

Sets the player's raid dungeon difficulty preference. The dungeon difficulty has no effect on the instance created if the player is not the raid leader or while you are inside an instance already.

**Signature:** `SetRaidDifficulty(difficulty)`

**Arguments:**
- `difficulty` - Difficulty level for raid dungeons 

 - `1` - 10 Player
- `2` - 25 Player
- `3` - 10 Player (Heroic)
- `4` - 25 Player (Heroic)



## SetRaidRosterSelection

Selects a unit in the raid roster. Selection in the raid roster is used only for display in the default UI and has no effect on other Raid APIs.

**Signature:** `SetRaidRosterSelection(index)`

**Arguments:**
- `index` - Index of the raid member (between 1 and `GetNumRaidMembers()`); matches the numeric part of the unit's `raid` `unitID`, e.g. 21 for `raid21` (`number`)

**See also:** Raid functions.



## SetRaidSubgroup

Moves a raid member to a non-full raid subgroup. Only has effect if the player is the raid leader or a raid assistant. To put a member into a full subgroup (switching places with a member of that group), see `SwapRaidSubgroup()`.

**Signature:** `SetRaidSubgroup(index, subgroup)`

**Arguments:**
- `index` - Index of the raid member (between 1 and `GetNumRaidMembers()`); matches the numeric part of the unit's `raid` `unitID`, e.g. 21 for `raid21` (`number`)
- `subgroup` - Index of a raid subgroup (between 1 and `MAX_RAID_GROUPS`) (`number`)

**See also:** Raid functions.



## SetRaidTarget

Puts a raid target marker on a unit

**Signature:** `SetRaidTarget("unit", index) or SetRaidTarget("name", index)`

**Arguments:**
- `unit` - A unit to mark (`string`, unitID)
- `name` - Name of a unit to mark (`string`)
- `index` - Index of a target marker (`number`) 

 - `0` - Clear any raid target markers
- `1` - Star
- `2` - Circle
- `3` - Diamond
- `4` - Triangle
- `5` - Moon
- `6` - Square
- `7` - Cross
- `8` - Skull

**See also:** Raid functions.



## SetSavedInstanceExtend



## SetScreenResolution

Changes the screen resolution

**Signature:** `SetScreenResolution(index)`

**Arguments:**
- `index` - Index of a resolution setting (between 1 and `select("#",``GetScreenResolutions()``)`) (`number`)



## SetSelectedAuctionItem

Selects an item in an auction listing. Auction selection is used only for display and internal recordkeeping in the default UI; it has no direct effect on other Auction APIs.

**Signature:** `SetSelectedAuctionItem("list", index)`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed
- `index` - Index of an auction in the listing (`number`)

**See also:** Auction functions.



## SetSelectedBattlefield

Selects a battleground instance in the queueing list. Selection in the battleground instance list is used only for display in the default UI and has no effect on other Battlefield APIs.

**Signature:** `SetSelectedBattlefield(index)`

**Arguments:**
- `index` - Index in the battleground queue listing (1 for the first available instance, or between 2 and `GetNumBattlefields()` for other instances) (`number`)



## SetSelectedDisplayChannel

Selects a channel in the channel list display

**Signature:** `SetSelectedDisplayChannel(index)`

**Arguments:**
- `index` - Index of a channel in the channel list display (between 1 and `GetNumDisplayChannels()`) (`number`)

**See also:** Channel functions.



## SetSelectedFaction

Selects a faction in the reputation UI. 
 

Selection has no bearing on other faction-related APIs; this function merely facilitates behaviors of Blizzard's reputation UI.

**Signature:** `SetSelectedFaction(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)



## SetSelectedFriend

Selects a character in the player's friends list. Selection in the Friends list is used only for display in the default UI and has no effect on other Friends list APIs.

**Signature:** `SetSelectedFriend(index)`

**Arguments:**
- `index` - Index of a character in the Friends list (between 1 and `GetNumFriends()`) (`number`)

**See also:** Social functions.



## SetSelectedIgnore

Selects a character in the player's ignore list. Selection in the Ignore list is used only for display in the default UI and has no effect on other Ignore list APIs.

**Signature:** `SetSelectedIgnore(index)`

**Arguments:**
- `index` - Index of a character in the Ignore list (between 1 and `GetNumIgnores()`) (`number`)

**See also:** Social functions.



## SetSelectedMute

Selects an entry in the Muted list. Mute list selection is only used for display purposes in the default UI and has no effect on other API functions.

**Signature:** `SetSelectedMute(index)`

**Arguments:**
- `index` - Index of an entry in the mute listing (between 1 and `GetNumMutes()`) (`number`)



## SetSelectedSkill

_No snapshot available (page did not exist in archive)._



## SetSendMailCOD

Sets the Cash-On-Delivery cost of the outgoing message. Called in the default UI when clicking its Send button, immediately before sending the mail.

**Signature:** `SetSendMailCOD(amount)`

**Arguments:**
- `amount` - COD cost for the items attached to the mail (in copper) (`number`)

**See also:** Mail functions.



## SetSendMailMoney

Sets the amount of money to be sent with the outgoing message. Called in the default UI when clicking its Send button, immediately before sending the message. Causes an error message if the `amount` plus postage exceeds the player's total money.

**Signature:** `success = SetSendMailMoney(amount)`

**Arguments:**
- `amount` - Amount of money to send (in copper) (`number`)

**Returns:**
- `success` - 1 if the player has enough money to send the message; otherwise nil (`1nil`)



## SetSendMailShowing

Enables or disables shortcuts for attaching items to outgoing mail. When shortcuts are enabled, `UseContainerItem()` (i.e. right-click in the default UI's container frames) attaches the item to the outgoing message instead of using it.

**Signature:** `SetSendMailShowing(enable)`

**Arguments:**
- `enable` - True to enable shortcuts; false to disable (`boolean`)



## SetTaxiBenchmarkMode

Enables or disables flight path benchmark mode. When benchmark mode is enabled, the next taxi flight the player takes will behave differently: camera movement is disabled and players/creatures/objects below the flight path will not be shown (allowing for consistent test conditions). After the flight, framerate statistics will be printed in the chat window and benchmark mode will be automatically disabled.

**Signature:** `SetTaxiBenchmarkMode("arg")`

**Arguments:**
- `arg` - nil, `"on"`, or 1 to enable benchmark mode; `"off"` or 0 to disable (`string`)



## SetTaxiMap

Sets a Texture object to show the appropriate flight map texture. Only has effect while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `SetTaxiMap(texture)`

**Arguments:**
- `texture` - A Texture object (`table`)

**See also:** Taxi/Flight functions.



## SetTerrainMip

_No snapshot available (page did not exist in archive)._



## SetTexLodBias

**Signature:** `SetTexLodBias()`



## SetTracking

Enables a given minimap object/unit tracking ability

**Signature:** `SetTracking(index, enabled)`

**Arguments:**
- `index` - Index of a tracking ability (between 1 and `GetNumTrackingTypes()`) (`number`)
- `enabled` - pass true to enable, false to disable (`boolean`)

**See also:** Tracking functions.



## SetTradeMoney

Offers an amount of money for trade

**Signature:** `SetTradeMoney(amount)`

**Arguments:**
- `amount` - Amount of money to offer for trade (in copper) (`number`)

**See also:** Trade functions, Money functions.



## SetTradeSkillInvSlotFilter

Filters the trade skill listing by equipment slot of items produced

**Signature:** `SetTradeSkillInvSlotFilter(index [, enable [, exclusive]])`

**Arguments:**
- `index` - Index of an item equipment slot (in the list returned by `GetTradeSkillInvSlots()`), or `0` for no filter (`number`)
- `enable` - 1 to show recipes matching inventory type `index` in the filtered list; 0 to hide them (`number`)
- `exclusive` - 1 to disable other subclass filters when enabling this one; otherwise nil (`1nil`)



## SetTradeSkillItemLevelFilter

Filters the trade skill listing by required level of items produced

**Signature:** `SetTradeSkillItemLevelFilter(minLevel, maxLevel)`

**Arguments:**
- `minLevel` - Lowest required level of items to show in the filtered list (`number`)
- `maxLevel` - Highest required level of items to show in the filtered list (`number`)

**See also:** Tradeskill functions.



## SetTradeSkillItemNameFilter

Filters the trade skill listing by name of recipe, item produced, or reagents. Uses a substring (not exact-match) search: e.g. for a Scribe, the search string "doc" might filter the list to show only Certificate of Ownership because it matches the word "documentation" in that item's tooltip; a search for "stam" will match all items providing a Stamina bonus.

**Signature:** `SetTradeSkillItemNameFilter("text")`

**Arguments:**
- `text` - Text to search for in recipe names, produced item names or descriptions, or reagents (`string`)

**See also:** Tradeskill functions.



## SetTradeSkillSubClassFilter

Filters the trade skill listing by subclass of items produced

**Signature:** `SetTradeSkillSubClassFilter(index [, enable [, exclusive]])`

**Arguments:**
- `index` - Index of an item subclass (in the list returned by `GetTradeSkillSubClasses()`), or `0` for no filter (`number`)
- `enable` - 1 to show recipes matching subclass `index` in the filtered list; 0 to hide them (`number`)
- `exclusive` - 1 to disable other subclass filters when enabling this one; otherwise nil (`1nil`)



## SetTrainerServiceTypeFilter

Filters the trainer service listing by service status

**Signature:** `SetTrainerServiceTypeFilter("type" [, enable [, exclusive]])`

**Arguments:**
- `type` - A service status (`string`) 

 - `available` - Services the player can use
- `unavailable` - Services the player cannot currently use
- `used` - Services the player has already used
- `enable` - 1 to show services matching `type` in the filtered list; 0 to hide them (`number`)
- `exclusive` - 1 to disable other type filters when enabling this one; otherwise nil (`1nil`)

**See also:** Trainer functions.



## SetTrainerSkillLineFilter

Filters the trainer service listing by skill line. The default UI does not provide control for skill line filters, but they can nonetheless be used to alter the contents of the trainer service listing.

**Signature:** `SetTrainerSkillLineFilter("type" [, enable [, exclusive]])`

**Arguments:**
- `type` - Index of a skill line filter (in the list returned by `GetTrainerSkillLines()`) (`string`)
- `enable` - 1 to show services matching the given skill line in the filtered list; 0 to hide them (`number`)
- `exclusive` - 1 to disable other skill line filters when enabling this one; otherwise nil (`1nil`)



## SetUIVisibility

Enables or disables display of UI elements in the 3-D world. Applies only to 2-D UI elements displayed in the 3-D world: nameplates and raid target icons (skull, circle, square, etc). Does not directly control nameplates and target icons -- only affects whether they are displayed (see the `nameplateShowEnemies`/`nameplateShowFriends` CVars and `SetRaidTarget` functions for direct control).

Does not apply to 3-D UI elements such as the selection circle, area-effect targeting indicator, vehicle weapon aim indicator, etc.

**Signature:** `SetUIVisibility(visible)`

**Arguments:**
- `visible` - True to enable display of UI elements in the 3-D world; false to disable (`boolean`)



## SetupFullscreenScale

Sizes a frame to take up the entire screen regardless of screen resolution

**Signature:** `SetupFullscreenScale(frame)`

**Arguments:**
- `frame` - Frame to resize to full screen (`table`)



## SetView

Moves the camera to a saved camera setting. There are five "slots" for saved camera settings, indexed 1-5. These views can be set and accessed directly using `SaveView()` and `SetView()`, and cycled through using `NextView()` and `PrevView()`.

**Signature:** `SetView(index)`

**Arguments:**
- `index` - Index of a saved camera setting (between 1 and 5) (`number`)

**See also:** Camera functions.



## SetWatchedFactionIndex

Makes a faction the "watched" faction (displayed on the XP bar in the default UI)

**Signature:** `SetWatchedFactionIndex(index)`

**Arguments:**
- `index` - Index of an entry in the faction list; between 1 and GetNumFactions() (`number`)



## SetWaterDetail

Sets the value for the water details display

**Signature:** `SetWaterDetail(value)`

**Arguments:**
- `value` - The new value for the water detail (`number`)



## SetWhoToUI

Changes the delivery method for results from `SendWho()` queries. In the default UI, results delivered in `CHAT_MSG_SYSTEM` are printed in the main chat window; results delivered in a `WHO_LIST_UPDATE` event cause the FriendsFrame to be shown, displaying the results in its "Who" tab.

**Signature:** `SetWhoToUI(state)`

**Arguments:**
- `state` - Number identifying a delivery method (`number`) 

 - `0` - Send results of three entries or fewer in `CHAT_MSG_SYSTEM` events and results of greater than three entries in a `WHO_LIST_UPDATE` event
- `1` - Send all results in a `WHO_LIST_UPDATE` event

**See also:** Social functions.


