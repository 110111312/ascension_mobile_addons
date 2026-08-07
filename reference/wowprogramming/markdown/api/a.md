# WoW API Functions — A

_47 functions_

---

## AbandonQuest

Confirms abandoning a quest. Use `SetAbandonQuest()` first to select the quest to abandon.

**Signature:** `AbandonQuest()`


## AbandonSkill

Unlearns a skill (used only for professions)

**Signature:** `AbandonSkill(index)`

**Arguments:**
- `index` - Index of an entry in the skills list (between `1` and `GetNumSkillLines()`) (`number`)

**See also:** Skill functions.


## abs

Returns the absolute value of a number. Alias for the standard library function `math.abs`.

**Signature:** `absoluteValue = abs(x)`

**Arguments:**
- `x` - A number (`number`)

**Returns:**
- `absoluteValue` - Absolute value of `x` (`number`)

**See also:** Lua library functions.


## AcceptAreaSpiritHeal

Accepts the next upcoming periodic resurrection from a battleground spirit healer. Automatically called in the default UI in response to the `AREA_SPIRIT_HEALER_IN_RANGE` event which fires when the player's ghost is near a battleground spirit healer.

**Signature:** `AcceptAreaSpiritHeal()`

**See also:** Battlefield functions.


## AcceptArenaTeam

Accepts an invitation to join an arena team

**Signature:** `AcceptArenaTeam()`

**See also:** Arena functions.


## AcceptBattlefieldPort

Accepts the offered teleport to a battleground/arena or leaves the battleground/arena or queue. This function requires a hardware event when used to accept a teleport; it can be called without a hardware event for leaving a battleground/arena or its queue.

**Signature:** `AcceptBattlefieldPort(index, accept)`

**Arguments:**
- `index` - Index of a battleground or arena type for which the player is queued (`number`)
- `accept` - `1` to accept the offered teleport; `nil` to exit the queue or leave the battleground/arena match in progress (`1nil`)


## AcceptDuel

Accepts a proposed duel

**Signature:** `AcceptDuel()`


## AcceptGroup

Accepts an invitation to join a party or raid. Usable in response to the `PARTY_INVITE_REQUEST` event which fires when the player is invited to join a group. This function does not automatically hide the default UI's group invite dialog; doing such requires calling `StaticPopup_Hide("PARTY_INVITE")`, but only after the `PARTY_MEMBERS_CHANGED` event fires indicating the player has successfully joined the group.

**Signature:** `AcceptGroup()`


## AcceptGuild

Accepts an invitation to join a guild. Usable in response to the `GUILD_INVITE_REQUEST` event, which fires when the player is invited to join a guild.

**Signature:** `AcceptGuild()`

**See also:** Guild functions.


## AcceptLevelGrant

Accepts a level offered by the player's Recruit-a-Friend partner

**Signature:** `AcceptLevelGrant()`

**See also:** Recruit-a-friend functions.


## AcceptProposal

Accepts a LFG dungeon invite.

**Signature:** `AcceptProposal()`

**See also:** Looking for group functions.


## AcceptQuest

Accepts the quest that is currently displayed

**Signature:** `AcceptQuest()`


## AcceptResurrect

Accepts an offered resurrection spell. Not used for self-resurrection; see `UseSoulstone()` for such cases.

**Signature:** `AcceptResurrect()`

**See also:** Player information functions.


## AcceptSkillUps

**Signature:** `AcceptSkillUps()`


## AcceptSockets

Accepts changes made in the Item Socketing UI. Any gems added are permanently socketed into the item, and any existing gems replaced by new gems are destroyed. This function only has effect while the Item Socketing UI is open (i.e. between the `SOCKET_INFO_UPDATE` and `SOCKET_INFO_CLOSE` events).

**Signature:** `AcceptSockets()`


## AcceptTrade

Accepts a proposed trade

**Signature:** `AcceptTrade()`


## AcceptXPLoss

