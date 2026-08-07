# WoW Events — Q

_12 events_

---

## QUEST_ACCEPT_CONFIRM

Fires when certain kinds of quests (e.g. NPC escort quests) are started by another member of the player's group

**Payload:** `("name", "quest")`

**Arguments:**
- `name` - The name of the user who started the quest. (`string`)
- `quest` - The name of the quest that was started. (`string`)


## QUEST_ACCEPTED

Fires when a new quest is added to the player's quest log (which is what happens after a player accepts a quest).

**Payload:** `(questIndex)`

**Arguments:**
- `questIndex` - Index where the accepted quest was placed in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)


## QUEST_COMPLETE

Fires when the player is looking at the "Complete" page for a quest, at a questgiver.. This is the portion of a questgiver dialog in which the player is offered to choose a reward (or accept the only reward) and sees the "Complete" button available. This event does NOT fire when they actually complete the quest, it fires when they SEE the "Complete" button and are offered the ability to complete the quest, and has nothing to do with whether they actually turned in the quest or not.

To avoid confusion: This event should not be used if you want to know when the player actually turns in a quest, that's not what this event does (see above).

This event happens after the portion in which the questgiver verifies the player's progress on the quest.

**Payload:** `()`


## QUEST_DETAIL

Fires when details of an available quest are presented by a questgiver. Fires for the portion of a questgiver dialog in which the the quest is described and the player is offered to accept the quest, sometimes after choosing the available quest from a greeting dialog.

**Payload:** `()`


## QUEST_FINISHED

Fires when the player ends interaction with a questgiver or ends a stage of the questgiver dialog. A typical dialogue with a questgiver is presented in four stages (though some stages may be skipped for some quests):

 
 - A greeting, in which the questgiver presents the player a choice of one or more available or active quests (presented via the `QUEST_GREETING` or `GOSSIP_SHOW` events).
 
 - After choosing an available quest, the questgiver describes its details and rewards, offering the player a chance to accept or decline the quest (presented via the `QUEST_DETAIL` event).
 
 - Upon returning (and selecting the active quest from the greeting) after accepting the quest, the questgiver verifies the player's progress on the quest and allows the player to turn it in if complete (presented via the `QUEST_PROGRESS` event).
 
 - With the completed quest turned in, the questgiver presents additional text and offers rewards for the player to choose -- or merely accept, in the case of a single reward or no reward save for XP or money (presented via the `QUEST_COMPLETE` event).

This event fires when the player completes any of the above stages of dialog, before the event presenting the next stage fires, or when the player declines or aborts interaction with the questgiver.

**Payload:** `()`


## QUEST_GREETING

Fires when a questgiver presents a greeting along with a list of active or available quests. Used only for a few questgivers; most questgivers offering multiple quests or other dialog options use the Gossip APIs instead (with `GOSSIP_SHOW` being the equivalent to this event).

**Payload:** `()`


## QUEST_ITEM_UPDATE

Fires when information about items in a questgiver dialog is updated. Only fires if information about quest items is retrieved from the server after the quest dialog is presented (via `QUEST_DETAIL`, `QUEST_PROGRESS`, `QUEST_COMPLETE`).

**Payload:** `()`


## QUEST_LOG_UPDATE

Fires when the game client receives updates relating to the player's quest log (this event is not just related to the quests inside it). There are a LOT of various things that cause the server to send quest log information to the player's client, such as: Logging into the game world, zoning between servers (anytime you see a loading screen), accepting quests, deleting/abandoning quests, completing quests, quest progress updates (achieving whole or partial objective updates for a quest), when dailies reset (the "You can only complete 25 more daily quests today" event), and whenever something regarding the DISPLAY of the quest log VISUALLY changes (such as when you collapse or expand headers in the quest log; with headers being the lines such as "Terokkar Forest", that separate the quests into groups).

This event (`QUEST_LOG_UPDATE`) should therefore only be used if you care about the QUEST LOG itself more than the quests; ie if you implement a custom quest log, then you'd use this event to update the display when things like dailies reset or headers change.

However, if you are ONLY interested in tracking QUEST-related information (accepting quests, abandoning quests, achieving quest progress, and completing quests), there's a better event: `UNIT_QUEST_LOG_CHANGED`. See its page for details.

**Payload:** `()`


## QUEST_POI_UPDATE


## QUEST_PROGRESS

Fires when interacting with a questgiver about an active quest. This is the portion of a questgiver dialog in which the questgiver verifies the player's progress on the quest (e.g. "Have you brought me all 20 gnoll ears yet?"), generally after choosing the active quest from a greeting dialog and before turning in the completed quest.

**Payload:** `()`


## QUEST_QUERY_COMPLETE

Fires when quest completion information is available from the server. This event fires in response to a call to the QueryQuestsCompleted function.

**Payload:** `()`


## QUEST_WATCH_UPDATE

Fires when the player's status regarding a quest's objectives changes, for instance picking up a required object or killing a mob for that quest. All forms of (quest objective) progress changes will trigger this event.

**Payload:** `(questIndex)`

**Arguments:**
- `questIndex` - Index of the affected quest in the quest log (between 1 and `GetNumQuestLogEntries()`) (`number`)

