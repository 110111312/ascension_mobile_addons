# Widget: Scale

---

## Scale

Scale is an Animation type that automatically applies an affine scalar transformation to the region being animated as it progresses. You can set both the multiplier by which it scales, and the point from which it is scaled.

Scale animations are not applied to FontStrings.

### Methods

### Scale:GetOrigin

Returns the scale animation's origin point. During a scale animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the scale factor.

**Signature:** `point, xOffset, yOffset = Scale:GetOrigin()`

**Returns:**
- `point` - Anchor point for the scale origin (`string`, anchorPoint)
- `xOffset` - Horizontal distance from the anchor point to the scale origin (in pixels) (`number`)
- `yOffset` - Vertical distance from the anchor point to the scale origin (in pixels) (`number`)

### Scale:GetScale

Returns the animation's scaling factors. At the end of the scale animation, the animated region's dimensions are equal to its initial dimensions multiplied by its scaling factors.

**Signature:** `xFactor, yFactor = Scale:GetScale()`

**Returns:**
- `xFactor` - Horizontal scaling factor (`number`)
- `yFactor` - Vertical scaling factor (`number`)

### Scale:SetOrigin

Sets the scale animation's origin point. During a scale animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the scale factor.

**Signature:** `Scale:SetOrigin("point", xOffset, yOffset)`

**Arguments:**
- `point` - Anchor point for the scale origin (`string`, anchorPoint)
- `xOffset` - Horizontal distance from the anchor point to the scale origin (in pixels) (`number`)
- `yOffset` - Vertical distance from the anchor point to the scale origin (in pixels) (`number`)

### Scale:SetScale

Sets the animation's scaling factors. At the end of the scale animation, the animated region's dimensions are equal to its initial dimensions multiplied by its scaling factors.

**Signature:** `Scale:SetScale(xFactor, yFactor)`

**Arguments:**
- `xFactor` - Horizontal scaling factor (`number`)
- `yFactor` - Vertical scaling factor (`number`)

### Script Handlers

- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnFinished(self, requested) - Run when the animation (or animation group) finishes animating
- OnLoad(self) - Run when the frame is created
- OnPause(self) - Run when the animation (or animation group) is paused
- OnPlay(self) - Run when the animation (or animation group) begins to play
- OnStop(self, requested) - Run when the animation (or animation group) is stopped
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

