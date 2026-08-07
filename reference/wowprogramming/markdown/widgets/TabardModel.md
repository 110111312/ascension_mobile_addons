# Widget: TabardModel

---

## TabardModel

TabardModel is a frame type provided specifically for designing or modifying guild tabards. It provides functions for displaying a character in a sample tabard and cycling through different trim textures, emblems, and color schemes, as well as saving the selected look as your guild's current tabard (this requires that your character have appropriate guild privileges to do so).

Because the stock UI already includes a fairly comprehensive tabard interface using one of these frames, it's fairly unlikely that you'll need to create one of your own.

### Methods

### TabardModel:CanSaveTabardNow

Returns whether the tabard model's current design can be saved as the player's guild tabard

**Signature:** `enabled = TabardModel:CanSaveTabardNow()`

**Returns:**
- `enabled` - `1` if the tabard model's current design can be saved as the player's guild tabard; otherwise `nil` (`1nil`)

### TabardModel:CycleVariation

Cycles through available design variations for the tabard model

**Signature:** `TabardModel:CycleVariation(variable, delta)`

**Arguments:**
- `variable` - Number identifying one of the five tabard design variables: (`number`) 

 - `1` - Icon
- `2` - Icon color
- `3` - Border style
- `4` - Border color
- `5` - Background color
- `delta` - Number of steps by which to cycle through available options for the design variable (e.g. `1` for next design, `-1` for previous design, `3` to skip ahead by three) (`number`)

### TabardModel:GetLowerBackgroundFileName

Returns the image file for the lower portion of the tabard model's current background design

**Signature:** `TabardModel:GetLowerBackgroundFileName("filename")`

**Arguments:**
- `filename` - Path to the texture image file for the lower portion of the tabard model's current background design (`string`)

### TabardModel:GetLowerEmblemFileName

Returns the image file for the lower portion of the tabard model's current emblem design

**Signature:** `TabardModel:GetLowerEmblemFileName("filename")`

**Arguments:**
- `filename` - Path to the texture image file for the lower portion of the tabard model's current emblem design (`string`)

### TabardModel:GetLowerEmblemTexture

Sets a `Texture` object to display the lower portion of the tabard model's current emblem design

**Signature:** `TabardModel:GetLowerEmblemTexture(texture)`

**Arguments:**
- `texture` - Reference to a Texture object (`texture`)

### TabardModel:GetUpperBackgroundFileName

Returns the image file for the upper portion of the tabard model's current background design

**Signature:** `TabardModel:GetUpperBackgroundFileName("filename")`

**Arguments:**
- `filename` - Path to the texture image file for the upper portion of the tabard model's current background design (`string`)

### TabardModel:GetUpperEmblemFileName

Returns the image file for the upper portion of the tabard model's current emblem design

**Signature:** `TabardModel:GetUpperEmblemFileName("filename")`

**Arguments:**
- `filename` - Path to the texture image file for the upper portion of the tabard model's current emblem design (`string`)

### TabardModel:GetUpperEmblemTexture

Sets a `Texture` object to display the upper portion of the tabard model's current emblem design

**Signature:** `TabardModel:GetUpperEmblemTexture(texture)`

**Arguments:**
- `texture` - Reference to a Texture object (`texture`)

### TabardModel:InitializeTabardColors

Sets the tabard model's design to match the player's guild tabard. If the player is not in a guild or the player's guild does not yet have a tabard design, randomizes the tabard model's design.

**Signature:** `TabardModel:InitializeTabardColors()`

### TabardModel:Save

Saves the current tabard model design as the player's guild tabard. Has no effect if the player is not a guild leader.

**Signature:** `TabardModel:Save()`

### Script Handlers

- OnAnimFinished(self) - Run when the model's animation finishes
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
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine
- OnUpdateModel(self) - Run when a model changes or animates

