# Widget: Alpha

---

## Alpha

Alpha is a type of animation that automatically changes the transparency level of its attached region as it progresses. You can set the degree by which it will change the alpha as a fraction; for instance, a change of -1 will fade out a region completely.

### Methods

### Alpha:GetChange

Returns the animation's amount of alpha (opacity) change. A region's alpha value can be between 0 (fully transparent) and 1 (fully opaque); thus, an animation which changes alpha by 1 will always increase the region to full opacity, regardless of the region's existing alpha (and an animation whose change amount is -1 will reduce the region to fully transparent).

**Signature:** `change = Alpha:GetChange()`

**Returns:**
- `change` - Amount by which the region's alpha value changes over the animation's duration (between -1 and 1) (`number`)

### Alpha:SetChange

Sets the animation's amount of alpha (opacity) change. A region's alpha value can be between 0 (fully transparent) and 1 (fully opaque); thus, an animation which changes alpha by 1 will always increase the region to full opacity, regardless of the region's existing alpha (and an animation whose change amount is -1 will reduce the region to fully transparent).

**Signature:** `Alpha:SetChange(change)`

**Arguments:**
- `change` - Amount by which the region's alpha value should change over the animation's duration (between -1 and 1) (`number`)

### Script Handlers

- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnFinished(self, requested) - Run when the animation (or animation group) finishes animating
- OnLoad(self) - Run when the frame is created
- OnPause(self) - Run when the animation (or animation group) is paused
- OnPlay(self) - Run when the animation (or animation group) begins to play
- OnStop(self, requested) - Run when the animation (or animation group) is stopped
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

