# WoW Events — R

_12 events_

---

## RAID_INSTANCE_WELCOME

Fires when the player enters an instance that has a reset timer

**Payload:** `("name", ttl)`

**Arguments:**
- `name` - The name of the instance you're entering (`string`)
- `ttl` - The time till the instance resets, in seconds. (`number`)


## RAID_ROSTER_UPDATE

Fires when the raid roster changes. This occurs when a raid is formed or disbanded, if members join or leave or are moved between raid subgroups, if the loot policy or loot master is changed, or if raid leader, assistant, main tank or main assist attributes are changed.

**Payload:** `()`


## RAID_TARGET_UPDATE

Fires when raid target icons are assigned or cleared

**Payload:** `()`


## RAISED_AS_GHOUL

Fires when the player is raised as a ghoul by a friendly death knight

**Payload:** `()`


## READY_CHECK

Fires when a ready check is triggered

**Payload:** `("name")`

**Arguments:**
- `name` - The username of the person who triggered the ready check (`string`)


## READY_CHECK_CONFIRM

Fires when a unit responds to a ready check

**Payload:** `(id, response)`

**Arguments:**
- `id` - The unitid without raid or party prefix (`number`)
- `response` - `true` if the unit is ready, otherwise `false`. (`boolean`)


## READY_CHECK_FINISHED

Fires when a ready check ends

**Payload:** `()`


## RECEIVED_ACHIEVEMENT_LIST


## REPLACE_ENCHANT

Fires when the player attempts to enchant an item which is already enchanted

**Payload:** `("current", "new")`

**Arguments:**
- `current` - The name of the current enchant. (`string`)
- `new` - The name of the proposed enchant. (`string`)


## RESURRECT_REQUEST

Fires when another character offers to resurrect the player

**Payload:** `("name")`

**Arguments:**
- `name` - The name of the user who is attempting to ressurect you/ (`string`)


## RUNE_POWER_UPDATE

Fires when the availability of one of the player's rune resources changes

**Payload:** `("runeIndex", "isEnergize")`

**Arguments:**
- `runeIndex` - the runeIndex that was affected. (`string`)
- `isEnergize` - if the rune was energized. (`string`)


## RUNE_TYPE_UPDATE

Fires when the type of one of the player's rune resources changes

**Payload:** `(runeIndex)`

**Arguments:**
- `runeIndex` - the runeIndex that was affected. (`number`)

