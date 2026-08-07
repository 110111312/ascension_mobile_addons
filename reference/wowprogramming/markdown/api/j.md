# WoW API Functions — J

_6 functions_

---

## JoinBattlefield

Joins the queue for a battleground instance

**Signature:** `JoinBattlefield(index, asGroup)`

**Arguments:**
- `index` - Index in the battleground queue listing (1 for the first available instance, or between 2 and `GetNumBattlefields()` for other instances) (`number`)
- `asGroup` - True to enter the player's entire party/raid in the queue; false to enter the player only (`boolean`)


## JoinChannelByName


## JoinLFG


## JoinPermanentChannel

Joins a channel, saving associated chat window settings

**Signature:** `zoneChannel, channelName = JoinPermanentChannel("name" [, "password" [, chatFrameIndex [, enableVoice]]])`

**Arguments:**
- `name` - Name of the channel to join (`string`)
- `password` - Password to use when joining (`string`)
- `chatFrameIndex` - Index of a chat frame (between 1 and `NUM_CHAT_WINDOWS`) in which to subscribe to the channel (`number`)
- `enableVoice` - True to enable voice in the channel; otherwise false (`boolean`)

**Returns:**
- `zoneChannel` - 0 for non-zone channels, otherwise a numeric index specific to that channel (`number`)
- `channelName` - Display name of the channel, if the channel was a zone channel (`string`)

**See also:** Channel functions.


## JoinTemporaryChannel

Joins a channel, but does not save associated chat window settings

**Signature:** `JoinTemporaryChannel("channel")`

**Arguments:**
- `channel` - Name of a channel to join (`string`)

**See also:** Channel functions.


## JumpOrAscendStart

Causes the player character to jump (or begins ascent if swimming or flying). Used by the `JUMP` binding, which also controls ascent when swimming or flying.

**Signature:** `JumpOrAscendStart()`

**See also:** Movement functions.

