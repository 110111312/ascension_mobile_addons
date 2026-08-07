# Widget: Model

---

## Model

When you want to display a rendering of a three-dimensional object as part of the UI, a Model frame is your basic tool. These frames provide a rendering environment which is drawn into the backdrop of their frame, allowing you to display the contents of an .m2 file and set facing, scale, light and fog information, or run motions associated with the model.

It's comparatively rare to see the basic Model type used; most renderings of models in the stock UI and mods use PlayerFrame to display players, pets and mounts.

### Methods

### Model:AdvanceTime

Advances to the model's next animation frame. (Applies to 3D animations defined within the model file, not UI `Animation`s.)

**Signature:** `Model:AdvanceTime()`

### Model:ClearFog

Disables fog display for the model.

**Signature:** `Model:ClearFog()`

### Model:ClearModel

Removes the 3D model currently displayed

**Signature:** `Model:ClearModel()`

### Model:GetFacing

Returns the model's current rotation setting. The 3D model displayed by the model object can be rotated about its vertical axis. For example, a model of a player race faces towards the viewer when its facing is set to 0; setting facing to `math.pi` faces it away from the viewer.

**Signature:** `facing = Model:GetFacing()`

**Returns:**
- `facing` - Current rotation angle of the model (in radians) (`number`)

### Model:GetFogColor

Returns the model's current fog color. Does not indicate whether fog display is enabled.

**Signature:** `red, green, blue = Model:GetFogColor()`

**Returns:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)

### Model:GetFogFar

Returns the far clipping distance for the model's fog.. This determines how far from the camera the fog ends.

**Signature:** `distance = Model:GetFogFar()`

**Returns:**
- `distance` - The distance to the fog far clipping plane (`number`)

### Model:GetFogNear

Returns the near clipping distance for the model's fog.. This determines how close to the camera the fog begins.

**Signature:** `distance = Model:GetFogNear()`

**Returns:**
- `distance` - The distance to the fog near clipping plane (`number`)

### Model:GetLight

Returns properties of the light sources used when rendering the model

**Signature:** `enabled, omni, dirX, dirY, dirZ, ambIntensity, ambR, ambG, ambB, dirIntensity, dirR, dirG, dirB = Model:GetLight()`

