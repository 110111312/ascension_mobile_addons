# WoW API Functions — M

_47 functions_

---

## MakeMinigameMove


## max

Returns the greatest of a list of numbers. Alias for the standard library function `math.max`.

**Signature:** `maximum = max(...)`

**Arguments:**
- `...` - A list of numbers (`list`)

**Returns:**
- `maximum` - The highest number among all arguments (`number`)

**See also:** Lua library functions.


## min

Returns the least of a list of numbers. Alias for the standard library function `math.min`.

**Signature:** `maximum = min(...)`

**Arguments:**
- `...` - A list of numbers (`list`)

**Returns:**
- `maximum` - The lowest number among all arguments (`number`)

**See also:** Lua library functions.


## mod

Returns the remainder from division of two numbers. Alias for the standard library function `math.fmod`.

**Signature:** `remainder = mod(x, y)`

**Arguments:**
- `x` - A number (`number`)
- `y` - A number (`number`)

**Returns:**
- `remainder` - Remainder of the division of `x` by `y` that rounds the quotient towards zero (`number`)


## MouselookStart

Enables mouselook mode, in which cursor movement rotates the camera

**Signature:** `MouselookStart()`

**See also:** Camera functions.


## MouselookStop

Disables mouselook mode

**Signature:** `MouselookStop()`

**See also:** Camera functions.


## MoveAndSteerStart

Begins moving the player character forward while steering via mouse movement. After calling this function, the player character begins moving forward while cursor movement rotates (or steers) the character, altering yaw (facing) and/or pitch (vertical movement angle) as well as camera position.

Equivalent to calling both `CameraOrSelectOrMoveStart` and `TurnOrActionStart` without calling the respective `Stop` functions; i.e. holding both left and right mouse buttons down. Used by the `MOVEANDSTEER` binding, which can be customized to allow alternate access to this action if the player's system does not allow pressing multiple mouse buttons at once.

**Signature:** `MoveAndSteerStart()`


## MoveAndSteerStop

Ends movement initiated by `MoveAndSteerStart`. After calling this function, forward movement and character steering stops and normal cursor movement resumes.

Used by the `MOVEANDSTEER` binding.

**Signature:** `MoveAndSteerStop()`


## MoveBackwardStart

Begins moving the player character backward. Used by the `MOVEBACKWARD` binding.

**Signature:** `MoveBackwardStart()`

**See also:** Movement functions.


## MoveBackwardStop

Ends movement initiated by `MoveBackwardStart`

**Signature:** `MoveBackwardStop()`

**See also:** Movement functions.


## MoveForwardStart

Begins moving the player character forward. Used by the `MOVEFORWARD` binding.

**Signature:** `MoveForwardStart()`


## MoveForwardStop

Ends movement initiated by `MoveForwardStart`

**Signature:** `MoveForwardStop()`

**See also:** Movement functions.


## MoveViewDownStart

Begins orbiting the camera downward (to look upward)

**Signature:** `MoveViewDownStart()`

**See also:** Camera functions.


## MoveViewDownStop

Ends camera movement initiated by `MoveViewDownStart`

**Signature:** `MoveViewDownStop()`

**See also:** Camera functions.


## MoveViewInStart

Begins zooming the camera inward (towards/through the player character)

**Signature:** `MoveViewInStart()`

**See also:** Camera functions.


## MoveViewInStop

Ends camera movement initiated by `MoveViewInStart`

**Signature:** `MoveViewInStop()`


## MoveViewLeftStart

Begins orbiting the camera around the player character to the left. "Left" here is relative to the player's facing; i.e. the camera orbits clockwise if looking down. Moving the camera to the left causes it to look towards the character's right.

**Signature:** `MoveViewLeftStart()`

**See also:** Camera functions.


## MoveViewLeftStop

Ends camera movement initiated by `MoveViewLeftStart`

**Signature:** `MoveViewLeftStop()`

**See also:** Camera functions.


## MoveViewOutStart

Begins zooming the camera outward (away from the player character)

**Signature:** `MoveViewOutStart()`

**See also:** Camera functions.


## MoveViewOutStop

Ends camera movement initiated by `MoveViewOutStart`

**Signature:** `MoveViewOutStop()`

**See also:** Camera functions.


## MoveViewRightStart

Begins orbiting the camera around the player character to the right. "Right" here is relative to the player's facing; i.e. the camera orbits counter--clockwise if looking down. Moving the camera to the right causes it to look towards the character's left.

**Signature:** `MoveViewRightStart()`

**See also:** Camera functions.


## MoveViewRightStop

Ends camera movement initiated by `MoveViewRightStart`

**Signature:** `MoveViewRightStop()`

**See also:** Camera functions.


## MoveViewUpStart

Begins orbiting the camera upward (to look down)

**Signature:** `MoveViewUpStart()`

**See also:** Camera functions.


## MoveViewUpStop

Ends camera movement initiated by `MoveViewUpStart`

