# WoW API Functions — G (other)

_37 functions_

---

## GameMovieFinished

Ends in-game movie playback

**Signature:** `GameMovieFinished()`

**See also:** In-game movie playback functions.



## gcinfo

Returns the total Lua memory usage. Deprecated in Lua 5.1; use `collectgarbage("count")` instead.

**Signature:** `count = gcinfo()`

**Returns:**
- `count` - Total Lua memory usage (in kilobytes) (`number`)

> **Note:** This function is deprecated and is no longer in use



## GiveMasterLoot

Awards a loot item to a group member. Has no effect if the player is not the loot master or if no loot or candidate matching the given parameters exists.

**Signature:** `GiveMasterLoot(slot, index)`

**Arguments:**
- `slot` - Index of a loot slot (between 1 and `GetNumLootItems()`) (`number`)
- `index` - Index of a loot candidate (see `GetMasterLootCandidate()`) (`number`)

**See also:** Loot functions.



## GlyphMatchesSocket

Returns whether a socket is eligible for the glyph currently awaiting a target. 
Only valid during glyph application: when the player has activated the glyph item but before she has chosen the glyph slot to put it in (i.e. the glowing hand cursor is showing).

**Signature:** `match = GlyphMatchesSocket(socket)`

**Arguments:**
- `socket` - Which glyph socket to query (between 1 and `NUM_GLYPH_SLOTS`) (`number`, glyphIndex)

**Returns:**
- `match` - 1 if the glyph awaiting a target fits the given socket; nil if it doesn't fit or if no glyph is awaiting a target (`1nil`)

**See also:** Glyph functions.



## gmatch

Returns an iterator function for finding pattern matches in a string. Alias for the standard library function `string.gmatch`.

**Signature:** `iterator = gmatch("s", "pattern")`

**Arguments:**
- `s` - A string (`string`)
- `pattern` - A regular expression pattern (`string`, pattern)

**Returns:**
- `iterator` - A function which, each time it is called, returns the next capture of `pattern` in the string `s`; always returns the whole string if `pattern` specifies no captures (`function`)

**See also:** Lua library functions.



## GMReportLag



## GMRequestPlayerInfo



## GMResponseNeedMoreHelp

Requests further GM interaction on a ticket to which a GM has already responded

**Signature:** `GMResponseNeedMoreHelp()`



## GMResponseResolve

Notifies the server that the player's GM ticket issue has been resolved

**Signature:** `GMResponseResolve()`

**See also:** GM Ticket functions.



## GMSurveyAnswer

Returns text of multiple-choice question answers in a GM survey

**Signature:** `answerText = GMSurveyAnswer(questionIndex, answerIndex)`

**Arguments:**
- `questionIndex` - Index of a survey question (between 1 and `MAX_SURVEY_QUESTIONS`) (`number`)
- `answerIndex` - Index of one of the question's answers (between 1 and `MAX_SURVEY_ANSWERS`) (`number`)

**Returns:**
- `answerText` - Text of the answer choice (`string`)



## GMSurveyAnswerSubmit

Submits an answer to a GM survey question

**Signature:** `GMSurveyAnswerSubmit(question, rank, "comment")`

**Arguments:**
- `question` - The index of the question being answered (`number`)
- `rank` - The rank selected (`number`)
- `comment` - A comment for the given question (`string`)

**See also:** GM Survey functions.



## GMSurveyCommentSubmit

Submits a comment to the current GM survey

**Signature:** `GMSurveyCommentSubmit("comment")`

**Arguments:**
- `comment` - The comment made on the GM Survey (`string`)

**See also:** GM Survey functions.



## GMSurveyNumAnswers

Returns the number of possible answers for a GM Survey question. Deprecated; default UI uses the constant `MAX_SURVEY_ANSWERS` instead.

**Signature:** `numAnswers = GMSurveyNumAnswers(questionIndex)`

**Arguments:**
- `questionIndex` - Index of a survey question (between 1 and `MAX_SURVEY_QUESTIONS`) (`number`)

