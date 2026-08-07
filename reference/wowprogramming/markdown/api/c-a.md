# WoW API — C (A*)

_157 functions_

---

## CalculateAuctionDeposit

Returns the deposit amount for the item currently being set up for auction. Only returns useful information once an item has been placed in the Create Auction UI's "auction item" slot (see `ClickAuctionSellItemButton()`). 

Deposit amount for an auction varies based on the item being auction, the auction's proposed run time, and the auction house being used (i.e. faction or neutral).

**Signature:** `deposit = CalculateAuctionDeposit(runTime)`

**Arguments:**
- `runTime` - Run time of the proposed auction (`number`) 

 - `720` - 12 hours
- `1440` - 24 hours
- `2880` - 48 hours

**Returns:**
- `deposit` - Amount of the deposit (in copper) (`number`)

**See also:** Auction functions.



## CalendarAddEvent

Saves the event recently created (and selected for editing) to the calendar. Until this function is called, an event created with `CalendarNewEvent()`, `CalendarNewGuildEvent()`, or `CalendarNewGuildAnnouncement()` will not exist on the calendar -- that is, guild members or invitees will not see it, and it will not persist if the player closes the calendar, reloads the UI, or goes to view or edit another event.

**Signature:** `CalendarAddEvent()`

**See also:** Calendar functions.



## CalendarCanAddEvent

Returns whether the player can add an event to the calendar

**Signature:** `canAdd = CalendarCanAddEvent()`

**Returns:**
- `canAdd` - True if the player can add an event to the calendar; otherwise false (`boolean`)

**See also:** Calendar functions.



## CalendarCanSendInvite

Returns whether the player can invite others to a calendar event

**Signature:** `canInvite = CalendarCanSendInvite()`

**Returns:**
- `canInvite` - True if the player can invite others to a calendar event; otherwise false (`boolean`)



## CalendarCloseEvent

Deselects (ends viewing/editing on) an event. After calling this function, results of attempting to query or change event information are not guaranteed until a new event is created or another existing event is opened.

**Signature:** `CalendarCloseEvent()`



## CalendarContextDeselectEvent

Clears the event selection used only for `CalendarContext` functions. The selection state cleared by this function is used only by other `CalendarContext` functions; other calendar event functions use the selection state set by `CalendarOpenEvent`, `CalendarNewEvent`, `CalendarNewGuildEvent`, or `CalendarNewGuildAnnouncement` (if they use a selection state at all).

**Signature:** `CalendarContextDeselectEvent()`



## CalendarContextEventCanComplain

Returns whether the player can report an event invitation as spam. If all arguments are omitted, uses the event selected by `CalendarContextSelectEvent`.

