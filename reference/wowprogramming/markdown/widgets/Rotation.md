# Widget: Rotation

---

## Rotation

Rotation is an Animation that automatically applies an affine rotation to the region being animated. You can set the origin around which the rotation is being done, and the angle of rotation in either degrees or radians.

Rotation animations have no effect on FontStrings.

### Methods

### Rotation:GetDegrees

Returns the animation's rotation amount (in degrees)

**Signature:** `degrees = Rotation:GetDegrees()`

**Returns:**
- `degrees` - Amount by which the region rotates over the animation's duration (in degrees; positive values for counter-clockwise rotation, negative for clockwise) (`number`)

### Rotation:GetOrigin

Returns the rotation animation's origin point. During a rotation animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the rotation amount.

**Signature:** `point, xOffset, yOffset = Rotation:GetOrigin()`

**Returns:**
- `point` - Anchor point for the rotation origin (`string`, anchorPoint)
- `xOffset` - Horizontal distance from the anchor point to the rotation origin (in pixels) (`number`)
- `yOffset` - Vertical distance from the anchor point to the rotation origin (in pixels) (`number`)

### Rotation:GetRadians

Returns the animation's rotation amount (in radians)

**Signature:** `radians = Rotation:GetRadians()`

**Returns:**
- `radians` - Amount by which the region rotates over the animation's duration (in radians; positive values for counter-clockwise rotation, negative for clockwise) (`number`)

### Rotation:SetDegrees

Sets the animation's rotation amount (in degrees)

**Signature:** `Rotation:SetDegrees(degrees)`

**Arguments:**
- `degrees` - Amount by which the region should rotate over the animation's duration (in degrees; positive values for counter-clockwise rotation, negative for clockwise) (`number`)

### Rotation:SetOrigin

Sets the rotation animation's origin point. During a rotation animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the rotation amount.

**Signature:** `Rotation:SetOrigin("point", xOffset, yOffset)`

**Arguments:**
- `point` - Anchor point for the rotation origin (`string`, anchorPoint)
- `xOffset` - Horizontal distance from the anchor point to the rotation origin (in pixels) (`number`)
- `yOffset` - Vertical distance from the anchor point to the rotation origin (in pixels) (`number`)

### Rotation:SetRadians

Sets the animation's rotation amount (in radians)

**Signature:** `Rotation:SetRadians(radians)`

**Arguments:**
- `radians` - Amount by which the region should rotate over the animation's duration (in radians; positive values for counter-clockwise rotation, negative for clockwise) (`number`)

### Script Handlers

- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnFinished(self, requested) - Run when the animation (or animation group) finishes animating
- OnLoad(self) - Run when the frame is created
- OnPause(self) - Run when the animation (or animation group) is paused
- OnPlay(self) - Run when the animation (or animation group) begins to play
- OnStop(self, requested) - Run when the animation (or animation group) is stopped
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

