# Widget: Cooldown

---

## Cooldown

### Methods

### Cooldown:GetDrawEdge

Returns whether a bright line should be drawn on the moving edge of the cooldown animation

**Signature:** `enabled = Cooldown:GetDrawEdge()`

**Returns:**
- `enabled` - `1` if a bright line should be drawn on the moving edge of the cooldown "sweep" animation; otherwise `nil` (`1nil`)

### Cooldown:GetReverse

Returns whether the bright and dark portions of the cooldown animation should be inverted

**Signature:** `enabled = Cooldown:GetReverse()`

**Returns:**
- `enabled` - `1` if the cooldown animation "sweeps" an area of darkness over the underlying image; `nil` if the animation darkens the underlying image and "sweeps" the darkened area away (`1nil`)

### Cooldown:SetCooldown

Sets up the parameters for a Cooldown model.. The start value indicates the time when the cooldown began (your system time in seconds) and duration is how long the cooldown lasts.

**Signature:** `Cooldown:SetCooldown(start, duration)`

### Cooldown:SetDrawEdge

Sets whether a bright line should be drawn on the moving edge of the cooldown animation. Does not change the appearance of a currently running cooldown animation; only affects future runs of the animation.

**Signature:** `Cooldown:SetDrawEdge(enable)`

**Arguments:**
- `enable` - True to cause a bright line to be drawn on the moving edge of the cooldown "sweep" animation; false for the default behavior (no line drawn) (`boolean`)

### Cooldown:SetReverse

Sets whether to invert the bright and dark portions of the cooldown animation

**Signature:** `Cooldown:SetReverse(reverse)`

**Arguments:**
- `reverse` - True for an animation "sweeping" an area of darkness over the underlying image; false for the default animation of darkening the underlying image and "sweeping" the darkened area away (`boolean`)

### Script Handlers

- OnAttributeChanged(self, name, value) - Sets an arbitrary, named, taintless value on a frame.
- OnChar(self, character) - Fires when a text character is received by a frame.
- OnDragStart(self, button) - Fires when the user starts moving the mouse after clicking down on the frame.
- OnDragStop(self) - Fires when you release the mouse button after beginning a drag on the frame.
- OnEnter(self, motion) - Fires whenever the cursor becomes focused on a frame.
- OnEvent(self, event, ...) - Fires on each frame that is registered for a given event.
- OnHide(self) - Fires when the frame is hidden.
- OnKeyDown(self, key) - Fires when the frame receives a "down" key press.
- OnKeyUp(self, key) - Fires when the frame receives an "up" key press.
- OnLeave(self, motion) - Fires whenever the cursor is no longer focused on a frame.
- OnLoad(self) - Fires when a frame is first created.
- OnMouseDown(self, button) - Fires when a mouse button is pressed down while the mouse-enabled frame has mouse focus. See also: OnMouseUp, OnClick
- OnMouseUp(self, button) - Fires when the mouse button is released after clicking on a frame.
- OnMouseWheel(self, delta) - Fires for a mouse wheel-enabled frame when the user rolls the mouse wheel while over the frame.
- OnReceiveDrag(self) - Fires when you release the mouse button over a frame after starting a drag.
- OnShow(self) - Fires whenever a frame becomes visible after being not visible.
- OnSizeChanged(self, width, height) - Fires whenever a frame's size changes.
- OnUpdate(self, elapsed) - Fires once for every visible frame each time the UI is rendered.

