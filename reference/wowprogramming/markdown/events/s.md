# WoW Events — S

_16 events_

---

## SCREENSHOT_FAILED

Fires if an attempt to take a screenshot fails

**Payload:** `()`


## SCREENSHOT_SUCCEEDED

Fires when a screenshot is successfully taken

**Payload:** `()`


## SEND_MAIL_COD_CHANGED

Fires when the Cash On Delivery cost assigned for the outgoing mail message changes

**Payload:** `()`


## SEND_MAIL_MONEY_CHANGED

Fires when the amount of money attached to the outgoing mail message changes

**Payload:** `()`


## SKILL_LINES_CHANGED

Fires when the content of the player's skill list changes. Applies only to major changes to the list -- e.g. learning a new skill or raising one's level (such as from Journeyman to Master) in a trade skill -- not to skill rank increases.

**Payload:** `()`


## SOCKET_INFO_CLOSE

Fires when the player ends interaction with the item socketing UI

**Payload:** `()`


## SOCKET_INFO_UPDATE

Fires when information about the contents of the item socketing UI changes or becomes available

**Payload:** `()`


## SOUND_DEVICE_UPDATE

Fires when information about sound input/output devices changes or becomes available

**Payload:** `()`


## SPELL_UPDATE_COOLDOWN

Fires when the cooldown on one of the player's spells begins or ends. Only fires while something is being cast (i.e. beginning of cast, end of cast.) 

While the event does react to every cooldown of a spell finishing, it doesn't fire until the next spellcast. If you're waiting for this event to see if a cooldown has finished, try `SPELL_UPDATE_USABLE`

**Payload:** `()`


## SPELL_UPDATE_USABLE

Fires when a spell becomes usable or unusable. Includes when spells become unusable due to the global cooldown.

**Payload:** `()`


## SPELLS_CHANGED

Fires when information about the contents of the player's spellbook changes or becomes available. Applies to both new content (e.g. learning a new spell or tradeskill) and changes which should cause the spellbook display to change (e.g. equipping a different main hand weapon, thus changing the icon for the Attack spell).

**Payload:** `()`


## START_AUTOREPEAT_SPELL

Fires when the player casts a spell which automatically repeats. Used by (for example) Shoot for wand users.

**Payload:** `()`


## START_LOOT_ROLL

Fires when an item becomes available for group loot rolling

**Payload:** `(id, time)`

**Arguments:**
- `id` - The id for this roll (`number`)
- `time` - How long the roll will last (`number`)


## START_MINIGAME

Unused. Minigames are not implemented in the current version of the WoW client.

**Payload:** `()`


## STOP_AUTOREPEAT_SPELL

Fires when the player stops repetition of an automatically repeating spell. Used by (for example) Shoot for wand users.

**Payload:** `()`


## SYNCHRONIZE_SETTINGS

Fires when game options are manually synchronized with those saved on the server

**Payload:** `()`

