# Widget: Slider

---

## Slider

Sliders are elements intended to display or allow the user to choose a value in a range. They are often used for configuration, to choose scale, camera distance, and similar settings.
Like Buttons, Sliders can be enabled or disabled, but unlike Buttons, they include no support for automatically changing appearance when this is done. You can set both their minimum and maximum values (one function returns or accepts both), and the step by which dragging changes their value. Sliders can be oriented either horizontally or vertically.

While you do not have to provide any code to manage the dragging of a slider's "thumb", you do have to provide a texture that will represent it, which the engine will position and draw automatically. In XML, you do this by providing a `<ThumbTexture>` element as a direct child of the `<Slider>` element, which can have any of the attributes or children allowed to any `<Texture>` element.

Sliders come in two common forms: thin tracks with a wide thumb, used for setting scalar options, or scroll bars used for positioning the contents of a frame.

### Methods

### Slider:Disable

Disallows user interaction with the slider. Does not automatically change the visual state of the slider; directly making a visible change is recommended in order to communicate the change in state to the user.

**Signature:** `Slider:Disable()`

### Slider:Enable

Allows user interaction with the slider

**Signature:** `Slider:Enable()`

### Slider:GetMinMaxValues

Returns the minimum and maximum values for the slider

**Signature:** `minValue, maxValue = Slider:GetMinMaxValues()`

**Returns:**
- `minValue` - Lower boundary for values represented by the slider position (`number`)
- `maxValue` - Upper boundary for values represented by the slider position (`number`)

### Slider:GetOrientation

Returns the orientation of the slider

**Signature:** `orientation = Slider:GetOrientation()`

**Returns:**
- `orientation` - Token describing the orientation and direction of the slider (`string`) 

 - `HORIZONTAL` - Slider thumb moves from left to right as the slider's value increases
- `VERTICAL` - Slider thumb moves from top to bottom as the slider's value increases

### Slider:GetThumbTexture

Returns the texture for the slider thumb

**Signature:** `texture = Slider:GetThumbTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for the slider thumb (`texture`)

### Slider:GetValue

Returns the value representing the current position of the slider thumb

**Signature:** `value = Slider:GetValue()`

**Returns:**
- `value` - Value representing the current position of the slider thumb (between `minValue` and `maxValue`, where `minValue, maxValue = slider``:GetMinMaxValues()`) (`number`)

### Slider:GetValueStep

Returns the minimum increment between allowed slider values

**Signature:** `step = Slider:GetValueStep()`

**Returns:**
- `step` - Minimum increment between allowed slider values (`number`)

### Slider:IsEnabled

Returns whether user interaction with the slider is allowed

**Signature:** `enabled = Slider:IsEnabled()`

**Returns:**
- `enabled` - `1` if user interaction with the slider is allowed; otherwise `nil` (`1nil`)

### Slider:SetMinMaxValues

Sets the minimum and maximum values for the slider

**Signature:** `Slider:SetMinMaxValues(minValue, maxValue)`

**Arguments:**
- `minValue` - Lower boundary for values represented by the slider position (`number`)
- `maxValue` - Upper boundary for values represented by the slider position (`number`)

### Slider:SetOrientation

Sets the orientation of the slider

**Signature:** `Slider:SetOrientation("orientation")`

**Arguments:**
- `orientation` - Token describing the orientation and direction of the slider (`string`) 

 - `HORIZONTAL` - Slider thumb moves from left to right as the slider's value increases
- `VERTICAL` - Slider thumb moves from top to bottom as the slider's value increases (default)

### Slider:SetThumbTexture

Sets the texture for the slider thumb

**Signature:** `Slider:SetThumbTexture(texture [, "layer"]) or Slider:SetThumbTexture("filename" [, "layer"])`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)
- `layer` - Graphics layer in which the texture should be drawn; defaults to `ARTWORK` if not specified (`string`, layer)

### Slider:SetValue

Sets the value representing the position of the slider thumb

**Signature:** `Slider:SetValue(value)`

**Arguments:**
- `value` - Value representing the new position of the slider thumb (between `minValue` and `maxValue`, where `minValue, maxValue = slider``:GetMinMaxValues()`) (`number`)

### Slider:SetValueStep

Sets the minimum increment between allowed slider values. The portion of the slider frame's area in which the slider thumb moves is its width (or height, for vertical sliders) minus 16 pixels on either end. If the number of possible values determined by the slider's minimum, maximum, and step values is less than the width (or height) of this area, the step value also affects the movement of the slider thumb; see example for details.

**Signature:** `Slider:SetValueStep(step)`

**Arguments:**
- `step` - Minimum increment between allowed slider values (`number`)

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
- OnMinMaxChanged(self, min, max) - Run when the slider's or status bar's minimum and maximum values change
- OnMouseDown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- OnMouseUp(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- OnMouseWheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine
- OnValueChanged(self, value) - Run when the slider's or status bar's value changes