**Returns:**
- `numAnswers` - Number of multiple-choice answers to present for the question (`number`)

**See also:** GM Survey functions.



## GMSurveyQuestion

Returns the text of a specific question from a GM survey

**Signature:** `surveyQuestion = GMSurveyQuestion(index)`

**Arguments:**
- `index` - The index of a GM survey question (`number`)

**Returns:**
- `surveyQuestion` - The question being asked (`string`)

**See also:** GM Survey functions.



## GMSurveySubmit

Submits the current GM survey

**Signature:** `GMSurveySubmit()`

**See also:** GM Survey functions.



## GrantLevel

Grants a level to the player's Recruit-a-Friend partner. Does not immediately cause the partner character to level up: that player is given a chance to accept or decline the offered level.

**Signature:** `GrantLevel("unit")`

**Arguments:**
- `unit` - Unit to gift a level (`string`, unitID)

**See also:** Recruit-a-friend functions.



## gsub

Returns a string in which occurrences of a pattern are replaced. Alias for the standard library function `string.gsub`.

**Signature:** `newString, numMatched = gsub("s", "pattern", "rep" [, maxReplaced]) or gsub("s", "pattern", repTable [, maxReplaced]) or gsub("s", "pattern", repFunc [, maxReplaced])`

**Arguments:**
- `s` - A string (`string`)
- `pattern` - A regular expression pattern (`string`, pattern)
- `rep` - String with which to replace occurrences of `pattern`; may contain specifiers for numbered captures in the `pattern` (`string`)
- `repTable` - Table containing replacement strings; replacements are looked up using captured substrings as keys, or the entire match if `pattern` specifies no captures (`table`)
- `repFunc` - Function to supply replacement strings; called with captured substrings (or the entire match if `pattern` specifies no captures) as arguments (`function`)
- `maxReplaced` - Maximum number of replacements to be made (`number`)

**Returns:**
- `newString` - A copy of `s` in which occurrences of the `pattern` have been replaced as specified (`string`)
- `numMatched` - Number of matches found (`number`)



## GuildControlAddRank

Adds a new rank to the player's guild. The newly added rank becomes the lowest rank in the guild.

**Signature:** `GuildControlAddRank("name")`

**Arguments:**
- `name` - Name of the new rank (`string`)



## GuildControlDelRank

Deletes a guild rank

**Signature:** `GuildControlDelRank("name")`

**Arguments:**
- `name` - Name of the rank to delete (`string`)



## GuildControlGetNumRanks

Returns the number of ranks in the guild

**Signature:** `numRanks = GuildControlGetNumRanks()`

**Returns:**
- `numRanks` - Number of guild ranks (including Guild Leader) (`number`)

**See also:** Guild functions.



## GuildControlGetRankFlags

Returns the list of privileges for the guild rank being edited. The name of a privilege for an index in this list can be found in the global variable `"GUILDCONTROL_OPTION"..index`.

**Signature:** `... = GuildControlGetRankFlags()`

**Returns:**
- `...` - A list of privilege flags (1 = privilege allowed, nil = privilege denied) for the rank being edited (`list`)

**See also:** Guild functions.



## GuildControlGetRankName

Returns the name of a guild rank

**Signature:** `rankName = GuildControlGetRankName(rank)`

**Arguments:**
- `rank` - Index of a rank to edit (between 1 and `GuildControlGetNumRanks()`) (`number`)

**Returns:**
- `rankName` - Name of the guild rank (`string`)



## GuildControlSaveRank

Saves changes to the guild rank being edited

**Signature:** `GuildControlSaveRank("name")`

**Arguments:**
- `name` - New name for the guild rank (`string`)

**See also:** Guild functions.



## GuildControlSetRank

Chooses a guild rank to edit

**Signature:** `GuildControlSetRank(rank)`

**Arguments:**
- `rank` - Index of a rank to edit (between 1 and `GuildControlGetNumRanks()`) (`number`)



## GuildControlSetRankFlag

Enables or disables a privilege for the guild rank being edited. Changes are not saved until a call is made to `GuildControlSaveRank()`.