Resurrects the player at a spirit healer, accepting possible consequences. Resurrecting at a spirit healer generally results in a loss of durability (both equipped items and those in the player's bags) and may also result in the Resurrection Sickness debuff.

Early in the development of World of Warcraft, resurrecting at a spirit healer caused a loss of experience points. The change to a loss of item durability was made before the initial public release of World of Warcraft, but the name of this function was never changed.

**Signature:** `AcceptXPLoss()`

**See also:** Player information functions.


## ActionHasRange

Returns whether an action has a range restriction

**Signature:** `hasRange = ActionHasRange(slot)`

**Arguments:**
- `slot` - An action bar slot (`number`, actionID)

**Returns:**
- `hasRange` - 1 if the action has a range restriction; otherwise nil (`1nil`)


## AddChatWindowChannel

Adds a chat channel to the saved list of those displayed in a chat window. Used by the default UI's function `ChatFrame_AddChannel()` which manages the set of channel messages shown in a displayed ChatFrame.

**Signature:** `zoneChannel = AddChatWindowChannel(index, channel)`

**Arguments:**
- `index` - Index of a chat frame (between `1` and `NUM_CHAT_WINDOWS`) (`number`)
- `channel` - Name of a chat channel (`number`)

**Returns:**
- `zoneChannel` - `0` for non-zone channels, otherwise a numeric index specific to that channel (`number`)


## AddChatWindowMessages

Adds a message type to the saved list of those displayed in a chat window. Used by the default UI's function `ChatFrame_AddMessageGroup()`, which manages the set of message types shown in a displayed ChatFrame.

**Signature:** `AddChatWindowMessages(index, "messageGroup")`

**Arguments:**
- `index` - Index of a chat frame (between `1` and `NUM_CHAT_WINDOWS`) (`number`)
- `messageGroup` - Token identifying a message type (`string`, chatMsgType)


## AddFriend

Adds a character to the friends list

**Signature:** `AddFriend("name")`

**Arguments:**
- `name` - Name of a character to add to the friends list (`string`)


## AddIgnore

Adds a character to the ignore list

**Signature:** `AddIgnore("name")`

**Arguments:**
- `name` - Name of a character to add to the ignore list (`string`)

**See also:** Social functions.


## AddMute

Adds a character to the muted list for voice chat. The Muted list acts for voice chat as the Ignore list does for text chat: muted characters will never be heard regardless of which voice channels they join the player in.

**Signature:** `AddMute("name")`

**Arguments:**
- `name` - Name of a character to add to the mute list (`string`)

**See also:** Voice functions.


## AddOrDelIgnore

Adds the named character to the ignore list, or removes the character if already in the ignore list

**Signature:** `AddOrDelIgnore("fullname")`

**Arguments:**
- `fullname` - Name of a character to add to or remove from the ignore list (`string`)


## AddOrDelMute

Adds or removes a character from the voice mute list. Adds the character to the list if he/she is not already on it; removes the character if already on the list.

The Muted list acts for voice chat as the Ignore list does for text chat: muted characters will never be heard regardless of which voice channels they join the player in.

**Signature:** `AddOrDelMute("unit") or AddOrDelMute("name")`

**Arguments:**
- `unit` - A unit to mute (`string`, unitID)
- `name` - Name of a character to mute (`string`)

**See also:** Voice functions.


## AddOrRemoveFriend

Adds the named character to the friends list, or removes the character if already in the friends list

**Signature:** `AddOrRemoveFriend("name", "note")`

**Arguments:**
- `name` - Name of a character to add to or remove from the friends list (`string`)
- `note` - Note text to be associated with the friends list entry created (`string`)


## AddPreviewTalentPoints

Spends (or unspends) talent points in the Talent UI's preview mode

**Signature:** `AddPreviewTalentPoints(tabIndex, talentIndex, points, isPet, talentGroup)`

**Arguments:**
- `tabIndex` - Index of a talent tab (between 1 and `GetNumTalentTabs()`) (`number`)
- `talentIndex` - Index of a talent option (between 1 and `GetNumTalents()`) (`number`)
- `points` - Number of points to spend on the talent, or a negative number to unspend points. Values larger than allowed for the talent will be clipped to the maximum value (e.g. attempting to spend ten points on a talent that has five ranks will only spend up to five points). (`number`)
- `isPet` - True to edit talents for the player's pet, false to edit talents for the player (`boolean`)
- `talentGroup` - Which set of talents to edit, if the player has Dual Talent Specialization enabled (`number`) 

 - `1` - Primary Talents
- `2` - Secondary Talents
- `nil` - Currently active talents

**See also:** Talent functions.


## AddQuestWatch

Adds a quest to the objectives tracker

**Signature:** `AddQuestWatch(questIndex)`

**Arguments:**
- `questIndex` - Index of a quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)


## AddSkillUp

**Signature:** `AddSkillUp()`


## AddTrackedAchievement

Adds an achievement to the objectives tracker UI

**Signature:** `AddTrackedAchievement(id)`

**Arguments:**
- `id` - The numeric ID of an achievement (`number`)

**See also:** Achievement functions, Objectives tracking functions.


## AddTradeMoney

Adds the money currently on the cursor to the trade window

**Signature:** `AddTradeMoney()`

**See also:** Trade functions, Money functions, Cursor functions.


## AppendToFile


## ApplyBarberShopStyle

Purchases the selected barber shop style changes. Does not exit the barber shop session, so further changes are still allowed.

