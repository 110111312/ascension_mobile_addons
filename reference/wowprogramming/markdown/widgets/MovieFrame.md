# Widget: MovieFrame

---

## MovieFrame

MovieFrame is one of the least well-known frame subtypes. To date, it has been used in only one well-known mod, which was an April Fools' Day joke, HighRoller. If you're curious what this mod did, it's still available for download; read the description or try and run it (but keep in mind it's a prank.) It runs the contents of an .avi file, for there are some fairly stringent requirements on the file format supplied.

### Methods

### MovieFrame:EnableSubtitles

Enables or disables subtitles for movies played in the frame. Subtitles are not automatically displayed by the MovieFrame; enabling subtitles causes the frame's `OnMovieShowSubtitle` and `OnMovieHideSubtitle` script handlers to be run when subtitle text should be displayed.

**Signature:** `MovieFrame:EnableSubtitles(enable)`

**Arguments:**
- `enable` - True to enable display of movie subtitles; false to disable (`boolean`)

### MovieFrame:StartMovie

Plays a specified movie in the frame. Note: Size and position of the movie display is unaffected by that of the MovieFrame -- movies are automatically centered and sized proportionally to fill the screen in their largest dimension (i.e. a widescreen movie will fill the width of the screen but not necessarily its full height).

**Signature:** `enabled = MovieFrame:StartMovie("filename", volume)`

**Arguments:**
- `filename` - Path to a movie file (excluding filename extension) (`string`)
- `volume` - Audio volume for movie playback (0 = minimum, 255 = maximum) (`number`)

**Returns:**
- `enabled` - `1` if a valid movie was loaded and playback begun; otherwise `nil` (`1nil`)

### MovieFrame:StopMovie

Stops the movie currently playing in the frame

**Signature:** `MovieFrame:StopMovie()`

### Script Handlers

- OnAttributeChanged(self, "name", value) - Run when a frame attribute is changed
- OnChar(self, "text") - Run for each text character typed in the frame
- OnDisable(self) - Run when the frame is disabled
- OnDragStart(self, "button") - Run when the mouse is dragged starting in the frame
- OnDragStop(self) - Run when the mouse button is released after a drag started in the frame
- OnEnable(self) - Run when the frame is enabled
- OnEnter(self, motion) - Run when the mouse cursor enters the frame's interactive area
- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnHide(self) - Run when the frame's visbility changes to hidden
- OnKeyDown(self, "key") - Run when a keyboard key is pressed if the frame is keyboard enabled
- OnKeyUp(self, "key") - Run when a keyboard key is released if the frame is keyboard enabled
- OnLeave(self, motion) - Run when the mouse cursor leaves the frame's interactive area
- OnLoad(self) - Run when the frame is created
- OnMouseDown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- OnMouseUp(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- OnMouseWheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- OnMovieFinished(self) - Run when a movie frame's movie ends
- OnMovieHideSubtitle(self) - Runs when the movie's most recently displayed subtitle should be hidden
- OnMovieShowSubtitle(self, "text") - Runs when a subtitle for the playing movie should be displayed
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

