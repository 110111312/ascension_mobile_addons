# WoW API — GetZ*

_2 functions_

---

## GetZonePVPInfo

Returns PVP information about the current area. Information returned may apply to the current subzone, not the entire zone.

**Signature:** `pvpType, isSubZonePVP, factionName = GetZonePVPInfo()`

**Returns:**
- `pvpType` - PvP status for the area (`string`) 

 - `arena` - Arena or outdoor free-for-all area (e.g. Gurubashi Arena)
- `combat` - Combat zone (e.g. Wintergrasp)
- `contested` - Horde/Alliance PvP is enabled for all players
- `friendly` - Zone is controlled by the player's faction; PvP status is optional for the player but mandatory for enemy players
- `hostile` - Zone is controlled by the enemy's faction; PvP status is optional for the enemy but mandatory for the player
- `nil` - PvP status is not automatically enabled for either faction (used for "contested" zones on Normal servers)
- `sanctuary` - PvP activity is not allowed (e.g. Dalaran)
- `isSubZonePVP` - 1 if the current area allows free-for-all PVP; otherwise nil (`1nil`)
- `factionName` - Name of the faction that controls the zone (only applies if `pvpType` is friendly or hostile) (`string`)

**See also:** PvP functions, Zone information functions.




## GetZoneText

Returns the name of the zone in which the player is located

**Signature:** `zone = GetZoneText()`

**Returns:**
- `zone` - Name of the current zone (`string`)