**Signature:** `MoveViewUpStop()`

**See also:** Camera functions.


## MovieRecording_Cancel

Cancels video recording and compression. If a recording is in progress, recording is stopped and the results discarded. If compression is in progress, compression is stopped and the uncompressed portion of the movie is deleted.

**Signature:** `MovieRecording_Cancel()`


## MovieRecording_DataRate

Returns the data rate required for a given set of video recording parameters. The value returned is a prediction of the rate at which data will be written to the hard drive while recording -- if the hardware cannot support this data rate, game performance may suffer and recording may stop.

**Signature:** `dataRate = MovieRecording_DataRate(width, framerate, sound)`

**Arguments:**
- `width` - Width of the output video (in pixels) (`number`)
- `framerate` - Number of video frames to be recorded per second (`number`)
- `sound` - 1 if game audio is to be captured with video; otherwise 0 (`number`)

**Returns:**
- `dataRate` - Summary of the data rate (e.g. "438.297 KB/s", "11.132 MB/s") (`string`)

**See also:** Mac client functions.


## MovieRecording_DeleteMovie

Deletes an uncompressed movie

**Signature:** `MovieRecording_DeleteMovie("filename")`

**Arguments:**
- `filename` - Path to an uncompressed movie (as provided in the `MOVIE_UNCOMPRESSED_MOVIE` event) (`string`)

**See also:** Mac client functions.


## MovieRecording_GetAspectRatio

Returns the aspect ratio of the game display. Used in the default UI to calculate dimensions for scaling captured video to predetermined widths.

For example, if the aspect ratio is 0.75 (as on a 1600x1200 screen), a movie scaled to 640 pixels wide will be 480 pixels tall; but if the aspect ratio is 0.625 (as on a 1440x900 screen), a movie scaled to 640 pixels wide will be 400 pixels tall.

**Signature:** `ratio = MovieRecording_GetAspectRatio()`

**Returns:**
- `ratio` - Ratio of the game display's width to its height (`number`)

**See also:** Mac client functions.


## MovieRecording_GetMovieFullPath

Returns a path to the movie currently being recorded or compressed. If no movie is being recorded or compressed, returns either the empty string (`""`) or the path of the last movie recorded/compressed.

**Signature:** `path = MovieRecording_GetMovieFullPath()`

**Returns:**
- `path` - Path to the movie currently being recorded or compressed, relative to the folder containing the World of Warcraft app (`string`)

**See also:** Mac client functions.


## MovieRecording_GetProgress

Returns information about movie compression progress

**Signature:** `recovering, progress = MovieRecording_GetProgress()`

**Returns:**
- `recovering` - True if a previous compression was interrupted (e.g. due to WoW being crashing or being forced to quit), indicating that recovery is being attempted on the file; otherwise false (`boolean`)
- `progress` - Progress of the movie compression process (0 = just started, 1 = finished) (`number`)


## MovieRecording_GetTime

Returns the amount of time since video recording was last started. Used in the default UI to show the length of the recording in progress when mousing over the recording indicator on the minimap.

May return a nonsensical value if no video has been recorded since logging in.

**Signature:** `time = MovieRecording_GetTime()`

**Returns:**
- `time` - Amount of time since video recording was last started (HH:MM:SS) (`string`)

**See also:** Mac client functions.


## MovieRecording_GetViewportWidth

Returns the current width of the game display. Used in the default UI to allow the current screen resolution (or an integral factor thereof) to be selected as the video recording resolution.

**Signature:** `width = MovieRecording_GetViewportWidth()`

**Returns:**
- `width` - Width of the game display (`number`)

**See also:** Mac client functions.


## MovieRecording_IsCodecSupported

Returns whether a video codec is supported on the current system

**Signature:** `isSupported = MovieRecording_IsCodecSupported(codecID)`

**Arguments:**
- `codecID` - Four-byte identifier of a QuickTime codec (`number`) 

 - `1635148593` - H.264 - supported natively by Apple devices like the iPod, iPhone and AppleTV; best ratio quality/size but slowest to compress
- `1768124260` - Apple Intermediate Codec - fastest to compress, but exclusive to Mac OS X
- `1835692129` - Motion JPEG - faster to compress than H.264 but it will generate a bigger file
- `1836070006` - MPEG-4 - supported by many digital cameras and iMovie

**Returns:**
- `isSupported` - true if the codec is supported on the current system, otherwise false (`boolean`)

**See also:** Mac client functions.


## MovieRecording_IsCompressing

Returns whether a movie file is currently being compressed

**Signature:** `isCompressing = MovieRecording_IsCompressing()`

**Returns:**
- `isCompressing` - true if the client is currently compressing a recording; otherwise false (`boolean`)

**See also:** Mac client functions.


## MovieRecording_IsCursorRecordingSupported

Returns whether the current system supports recording the mouse cursor in movies

