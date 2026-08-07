# WoW Events — M

_26 events_

---

## MACRO_ACTION_BLOCKED

Fires when a macro script attempts to use a protected API

**Payload:** `()`


## MACRO_ACTION_FORBIDDEN

Fires when a macro script attempts to use a protected API

**Payload:** `()`


## MAIL_CLOSED

Fires when the player ends interaction with a mailbox

**Payload:** `()`


## MAIL_FAILED

Fires when an outgoing mail message fails to send. Can occur when the player attempts to send mail to an unknown recipient, or trying to send Bind on Account items to a character not on the player's account.

**Payload:** `()`


## MAIL_INBOX_UPDATE

Fires when information about the contents of the player's inbox changes or becomes available

**Payload:** `()`


## MAIL_LOCK_SEND_ITEMS


## MAIL_SEND_INFO_UPDATE

Fires when information about the outgoing mail message's attachments changes

**Payload:** `()`


## MAIL_SEND_SUCCESS

Fires when an outgoing message is successfully sent

**Payload:** `()`


## MAIL_SHOW

Fires when the player begins interaction with a mailbox

**Payload:** `()`


## MAIL_SUCCESS


## MAIL_UNLOCK_SEND_ITEMS


## MERCHANT_CLOSED

Fires when the player ends interaction with a vendor

**Payload:** `()`


## MERCHANT_SHOW

Fires when the player begins interaction with a vendor

**Payload:** `()`


## MERCHANT_UPDATE

Fires when information about a vendor's available items changes or becomes available. This event is most meaningful when it fires in response to the player purchasing an item for which the vendor has a limited supply, but it also fires in response to any other vendor transaction.

**Payload:** `()`


## MINIGAME_UPDATE

Unused. Minigames are not implemented in the current version of the WoW client.

**Payload:** `()`


## MINIMAP_PING

Fires when the player or a group member "pings" a point on the minimap to share its location with the group

**Payload:** `("unit", x, y)`

**Arguments:**
- `unit` - The unit of the player that was the source of said event (`string`)
- `x` - The x coordinate. 0 is the center point going out to .5 to the right and -.5 to the left. (`number`)
- `y` - The y coordinate. 0 is the center point going out to .5 to the top and -.5 to the bottom. (`number`)


## MINIMAP_UPDATE_TRACKING

Fires when the player's currently active tracking ability changes. Applies to both tracking spells (such as a hunter's Track Beasts or a miner's Find Minerals) and UI tracking abilities provided to all players (such as finding Repair vendors or Low Level Quests).

**Payload:** `()`


## MINIMAP_UPDATE_ZOOM

Fires when the minimap zoom type changes. The client stores separate zoom level settings for both indoor and outdoor areas; this event fires so that the minimap's zoom level can be changed when the player moves between such areas. It does not fire when directly setting the minimap's zoom level.

**Payload:** `()`


## MIRROR_TIMER_PAUSE

Fires when a special countdown timer is paused. Mirror timers are used for breath and fatigue when swimming and for the hunter Feign Death ability.

**Payload:** `(duration)`

**Arguments:**
- `duration` - How long the timers should be paused. (`number`)


## MIRROR_TIMER_START

Fires when a special countdown timer starts. Mirror timers are used for breath and fatigue when swimming and for the hunter Feign Death ability.

**Payload:** `("name", value, maxvalue, step, pause, "label")`

**Arguments:**
- `name` - The name of the timer that is starting. (`string`)
- `value` - The current value of the timer. (`number`)
- `maxvalue` - The max value of the timer. (`number`)
- `step` - The step that the value moves. (`number`)
- `pause` - Signifies whether the timer is paused. (`number`)
- `label` - The label for the timer. (`string`)


## MIRROR_TIMER_STOP

Fires when a special countdown timer stops. Mirror timers are used for breath and fatigue when swimming and for the hunter Feign Death ability.

**Payload:** `("name")`

**Arguments:**
- `name` - The name associated with the timer that stopped. (`string`)


## MODIFIER_STATE_CHANGED

Fires when a modifier key is pressed or released.

**Payload:** `("key", state)`

**Arguments:**
- `key` - The name of the key that you pressed. Possible values are LSHIFT, RSHIFT, LCTRL, RCTRL, LALT, and RALT. (`string`)
- `state` - The state the key has entered. 1 means that the the key has been pressed. 0 means that the key has been released. (`number`)


## MOVIE_COMPRESSING_PROGRESS

Fires when compression of a movie recording starts

**Payload:** `()`


## MOVIE_RECORDING_PROGRESS

Fires when movie recording starts

**Payload:** `()`


## MOVIE_UNCOMPRESSED_MOVIE

Fires when the client prompts the player to allow compression of a movie recording

**Payload:** `("filename")`

**Arguments:**
- `filename` - The filename of the movie to compress (`string`)


## MUTELIST_UPDATE

Fires when the content of the player's muted list becomes available or changes

**Payload:** `()`

