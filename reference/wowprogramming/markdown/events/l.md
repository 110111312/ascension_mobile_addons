# WoW Events — L

_27 events_

---

## LANGUAGE_LIST_CHANGED

Fires when the list of known languages changes.

**Payload:** `()`


## LEARNED_SPELL_IN_TAB

Fires when a spell is learned inside of a given spell book tab, including when spells are learned upon changing the active talent spec.

**Payload:** `(spellID, tabID)`

**Arguments:**
- `spellID` - The spell id of the spell that was learned. (`number`)
- `tabID` - The id of the tab that has the updated item. (`number`)


## LEVEL_GRANT_PROPOSED

Fires when the player is offered to instantly gain a level thanks to a Recruit-A-Friend partner

**Payload:** `()`


## LFG_BOOT_PROPOSAL_UPDATE


## LFG_COMPLETION_REWARD

Fires when the player receives the completion reward for a randoms LFG dungeon

**Payload:** `()`


## LFG_LOCK_INFO_RECEIVED

Fires when LFR information is available. Fires when LFR boss kill information is available to be queried using GetLFGDungeonNumEncounters() and GetLFGDungeonEncounterInfo()

**Payload:** `()`


## LFG_OFFER_CONTINUE


## LFG_OPEN_FROM_GOSSIP


## LFG_PROPOSAL_FAILED


## LFG_PROPOSAL_SHOW

Fires when the LFD system has found a possible group. Fires when the LFD system has found a possible group, and is seeking confirmation to enter the instance (via a call to AcceptProposal).

**Payload:** `()`


## LFG_PROPOSAL_SUCCEEDED

Fires when an LFD group was successfully formed. Fires when an LFD group was successfully formed and the party is being created

**Payload:** `()`


## LFG_PROPOSAL_UPDATE

Fires when a potential group member accepts or declines the LFD offer. Fires when a potential group member accepts or declines the LFD offer.

**Payload:** `()`


## LFG_QUEUE_STATUS_UPDATE


## LFG_ROLE_CHECK_HIDE


## LFG_ROLE_CHECK_ROLE_CHOSEN


## LFG_ROLE_CHECK_SHOW


## LFG_ROLE_CHECK_UPDATE


## LFG_ROLE_UPDATE


## LFG_UPDATE

Fires when information about the player's LFG system settings changes or becomes available

**Payload:** `()`


## LFG_UPDATE_RANDOM_INFO

Fires when instance information is available for populating the LFD frame

**Payload:** `()`


## LOCALPLAYER_PET_RENAMED

Fires when the player's pet is renamed. Primarily applies to hunter pets.

**Payload:** `()`


## LOGOUT_CANCEL

Fires when the logout countdown is aborted. The player is required to wait several seconds before logging out or quitting if not in an inn, major city or other "resting" area -- this method fires if the player attempts to log out or quit, starting the countdown, and then performs an action which aborts it.

**Payload:** `()`


## LOOT_BIND_CONFIRM

Fires when the player attempts to loot a Bind on Pickup item

**Payload:** `(slotID)`

**Arguments:**
- `slotID` - The id of the loot slot in question. (`number`)


## LOOT_CLOSED

Fires when the player ends interaction with a lootable corpse or object. Fires regardless of whether looting ended by closing the default UI's loot window, looting all of its contents, or moving too far away from the corpse or object.

**Payload:** `()`


## LOOT_OPENED

Fires when the player begins interaction with a lootable corpse or object

**Payload:** `(autoLoot)`

**Arguments:**
- `autoLoot` - Specifies if the target should be autolooted or not. (`boolean`)


## LOOT_SLOT_CHANGED


## LOOT_SLOT_CLEARED

Fires when the contents of a loot slot are removed. Can fire due to the player looting the slot's contents or due to them being taken by another group member.

**Payload:** `(slotID)`

**Arguments:**
- `slotID` - The numeric id of the slot that was looted. (`number`)