**Signature:** `isSupported = MovieRecording_IsCursorRecordingSupported()`

**Returns:**
- `isSupported` - True if the cursor recording option should be enabled; otherwise false (`boolean`)

**See also:** Mac client functions.


## MovieRecording_IsRecording

Returns whether movie recording is currently in progress

**Signature:** `isRecording = MovieRecording_IsRecording()`

**Returns:**
- `isRecording` - 1 if the client is currently recording, otherwise nil (`1nil`)


## MovieRecording_IsSupported

Returns whether movie recording is supported on the current system

**Signature:** `isSupported = MovieRecording_IsSupported()`

**Returns:**
- `isSupported` - true if the client supports video recording; otherwise nil (`boolean`)

**See also:** Mac client functions.


## MovieRecording_MaxLength

Returns the maximum length of recorded video for a given set of video recording parameters. The value returned reflects both the data rate associated with the given parameters and the amount of space remaining on the hard drive.

**Signature:** `time = MovieRecording_MaxLength(width, framerate, sound)`

**Arguments:**
- `width` - Width of the output video (in pixels) (`number`)
- `framerate` - Number of video frames to be recorded per second (`number`)
- `sound` - 1 if game audio is to be captured with video; otherwise 0 (`number`)

**Returns:**
- `time` - Maximum length of recorded video (HH:MM:SS) (`string`)


## MovieRecording_QueueMovieToCompress

Queues an uncompressed movie for compression. If there are no items currently in the queue the movie will begin compressing immediately.

**Signature:** `MovieRecording_QueueMovieToCompress("filename")`

**Arguments:**
- `filename` - Path to an uncompressed movie (as provided in the `MOVIE_UNCOMPRESSED_MOVIE` event) (`string`)

**See also:** Mac client functions.


## MovieRecording_SearchUncompressedMovie

Enables or disables a search for uncompressed movies. After calling this function with `true`, a `MOVIE_UNCOMPRESSED_MOVIE` fires for the first uncompressed movie found (causing the default UI to prompt the user to choose whether to compress, ignore, or delete the movie). Calling this function with `false` ignores the movie, causing the search to continue (firing a `MOVIE_UNCOMPRESSED_MOVIE` event for the next uncompressed movie found, and so forth).

**Signature:** `MovieRecording_SearchUncompressedMovie(enable)`

**Arguments:**
- `enable` - True to begin searching for uncompressed movies, false to ignore a movie for compression (`boolean`)


## MovieRecording_Toggle

Begins or ends video recording. Used by the `MOVIE_RECORDING_STARTSTOP` key binding.

**Signature:** `MovieRecording_Toggle()`

**See also:** Mac client functions.


## MovieRecording_ToggleGUI

Enables or disables inclusion of UI elements in a video recording. Equivalent to the `MovieRecordingGUI` CVar, but provided as a convenience for the `MOVIE_RECORDING_GUI` so UI recording can be turned on or off while a movie is recording.

**Signature:** `MovieRecording_ToggleGUI()`

**See also:** Mac client functions.


## MusicPlayer_BackTrack

Causes iTunes to return to the previous track played. Used by the iTunes Remote key bindings only available on the Mac OS X WoW client. Only has effect while the iTunes application is open.

**Signature:** `MusicPlayer_BackTrack()`

> **Note:** This function is protected and can only be called by the Blizzard user interface

**See also:** Mac client functions.


## MusicPlayer_NextTrack

Causes iTunes to play the next track in sequence. Used by the iTunes Remote key bindings only available on the Mac OS X WoW client. Only has effect while the iTunes application is open.

**Signature:** `MusicPlayer_NextTrack()`

> **Note:** This function is protected and can only be called by the Blizzard user interface


## MusicPlayer_PlayPause

Causes iTunes to start or pause playback. Used by the iTunes Remote key bindings only available on the Mac OS X WoW client. Only has effect while the iTunes application is open.

**Signature:** `MusicPlayer_PlayPause()`

> **Note:** This function is protected and can only be called by the Blizzard user interface

**See also:** Mac client functions.


## MusicPlayer_VolumeDown

Causes iTunes to lower its playback volume. Affects the iTunes volume setting only, not the overall system volume or any of WoW's volume settings.

Used by the iTunes Remote key bindings only available on the Mac OS X WoW client. Only has effect while the iTunes application is open.

**Signature:** `MusicPlayer_VolumeDown()`

> **Note:** This function is protected and can only be called by the Blizzard user interface

**See also:** Mac client functions.


## MusicPlayer_VolumeUp

Causes iTunes to raise its playback volume. Affects the iTunes volume setting only, not the overall system volume or any of WoW's volume settings.

Used by the iTunes Remote key bindings only available on the Mac OS X WoW client. Only has effect while the iTunes application is open.

**Signature:** `MusicPlayer_VolumeUp()`

> **Note:** This function is protected and can only be called by the Blizzard user interface

**See also:** Mac client functions.

