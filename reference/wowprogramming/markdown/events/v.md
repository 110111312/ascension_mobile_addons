# WoW Events — V

_19 events_

---

## VARIABLES_LOADED

Fires when non-addon-specific saved variables are loaded. Addons should generally use `ADDON_LOADED` to determine whether their saved variables have loaded.

**Payload:** `()`


## VEHICLE_ANGLE_SHOW

Fires when controls for vehicle weapon pitch should be displayed

**Payload:** `()`


## VEHICLE_ANGLE_UPDATE

Fires when the player's vehicle weapon pitch changes

**Payload:** `()`


## VEHICLE_PASSENGERS_CHANGED

Fires when the list of passengers in the player's vehicle changes

**Payload:** `()`


## VEHICLE_POWER_SHOW

Fires when controls for vehicle weapon power should be displayed

**Payload:** `()`


## VEHICLE_UPDATE

Fires when information about the player's vehicle changes or becomes available

**Payload:** `()`


## VOICE_CHANNEL_STATUS_UPDATE

Fires when voice-related status of a chat channel changes

**Payload:** `()`


## VOICE_CHAT_ENABLED_UPDATE

Fires when the client's voice chat feature is enabled or disabled

**Payload:** `()`


## VOICE_LEFT_SESSION

Fires when a voice-enabled member leaves a chat channel

**Payload:** `()`


## VOICE_PLATE_START

Fires when a channel member begins speaking in voice chat

**Payload:** `("name", "unit")`

**Arguments:**
- `name` - The username of the player thats talking (`string`)
- `unit` - The unit of the player thats talking, i.e. party1. (`string`)


## VOICE_PLATE_STOP

Fires when a channel member finishes speaking in voice chat

**Payload:** `("name", "unit")`

**Arguments:**
- `name` - The username of the player thats talking (`string`)
- `unit` - The unit of the player thats talking, i.e. party1. (`string`)


## VOICE_PUSH_TO_TALK_START

Fires when the "Push to Talk" key binding is activated

**Payload:** `()`


## VOICE_PUSH_TO_TALK_STOP

Fires when the "Push to Talk" key binding is deactivated

**Payload:** `()`


## VOICE_SELF_MUTE

Fires when the player's self mute setting changes

**Payload:** `()`


## VOICE_SESSIONS_UPDATE

Fires when information about a voice chat session changes or becomes available

**Payload:** `()`


## VOICE_START

Fires when a channel member begins speaking in voice chat

**Payload:** `("unit")`

**Arguments:**
- `unit` - The unit of the player thats talking, i.e. party1. (`string`)


## VOICE_STATUS_UPDATE

Fires when a member of the player's group changes voice chat status

**Payload:** `()`


## VOICE_STOP

Fires when a channel member finishes speaking in voice chat

**Payload:** `("unit")`

**Arguments:**
- `unit` - The unit of the player thats talking, i.e. party1. (`string`)


## VOTE_KICK_REASON_NEEDED

Fires when the player attempts to vote-kick another player and the game requests a reason

**Payload:** `()`

