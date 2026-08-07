# WoW API — GetN*

_91 functions_

---

## getn




## GetNetStats

Returns information about current network connection performance

**Signature:** `bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()`

**Returns:**
- `bandwidthIn` - Current incomming bandwidth (download) usage, measured in KB/s (`number`)
- `bandwidthOut` - Current outgoing bandwidth (upload) usage, measured in KB/s (`number`)
- `latencyHome` - Average roundtrip latency to the home realm server (only updated every 30 seconds) (`number`)
- `latencyWorld` - Average roundtrip latency to the current world server (only updated every 30 seconds) (`number`)

**See also:** Client control and information functions, Debugging and Profiling functions.




## GetNewSocketInfo

Returns information about a gem added to a socket. If the given socket contains a new gem (one that has been placed in the UI, but not yet confirmed for permanently socketing into the item), returns information for that gem. If the socket is empty or has a permanently socketed gem but no new gem, returns `nil`.

Only returns valid information when the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `name, texture, matches = GetNewSocketInfo(index)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)

**Returns:**
- `name` - Name of the gem added to the socket (`string`)
- `texture` - Path to an icon texture for the gem added to the socket (`string`)
- `matches` - 1 if the gem matches the socket's color; otherwise nil (`1nil`)




## GetNewSocketLink

Returns a hyperlink for a gem added to a socket. If the given socket contains a new gem (one that has been placed in the UI, but not yet confirmed for permanently socketing into the item), returns an item link for that gem. If the socket is empty or has a permanently socketed gem but no new gem, returns `nil`.

Only returns valid information when the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `link = GetNewSocketLink(index)`

**Arguments:**
- `index` - Index of a gem socket (between 1 and `GetNumSockets()`) (`number`)

**Returns:**
- `link` - A hyperlink for the gem added to the socket (`string`, hyperlink)

**See also:** Socketing functions, Hyperlink functions.




## GetNextAchievement

Returns the next achievement for an achievement which is part of a series

**Signature:** `nextID, completed = GetNextAchievement(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**Returns:**
- `nextID` - If the given achievement is part of a series and not the last in its series, the ID of the next achievement in the series; otherwise nil (`number`)
- `completed` - True if the next achievement has been completed; otherwise nil (`boolean`)

**See also:** Achievement functions.




## GetNextCompleatedTutorial




## GetNextStableSlotCost

_No snapshot available (page did not exist in archive)._




## GetNumActiveQuests

Returns the number of quests which can be turned in to the current Quest NPC. Only returns valid information after a `QUEST_GREETING` event.

Note: Most quest NPCs present active quests using the `GetGossipActiveQuests()` instead of this function.

**Signature:** `numActiveQuests = GetNumActiveQuests()`

**Returns:**
- `numActiveQuests` - Number of quests which can be turned in to the current Quest NPC (`number`)

**See also:** Quest functions.




## GetNumAddOns

Returns the number of addons in the addon listing

**Signature:** `numAddons = GetNumAddOns()`

**Returns:**
- `numAddons` - The number of addons in the addon listing (`number`)




## GetNumArenaOpponents

Returns the number of enemy players in an arena match

**Signature:** `numOpponents = GetNumArenaOpponents()`

**Returns:**
- `numOpponents` - Number of enemy players in an arena match (`number`)

**See also:** Arena functions.




## GetNumArenaTeamMembers

Returns the number of members in an arena team

**Signature:** `numMembers = GetNumArenaTeamMembers(teamindex, showOffline)`

**Arguments:**
- `teamindex` - The index of the arena team, based on the order they are displayed in the PvP tab. (`number`)
- `showOffline` - True to include currently offline members in the count; otherwise false (`boolean`)

**Returns:**
- `numMembers` - Number of characters on the team (`number`)




## GetNumAuctionItems

Returns the number of auction items in a listing

**Signature:** `numBatchAuctions, totalAuctions = GetNumAuctionItems("list")`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed

**Returns:**
- `numBatchAuctions` - Number of auctions in the current page of the listing (`number`)
- `totalAuctions` - Total number of auctions available for the listing (`number`)




## GetNumAvailableQuests

Returns the number quests available from the current Quest NPC. Only returns valid information after a `QUEST_GREETING` event.

Note: Most quest NPCs present available quests using the `GetGossipAvailableQuests()` instead of this function.

**Signature:** `numAvailableQuests = GetNumAvailableQuests()`

**Returns:**
- `numAvailableQuests` - Number of quests available from the current Quest NPC (`number`)

**See also:** Quest functions.




## GetNumBankSlots

Returns information about purchased bank bag slots

**Signature:** `numSlots, isFull = GetNumBankSlots()`

**Returns:**
- `numSlots` - Number of bank bag slots the player has purchased (`number`)
- `isFull` - 1 if the player has purchased all available slots; otherwise nil (`1nil`)

**See also:** Bank functions.




## GetNumBattlefieldFlagPositions

Returns the number of battleground flags for which map position information is available

**Signature:** `numFlags = GetNumBattlefieldFlagPositions()`

**Returns:**
- `numFlags` - Number of battleground flags for which map position information is available (`number`)

**See also:** Battlefield functions.




## GetNumBattlefieldPositions

Returns the number of team members in the battleground not in the player's group. Still used in the default UI but no longer useful; always returns 0, as all team members in a battleground match are automatically joined into a raid group.

**Signature:** `numTeamMembers = GetNumBattlefieldPositions()`

**Returns:**
- `numTeamMembers` - Number of team members in the battleground not in the player's party or raid (`number`)

**See also:** Battlefield functions.




## GetNumBattlefields

Returns the number of instances available for a battleground

**Signature:** `numBattlefields = GetNumBattlefields([index])`

**Arguments:**
- `index` - Index of a battleground (between 1 and `NUM_BATTLEGROUNDS`), if using the queue-anywhere UI; not used when choosing an instance for a single battleground (e.g. at a battlemaster or battleground portal) (`number`)

**Returns:**
- `numBattlefields` - Number of instances currently available for the battleground (`number`)

**See also:** Battlefield functions.




## GetNumBattlefieldScores

Returns the number of participant scores available in the current battleground

**Signature:** `numScores = GetNumBattlefieldScores()`

**Returns:**
- `numScores` - Number of participant scores available in the current battleground; 0 if not in a battleground (`number`)




## GetNumBattlefieldStats

Returns the number of battleground-specific statistics on the current battleground's scoreboard. Battleground-specific statistics include flags captured in Warsong Gulch, towers assaulted in Alterac Valley, etc. For the name and icon associated with each statistic, see `GetBattlefieldStatInfo()`.

**Signature:** `numStats = GetNumBattlefieldStats()`

**Returns:**
- `numStats` - Number of battleground-specific scoreboard columns (`number`)




## GetNumBattlefieldVehicles

Returns the number of special vehicles in the current zone. Used only for certain vehicles in certain zones: includes the airships in Icecrown as well as vehicles used in Ulduar, Wintergrasp, and Strand of the Ancients.

**Signature:** `numVehicles = GetNumBattlefieldVehicles()`

**Returns:**
- `numVehicles` - Number of special vehicles (`number`)

**See also:** Battlefield functions, Map functions.




## GetNumBattlegroundTypes

Returns the number of different battlegrounds available. Refers to distinct battlegrounds, not battleground instances. Does not indicate the number of battlegrounds the player can enter: for that, see `GetBattlegroundInfo`.

As of WoW 3.2, should always return 6: for Alterac Valley, Warsong Gulch, Arathi Basin, Eye of the Storm, Strand of the Ancients, and Isle of Conquest. If a future patch adds a new battleground, this function will reflect that.

**Signature:** `numBattlegrounds = GetNumBattlegroundTypes()`

**Returns:**
- `numBattlegrounds` - Number of different battlegrounds available (`number`)

**See also:** Battlefield functions.




## GetNumBindings

Returns the number of entries in the key bindings list

**Signature:** `numBindings = GetNumBindings()`

**Returns:**
- `numBindings` - Number of binding actions (and headers) in the key bindings list (`number`)

**See also:** Keybind functions.




## GetNumBuybackItems

Returns the number of items recently sold to a vendor and available to be repurchased

**Signature:** `numBuybackItems = GetNumBuybackItems()`

**Returns:**
- `numBuybackItems` - Number of items available to be repurchased (`number`)




## GetNumChannelMembers

Returns the number of members in a chat channel

**Signature:** `numMembers = GetNumChannelMembers(id)`

**Arguments:**
- `id` - Numeric identifier of a chat channel (`number`)

**Returns:**
- `numMembers` - Number of characters in the channel (`number`)

**See also:** Channel functions.




## GetNumCompanions

Returns the number of mounts or non-combat pets the player can summon

**Signature:** `count = GetNumCompanions("type")`

**Arguments:**
- `type` - The type of companion (`string`) 

 - `CRITTER` - Non-combat pets
- `MOUNT` - Mounts

**Returns:**
- `count` - The number of available companions (`number`)




## GetNumComparisonCompletedAchievements

Returns the number of achievements earned by the comparison unit. 
 

Does not include Feats of Strength.

**Signature:** `total, completed = GetNumComparisonCompletedAchievements()`

**Returns:**
- `total` - Total number of achievements currently in the game (`number`)
- `completed` - Number of achievements earned by the comparison unit (`number`)

**See also:** Achievement functions.




## GetNumCompletedAchievements

Returns the number of achievements earned by the player. 
Does not include Feats of Strength.

**Signature:** `total, completed = GetNumCompletedAchievements()`

**Returns:**
- `total` - Total number of achievements currently in the game (`number`)
- `completed` - Number of achievements earned by the player (`number`)

**See also:** Achievement functions.




## GetNumDeclensionSets

Returns the number of suggested declension sets for a name. Used in the Russian localized World of Warcraft client; see `DeclineName` for further details. Returns 0 in other locales.

**Signature:** `numSets = GetNumDeclensionSets("name", gender)`

**Arguments:**
- `name` - Nominative form of the player's or pet's name (`string`)
- `gender` - Gender for names (for declensions of the player's name, should match the player's gender; for the pet's name, should be neuter) (`number`) 

 - `1 or nil` - Neuter
- `2` - Male
- `3` - Female

**Returns:**
- `numSets` - Number of available declension sets usable with `DeclineName` (`number`)




## GetNumDisplayChannels

Returns the number of entries in the channel list display

**Signature:** `channelCount = GetNumDisplayChannels()`

**Returns:**
- `channelCount` - Number of channels and group headers to be displayed in the channel list (`number`)




## GetNumDungeonMapLevels

Returns the number of map images for the world map's current zone. Used in zones with more than one "floor" or area such as Dalaran and several Wrath of the Lich King dungeons and raids.

**Signature:** `numLevels = GetNumDungeonMapLevels()`

**Returns:**
- `numLevels` - Number of map images (`number`)




## GetNumEquipmentSets

Returns the number of saved equipment sets

**Signature:** `numSets = GetNumEquipmentSets()`

**Returns:**
- `numSets` - Number of saved equipment sets (`number`)




## GetNumFactions

Returns the number of entries in the reputation UI. 
Entries in the reputation UI can be major group headers (Classic, Burning Crusade, Wrath of the Lich King, Inactive, etc.), the sub-group headers within them (Alliance Forces, Steamwheedle Cartel, Horde Expedition, Shattrath City, etc.), or individual factions (Darkmoon Faire, Orgrimmar, Honor Hold, Kirin Tor, etc.).

This function returns not the total number of factions (and headers) known, but the number which should currently be visible in the UI according to the expanded/collapsed state of headers.

**Signature:** `numFactions = GetNumFactions()`

**Returns:**
- `numFactions` - The number of visible factions and headers (`number`)




## GetNumFrames

Returns the number of existing Frame objects (and derivatives). Only counts Frame objects and derivatives thereof (e.g. Button, Minimap, and StatusBar; but not FontString, AnimationGroup, and Texture).

**Signature:** `numFrames = GetNumFrames()`

**Returns:**
- `numFrames` - Number of existing Frame objects (and derivatives) (`number`)

**See also:** Utility functions.




## GetNumFriends

Returns the number of characters on the player's friends list

**Signature:** `numFriends = GetNumFriends()`

**Returns:**
- `numFriends` - Number of characters currently on the friends list (`number`)




## GetNumGlyphSockets

Currently unused. Use the constant `NUM_GLYPH_SLOTS` instead.

**Signature:** `GetNumGlyphSockets()`

**See also:** Glyph functions.




## GetNumGossipActiveQuests

Returns the number of quests which can be turned in to the current Gossip NPC. These quests are displayed with a question mark icon in the default UI's GossipFrame.

**Signature:** `num = GetNumGossipActiveQuests()`

**Returns:**
- `num` - Number of quests which can be turned in to the current Gossip NPC (`number`)

**See also:** Quest functions, NPC "Gossip" Dialog functions.




## GetNumGossipAvailableQuests

Returns the number of quests available from the current Gossip NPC. These quests are displayed with an exclamation mark icon in the default UI's GossipFrame.

**Signature:** `num = GetNumGossipAvailableQuests()`

**Returns:**
- `num` - Number of quests available from the current Gossip NPC (`number`)




## GetNumGossipOptions

Returns the number of non-quest dialog options for the current Gossip NPC. Used by the default UI to skip greeting gossip for NPCs which provide only a greeting and one gossip option leading to the NPC's main interaction type (e.g. flight masters, merchants).

**Signature:** `numOptions = GetNumGossipOptions()`

**Returns:**
- `numOptions` - Number of options available from the current Gossip NPC (`number`)

**See also:** NPC "Gossip" Dialog functions.




## GetNumGuildBankMoneyTransactions

Returns the number of transactions in the guild bank money log

**Signature:** `numTransactions = GetNumGuildBankMoneyTransactions()`

**Returns:**
- `numTransactions` - Number of transactions in the money log (`number`)

**See also:** Guild bank functions.




## GetNumGuildBankTabs

_No snapshot available (page did not exist in archive)._




## GetNumGuildBankTransactions

Returns the number of entries in a guild bank tab's transaction log. Only returns valid information following the `GUILDBANKLOG_UPDATE` event which fires after calling `QueryGuildBankLog()`.

**Signature:** `numTransactions = GetNumGuildBankTransactions(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**Returns:**
- `numTransactions` - Number of transactions in the tab's log (`number`)

**See also:** Guild bank functions.




## GetNumGuildEvents

Returns the number of entries in the guild event log. Only returns valid data after calling `QueryGuildEventLog()` and the following `GUILD_EVENT_LOG_UPDATE` event has fired.

**Signature:** `numEvents = GetNumGuildEvents()`

**Returns:**
- `numEvents` - Number of entries in the guild event log (`number`)




## GetNumGuildMembers

Returns the number of members in the guild roster

**Signature:** `numGuildMembers = GetNumGuildMembers([includeOffline])`

**Arguments:**
- `includeOffline` - True to count all members in the guild; false or omitted to count only those members currently online (`boolean`)

**Returns:**
- `numGuildMembers` - Number of members in the guild roster (`number`)




## GetNumIgnores

Returns the number of characters on the player's ignore list

**Signature:** `numIgnores = GetNumIgnores()`

**Returns:**
- `numIgnores` - Number of characters currently on the ignore list (`number`)

**See also:** Social functions.




## GetNumLanguages

Returns the number of languages the player character can speak

**Signature:** `languages = GetNumLanguages()`

**Returns:**
- `languages` - Number of in-game languages known to the player character (generally 2 for most races, 1 for Orcs or Humans) (`number`)




## GetNumLootItems

Returns the number of items available to be looted

**Signature:** `numItems = GetNumLootItems()`

**Returns:**
- `numItems` - Number of the items available to be looted (`number`)




## GetNumMacroIcons

Returns the number of available macro icons

**Signature:** `numMacroIcons = GetNumMacroIcons()`

**Returns:**
- `numMacroIcons` - The number of available macro icons (`number`)

**See also:** Macro functions.




## GetNumMacroItemIcons

Returns the number of available item icons. Despite the "macro" in the title, this function is only used by the default UI for providing tab icon options in the guild bank.

**Signature:** `numIcons = GetNumMacroItemIcons()`

**Returns:**
- `numIcons` - Number of available item icons (`number`)




## GetNumMacros

Returns the number of macros the player has stored

**Signature:** `numAccountMacros, numCharacterMacros = GetNumMacros()`

**Returns:**
- `numAccountMacros` - Number of account-wide macros (`number`)
- `numCharacterMacros` - Number of character-specific macros (`number`)

**See also:** Macro functions.




## GetNumMapDebugObjects

**Signature:** `GetNumMapDebugObjects()`




## GetNumMapLandmarks

Returns the number of landmarks on the world map. Possible landmarks include PvP objectives (both in battlegrounds and in world PvP areas), town and city markers on continent maps, and special markers such as those used during the Scourge Invasion world event. Some landmarks (such as those for towns on a zone map) exist but are not visible in the default UI.

**Signature:** `numLandmarks = GetNumMapLandmarks()`

**Returns:**
- `numLandmarks` - The number of landmarks on the current world map (`number`)

**See also:** Map functions.




## GetNumMapOverlays

Returns the number of overlays for the current world map zone. Map overlays correspond to areas which are "discovered" when entered by the player, "filling in" the blank areas of the world map.

**Signature:** `numOverlays = GetNumMapOverlays()`

**Returns:**
- `numOverlays` - Number of overlays for the current world map zone (`number`)




## GetNumModifiedClickActions

Returns the number of modified click actions registered. May return an invalid result if called when no modified click actions have been registered (i.e. early in the UI loading process).

**Signature:** `num = GetNumModifiedClickActions()`

**Returns:**
- `num` - Number of modifed click actions registered (`number`)




## GetNumMutes

Returns the number of characters on the player's mute list

**Signature:** `numMuted = GetNumMutes()`

**Returns:**
- `numMuted` - The number of characters on the player's mute list (`number`)

**See also:** Voice functions.




## GetNumPackages




## GetNumPartyMembers

Returns the number of additional members in the player's party

**Signature:** `numPartyMembers = GetNumPartyMembers()`

**Returns:**
- `numPartyMembers` - Number of additional members in the player's party (between 1 and `MAX_PARTY_MEMBERS`, or 0 if the player is not in a party) (`number`)

**See also:** Party functions.




## GetNumPetitionItems

**Signature:** `GetNumPetitionItems()`




## GetNumPetitionNames

Returns the number of people who have signed the open petition

**Signature:** `numNames = GetNumPetitionNames()`

**Returns:**
- `numNames` - Number of characters that have signed the petition (`number`)

**See also:** Petition functions.




## GetNumQuestChoices

Returns the number of available quest rewards from which the player must choose one upon completing the quest presented by a questgiver. Only valid during the accept/decline or completion stages of a quest dialog (following the `QUEST_DETAIL` or `QUEST_COMPLETE` events); otherwise may return 0 or a value from the most recently displayed quest.

**Signature:** `numQuestChoices = GetNumQuestChoices()`

**Returns:**
- `numQuestChoices` - Number of available quest rewards from which the player must choose one upon completing the quest (`number`)

**See also:** Quest functions.




## GetNumQuestItemDrops




## GetNumQuestItems

Returns the number of different items required to complete the quest presented by a questgiver. Usable following the `QUEST_PROGRESS` event in which it is determined whether the player can complete the quest.

**Signature:** `numRequiredItems = GetNumQuestItems()`

**Returns:**
- `numRequiredItems` - Number of different items required to complete the quest (`number`)

**See also:** Quest functions.




## GetNumQuestLeaderBoards

Returns the number of quest objectives for a quest in the player's quest log

**Signature:** `numObjectives = GetNumQuestLeaderBoards([questIndex])`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`); if omitted, defaults to the selected quest (`number`)

**Returns:**
- `numObjectives` - Number of trackable objectives for the quest (`number`)




## GetNumQuestLogChoices

Returns the number of available item reward choices for the selected quest in the quest log. This function refers to quest rewards for which the player is allowed to choose one item from among several; for items always awarded upon quest completion, see GetNumQuestLogRewards.

**Signature:** `numChoices = GetNumQuestLogChoices()`

**Returns:**
- `numChoices` - Number of items among which a reward can be chosen for completing the quest (`number`)

**See also:** Quest functions.




## GetNumQuestLogEntries

Returns the number of quests and headers in the quest log

**Signature:** `numEntries, numQuests = GetNumQuestLogEntries()`

**Returns:**
- `numEntries` - Total number of entries (quests and headers) (`number`)
- `numQuests` - Number of quests only (`number`)




## GetNumQuestLogRewardFactions




## GetNumQuestLogRewards

Returns the number of item rewards for the selected quest in the quest log. This function refers to items always awarded upon quest completion; for quest rewards for which the player is allowed to choose one item from among several, see GetNumQuestLogChoices.

**Signature:** `numRewards = GetNumQuestLogRewards()`

**Returns:**
- `numRewards` - Number of rewards for completing the quest (`number`)




## GetNumQuestRewards

Returns the number of different items always awarded upon completing the quest presented by a questgiver. Only valid during the accept/decline or completion stages of a quest dialog (following the `QUEST_DETAIL` or `QUEST_COMPLETE` events); otherwise may return 0 or a value from the most recently displayed quest.

**Signature:** `numQuestRewards = GetNumQuestRewards()`

**Returns:**
- `numQuestRewards` - Number of different items always awarded upon completing the quest (`number`)

**See also:** Quest functions.




## GetNumQuestWatches

Returns the number of quests included in the objectives tracker

**Signature:** `numWatches = GetNumQuestWatches()`

**Returns:**
- `numWatches` - Number of quests from the quest log currently marked for watching (`number`)




## GetNumRaidMembers

Returns the number of members in the player's raid

**Signature:** `numRaidMembers = GetNumRaidMembers()`

**Returns:**
- `numRaidMembers` - Number of members in the raid (including the player) (`number`)




## GetNumRandomDungeons




## GetNumRoutes

Returns the number of hops from the current location to another taxi node. Only returns valid data while interacting with a flight master (i.e. between the `TAXIMAP_OPENED` and `TAXIMAP_CLOSED` events).

**Signature:** `numHops = GetNumRoutes(index)`

**Arguments:**
- `index` - Index of a flight point (between 1 and `NumTaxiNodes()`) (`number`)

**Returns:**
- `numHops` - Number of hops from the current location to the given node (`number`)

**See also:** Taxi/Flight functions.




## GetNumSavedInstances

Returns the number of instances to which the player is saved

**Signature:** `savedInstances = GetNumSavedInstances()`

**Returns:**
- `savedInstances` - Number of instances to which the player is saved (`number`)

**See also:** Instance functions.




## GetNumShapeshiftForms

Returns the number of abilities to be presented on the stance/shapeshift bar

**Signature:** `numForms = GetNumShapeshiftForms()`

**Returns:**
- `numForms` - Number of abilities to be presented on the stance/shapeshift bar (`number`)




## GetNumSkillLines

Returns the number of entries in the Skills UI list. Includes both character skills (including non-ranked skills such as talent schools and armor proficiencies, as well as progressively learned skills such as trade skills, weapon skills, and Defense skill) and skill group headers. Reflects the current state of the list (i.e. returns a lower number if group headers are collapsed.)

**Signature:** `numSkills = GetNumSkillLines()`

**Returns:**
- `numSkills` - Number of skills and headers to be displayed in the Skills UI (`number`)




## GetNumSockets

Returns the number of sockets on the item currently being socketed. Only returns valid information when the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `numSockets = GetNumSockets()`

**Returns:**
- `numSockets` - Number of sockets on the item (`number`)

**See also:** Socketing functions.




## GetNumSpellTabs

Returns the number of tabs in the player's spellbook

**Signature:** `numTabs = GetNumSpellTabs()`

**Returns:**
- `numTabs` - Number of spellbook tabs (`number`)




## GetNumStablePets

Returns the number of stabled pets. Returned value does not include the current pet.

**Signature:** `numPets = GetNumStablePets()`

**Returns:**
- `numPets` - Number of pets in the stables (`number`)




## GetNumStableSlots

_No snapshot available (page did not exist in archive)._




## GetNumStationeries

Returns the number of available stationery types. Always returns 1; the stationery feature for sending mail is not implemented in the current version of World of Warcraft.

**Signature:** `numStationeries = GetNumStationeries()`

**Returns:**
- `numStationeries` - Number of available stationery types (`number`)

**See also:** Mail functions.




## GetNumTalentGroups

Returns the number of talent specs a character can switch among

**Signature:** `numTalentGroups = GetNumTalentGroups(isInspect, isPet)`

**Arguments:**
- `isInspect` - true to query talent info for the currently inspected unit, false to query talent info for the player (`boolean`)
- `isPet` - true to query talent info for the player's pet, false to query talent info for the player (`boolean`)

**Returns:**
- `numTalentGroups` - Number of talent groups the character has enabled (`number`) 

 - `1` - Default
- `2` - The character has purchased Dual Talent Specialization




## GetNumTalents

Returns the number of options in a talent tab

**Signature:** `numTalents = GetNumTalents(tabIndex, inspect, pet)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)

**Returns:**
- `numTalents` - Number of different talent options (`number`)




## GetNumTalentTabs

Returns the number of talent tabs for the player, pet, or inspect target

**Signature:** `numTabs = GetNumTalentTabs(inspect, pet)`

**Arguments:**
- `inspect` - true to return information for the currently inspected unit; false to return information for the player (`boolean`)
- `pet` - true to return information for the player's pet; false to return information for the player (`boolean`)

**Returns:**
- `numTabs` - Number of talent tabs (`number`)




## GetNumTitles

Returns the number of available player titles. Includes all titles, not just those earned by the player

**Signature:** `numTitles = GetNumTitles()`

**Returns:**
- `numTitles` - Number of available player titles (`number`)

**See also:** Player information functions.




## GetNumTrackedAchievements

Returns the number of achievements flagged for display in the objectives tracker UI

**Signature:** `count = GetNumTrackedAchievements()`

**Returns:**
- `count` - Number of achievements flagged for tracking (`number`)




## GetNumTrackingTypes

Returns the number of available minimap object/unit tracking abilities

**Signature:** `count = GetNumTrackingTypes()`

**Returns:**
- `count` - Number of available tracking types (`number`)




## GetNumTradeSkills

Returns the number of entries in the trade skill listing. Entries include both group headers and individual trade skill recipes. Reflects the list as it should currently be displayed, not necessarily the complete list -- if headers are collapsed or a filter is enabled, a smaller number will be returned.

Returns 0 if a trade skill is not "open".

**Signature:** `numSkills = GetNumTradeSkills()`

**Returns:**
- `numSkills` - Number of headers and recipes to display in the trade skill list (`number`)




## GetNumTrainerServices

Returns the number of entries in the trainer service listing. Entries include both group headers and individual trainer services (i.e spells or recipes to be purchased). Reflects the list as it should currently be displayed, not necessarily the complete list -- if headers are collapsed or a filter is enabled, a smaller number will be returned.

Returns 0 if not interacting with a trainer.

**Signature:** `numServices = GetNumTrainerServices()`

**Returns:**
- `numServices` - Number of headers and services to display in the trainer service listing (`number`)




## GetNumVoiceSessionMembersBySessionID

Returns the number of members in a voice channel

**Signature:** `numMembers = GetNumVoiceSessionMembersBySessionID(sessionId)`

**Arguments:**
- `sessionId` - Index of a voice session (between 1 and `GetNumVoiceSessions()`) (`number`)

**Returns:**
- `numMembers` - Number of members in the voice channel (`number`)




## GetNumVoiceSessions

Returns the number of available voice channels. Returns 0 if voice chat is disabled.

**Signature:** `count = GetNumVoiceSessions()`

**Returns:**
- `count` - Number of available voice sessions (`number`)

**See also:** Voice functions.




## GetNumWhoResults

Returns the number of results from a Who system query

**Signature:** `numResults, totalCount = GetNumWhoResults()`

**Returns:**
- `numResults` - Number of results returned (`number`)
- `totalCount` - Number of results to display (`number`)




## GetNumWorldStateUI

Returns the number of world state UI elements. World State UI elements include PvP, instance, and quest objective information (displayed at the top center of the screen in the default UI) as well as more specific information for "control point" style PvP objectives. Examples: the Horde/Alliance score in Arathi Basin, the tower status and capture progress bars in Hellfire Peninsula, the progress text in the Black Morass and Violet Hold instances, and the event status text for quests The Light of Dawn and The Battle For The Undercity.

**Signature:** `numUI = GetNumWorldStateUI()`

**Returns:**
- `numUI` - Returns the number of world state elements (`number`)