**Signature:** `GuildControlSetRankFlag(index, enabled)`

**Arguments:**
- `index` - Index of a privilege to change (`number`) 

 - `1` - Guildchat listen
- `2` - Guildchat speak
- `3` - Officerchat listen
- `4` - Officerchat speak
- `5` - Promote
- `6` - Demote
- `7` - Invite Member
- `8` - Remove Member
- `9` - Set MOTD
- `10` - Edit Public Notes
- `11` - View Officer Note
- `12` - Edit Officer Note
- `13` - Modify Guild Info
- `15` - Use guild funds for repairs
- `16` - Withdraw gold from the guild bank
- `17` - Create Guild Event
- `enabled` - True to allow the privilege; false to deny (`boolean`)

**See also:** Guild functions.



## GuildDemote

Reduces a guild member's rank by one. The player can only demote members whose rank is below the player's own, and only if the player has permission to demote (i.e. if `CanGuildDemote()` returns 1).

**Signature:** `GuildDemote("name")`

**Arguments:**
- `name` - Name of a guild member to demote (`string`)



## GuildDisband

Disbands the player's guild. Only has effect if the player is the guild leader

**Signature:** `GuildDisband()`



## GuildInfo

Requests guild information from the server. Fires two `CHAT_MSG_SYSTEM` events, one containing the name of the guild, followed by one containing the date the guild was created and how many players and accounts belong to the guild.

**Signature:** `GuildInfo()`

**See also:** Guild functions.



## GuildInvite

Invites a character to join the player's guild

**Signature:** `GuildInvite("name")`

**Arguments:**
- `name` - Name of a character to invite (`string`)

**See also:** Guild functions.



## GuildLeave

Leaves the player's current guild

**Signature:** `GuildLeave()`



## GuildPromote

Increases a guild member's rank by one. The player can only promote members up to the rank immediately below the player's own, and only if the player has permission to promote (i.e. if `CanGuildPromote()` returns 1).

**Signature:** `GuildPromote("name")`

**Arguments:**
- `name` - Name of a guild member to promote (`string`)

**See also:** Guild functions.



## GuildRoster

Requests guild roster information from the server. Information is not returned immediately; the `GUILD_ROSTER_UPDATE` event fires when data is available for retrieval via `GetGuildRosterInfo()` and related functions. Requests are throttled to reduce server load; the server will only respond to a new request approximately 10 seconds after a previous request.

**Signature:** `GuildRoster()`

**See also:** Guild functions.



## GuildRosterSetOfficerNote

Sets the officer note for a guild member

**Signature:** `GuildRosterSetOfficerNote(index, "note")`

**Arguments:**
- `index` - Index of a member in the guild roster (between 1 and `GetNumGuildMembers()`), or 0 for no selection (`number`)
- `note` - Note text to set for the guild member (up to 31 characters) (`string`)

**See also:** Guild functions.



## GuildRosterSetPublicNote

Sets the public note for a guild member

**Signature:** `GuildRosterSetPublicNote(index, "note")`

**Arguments:**
- `index` - Index of a member in the guild roster (between 1 and `GetNumGuildMembers()`), or 0 for no selection (`number`)
- `note` - Note text to set for the guild member (up to 31 characters) (`string`)



## GuildSetLeader

Promotes a member to guild leader. Only works if the player is the guild leader and the named character is in the guild and currently online.

**Signature:** `GuildSetLeader("name")`

**Arguments:**
- `name` - Name of a guild member to promote to leader (`string`)

**See also:** Guild functions.



## GuildSetMOTD

Sets the guild Message of the Day. Guild members see the message of the day upon login and whenever it is changed (and cannot disable its display in the default UI), so keeping the message concise is recommended.

**Signature:** `GuildSetMOTD("message")`

**Arguments:**
- `message` - New text for the message of the day (up to 128 characters; embedded newlines allowed) (`string`)



## GuildUninvite

Removes a character from the player's guild

**Signature:** `GuildUninvite("name")`

**Arguments:**
- `name` - Name of a guild member to remove (`string`)

**See also:** Guild functions.