**Signature:** `canReport = CalendarContextEventCanComplain([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from `1` to `CalendarGetNumDayEvents()`) (`number`)

**Returns:**
- `canReport` - `true` if the player can report the event as spam; otherwise `false` (`boolean`)

**See also:** Calendar functions, Complaint functions.



## CalendarContextEventCanEdit

Returns whether the player can edit an event

**Signature:** `canEdit = CalendarContextEventCanEdit([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from `1` to `CalendarGetNumDayEvents()`) (`number`)

**Returns:**
- `canEdit` - True if the player can edit the event (`boolean`)

**See also:** Calendar functions.



## CalendarContextEventClipboard

Returns whether the player can paste an event

**Signature:** `canPaste = CalendarContextEventClipboard()`

**Returns:**
- `canPaste` - `true` if an event has been copied via `CalendarContextEventCopy`; otherwise `false` (`boolean`)



## CalendarContextEventComplain

Reports an event invitation as spam

**Signature:** `CalendarContextEventComplain([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from `1` to `CalendarGetNumDayEvents()`) (`number`)

**See also:** Calendar functions, Complaint functions.



## CalendarContextEventCopy

Copies an event for later pasting

**Signature:** `CalendarContextEventCopy([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from `1` to `CalendarGetNumDayEvents()`) (`number`)

**See also:** Calendar functions.



## CalendarContextEventGetCalendarType

Returns the type of a calendar event. If all arguments are omitted, uses the event selected by `CalendarContextSelectEvent`.

**Signature:** `calendarType = CalendarContextEventGetCalendarType([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from `1` to `CalendarGetNumDayEvents()`) (`number`)

**Returns:**
- `calendarType` - Token identifying the type of event (`string`) 

 - `GUILD_ANNOUNCEMENT` - Guild announcement (does not allow players to sign up)
- `GUILD_EVENT` - Guild event (allows players to sign up)
- `HOLIDAY` - World event (e.g. Lunar Festival, Darkmoon Faire, Stranglethorn Fishing Tournament, Call to Arms: Arathi Basin)
- `PLAYER` - Player-created event or invitation
- `RAID_LOCKOUT` - Indicates when one of the player's saved instances resets
- `RAID_RESET` - Indicates scheduled reset times for major raid instances
- `SYSTEM` - Other server-provided event

**See also:** Calendar functions.



## CalendarContextEventPaste

Pastes a copied event into a given date. Does nothing if no event has been copied via `CalendarContextEventCopy`.

**Signature:** `CalendarContextEventPaste(monthOffset, day)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `day` - Day of the month (`number`)

**See also:** Calendar functions.



## CalendarContextEventRemove

Deletes an event from the calendar

**Signature:** `CalendarContextEventRemove([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from `1` to `CalendarGetNumDayEvents()`) (`number`)

**See also:** Calendar functions.



## CalendarContextEventSignUp

Signs the player up for a guild event

**Signature:** `CalendarContextEventSignUp([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)



## CalendarContextGetEventIndex

Returns the month, day, and index of the event selection used only for `CalendarContext` functions. The selection state referenced by this function is used only by other `CalendarContext` functions; other calendar event functions use the selection state set by `CalendarOpenEvent`, `CalendarNewEvent`, `CalendarNewGuildEvent`, or `CalendarNewGuildAnnouncement` (if they use a selection state at all).

Used in the default UI to implement the calendar's context menu (on right-click).

**Signature:** `monthOffset, day, index = CalendarContextGetEventIndex()`

**Returns:**
- `monthOffset` - Month relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `day` - Day of the month (`number`)
- `index` - Index of the event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**See also:** Calendar functions.



## CalendarContextInviteAvailable

Accepts an event invitation

**Signature:** `CalendarContextInviteAvailable([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**See also:** Calendar functions.



## CalendarContextInviteDecline

Declines an event invitation

**Signature:** `CalendarContextInviteDecline([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)



## CalendarContextInviteIsPending

Returns whether the player has been invited to an event and not yet responded

**Signature:** `pendingInvite = CalendarContextInviteIsPending([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `pendingInvite` - True if the player is invited to the event and has yet to respond; otherwise false (`boolean`)



## CalendarContextInviteModeratorStatus

Returns the player's moderator status for an event

**Signature:** `modStatus = CalendarContextInviteModeratorStatus([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `modStatus` - The player's level of authority for the event, or "" if not applicable (`number`) 

 - `CREATOR` - The player is the original creator of the event
- `MODERATOR` - The player has been granted moderator status for the event



## CalendarContextInviteRemove

Removes an invitation from the player's calendar or removes the player from a guild event's signup list

**Signature:** `CalendarContextInviteRemove([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**See also:** Calendar functions.



## CalendarContextInviteStatus

Returns the player's invite status for an event

**Signature:** `inviteStatus = CalendarContextInviteStatus([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `inviteStatus` - The player's status regarding the event (`number`) 

 - `1` - Invited (also used for non-invitation/non-signup events)
- `2` - Accepted
- `3` - Declined
- `4` - Confirmed
- `5` - Out
- `6` - Standby
- `7` - Signed up
- `8` - Not signed up

**See also:** Calendar functions.



## CalendarContextInviteTentative



## CalendarContextInviteType

Returns the invite type for an event

**Signature:** `inviteType = CalendarContextInviteType([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `inviteType` - Invitation/announcement type for the event (`number`) 

 - `1` - Characters can only be explicitly invited to the event (or event is a non-invite/non-signup event)
- `2` - Event is visible to the player's entire guild; guild members can sign up and other characters can be explicitly invited

**See also:** Calendar functions.



## CalendarContextSelectEvent

Selects an event for use only with other `CalendarContext` functions. The selection state set by this function is used only by other `CalendarContext` functions; other calendar event functions use the selection state set by `CalendarOpenEvent`, `CalendarNewEvent`, `CalendarNewGuildEvent`, or `CalendarNewGuildAnnouncement` (if they use a selection state at all).

Used in the default UI to implement the calendar's context menu (on right-click).

**Signature:** `CalendarContextSelectEvent([monthOffset,] day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `nil` - Use the event selected by `CalendarContextSelectEvent` and ignore further arguments
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)



## CalendarDefaultGuildFilter

Returns default options for the guild member Mass Invite filter

**Signature:** `minLevel, maxLevel, rank = CalendarDefaultGuildFilter()`

**Returns:**
- `minLevel` - Lowest level of characters to invite (`number`)
- `maxLevel` - Highest level of characters to invite (`number`)
- `rank` - Lowest guild rank of characters to invite (`number`)



## CalendarEventAvailable

Accepts invitation to the selected calendar event. Only applies to player-created events and invitations sent by other players; has no effect if the current calendar event is of another type.

**Signature:** `CalendarEventAvailable()`



## CalendarEventCanEdit

Returns whether the player can edit the selected calendar event

**Signature:** `canEdit = CalendarEventCanEdit()`

**Returns:**
- `canEdit` - True if the player can edit the current event; otherwise false (`boolean`)



## CalendarEventCanModerate

Returns whether an event invitee can be granted moderator authority

**Signature:** `canModerate = CalendarEventCanModerate(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and `CalendarEventGetNumInvites()`) (`number`)

**Returns:**
- `canModerate` - True if the given character can be given moderator authority for the event; otherwise false (`boolean`)



## CalendarEventClearAutoApprove

Disables the auto-approve feature (currently unused) for the selected calendar event

**Signature:** `CalendarEventClearAutoApprove()`



## CalendarEventClearLocked

Unlocks the selected calendar event. Locked events do not allow invitees to respond or guild members to sign up, but can still be edited.

**Signature:** `CalendarEventClearLocked()`

**See also:** Calendar functions.



## CalendarEventClearModerator

Removes moderator status from a character on the selected event's invite/signup list. Moderators can change the status of characters on the invite/signup list and invite more characters, but cannot otherwise edit the event.

**Signature:** `CalendarEventClearModerator(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()) (`number`)

**See also:** Calendar functions.



## CalendarEventDecline

Declines invitation to the selected calendar event. Only applies to player-created events and invitations sent by other players; has no effect if the current calendar event is of another type.

**Signature:** `CalendarEventDecline()`

**See also:** Calendar functions.



## CalendarEventGetCalendarType

Returns the type of the selected calendar event

**Signature:** `calendarType = CalendarEventGetCalendarType()`

**Returns:**
- `calendarType` - Token identifying the type of event (`string`) 

 - `GUILD_ANNOUNCEMENT` - Guild announcement (does not allow players to sign up)
- `GUILD_EVENT` - Guild event (allows players to sign up)
- `PLAYER` - Player-created event or invitation

**See also:** Calendar functions.



## CalendarEventGetInvite

Returns information about an entry in the selected event's invite/signup list

**Signature:** `name, level, className, classFileName, inviteStatus, modStatus, inviteIsMine, inviteType = CalendarEventGetInvite(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and `CalendarEventGetNumInvites()`) (`number`)

**Returns:**
- `name` - Name of the character (`string`)
- `level` - The character's current level (`number`)
- `className` - Localized name of the character's class (`string`)
- `classFileName` - Non-localized token representing the character's class (`string`)
- `inviteStatus` - The character's status regarding the event (`number`) 

 - `1` - Invited
- `2` - Accepted
- `3` - Declined
- `4` - Confirmed
- `5` - Out
- `6` - Standby
- `7` - Signed up
- `modStatus` - The character's level of authority for the event, or "" if not applicable (`number`) 

 - `CREATOR` - The character is the original creator of the event
- `MODERATOR` - The character has been granted moderator status for the event
- `inviteIsMine` - True if this list entry represents the player; otherwise false (`boolean`)
- `inviteType` - Invitation/announcement type for the event (`number`) 

 - `1` - Characters can only be explicitly invited to the event
- `2` - Event is visible to the player's entire guild; guild members can sign up and other characters can be explicitly invited



## CalendarEventGetInviteResponseTime

Returns the time at which a character on the selected event's invite/signup list responded. Returns all zeros if the character has not yet responded or is the event's creator.

**Signature:** `weekday, month, day, year, hour, minute = CalendarEventGetInviteResponseTime(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()) (`number`)

**Returns:**
- `weekday` - Index of the day of the week (starting at 1 = Sunday) (`number`)
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)
- `hour` - Hour part of the time (on a 24-hour clock) (`number`)
- `minute` - Minute part of the time (`number`)

**See also:** Calendar functions.



## CalendarEventGetInviteSortCriterion

Returns the current sort mode for the event invite/signup list

**Signature:** `criterion, reverse = CalendarEventGetInviteSortCriterion()`

**Returns:**
- `criterion` - Token identifying the attribute used for sorting the list (`string`) 

 - `class` - Sorted by character class (according to the global table `CLASS_SORT_ORDER`)
- `name` - Sorted by character name
- `status` - Sorted by invite status
- `reverse` - True if the list is sorted in reverse order; otherwise false (`boolean`)



## CalendarEventGetNumInvites

Returns the number of characters on the selected calendar event's invite/signup list

**Signature:** `numInvites = CalendarEventGetNumInvites()`

**Returns:**
- `numInvites` - Number of characters on the event's invite/signup list (`number`)

**See also:** Calendar functions.



## CalendarEventGetRepeatOptions

Returns a list of localized event repetition option labels (currently unused)

**Signature:** `... = CalendarEventGetRepeatOptions()`

**Returns:**
- `...` - List of localized event repetition option labels (`list`)

**See also:** Calendar functions.



## CalendarEventGetSelectedInvite

Returns the index of the selected entry on the selected event's invite/signup list. In the current default UI, selection behavior in the invite list is implemented but disabled; selecting an invite list entry has no effect on the behavior of other APIs.

**Signature:** `index = CalendarEventGetSelectedInvite()`

**Returns:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()), or 0 if no selection has been made (`number`)



## CalendarEventGetStatusOptions

Returns a list of localized invite status labels

**Signature:** `... = CalendarEventGetStatusOptions()`

**Returns:**
- `...` - List of localized invite status labels (`list`)

**See also:** Calendar functions.



## CalendarEventGetTextures

Returns a list of instance names and icons for dungeon or raid events

**Signature:** `name, icon, expansion = CalendarEventGetTextures(eventType)`

**Arguments:**
- `eventType` - Type (display style) of event to query (`number`) 

 - `1` - Raid dungeon
- `2` - Five-player dungeon

**Returns:**
- `name` - Name of an instance (may include heroic designation) (`string`)
- `icon` - Unique part of the path to the instance's icon texture; for the full path, prepend with `"Interface\LFGFrame\LFGIcon-"` (`string`)
- `expansion` - Expansion to which the instance belongs; localized names can be found in the constants `EXPANSION_NAME0`, `EXPANSION_NAME1`, etc. (`number`)



## CalendarEventGetTypes

Returns a list of event display style labels

**Signature:** `... = CalendarEventGetTypes()`

**Returns:**
- `...` - A list of localized event display style labels (`list`)

**See also:** Calendar functions.



## CalendarEventHasPendingInvite

Returns whether the player has been invited to the selected event and not yet responded

**Signature:** `pendingInvite = CalendarEventHasPendingInvite()`

**Returns:**
- `pendingInvite` - True if the player has been invited to the event and not yet responded; otherwise false (`boolean`)



## CalendarEventHaveSettingsChanged

Returns whether the selected event has unsaved changes

**Signature:** `settingsChanged = CalendarEventHaveSettingsChanged()`

**Returns:**
- `settingsChanged` - True if any of the event's attributes have been changed since the event was last saved; otherwise false (`boolean`)



## CalendarEventInvite

Attempts to invite a character to the selected event. If successful, the `CALENDAR_UPDATE_INVITE_LIST` event fires indicating the character has been added to the invite list; otherwise the `CALENDAR_UPDATE_ERROR` event fires containing a localized error message.

**Signature:** `CalendarEventInvite("name")`

**Arguments:**
- `name` - Name of a character to invite (`string`)



## CalendarEventIsModerator

Returns whether the player has moderator status for the selected calendar event. Also returns true if the player is the event's creator.

**Signature:** `isModerator = CalendarEventIsModerator()`

**Returns:**
- `isModerator` - True if the player has moderator status for the event; otherwise false (`boolean`)



## CalendarEventRemoveInvite

Removes a character from the selected event's invite/signup list. Cannot be used to remove the event's creator (fires a `CALENDAR_UPDATE_ERROR` event with nil error message if such is attempted).

**Signature:** `CalendarEventRemoveInvite(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()) (`number`)

**See also:** Calendar functions.



## CalendarEventSelectInvite

Selects an entry in the selected event's invite/signup list. In the current default UI, selection behavior in the invite list is implemented but disabled; selecting an invite list entry has no effect on the behavior of other APIs.

**Signature:** `CalendarEventSelectInvite(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()) (`number`)

**See also:** Calendar functions.



## CalendarEventSetAutoApprove

Enables the auto-approve feature (currently unused) for the selected calendar event

**Signature:** `CalendarEventSetAutoApprove()`

**See also:** Calendar functions.



## CalendarEventSetDate

Changes the scheduled date of the selected calendar event

**Signature:** `CalendarEventSetDate(month, day, year)`

**Arguments:**
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)

**See also:** Calendar functions.



## CalendarEventSetDescription



## CalendarEventSetLocked

Locks the selected calendar event. Locked events do not allow invitees to respond or guild members to sign up, but can still be edited.

**Signature:** `CalendarEventSetLocked()`

**See also:** Calendar functions.



## CalendarEventSetLockoutDate

Changes the lockout date associated with the selected event (currently unused). This feature is not enabled in the current version of World of Warcraft; saving an event in which the lockout date has been changed will revert it to its default of 1, 1, 1, 2000 (January 1, 2000).

**Signature:** `CalendarEventSetLockoutDate(month, day, year)`

**Arguments:**
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)

**See also:** Calendar functions.



## CalendarEventSetLockoutTime

Changes the lockout time associated with the selected event (currently unused). This feature is not enabled in the current version of World of Warcraft; saving an event in which the lockout time has been changed will revert it to its default of 0, 0 (midnight).

**Signature:** `CalendarEventSetLockoutTime(hour, minute)`

**Arguments:**
- `hour` - Hour part of the time (on a 24-hour clock) (`number`)
- `minute` - Minute part of the time (`number`)

**See also:** Calendar functions.



## CalendarEventSetModerator

Grants moderator status to a character on the selected event's invite/signup list. Moderators can change the status of characters on the invite/signup list and invite more characters, but cannot otherwise edit the event.

**Signature:** `CalendarEventSetModerator(index)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()) (`number`)



## CalendarEventSetRepeatOption

Changes the repetition option for the selected event (currently unused). This feature is not enabled in the current version of World of Warcraft; saving an event in which the repeat option has been changed will revert it to its default of 1 (Never).

**Signature:** `CalendarEventSetRepeatOption(title)`

**Arguments:**
- `title` - Index of a repeating event option; see CalendarEventGetRepeatOptions() (`number`)

**See also:** Calendar functions.



## CalendarEventSetSize

Changes the maximum number of invites/signups for the selected event (currently unused). This feature is not enabled in the current version of World of Warcraft; saving an event in which the max size has been changed will revert it to its default of 100.

**Signature:** `CalendarEventSetSize(size)`

**Arguments:**
- `size` - Maximum number of invites/signups for the event (`number`)



## CalendarEventSetStatus

Sets the status of a character on the selected event's invite/signup list

**Signature:** `CalendarEventSetStatus(index, inviteStatus)`

**Arguments:**
- `index` - Index of a character on the event's invite list (between 1 and CalendarEventGetNumInvites()) (`number`)
- `inviteStatus` - The player's status regarding the event (`number`) 

 - `1` - Invited (also used for non-invitation/non-signup events)
- `2` - Accepted
- `3` - Declined
- `4` - Confirmed
- `5` - Out
- `6` - Standby
- `7` - Signed up
- `8` - Not signed up (displays as "")

**See also:** Calendar functions.



## CalendarEventSetTextureID

Changes the raid or dungeon instance for the selected event. Only applicable if the event's `eventType` is set to 1 or 2 (see `CalendarEventSetType`).

A list of dungeon or raid instances can be found by calling `CalendarEventGetTextures` with the current `eventType`. That function returns three values (`name`, `icon`, and `expansion`) for each instance in the list; e.g. to get the `index` for use with this function, find the index of the instance's name in that list and divide by 3.

**Signature:** `CalendarEventSetTextureID(index)`

**Arguments:**
- `index` - Index of a dungeon or raid instance (`number`)

**See also:** Calendar functions.



## CalendarEventSetTime

Changes the scheduled time of the selected event

**Signature:** `CalendarEventSetTime(hour, minute)`

**Arguments:**
- `hour` - Hour part of the time (on a 24-hour clock) (`number`)
- `minute` - Minute part of the time (`number`)



## CalendarEventSetTitle

Changes the title for the selected event

**Signature:** `CalendarEventSetTitle("title")`

**Arguments:**
- `title` - A title to be displayed for the event (`string`)

**See also:** Calendar functions.



## CalendarEventSetType

Changes the display type of the selected event

**Signature:** `CalendarEventSetType(eventType)`

**Arguments:**
- `eventType` - Display type for the event; used in the default UI to determine which icon to show (`number`) 

 - `1` - Raid dungeon
- `2` - Five-player dungeon
- `3` - PvP event
- `4` - Meeting
- `5` - Other event

**See also:** Calendar functions.



## CalendarEventSignUp

Signs the player up for the selected calendar event. Only applies to guild events; has no effect if called when the current calendar event is not a guild event.

**Signature:** `CalendarEventSignUp()`

**See also:** Calendar functions.



## CalendarEventSortInvites

Sorts the event invite/signup list. Does not cause the list to automatically remain sorted; e.g. if sorted by status and a character's status is changed, the list will not be resorted until this function is called again.

**Signature:** `CalendarEventSortInvites("criterion", reverse)`

**Arguments:**
- `criterion` - Token identifying the attribute to use for sorting the list (`string`) 

 - `class` - Sort by character class (according to the global table `CLASS_SORT_ORDER`)
- `name` - Sort by character name
- `status` - Sort by invite status
- `reverse` - True to sort the lis in reverse order; otherwise false (`boolean`)

**See also:** Calendar functions.



## CalendarEventTentative



## CalendarGetAbsMonth

Returns date information for a given month and year. Note: This function is broken in WoW 3.1.1, but is expected to work as described in WoW Patch 3.2.0 and later.

**Signature:** `month, year, numDays, firstWeekday = CalendarGetAbsMonth(month, year)`

**Arguments:**
- `month` - Index of a month (starting at 1 = January) (`number`)
- `year` - Year (full four-digit year) (`number`)

**Returns:**
- `month` - Index of the month (starting at 1 = January) (`number`)
- `year` - Year (full four-digit year) (`number`)
- `numDays` - Number of days in the month (`number`)
- `firstWeekday` - Index of the weekday (starting at 1 = Sunday) for the first day of the month (`number`)



## CalendarGetDate

Returns the current date (in the server's time zone). Only returns valid information after the `PLAYER_LOGIN` event has fired.

**Signature:** `weekday, month, day, year = CalendarGetDate()`

**Returns:**
- `weekday` - Index of the day of the week (starting at 1 = Sunday) (`number`)
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)

**See also:** Calendar functions.



## CalendarGetDayEvent

Returns information about a calendar event on a given day. Information can only be retrieved for events which might be visible in the calendar's current month -- i.e. those in the current month as well as those in (roughly) the last week of the previous month and (roughly) the first two weeks of the following month. To reliably retrieve information for events outside the calendar's current month, first change the calendar's month with `CalendarSetMonth`.

**Signature:** `title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType = CalendarGetDayEvent(monthOffset, day, index)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `day` - Day of the month containing an event (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `title` - Title displayed for the event (`string`)
- `hour` - Hour part of the event's start time (on a 24-hour clock) (`number`)
- `minute` - Minute part of the event's start time (`number`)
- `calendarType` - Token identifying the type of event (`string`) 

 - `GUILD_ANNOUNCEMENT` - Guild announcement (does not allow players to sign up)
- `GUILD_EVENT` - Guild event (allows players to sign up)
- `HOLIDAY` - World event (e.g. Lunar Festival, Darkmoon Faire, Stranglethorn Fishing Tournament, Call to Arms: Arathi Basin)
- `PLAYER` - Player-created event or invitation
- `RAID_LOCKOUT` - Indicates when one of the player's saved instances resets
- `RAID_RESET` - Indicates scheduled reset times for major raid instances
- `SYSTEM` - Other server-provided event
- `sequenceType` - Display cue for multi-day events, or "" if not applicable (`string`) 

 - `END` - Last day of the event
- `INFO` - An additional specially-labeled day related the event
- `ONGOING` - Continuation of the event
- `START` - First day of the event
- `eventType` - Display type for the event; used in the default UI to determine which icon to show (`number`) 

 - `0` - Holiday or other server-provided event
- `1` - Raid dungeon
- `2` - Five-player dungeon
- `3` - PvP event
- `4` - Meeting
- `5` - Other event
- `texture` - Unique portion of the path to a texture for the event (e.g. "CalendarChildrensWeek"). The mechanism by which a full texture path can be generated is not public API, but can be found in Addons/BlizzardCalendar/Blizzard_Calendar.lua after extracting default UI files with the AddOn Kit. (`string`)
- `modStatus` - The player's level of authority for the event, or "" if not applicable (`number`) 

 - `CREATOR` - The player is the original creator of the event
- `MODERATOR` - The player has been granted moderator status for the event
- `inviteStatus` - The player's status regarding the event (`number`) 

 - `1` - Invited (also used for non-invitation/non-signup events)
- `2` - Accepted
- `3` - Declined
- `4` - Confirmed
- `5` - Out
- `6` - Standby
- `7` - Signed up
- `8` - Not signed up
- `invitedBy` - Name of the character who created (or invited the player to) the event (`string`)
- `difficulty` - Difficulty of the dungeon or raid instance associated with the event (used only for `RAID_LOCKOUT` and `RAID_RESET` events, not player-created raid/dungeon events) (`number`) 

 - `1` - Normal
- `2` - Heroic
- `inviteType` - Invitation/announcement type for the event (`number`) 

 - `1` - Characters can only be explicitly invited to the event (or event is a non-invite/non-signup event)
- `2` - Event is visible to the player's entire guild; guild members can sign up and other characters can be explicitly invited

**See also:** Calendar functions.



## CalendarGetDayEventSequenceInfo



## CalendarGetEventIndex

Returns the month, day, and index of the selected calendar event

**Signature:** `monthOffset, day, index = CalendarGetEventIndex()`

**Returns:**
- `monthOffset` - Month relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month
- `day` - Day of the month (`number`)
- `index` - Index of the event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)



## CalendarGetEventInfo

Returns information about the selected calendar event (for player/guild events)

**Signature:** `title, description, creator, eventType, repeatOption, maxSize, textureIndex, weekday, month, day, year, hour, minute, lockoutWeekday, lockoutMonth, lockoutDay, lockoutYear, lockoutHour, lockoutMinute, locked, autoApprove, pendingInvite, inviteStatus, inviteType, calendarType = CalendarGetEventInfo()`

**Returns:**
- `title` - Title displayed for the event (`string`)
- `description` - Descriptive text about the event (`string`)
- `creator` - Name of the character who created the event (`string`)
- `eventType` - Display style for the event; used in the default UI to determine which icon to show (`number`) 

 - `1` - Raid dungeon
- `2` - Five-player dungeon
- `3` - PvP event
- `4` - Meeting
- `5` - Other event
- `repeatOption` - Index of an event repetition option (see CalendarEventGetRepeatOptions); currently unused (always 1) (`number`)
- `maxSize` - Maximum number of invites/signups; currently unused (always 100) (`number`)
- `textureIndex` - Index of the dungeon or raid instance (between `1` and `select("#", CalendarEventGetTextures(eventType)) / 3` (`number`)
- `weekday` - Index of the day of the week on which the event starts (starting at 1 = Sunday) (`number`)
- `month` - Index of the month in which the event starts (starting at 1 = January) (`number`)
- `day` - Day of the month on which the event starts (`number`)
- `year` - Year in which the event starts (full four-digit year) (`number`)
- `hour` - Hour part of the event's start time (on a 24-hour clock) (`number`)
- `minute` - Minute part of the event's start time (`number`)
- `lockoutWeekday` - Currently unused (`number`)
- `lockoutMonth` - Currently unused (`number`)
- `lockoutDay` - Currently unused (`number`)
- `lockoutYear` - Currently unused (`number`)
- `lockoutHour` - Currently unused (`number`)
- `lockoutMinute` - Currently unused (`number`)
- `locked` - 1 if the event is locked (preventing invitees from responding); otherwise nil (`1nil`)
- `autoApprove` - 1 if signups to the event should be automatically approved (currently unused); otherwise nil (`1nil`)
- `pendingInvite` - 1 if the player has been invited to this event and has not yet responded; otherwise nil (`1nil`)
- `inviteStatus` - The player's status regarding the event (`number`) 

 - `1` - Invited
- `2` - Accepted
- `3` - Declined
- `4` - Confirmed
- `5` - Out
- `6` - Standby
- `7` - Signed up
- `8` - Not signed up
- `inviteType` - Invitation/announcement type for the event (`number`) 

 - `1` - Player has been explicitly invited to the event and can accept or decline
- `2` - Event is visible to the player's entire guild; player can sign up if desired
- `calendarType` - Token identifying the type of event (`string`) 

 - `GUILD_ANNOUNCEMENT` - Guild announcement (does not allow players to sign up)
- `GUILD_EVENT` - Guild event (allows players to sign up)
- `PLAYER` - Player-created event or invitation
- `SYSTEM` - Other server-provided event



## CalendarGetFirstPendingInvite

Returns the index of the first invitation on a given day to which the player has not responded

**Signature:** `index = CalendarGetFirstPendingInvite(monthOffset, day)`

**Arguments:**
- `monthOffset` - Month to query relative to the calendar's currently displayed month (i.e. 0 for current month, 1 for next month, -1 for previous month) (`number`)
- `day` - Day of the month to query (`number`)

**Returns:**
- `index` - Index of the event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)



## CalendarGetHolidayInfo

Returns additional information about a holiday event. Information can only be retrieved for events which might be visible in the calendar's current month -- i.e. those in the current month as well as those in (roughly) the last week of the previous month and (roughly) the first two weeks of the following month. To reliably retrieve information for events outside the calendar's current month, first change the calendar's month with `CalendarSetMonth`.

**Signature:** `name, description, texture = CalendarGetHolidayInfo(monthOffset, day, index)`

**Arguments:**
- `monthOffset` - Month to query relative to the calendar's currently displayed month (i.e. 0 for current month, 1 for next month, -1 for previous month) (`number`)
- `day` - Day of the month to query (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `name` - Localized name of the event (`string`)
- `description` - Localized text describing the event (`string`)
- `texture` - Unique portion of the path to a texture for the event (e.g. "CalendarChildrensWeek"). The mechanism by which a full texture path can be generated is not public API, but can be found in Addons/BlizzardCalendar/Blizzard_Calendar.lua after extracting default UI files with the AddOn Kit. (`string`)



## CalendarGetMaxCreateDate

Returns the latest date for which events may be scheduled. Currently, events can only be created up to one year from the last day of the current month (e.g. If the current date is May 19, 2009, the player is not allowed to create events scheduled for later than May 31, 2010). The default Calendar UI also does not allow viewing months beyond this date.

**Signature:** `weekday, month, day, year = CalendarGetMaxCreateDate()`

**Returns:**
- `weekday` - Index of the day of the week (starting at 1 = Sunday) (`number`)
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)



## CalendarGetMaxDate

Returns the latest date usable in the calendar system. This function currently always returns December 31st, 2030 as the max date.

**Signature:** `weekday, month, day, year = CalendarGetMaxDate()`

**Returns:**
- `weekday` - Index of the day of the week (starting at 1 = Sunday) (`number`)
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)

**See also:** Calendar functions.



## CalendarGetMinDate

Returns the earliest date usable in the calendar system. This function currently returns November 24th, 2004 as the minimum date. This is the date that World of Warcraft was launched in the U.S.

**Signature:** `weekday, month, day, year = CalendarGetMinDate()`

**Returns:**
- `weekday` - Index of the day of the week (starting at 1 = Sunday) (`number`)
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)

**See also:** Calendar functions.



## CalendarGetMinHistoryDate

Returns the earliest date for which information about past player events is available. Applies to events created by the player, invites the player accepted, and guild events or announcements. Currently, the default UI only shows past events from up to two weeks before the current date.

**Signature:** `weekday, month, day, year = CalendarGetMinHistoryDate()`

**Returns:**
- `weekday` - Index of the day of the week (starting at 1 = Sunday) (`number`)
- `month` - Index of the month (starting at 1 = January) (`number`)
- `day` - Day of the month (`number`)
- `year` - Year (full four-digit year) (`number`)



## CalendarGetMonth

Returns information about a calendar month

**Signature:** `month, year, numDays, firstWeekday = CalendarGetMonth([monthOffset])`

**Arguments:**
- `monthOffset` - Month to query relative to the calendar's currently displayed month (i.e. 0 for current month, 1 for next month, -1 for previous month). Defaults to the calendar's current month if omitted. (`number`)

**Returns:**
- `month` - Index of the month (starting at 1 = January) (`number`)
- `year` - Year (full four-digit year) (`number`)
- `numDays` - Number of days in the month (`number`)
- `firstWeekday` - Index of the weekday (starting at 1 = Sunday) for the first day of the month (`number`)

**See also:** Calendar functions.



## CalendarGetMonthNames

Returns a list of localized month names

**Signature:** `... = CalendarGetMonthNames()`

**Returns:**
- `...` - A list of localized month names in calendar order (i.e. 1 = January) (`list`)

**See also:** Calendar functions.



## CalendarGetNumDayEvents

Returns the number of calendar events on a given day

**Signature:** `numEvents = CalendarGetNumDayEvents(monthOffset, day)`

**Arguments:**
- `monthOffset` - Month to query relative to the calendar's currently displayed month (i.e. 0 for current month, 1 for next month, -1 for previous month) (`number`)
- `day` - Day of the month to query (`number`)

**Returns:**
- `numEvents` - Number of events on the given day (`number`)

**See also:** Calendar functions.



## CalendarGetNumPendingInvites

Returns the number of calendar invitations to which the player has yet to respond

**Signature:** `numInvites = CalendarGetNumPendingInvites()`

**Returns:**
- `numInvites` - Number of pending calendar invitations (`number`)

**See also:** Calendar functions.



## CalendarGetRaidInfo

Returns information about a raid lockout or scheduled raid reset event. Information can only be retrieved for events which might be visible in the calendar's current month -- i.e. those in the current month as well as those in (roughly) the last week of the previous month and (roughly) the first two weeks of the following month. To reliably retrieve information for events outside the calendar's current month, first change the calendar's month with `CalendarSetMonth`.

**Signature:** `title, calendarType, raidID, hour, minute, difficulty = CalendarGetRaidInfo(monthOffset, day, index)`

**Arguments:**
- `monthOffset` - Month to query relative to the calendar's currently displayed month (i.e. 0 for current month, 1 for next month, -1 for previous month) (`number`)
- `day` - Day of the month to query (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)

**Returns:**
- `title` - Title displayed for the event (`number`)
- `calendarType` - Token identifying the type of event (`string`) 

 - `RAID_LOCKOUT` - Indicates when one of the player's saved instances resets
- `RAID_RESET` - Indicates scheduled reset times for major raid instances
- `raidID` - ID number of the instance to which the player is saved, or 0 if not applicable (`number`)
- `hour` - Hour part of the time at which the instance resets (on a 24-hour clock) (`number`)
- `minute` - Minute part of the time at which the instance resets (`number`)
- `difficulty` - Difficulty of the dungeon or raid instance associated with the event (`number`) 

 - `1` - Normal
- `2` - Heroic



## CalendarGetWeekdayNames

Returns a list of localized weekday names

**Signature:** `... = CalendarGetWeekdayNames()`

**Returns:**
- `...` - A list of localized weekday names in calendar order (i.e. 1 = Sunday) (`list`)



## CalendarIsActionPending

Returns whether an update to calendar information is in progress. Returns true while the client is synchronizing its calendar information from the server; e.g. after calling CalendarOpenEvent, CalendarAddEvent, or CalendarUpdateEvent. During such periods, using other calendar API functions to query or change event information may not have valid orexpected results.

**Signature:** `isPending = CalendarIsActionPending()`

**Returns:**
- `isPending` - True if an update to calendar information is in progress; otherwise false (`boolean`)

**See also:** Calendar functions.



## CalendarMassInviteArenaTeam

Repopulates the current event's invite list with members of one of the player's arena teams. Clears any invites already listed. Can only be used for events not yet created (i.e. saved to the calendar).

**Signature:** `CalendarMassInviteArenaTeam(index)`

**Arguments:**
- `index` - Index of an arena team type (`number`) 

 - `1` - 2v2 team
- `2` - 3v3 team
- `3` - 5v5 team

**See also:** Calendar functions.



## CalendarMassInviteGuild

Repopulates the selected event's invite list with members of the player's guild. Clears any invites already listed. Can only be used for events not yet created (i.e. saved to the calendar).

**Signature:** `CalendarMassInviteGuild(minLevel, maxLevel, rank)`

**Arguments:**
- `minLevel` - Lowest level of characters to invite (`number`)
- `maxLevel` - Highest level of characters to invite (`number`)
- `rank` - Lowest guild rank of characters to invite (`number`)

**See also:** Calendar functions.



## CalendarNewEvent

Creates a new event and selects it for viewing/editing

**Signature:** `CalendarNewEvent()`



## CalendarNewGuildAnnouncement

Creates a new guild announcement and selects it for viewing/editing. Guild announcements are visible to all guild members but do not allow signups or invitations.

**Signature:** `CalendarNewGuildAnnouncement()`

**See also:** Calendar functions.



## CalendarNewGuildEvent

Creates a new guild event and selects it for viewing/editing. Guild events are visible to all guild members and allow members to sign up (or non-members to be invited).

**Signature:** `CalendarNewGuildEvent()`

**See also:** Calendar functions.



## CalendarOpenEvent

Selects a calendar event for viewing/editing

**Signature:** `CalendarOpenEvent(monthOffset, day, index)`

**Arguments:**
- `monthOffset` - Month to query relative to the calendar's currently displayed month (i.e. 0 for current month, 1 for next month, -1 for previous month) (`number`)
- `day` - Day of the month to query (`number`)
- `index` - Index of an event on the given day (from 1 to CalendarGetNumDayEvents()) (`number`)



## CalendarRemoveEvent

Removes the selected event invitation from the player's calendar or removes the player from the selected guild event's signup list. NOTE: May disconnect the player if called when the selected calendar event is not a received invitation or a guild event.

**Signature:** `CalendarRemoveEvent()`



## CalendarSetAbsMonth

Set's the calendar's month to an absolute date

**Signature:** `CalendarSetAbsMonth(month [, year])`

**Arguments:**
- `month` - Index of the month (starting at 1 = January) (`number`)
- `year` - Year (full four-digit year); uses current year if omitted (`number`)

**See also:** Calendar functions.



## CalendarSetMonth

Sets the calendar's month relative to its current month

**Signature:** `CalendarSetMonth(monthOffset)`

**Arguments:**
- `monthOffset` - Month containing an event relative to the calendar's currently displayed month (`number`) 

 - `-1` - Month preceding the calendar's current month
- `0` - The calendar's current month (i.e. same month as CalendarGetMonth())
- `1` - Month after the calendar's current month

**See also:** Calendar functions.



## CalendarUpdateEvent

Saves changes made to the selected event. Until this function is called, changes made to an event will not be saved -- they will not propagate to guild members or invitees, and the event will revert to its previous state if the player closes the calendar, reloads the UI, or goes to view or edit another event.

Only applies to existing events; for newly created events use `CalendarAddEvent()` once the event's attributes and initial invite list are set.

**Signature:** `CalendarUpdateEvent()`

**See also:** Calendar functions.



## CallCompanion

Summons a non-combat pet or mount. 
If called referencing the current non-combat pet, dismisses it. Does nothing if given an index greater than `GetNumCompanions(type)`.

**Signature:** `CallCompanion("type", index)`

**Arguments:**
- `type` - Type of companion (`string`) 

 - `CRITTER` - A non-combat pet
- `MOUNT` - A mount
- `index` - Index of a companion (between 1 and `GetNumCompanions(type)`) (`number`)

**See also:** Companion functions.



## CameraOrSelectOrMoveStart

Begins camera movement or selection (equivalent to left-clicking in the 3-D world). After calling this function (i.e. while the left mouse button is held), cursor movement rotates the camera. Final results vary by context and are determined when calling `CameraOrSelectOrMoveStop()` (i.e. releasing the left mouse button).

Used by the `CAMERAORSELECTORMOVE` binding (not customizable in the default UI), which is bound to the left mouse button by default.

**Signature:** `CameraOrSelectOrMoveStart()`



## CameraOrSelectOrMoveStop

Ends action initiated by `CameraOrSelectOrMoveStart`. After calling this function (i.e. releasing the left mouse button), camera movement stops and normal cursor movement resumes. If the cursor has not moved significantly since calling `CameraOrSelectOrMoveStart()` (i.e. pressing the left mouse button) and is over a unit, that unit becomes the player's target; if the cursor has not moved significantly and is not over a unit, clears the player's target unless the "Sticky Targeting" option is enabled (i.e. the "deselectOnClick" CVar is 0).

Used by the `CAMERAORSELECTORMOVE` binding (not customizable in the default UI), which is bound to the left mouse button by default.

**Signature:** `CameraOrSelectOrMoveStop(isSticky)`

**Arguments:**
- `isSticky` - If 1, the camera will remain static until cancelled. Otherwise, the camera will pan back to be directly behind the character (`1nil`)



## CameraZoomIn

Zooms the camera in by a specified distance. 
The max distance of the camera is set in the Interface Options screen, and the maximum distance allowed is enforced by this setting, and the game client. Depending on the setting, this is between 15.0 and 24.0 in the current version of the client.

**Signature:** `CameraZoomIn(distance)`

**Arguments:**
- `distance` - The distance to zoom in (`number`)

**See also:** Camera functions.



## CameraZoomOut

Zooms the camera out by a specified distance. 
This function is used to zoom the camera out. The max distance of the camera is set in the Interface Options screen, and the maximum distance allowed is enforced by this setting, and the game client. Depending on the setting, this is between 15.0 and 24.0 in the current version of the client.

**Signature:** `CameraZoomOut(distance)`

**Arguments:**
- `distance` - The distance to zoom out (`number`)

**See also:** Camera functions.



## CanAlterSkin

Lets you check if the player can change their skin color. Returns true if the player can change their skin color while using the barbershop.

**Signature:** `canAlter = CanAlterSkin()`

**Returns:**
- `canAlter` - Can the player change skin color (`boolean`)

**See also:** Barbershop functions.



## CanCancelAuction

Returns whether one of the player's auctions can be canceled. Generally, non-cancelable auctions are those which have completed but for which payment has not yet been delivered.

**Signature:** `canCancel = CanCancelAuction(index)`

**Arguments:**
- `index` - Index of an auction in the "owner" listing (`number`)

**Returns:**
- `canCancel` - 1 if the auction can be canceled; otherwise nil (`1nil`)



## CancelAreaSpiritHeal

Declines the next upcoming periodic resurrection from a battleground spirit healer. Usable in response to the `AREA_SPIRIT_HEALER_IN_RANGE` event which fires when the player's ghost is near a battleground spirit healer.

**Signature:** `CancelAreaSpiritHeal()`

**See also:** Battlefield functions.



## CancelAuction

Cancels an auction created by the player. When canceling an auction, the deposit amount is not refunded.

**Signature:** `CancelAuction(index)`

**Arguments:**
- `index` - Index of an auction in the "owner" listing (`number`)

> **Note:** This function does not prompt the user for confirmation before its results take effect -- that behavior is provided by the default UI, and this function is called from the confirmation dialog

**See also:** Auction functions.



## CancelBarberShop

Exits a barber shop session. Causes the player character to stand up, returning to the normal world, and fires the `BARBER_SHOP_CLOSE` event. Any style changes already paid for (with `ApplyBarberShopStyle()`) are kept; any changes since are discarded.

**Signature:** `CancelBarberShop()`

**See also:** Barbershop functions.



## CancelDuel

Cancels an ongoing duel, or declines an offered duel

**Signature:** `CancelDuel()`

**See also:** Duel functions.



## CancelItemTempEnchantment

Cancels a temporary item enchant

**Signature:** `CancelItemTempEnchantment(slot)`

**Arguments:**
- `slot` - 1 to cancel the mainhand item enchant, 2 to cancel the offhand item enchant (`number`)



## CancelLogout

Cancels a pending logout or quit. Only has effect if logout or quit is pending (following the `PLAYER_CAMPING` or `PLAYER_QUITING` event).

**Signature:** `CancelLogout()`



## CancelPendingEquip

Cancels equipping a bind-on-equip item. When the player attempts to equip a bind-on-equip item, the default UI displays a dialog warning that equipping the item will cause it to become soulbound; this function is called when canceling that dialog.

**Signature:** `CancelPendingEquip(index)`

**Arguments:**
- `index` - Index of a pending equip warning; currently always 0 as only one equip warning will be given at a time (`number`)



## CancelSell



## CancelShapeshiftForm

Cancels the current shapeshift form. Unlike other Shapeshift APIs, this function refers specifically to shapeshifting -- therefore including some abilities not found on the default UI's ShapeshiftBar and excluding some which are. For example, cancels shaman Ghost Wolf form and druid shapeshifts but not warrior stances, paladin auras, or rogue stealth.

**Signature:** `CancelShapeshiftForm()`



## CancelSkillUps

_No snapshot available (page did not exist in archive)._



## CancelSummon

Declines an offered summons. Usable between when the `CONFIRM_SUMMON` event fires (due to a summoning spell cast by another player) and when the value returned by `GetSummonConfirmTimeLeft()` reaches zero.

**Signature:** `CancelSummon()`

**See also:** Summoning functions.



## CancelTrade

Cancels a trade in progress. Can be used if either party has accepted the trade, but not once both have.

**Signature:** `CancelTrade()`

**See also:** Trade functions.



## CancelTradeAccept

Cancels the player's acceptance of a trade. If the player has accepted the trade but the target has not, reverts the player to the pre-acceptance state but does not end the trade.

**Signature:** `CancelTradeAccept()`

**See also:** Trade functions.



## CancelUnitBuff

Cancels a buff on the player

**Signature:** `CancelUnitBuff("unit", index [, "filter"]) or CancelUnitBuff("unit", "name" [, "rank" [, "filter"]])`

**Arguments:**
- `unit` - A unit to query (only valid for 'player') (`string`, unitID)
- `index` - Index of an aura to query (`number`)
- `name` - Name of an aura to query (`string`)
- `rank` - Secondary text of an aura to query (often a rank; e.g. "Rank 7") (`string`)
- `filter` - A list of filters to use separated by the pipe '|' character; e.g. `"RAID|PLAYER"` will query group buffs cast by the player (`string`) 

 - `CANCELABLE` - Query auras that can be cancelled
- `HARMFUL` - Query debuffs only
- `HELPFUL` - Query buffs only
- `NOT_CANCELABLE` - Query auras that cannot be cancelled
- `PLAYER` - Query auras the player has cast
- `RAID` - Query auras the player can cast on party/raid members (as opposed to self buffs)



## CanChangePlayerDifficulty



## CanComplainChat

Returns whether a chat message can be reported as spam

**Signature:** `canComplain = CanComplainChat(lineID)`

**Arguments:**
- `lineID` - Unique identifier of a chat message (11th argument received with the corresponding `CHAT_MSG` event) (`number`)

**Returns:**
- `canComplain` - 1 if the player can report the given chat message as spam; otherwise nil (`1nil`)

**See also:** Chat functions, Complaint functions.



## CanComplainInboxItem

Returns whether a mail can be reported as spam. Returns nil for messages from Game Masters or friends, as well as for messages generated by the game itself (Auction House mail, mails from NPCs, etc).

As with most mail functions, only provides valid information if used while the mail UI is open (between the `MAIL_SHOW` and `MAIL_CLOSE` events).

**Signature:** `complain = CanComplainInboxItem(mailID)`

**Arguments:**
- `mailID` - Index of a mail in the player's inbox (between 1 and `GetInboxNumItems()`) (`number`)

**Returns:**
- `complain` - 1 if the mail can be reported as spam; otherwise nil (`1nil`)

**See also:** Complaint functions, Mail functions.



## CanEditGuildEvent

Returns whether the player is allowed to edit guild-wide calendar events

**Signature:** `canEdit = CanEditGuildEvent()`

**Returns:**
- `canEdit` - 1 if the player can create or edit guild calendar events, otherwise nil (`1nil`)

**See also:** Guild functions, Calendar functions.



## CanEditGuildInfo

Returns whether the player is allowed to edit the guild information text. This text appears when clicking the "Guild Information" button in the default UI's Guild window.

**Signature:** `canEdit = CanEditGuildInfo()`

**Returns:**
- `canEdit` - 1 if the player can edit the guild information; otherwise nil (`1nil`)

**See also:** Guild functions.



## CanEditGuildTabInfo

Returns whether the player is allowed to edit a guild bank tab's information

**Signature:** `canEdit = CanEditGuildTabInfo(tab)`

**Arguments:**
- `tab` - Index of a guild bank tab (between 1 and `GetNumGuildBankTabs()`) (`number`)

**Returns:**
- `canEdit` - 1 if the player can edit the guild bank tab; otherwise nil (`1nil`)

**See also:** Guild bank functions.



## CanEditMOTD

Returns whether the player is allowed to edit the guild Message of the Day

**Signature:** `canEdit = CanEditMOTD()`

**Returns:**
- `canEdit` - 1 if the player can edit the guild MOTD, otherwise nil (`1nil`)

**See also:** Guild functions.



## CanEditOfficerNote

Returns whether the player is allowed to edit guild officer notes

**Signature:** `canEdit = CanEditOfficerNote()`

**Returns:**
- `canEdit` - 1 if the player can edit officer notes; otherwise nil (`1nil`)

**See also:** Guild functions.



## CanEditPublicNote

Returns whether the player is allowed to edit guild public notes

**Signature:** `canEdit = CanEditPublicNote()`

**Returns:**
- `canEdit` - 1 if the player can edit public notes, otherwise nil (`1nil`)

**See also:** Guild functions.



## CanEjectPassengerFromSeat

Returns whether the player can eject the occupant of a seat in the player's vehicle

**Signature:** `canEject = CanEjectPassengerFromSeat(seat)`

**Arguments:**
- `seat` - Index of a seat in the player's vehicle (`number`)

**Returns:**
- `canEject` - True if the player can eject the seat's occupant; false if the player cannot eject the occupant or if the seat is empty (`boolean`)

**See also:** Vehicle functions.



## CanExitVehicle

Returns whether the player is in a vehicle. Used in the default UI to determine whether to show the "Leave Vehicle" button while controlling siege vehicles, turrets, and certain special mounts and quest entities.

**Signature:** `canExit = CanExitVehicle()`

**Returns:**
- `canExit` - 1 if the player is in a vehicle and can exit; otherwise nil (`1nil`)



## CanGrantLevel

Returns whether the player can give levels to a Recruit-a-Friend partner

**Signature:** `canGrant = CanGrantLevel("unit")`

**Arguments:**
- `unit` - Unit to gift a level (`string`, unitID)

**Returns:**
- `canGrant` - 1 if the player can grant a level to the unit; otherwise nil (`1nil`)



## CanGuildBankRepair

Returns whether the player is allowed to pay for repairs using guild bank funds

**Signature:** `canRepair = CanGuildBankRepair()`

**Returns:**
- `canRepair` - 1 if the player can use guild bank funds for repair; otherwise nil (`1nil`)

**See also:** Guild bank functions.



## CanGuildDemote

Returns whether the player is allowed to demote lower ranked guild members

**Signature:** `canDemote = CanGuildDemote()`

**Returns:**
- `canDemote` - 1 if the player can demote lower ranked guild members; otherwise nil (`1nil`)

**See also:** Guild functions.



## CanGuildInvite

Returns whether the player is allowed to invite new members to his or her guild

**Signature:** `canInvite = CanGuildInvite()`

**Returns:**
- `canInvite` - 1 if the player can invite members to their guild, otherwise nil (`1nil`)

**See also:** Guild functions.



## CanGuildPromote

Returns whether the player is allowed to promote other guild members. The player may promote other members only up to the rank below his or her own.

**Signature:** `canPromote = CanGuildPromote()`

**Returns:**
- `canPromote` - 1 if the player can promote other guild members; otherwise nil (`1nil`)

**See also:** Guild functions.



## CanGuildRemove

Returns whether the player is allowed to remove members from his or her guild. The player may only remove lower ranked members from the guild.

**Signature:** `canRemove = CanGuildRemove()`

**Returns:**
- `canRemove` - 1 if the player can remove a member from their guild, otherwise nil (`1nil`)



## CanHearthAndResurrectFromArea

Returns whether the player is in a world PvP zone offering an exit option. 
Used by the default UI to show the MiniMapBattlefieldFrame and provide a menu option for leaving if the player is in a world PvP combat zone (i.e. Wintergrasp).

**Signature:** `status = CanHearthAndResurrectFromArea()`

**Returns:**
- `status` - 1 if in a world PvP zone with an exit option; otherwise nil (`1nil`)

**See also:** PvP functions, Player information functions.



## CanInspect

Returns whether a unit can be inspected. Returns `nil` if the unit is out of inspect range, if the unit is an NPC, or if the unit is flagged for PvP combat and hostile to the player.

**Signature:** `canInspect = CanInspect("unit", showError)`

**Arguments:**
- `unit` - A unit to inspect (`string`, unitID)
- `showError` - True to fire a `UI_ERROR_MESSAGE` event (causing the default UI to display an error message) if the unit cannot be inspected; otherwise false (`boolean`)

**Returns:**
- `canInspect` - 1 if the unit can be inspected; otherwise nil (`1nil`)



## CanJoinBattlefieldAsGroup

Returns whether the battleground for which the player is queueing supports joining as a group

**Signature:** `canGroupJoin = CanJoinBattlefieldAsGroup()`

**Returns:**
- `canGroupJoin` - 1 if the currently displayed battlefield supports joining as a group (`1nil`)



## CanMapChangeDifficulty



## CanMerchantRepair

Returns whether the vendor with whom the player is currently interacting can repair equipment

**Signature:** `canRepair = CanMerchantRepair()`

**Returns:**
- `canRepair` - 1 if the vendor can repair equipment; otherwise nil (`1nil`)



## CannotBeResurrected



## CanPartyLFGBackfill



## CanQueueForWintergrasp

Returns whether the player can queue for Wintergrasp

**Signature:** `canQueue = CanQueueForWintergrasp()`

**Returns:**
- `canQueue` - Can the player queue for Wintergrasp (`boolean`)

**See also:** PvP functions.



## CanResetTutorials



## CanSendAuctionQuery

Returns whether the player can perform an auction house query. All auction query types are throttled, preventing abuse of the server by clients sending too many queries in short succession. Normal queries can be sent once every few seconds; mass queries return all results in the auction house instead of one "page" at a time, and can only be sent once every several minutes.

**Signature:** `canQuery, canMassQuery = CanSendAuctionQuery("list")`

**Arguments:**
- `list` - Type of auction listing (`string`) 

 - `bidder` - Auctions the player has bid on
- `list` - Auctions the player can browse and bid on or buy out
- `owner` - Auctions the player placed

**Returns:**
- `canQuery` - 1 if the player can submit an auction query; otherwise nil (`1nil`)
- `canMassQuery` - 1 if the player can submit a mass auction query; otherwise nil (`1nil`)



## CanShowAchievementUI

Returns whether the Achievements UI should be enabled. 
Used by the default UI to determine whether to show or hide the menu button for Achievements (as it also does for Talents); currently always returns true.

**Signature:** `canShow = CanShowAchievementUI()`

**Returns:**
- `canShow` - true if the Achievements UI should be enabled, otherwise false (`boolean`)

**See also:** Achievement functions.



## CanShowResetInstances

Returns whether the player can reset instances. Used to determine whether to display the "Reset Instance" option in the unit popup menu for the player.

Only instances to which the player is not saved may be reset (i.e. normal 5-man dungeons, not heroic dungeons or raids), and only by a solo player or group leader.

**Signature:** `canResetInstances = CanShowResetInstances()`

**Returns:**
- `canResetInstances` - 1 if the player can currently reset instances; otherwise nil (`1nil`)

**See also:** Instance functions.



## CanSignPetition

Returns whether the player can sign the currently offered petition. Petitions can only be signed once per account, rather than once per character.

**Signature:** `canSign = CanSignPetition()`

**Returns:**
- `canSign` - 1 if the player can sign the offered petition; otherwise nil (`1nil`)

**See also:** Petition functions.



## CanSummonFriend

Returns whether a unit can be summoned via Recruit-a-Friend. Indicates whether the target unit is currently summonable, not just whether that unit's account is linked to the player's via the Recruit-A-Friend program.

**Signature:** `canSummon = CanSummonFriend("name") or CanSummonFriend("unit")`

**Arguments:**
- `name` - Exact name of a player to summon (`string`)
- `unit` - A unit to summon (`string`, unitID)

**Returns:**
- `canSummon` - 1 if the unit can be summoned, otherwise nil (`1nil`)

**See also:** Recruit-a-friend functions.



## CanSwitchVehicleSeat

Returns whether the player can change vehicle seats. Tells you if the player can switch seats in general, whereas UnitVehicleSeatInfo() tells you if the player can switch into a specific seat.

**Signature:** `canSwitch = CanSwitchVehicleSeat()`

**Returns:**
- `canSwitch` - Can the player change vehicle seats (`boolean`)

**See also:** Vehicle functions.



## CanSwitchVehicleSeats

Returns whether the player is in a vehicle with multiple seats

**Signature:** `canSwitch = CanSwitchVehicleSeats()`

**Returns:**
- `canSwitch` - 1 if the player can switch seats; otherwise nil (`1nil`)

**See also:** Vehicle functions.



## CanUseEquipmentSets

Returns whether the player has enabled the equipment manager. Despite the name, this returns true when the player has enabled the use of the equipment manager through the interface or CVars.

**Signature:** `enabled = CanUseEquipmentSets()`

**Returns:**
- `enabled` - Has the player enable the equipment manager (`boolean`)



## CanViewOfficerNote

Returns whether the player is allowed to view guild officer notes

**Signature:** `canView = CanViewOfficerNote()`

**Returns:**
- `canView` - 1 if the player can view officer notes, otherwise nil (`1nil`)

**See also:** Guild functions.



## CanWithdrawGuildBankMoney

Returns whether the player is allowed to withdraw money from the guild bank

**Signature:** `canWithdraw = CanWithdrawGuildBankMoney()`

**Returns:**
- `canWithdraw` - 1 if the player can withdraw money from the guild bank; otherwise nil (`1nil`)



## CastPetAction

Casts a pet action on a specific target

**Signature:** `CastPetAction(index [, "unit"])`

**Arguments:**
- `index` - Index of a pet action button (between 1 and `NUM_PET_ACTION_SLOTS`) (`number`)
- `unit` - A unit to be used as target for the action (`string`, unitID)

**See also:** Pet functions, Action functions.



## CastShapeshiftForm

Casts an ability on the stance/shapeshift bar

**Signature:** `CastShapeshiftForm(index)`

**Arguments:**
- `index` - Index of an ability on the stance/shapeshift bar (between 1 and `GetNumShapeshiftForms()`) (`number`)



## CastSpell

Casts a from the spellbook. Only protected (i.e. usable only by the Blizzard UI) if the given `id` corresponds to a spell which can be cast (not a passive spell) and is not a trade skill; can be used by addons to cast the "spells" that open trade skill windows.

**Signature:** `CastSpell(id, "bookType")`

**Arguments:**
- `id` - Index of a spell in the spellbook (`number`, spellbookID)
- `bookType` - Type of spellbook (`string`) 

 - `pet` - The pet's spellbook
- `spell` - The player's spellbook

**See also:** Spell functions.



## CastSpellByID

Casts a spell specified by id (optionally on a specified unit). Only protected (i.e. usable only by the Blizzard UI) if the given spell is castable (not passive) and is not a trade skill; can be used by addons to cast the "spells" that open trade skill windows.

**Signature:** `CastSpellByID(spellID [, "target"])`

**Arguments:**
- `spellID` - ID of the spell to cast (`number`, spellID)
- `target` - A unit to target with the spell (`string`, unitID)

**See also:** Spell functions.



## CastSpellByName

Casts a spell specified by name (optionally on a specified unit). Only protected (i.e. usable only by the Blizzard UI) if the given spell is castable (not passive) and is not a trade skill; can be used by addons to cast the "spells" that open trade skill windows.

**Signature:** `CastSpellByName("name" [, "target"])`

**Arguments:**
- `name` - Name of a spell to cast (`string`)
- `target` - A unit to target with the spell (`string`, unitID)


