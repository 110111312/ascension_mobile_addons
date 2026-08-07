# WoW API Functions — V

_36 functions_

---

## VehicleAimDecrement

Adjusts vehicle aim downward by a specified amount

**Signature:** `VehicleAimDecrement(amount)`

**Arguments:**
- `amount` - Angle by which to adjust aim (in radians) (`number`)

**See also:** Vehicle functions.


## VehicleAimDownStart

Starts adjusting vehicle aim downward

**Signature:** `VehicleAimDownStart()`

**See also:** Vehicle functions.


## VehicleAimDownStop

Stops adjusting vehicle aim downward

**Signature:** `VehicleAimDownStop()`

**See also:** Vehicle functions.


## VehicleAimGetAngle

Returns the aim angle of a vehicle weapon. The returned value is in radians, with positive values indicating upward angle, negative values indicating downward angle, and 0 indicating straight ahead.

**Signature:** `angle = VehicleAimGetAngle()`

**Returns:**
- `angle` - Vertical angle of vehicle weapon aim (in radians) (`number`)

**See also:** Vehicle functions.


## VehicleAimGetNormAngle


## VehicleAimGetNormPower

**Signature:** `VehicleAimGetNormPower()`


## VehicleAimIncrement

Adjusts vehicle aim upward by a specified amount

**Signature:** `VehicleAimIncrement(amount)`

**Arguments:**
- `amount` - Angle by which to adjust aim (in radians) (`number`)

**See also:** Vehicle functions.


## VehicleAimRequestAngle

Attempts to set a vehicle weapon's aim angle to a specific value. Causes aim angle to transition smoothly from the current value to the requested value (or to the closest allowed value to the requested value if it is beyond the vehicle's limits).

Aim angle values are in radians, with positive values indicating upward angle, negative values indicating downward angle, and 0 indicating straight ahead.

**Signature:** `VehicleAimRequestAngle(amount)`

**Arguments:**
- `amount` - New aim angle (in radians) (`number`)


## VehicleAimRequestNormAngle

Attempts to set a vehicle weapon's aim angle to a specific value relative to its minimum value. Causes aim angle to transition smoothly from the current value to the requested value (or to the closest allowed value to the requested value if it is beyond the vehicle's limits).

The returned value is in radians, with 0 indicating the lowest angle allowed for the vehicle weapon and increasing values for upward aim.

**Signature:** `VehicleAimRequestNormAngle(amount)`

**Arguments:**
- `amount` - New aim angle (in radians) (`number`)

**See also:** Vehicle functions.


## VehicleAimSetNormPower

**Signature:** `VehicleAimSetNormPower()`


## VehicleAimUpStart

Starts adjusting vehicle aim upward

**Signature:** `VehicleAimUpStart()`

**See also:** Vehicle functions.


## VehicleAimUpStop

Stops adjusting vehicle aim upward

**Signature:** `VehicleAimUpStop()`

**See also:** Vehicle functions.


## VehicleCameraZoomIn

Zooms the player's view in while in a vehicle

**Signature:** `VehicleCameraZoomIn()`


## VehicleCameraZoomOut

Zooms the player's view out while in a vehicle

**Signature:** `VehicleCameraZoomOut()`

**See also:** Vehicle functions.


## VehicleExit

Removes the player from the current vehicle. Does nothing if the player is not in a vehicle.

**Signature:** `VehicleExit()`

**See also:** Vehicle functions.


## VehicleNextSeat

Moves the player from his current seat in a vehicle to the next sequentially numbered seat. If the player is in the highest-numbered seat, cycles around to the lowest-numbered seat.

**Signature:** `VehicleNextSeat()`


## VehiclePrevSeat

Moves the player from his current seat in a vehicle to the previous sequentially numbered seat. If the player is in the lowest-numbered seat, cycles around to the highest-numbered seat.

**Signature:** `VehiclePrevSeat()`

**See also:** Vehicle functions.


## VoiceChat_ActivatePrimaryCaptureCallback


## VoiceChat_GetCurrentMicrophoneSignalLevel

Returns the current volume level of the microphone signal

**Signature:** `volume = VoiceChat_GetCurrentMicrophoneSignalLevel()`

**Returns:**
- `volume` - The current volume level of the microphone signal (`number`)


## VoiceChat_IsPlayingLoopbackSound