The `BARBER_SHOP_SUCCESS` and `BARBER_SHOP_APPEARANCE_APPLIED` events fire once the style change takes effect.

**Signature:** `ApplyBarberShopStyle()`

**See also:** Barbershop functions.


## ArenaTeam_GetTeamSizeID

Converts an arena team size to the appropriate numeric arena team identifier

**Signature:** `teamID = ArenaTeam_GetTeamSizeID(teamSize)`

**Arguments:**
- `teamSize` - The size of the arena team (i.e. 2 for 2v2, 3 for 3v3, etc.) (`number`)

**Returns:**
- `teamID` - The numeric identifier for the arena team of the given size (`number`, arenaTeamID)

**See also:** Arena functions.


## ArenaTeamDisband

Disbands an arena team. Only has effect if the player is captain of the given team.

**Signature:** `ArenaTeamDisband(team)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)

**See also:** Arena functions.


## ArenaTeamInviteByName

Invites a character to one of the player's arena teams

**Signature:** `ArenaTeamInviteByName(team, "name")`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)
- `name` - Name of a character to invite (`string`)

**See also:** Arena functions.


## ArenaTeamLeave

Leaves an arena team

**Signature:** `ArenaTeamLeave(team)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)

**See also:** Arena functions.


## ArenaTeamRoster

Requests arena team roster information from the server. Does not return information directly: the `ARENA_TEAM_ROSTER_UPDATE` event fires when information from the server becomes available, which can then be retrieved using `GetNumArenaTeamMembers()` and `GetArenaTeamRosterInfo()`.

Roster update requests are limited to once every 10 seconds per team. For example, calling `ArenaTeamRoster(1)` twice within ten seconds will not result in a second `ARENA_TEAM_ROSTER_UPDATE` event, but calling `ArenaTeamRoster(1)` and `ArenaTeamRoster(2)` within ten seconds will result in two `ARENA_TEAM_ROSTER_UPDATE` events (one for each team).

**Signature:** `ArenaTeamRoster(team)`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)


## ArenaTeamSetLeaderByName

Promotes an arena team member to team captain. Only has effect if the player is captain of the given team.

**Signature:** `ArenaTeamSetLeaderByName(team, "name")`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)
- `name` - Name of a team member to promote (`string`)

**See also:** Arena functions.


## ArenaTeamUninviteByName

Removes a member from an arena team

**Signature:** `ArenaTeamUninviteByName(team, "name")`

**Arguments:**
- `team` - Index of one of the player's arena teams (`number`, arenaTeamID)
- `name` - Name of a team member to remove (`string`)


## AscendStop

Stops movement initiated by `JumpOrAscendStart`. Used by the `JUMP` binding, which also controls ascent when swimming or flying. Has no meaningful effect if called while jumping (in which case movement is generally stopped by hitting the ground).

**Signature:** `AscendStop()`

**See also:** Movement functions.


## assert

Causes a Lua error if a condition is failed

**Signature:** `value = assert(condition, "message")`

**Arguments:**
- `condition` - Any value (commonly the result of an expression) (`value`)
- `message` - Error message to be produced if `condition` is `false` or `nil` (`string`)

**Returns:**
- `value` - The `condition` value provided, if not `false` or `nil` (`value`)

**See also:** Lua library functions.


## AssistUnit

Targets the unit targeted by another unit

**Signature:** `AssistUnit("unit") or AssistUnit("name")`

**Arguments:**
- `unit` - A unit to assist (`string`, unitID)
- `name` - The name of a unit to assist (`string`)


## AttackTarget

Begins auto-attack against the player's current target. (If the "Auto Attack/Auto Shot" option is turned on, also begins Auto Shot for hunters.)

**Signature:** `AttackTarget()`

**See also:** Combat functions.


## AutoEquipCursorItem

Equips the item on the cursor. The item is automatically equipped in the first available slot in which it fits. To equip an item in a specific slot, see `EquipCursorItem()`.

Causes an error message (`UI_ERROR_MESSAGE`) if the item on the cursor cannot be equipped. Does nothing if the cursor does not contain an item.

**Signature:** `AutoEquipCursorItem()`


## AutoLootMailItem

Automatically takes any attached items and money from a mail. If the mail does not have body text (which can be saved as a permanent copy), also deletes the mail.

**Signature:** `AutoLootMailItem(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**See also:** Mail functions.


## AutoStoreGuildBankItem

Withdraws the item(s) from a slot in the guild bank, automatically adding to the player's bags

**Signature:** `AutoStoreGuildBankItem(tab, slot)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)
- `slot` - Index of an item slot in the guild bank tab (between 1 and `MAX_GUILDBANK_SLOTS_PER_TAB`) (`number`)

**See also:** Guild bank functions.

