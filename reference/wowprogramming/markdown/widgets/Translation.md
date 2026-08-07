# Widget: Translation

---

## Translation

Translation is an Animation type that applies an affine translation to its affected region automatically as it progresses. You can set the offset in both the X and Y dimensions. Translations can be applied normally to both Textures and FontStrings.

### Methods

### Translation:GetOffset

Returns the animation's translation offsets

**Signature:** `xOffset, yOffset = Translation:GetOffset()`

**Returns:**
- `xOffset` - Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration (`number`)
- `yOffset` - Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration (`number`)

### Translation:SetOffset

Sets the animation's translation offsets

**Signature:** `Translation:SetOffset(xOffset, yOffset)`

**Arguments:**
- `xOffset` - Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration (`number`)
- `yOffset` - Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration (`number`)

### Script Handlers

- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnFinished(self, requested) - Run when the animation (or animation group) finishes animating
- OnLoad(self) - Run when the frame is created
- OnPause(self) - Run when the animation (or animation group) is paused
- OnPlay(self) - Run when the animation (or animation group) begins to play
- OnStop(self, requested) - Run when the animation (or animation group) is stopped
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