Returns whether the Microphone Test recording is playing

**Signature:** `VoiceChat_IsPlayingLoopbackSound(isPlaying)`

**Arguments:**
- `isPlaying` - 1 if the loopback sound is currently being played; otherwise nil (`number`)


## VoiceChat_IsRecordingLoopbackSound

Returns whether a Microphone Test is recording

**Signature:** `isRecording = VoiceChat_IsRecordingLoopbackSound()`

**Returns:**
- `isRecording` - 1 if the player is recording a voice sample, otherwise 0 (`number`)

**See also:** Voice functions.


## VoiceChat_PlayLoopbackSound

Plays back the Microphone Test recording

**Signature:** `VoiceChat_PlayLoopbackSound()`


## VoiceChat_RecordLoopbackSound

Begins recording a Microphone Test

**Signature:** `VoiceChat_RecordLoopbackSound(seconds)`

**Arguments:**
- `seconds` - The amount of time to record (in seconds) (`number`)


## VoiceChat_StartCapture


## VoiceChat_StopCapture


## VoiceChat_StopPlayingLoopbackSound

Stops playing the Microphone Test recording

**Signature:** `VoiceChat_StopPlayingLoopbackSound()`

**See also:** Voice functions.


## VoiceChat_StopRecordingLoopbackSound

Stops recording a Microphone Test

**Signature:** `VoiceChat_StopRecordingLoopbackSound()`

**See also:** Voice functions.


## VoiceEnumerateCaptureDevices

Returns the name of an audio input device for voice chat

**Signature:** `deviceName = VoiceEnumerateCaptureDevices(deviceIndex)`

**Arguments:**
- `deviceIndex` - Index of the device (between 1 and `Sound_ChatSystem_GetNumInputDrivers()`) (`number`)

**Returns:**
- `deviceName` - Name of the device (`string`)

**See also:** Sound functions, Voice functions.


## VoiceEnumerateOutputDevices

Returns the name of an audio output device for voice chat

**Signature:** `device = VoiceEnumerateOutputDevices(deviceIndex)`

**Arguments:**
- `deviceIndex` - Index of the device (between 1 and `Sound_ChatSystem_GetNumOutputDrivers()`) (`number`)

**Returns:**
- `device` - Name of the device (`string`)

**See also:** Sound functions, Voice functions.


## VoiceGetCurrentCaptureDevice

Returns the index of the current voice capture device

**Signature:** `index = VoiceGetCurrentCaptureDevice()`

**Returns:**
- `index` - Index of the current voice capture device (between 1 and `Sound_ChatSystem_GetNumInputDrivers()`) (`number`)

**See also:** Voice functions, Sound functions.


## VoiceGetCurrentOutputDevice

Returns the index of the current voice output device

**Signature:** `index = VoiceGetCurrentOutputDevice()`

**Returns:**
- `index` - Index of the current voice output device (between 1 and `Sound_ChatSystem_GetNumOutputDrivers()`) (`number`)

**See also:** Voice functions, Sound functions.


## VoiceIsDisabledByClient

Returns whether the voice chat system cannot be enabled. Voice chat may be disabled if the underlying hardware does not support it or if multiple instances of World of Warcraft are running on the same hardware.

**Signature:** `isDisabled = VoiceIsDisabledByClient()`

**Returns:**
- `isDisabled` - 1 if the voice system is disabled; otherwise nil (`1nil`)


## VoicePushToTalkStart

Used internally to start talking, when push-to-talk is active in voice chat.

**Signature:** `VoicePushToTalkStart()`


## VoicePushToTalkStop

Used internally to stop talking, when push-to-talk is active in voice chat

**Signature:** `VoicePushToTalkStop()`

**See also:** Voice functions.


## VoiceSelectCaptureDevice

Selects an audio input device for voice chat

**Signature:** `VoiceSelectCaptureDevice("deviceName")`

**Arguments:**
- `deviceName` - Name of an audio input device, as returned from `VoiceEnumerateCaptureDevices()` (`string`)

**See also:** Voice functions, Sound functions.


## VoiceSelectOutputDevice

Selects an audio output device for voice chat

**Signature:** `VoiceSelectOutputDevice("deviceName")`

**Arguments:**
- `deviceName` - Name of an audio output device, as returned from `VoiceEnumerateOutputDevices()` (`string`)