**Returns:**
- `enabled` - `1` if lighting is enabled; otherwise `nil` (`1nil`)
- `omni` - `1` if omnidirectional lighting is enabled; otherwise `0` (`number`)
- `dirX` - Coordinate of the directional light in the axis perpendicular to the screen (negative values place the light in front of the model, positive values behind) (`number`)
- `dirY` - Coordinate of the directional light in the horizontal axis (negative values place the light to the left of the model, positive values to the right) (`number`)
- `dirZ` - Coordinate of the directional light in the vertical axis (negative values place the light below the model, positive values above (`number`)
- `ambIntensity` - Intensity of the ambient light (0.0 - 1.0) (`number`)
- `ambR` - Red component of the ambient light color (0.0 - 1.0); omitted if `ambIntensity` is 0 (`number`)
- `ambG` - Green component of the ambient light color (0.0 - 1.0); omitted if `ambIntensity` is 0 (`number`)
- `ambB` - Blue component of the ambient light color (0.0 - 1.0); omitted if `ambIntensity` is 0 (`number`)
- `dirIntensity` - Intensity of the directional light (0.0 - 1.0) (`number`)
- `dirR` - Red component of the directional light color (0.0 - 1.0); omitted if `dirIntensity` is 0 (`number`)
- `dirG` - Green component of the directional light color (0.0 - 1.0); omitted if `dirIntensity` is 0 (`number`)
- `dirB` - Blue component of the directional light color (0.0 - 1.0); omitted if `dirIntensity` is 0 (`number`)

### Model:GetModel

Returns the model file currently displayed. May instead return a reference to the `Model` object itself if a filename is not available.

**Signature:** `filename = Model:GetModel()`

**Returns:**
- `filename` - Path to the model file currently displayed (`string`)

### Model:GetModelScale

Returns the scale factor determining the size at which the 3D model appears

**Signature:** `scale = Model:GetModelScale()`

**Returns:**
- `scale` - Scale factor determining the size at which the 3D model appears (`number`)

### Model:GetPosition

Returns the position of the 3D model within the frame

**Signature:** `x, y, z = Model:GetPosition()`

**Returns:**
- `x` - Position of the model on the axis perpendicular to the plane of the screen (positive values make the model appear closer to the viewer; negative values place it further away) (`number`)
- `y` - Position of the model on the horizontal axis (positive values place the model to the right of its default position; negative values place it to the left) (`number`)
- `z` - Position of the model on the vertical axis (positive values place the model above its default position; negative values place it below) (`number`)

### Model:ReplaceIconTexture

Sets the icon texture used by the model. Only affects models that use icons (e.g. the model producing the default UI's animation which appears when an item goes into a bag).

**Signature:** `Model:ReplaceIconTexture("filename")`

**Arguments:**
- `filename` - Path to an icon texture for use in the model (`string`)

### Model:SetCamera

Sets the view angle on the model to a pre-defined camera location. Camera view angles are defined within the model files and not otherwise available to the scripting system. Some camera indices are standard across most models:

 
 - `0` - Non-movable camera, focused on the unit's face (if applicable); used by the game engine when rendering portrait textures
 
 - `1` - Movable camera, showing the entire body of the unit
 
 - `2` or higher - Movable camera in default position

**Signature:** `Model:SetCamera(index)`

**Arguments:**
- `index` - Index of a camera view defined by the model file (`number`)

### Model:SetFacing

Sets the model's current rotation. The 3D model displayed by the model object can be rotated about its vertical axis. For example, if the model faces towards the viewer when its facing is set to 0, setting facing to `math.pi` faces it away from the viewer.

**Signature:** `Model:SetFacing(facing)`

**Arguments:**
- `facing` - Rotation angle for the model (in radians) (`number`)

### Model:SetFogColor

Sets the model's fog color, enabling fog display if disabled

**Signature:** `Model:SetFogColor(red, green, blue)`

**Arguments:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)

### Model:SetFogFar

Sets the far clipping distance for the model's fog.. This sets how far from the camera the fog ends.

**Signature:** `Model:SetFogFar(distance)`

**Arguments:**
- `distance` - The distance to the fog far clipping plane (`number`)

### Model:SetFogNear

Sets the near clipping distance for the model's fog.. This sets how close to the camera the fog begins.

**Signature:** `Model:SetFogNear(distance)`

**Arguments:**
- `distance` - The distance to the fog near clipping plane (`number`)

### Model:SetGlow

Sets the model's glow amount

**Signature:** `Model:SetGlow(amount)`

**Arguments:**
- `amount` - Glow amount for the model (`number`)

### Model:SetLight

Sets properties of the light sources used when rendering the model

**Signature:** `Model:SetLight(enabled, omni, dirX, dirY, dirZ, ambIntensity [, ambR [, ambG [, ambB [, dirIntensity [, dirR [, dirG [, dirB]]]]]]])`

**Arguments:**
- `enabled` - `1` if lighting is enabled; otherwise `nil` (`1nil`)
- `omni` - `1` if omnidirectional lighting is enabled; otherwise `0` (`number`)
- `dirX` - Coordinate of the directional light in the axis perpendicular to the screen (negative values place the light in front of the model, positive values behind) (`number`)
- `dirY` - Coordinate of the directional light in the horizontal axis (negative values place the light to the left of the model, positive values to the right) (`number`)
- `dirZ` - Coordinate of the directional light in the vertical axis (negative values place the light below the model, positive values above (`number`)
- `ambIntensity` - Intensity of the ambient light (0.0 - 1.0) (`number`)
- `ambR` - Red component of the ambient light color (0.0 - 1.0); omitted if `ambIntensity` is 0 (`number`)
- `ambG` - Green component of the ambient light color (0.0 - 1.0); omitted if `ambIntensity` is 0 (`number`)
- `ambB` - Blue component of the ambient light color (0.0 - 1.0); omitted if `ambIntensity` is 0 (`number`)
- `dirIntensity` - Intensity of the directional light (0.0 - 1.0) (`number`)
- `dirR` - Red component of the directional light color (0.0 - 1.0); omitted if `dirIntensity` is 0 (`number`)
- `dirG` - Green component of the directional light color (0.0 - 1.0); omitted if `dirIntensity` is 0 (`number`)
- `dirB` - Blue component of the directional light color (0.0 - 1.0); omitted if `dirIntensity` is 0 (`number`)

### Model:SetModel

Sets the model file to be displayed

**Signature:** `Model:SetModel("filename")`

**Arguments:**
- `filename` - Path to the model file to be displayed (`string`)

### Model:SetModelScale

Sets the scale factor determining the size at which the 3D model appears

**Signature:** `Model:SetModelScale(scale)`

**Arguments:**
- `scale` - Scale factor determining the size at which the 3D model appears (`number`)

### Model:SetPosition

Sets the position of the 3D model within the frame

**Signature:** `Model:SetPosition(x, y, z)`

**Arguments:**
- `x` - Position of the model on the axis perpendicular to the plane of the screen (positive values make the model appear closer to the viewer; negative values place it further away) (`number`)
- `y` - Position of the model on the horizontal axis (positive values place the model to the right of its default position; negative values place it to the left) (`number`)
- `z` - Position of the model on the vertical axis (positive values place the model above its default position; negative values place it below) (`number`)

### Model:SetSequence

Sets the animation sequence to be used by the model. The number of available sequences and behavior of each are defined within the model files and not available to the scripting system.

**Signature:** `Model:SetSequence(sequence)`

**Arguments:**
- `sequence` - Index of an animation sequence defined by the model file (`number`)

### Model:SetSequenceTime

Sets the animation sequence and time index to be used by the model. The number of available sequences and behavior of each are defined within the model files and not available to the scripting system.

**Signature:** `Model:SetSequenceTime(sequence, time)`

**Arguments:**
- `sequence` - Index of an animation sequence defined by the model file (`number`)
- `time` - Time index within the sequence (`number`)

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

