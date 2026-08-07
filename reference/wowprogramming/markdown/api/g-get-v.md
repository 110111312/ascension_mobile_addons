# WoW API — GetV*

_7 functions_

---

## GetVehicleUIIndicator




## GetVehicleUIIndicatorSeat




## GetVideoCaps

Returns information about graphics capabilities of the current system

**Signature:** `hasAnisotropic, hasPixelShaders, hasVertexShaders, hasTrilinear, hasTripleBufering, maxAnisotropy, hasHardwareCursor = GetVideoCaps()`

**Returns:**
- `hasAnisotropic` - 1 if anisotropic filtering is available; otherwise 0 (`number`)
- `hasPixelShaders` - 1 if pixel shaders are available; otherwise 0 (`number`)
- `hasVertexShaders` - 1 if vertex shaders are available; otherwise 0 (`number`)
- `hasTrilinear` - 1 if trilinear filtering is available; otherwise 0 (`number`)
- `hasTripleBufering` - 1 if triple buffering is available; otherwise 0 (`number`)
- `maxAnisotropy` - Number of available settings for anisotropic filtering (corresponds to the "Texture Filtering" slider in the default UI) (`number`)
- `hasHardwareCursor` - 1 if hardware cursor support is available; otherwise 0 (`number`)

**See also:** Video functions.




## GetVoiceCurrentSessionID

Returns an identifier for the active voice session

**Signature:** `id = GetVoiceCurrentSessionID()`

**Returns:**
- `id` - Index of the active voice session (between 1 and `GetNumVoiceSessions()`), or nil if no session is active (`number`)

**See also:** Voice functions.




## GetVoiceSessionInfo

Returns information about a voice session

**Signature:** `name, active = GetVoiceSessionInfo(session)`

**Arguments:**
- `session` - Index of a voice session (between 1 and `GetNumVoiceSessions()`) (`number`)

**Returns:**
- `name` - Name of the voice session (channel) (`string`)
- `active` - 1 if the session is the active voice channel; otherwise nil (`1nil`)

**See also:** Voice functions.




## GetVoiceSessionMemberInfoBySessionID

Returns information about a member of a voice channel

**Signature:** `name, voiceActive, sessionActive, muted, squelched = GetVoiceSessionMemberInfoBySessionID(session, index)`

**Arguments:**
- `session` - Index of a voice session (between 1 and `GetNumVoiceSessions()`) (`number`)
- `index` - Index of a member in the voice session (between 1 and `GetNumVoiceSessionMembersBySessionID(session)`) (`number`)

**Returns:**
- `name` - Name of the member (`string`)
- `voiceActive` - 1 if the member has enabled voice chat; otherwise nil (`1nil`)
- `sessionActive` - 1 if the channel is the member's active voice channel; otherwise nil (`1nil`)
- `muted` - 1 if the member is on the player's muted list; otherwise nil (`1nil`)
- `squelched` - 1 if the member was silenced by the channel moderator; otherwise nil (`1nil`)




## GetVoiceStatus

Returns whether a character has voice chat enabled

**Signature:** `status = GetVoiceStatus(unit, "channel") or GetVoiceStatus("name", "channel")`

**Arguments:**
- `unit` - The unitid to query (`unitid`)
- `name` - The name of the player to query (`string`)
- `channel` - Channel to query for voice status. (`string`)

**Returns:**
- `status` - 1 if voice is enabled; otherwise nil (`1nil`)



