# Widget: Button

---

## Button

_No snapshot available for widget overview._

### Methods

### Button:Click

Performs a (virtual) mouse click on the button. Causes any of the button's mouse click-related scripts to be run as if the button were clicked by the user.

Calling this method can result in an error if the button inherits from a secure frame template and performs protected actions.

**Signature:** `Button:Click("button", down)`

**Arguments:**
- `button` - Name of the mouse button for the click action (`string`) 

 - `Button4`
- `Button5`
- `LeftButton`
- `MiddleButton`
- `RightButton`
- `down` - True for a "mouse down" click action, false for "mouse up" or other click actions (`boolean`)

### Button:Disable

Disallows user interaction with the button. Automatically changes the visual state of the button if its DisabledTexture, DisabledTextColor or DisabledFontObject are set.

**Signature:** `Button:Disable()`

### Button:Enable

Allows user interaction with the button. If a disabled appearance was specified for the button, automatically returns the button to its normal appearance.

**Signature:** `Button:Enable()`

### Button:GetButtonState

Returns the button's current state

**Signature:** `state = Button:GetButtonState()`

**Returns:**
- `state` - State of the button (`string`) 

 - `DISABLED` - Button is disabled and cannot receive user input
- `NORMAL` - Button is in its normal state
- `PUSHED` - Button is pushed (as during a click on the button)

### Button:GetDisabledFontObject

Returns the font object used for the button's disabled state

**Signature:** `font = Button:GetDisabledFontObject()`

**Returns:**
- `font` - Reference to the `Font` object used when the button is disabled (`font`)

### Button:GetDisabledTexture

Returns the texture used when the button is disabled

**Signature:** `texture = Button:GetDisabledTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used when the button is disabled (`texture`)

### Button:GetFontString

Returns the `FontString` object used for the button's label text

**Signature:** `fontstring = Button:GetFontString()`

**Returns:**
- `fontstring` - Reference to the `FontString` object used for the button's label text (`fontstring`)

### Button:GetHighlightFontObject

Returns the font object used when the button is highlighted

**Signature:** `font = Button:GetHighlightFontObject()`

**Returns:**
- `font` - Reference to the `Font` object used when the button is highlighted (`font`)

### Button:GetHighlightTexture

Returns the texture used when the button is highlighted

**Signature:** `texture = Button:GetHighlightTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used when the button is highlighted (`texture`)

### Button:GetMotionScriptsWhileDisabled

Determines whether OnEnter/OnLeave scripts will fire while the button is disabled

**Signature:** `isEnabled = Button:GetMotionScriptsWhileDisabled()`

**Returns:**
- `isEnabled` - `1` if motion scripts run while hidden; otherwise `nil` (`1nil`)

### Button:GetNormalFontObject

Returns the font object used for the button's normal state

**Signature:** `font = Button:GetNormalFontObject()`

**Returns:**
- `font` - Reference to the `Font` object used for the button's normal state (`font`)

### Button:GetNormalTexture

Returns the texture used for the button's normal state

**Signature:** `texture = Button:GetNormalTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for the button's normal state (`texture`)

### Button:GetPushedTextOffset

Returns the offset for moving the button's label text when pushed

**Signature:** `x, y = Button:GetPushedTextOffset()`

**Returns:**
- `x` - Horizontal offset for the text (in pixels; values increasing to the right) (`number`)
- `y` - Vertical offset for the text (in pixels; values increasing upward) (`number`)

### Button:GetPushedTexture

Returns the texture used when the button is pushed

**Signature:** `texture = Button:GetPushedTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used when the button is pushed (`texture`)

### Button:GetText

Returns the text of the button's label

**Signature:** `text = Button:GetText()`

**Returns:**
- `text` - Text of the button's label (`string`)

### Button:GetTextHeight

Returns the height of the button's text label. Reflects the height of the rendered text (which increases if the text wraps onto two lines), not the point size of the text's font.

**Signature:** `height = Button:GetTextHeight()`

**Returns:**
- `height` - Height of the button's text (in pixels) (`number`)

### Button:GetTextWidth

Returns the width of the button's text label

**Signature:** `width = Button:GetTextWidth()`

**Returns:**
- `width` - Width of the button's text (in pixels) (`number`)

### Button:IsEnabled

Returns whether user interaction with the button is allowed

**Signature:** `enabled = Button:IsEnabled()`

**Returns:**
- `enabled` - `1` if user interaction with the button is allowed; otherwise `nil` (`1nil`)

### Button:LockHighlight

Locks the button in its highlight state. When the highlight state is locked, the button will always appear highlighted regardless of whether it is moused over.

**Signature:** `Button:LockHighlight()`

### Button:RegisterForClicks

Registers a button to receive mouse clicks

**Signature:** `Button:RegisterForClicks(...)`

**Arguments:**
- `...` - A list of strings, each the combination of a button name and click action for which the button's click-related script handlers should be run. Possible values: (`list`) 

 - `Button4Down`
- `Button4Up`
- `Button5Down`
- `Button5Up`
- `LeftButtonDown`
- `LeftButtonUp`
- `MiddleButtonDown`
- `MiddleButtonUp`
- `RightButtonDown`
- `RightButtonUp`
- `AnyDown` - Responds to the down action of any mouse button
- `AnyUp` - Responds to the up action of any mouse button

### Button:SetButtonState

Sets the button's state

**Signature:** `Button:SetButtonState("state", lock)`

**Arguments:**
- `state` - State for the button (`string`) 

 - `DISABLED` - Button is disabled and cannot receive user input
- `NORMAL` - Button is in its normal state
- `PUSHED` - Button is pushed (as during a click on the button)
- `lock` - Locks the button in the given state; e.g. if `NORMAL`, the button cannot be clicked but remains in the `NORMAL` state (`boolean`)

### Button:SetDisabledFontObject

Sets the font object used for the button's disabled state

**Signature:** `Button:SetDisabledFontObject(font)`

**Arguments:**
- `font` - Reference to a `Font` object to be used when the button is disabled (`font`)

### Button:SetDisabledTexture

Sets the texture used when the button is disabled

**Signature:** `Button:SetDisabledTexture(texture) or Button:SetDisabledTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

### Button:SetFontString

Sets the `FontString` object used for the button's label text

**Signature:** `Button:SetFontString(fontstring)`

**Arguments:**
- `fontstring` - Reference to a `FontString` object to be used for the button's label text (`fontstring`)

### Button:SetFormattedText

Sets the button's label, using a format string and arguments. This prevents a new text string from being allocated, saving memory if the text is frequently changed to a new string

**Signature:** `Button:SetFormattedText("fmt", ...)`

**Arguments:**
- `fmt` - A format string to be passed to string.format() (`string`)
- `...` - A list of arguments to the string.format() function corresponding to the specified format string (`values`)

### Button:SetHighlightFontObject

Sets the font object used when the button is highlighted

**Signature:** `Button:SetHighlightFontObject(font)`

**Arguments:**
- `font` - Reference to a `Font` object to be used when the button is highlighted (`font`)

### Button:SetHighlightTexture

Sets the texture used when the button is highlighted. Unlike the other button textures for which only one is visible at a time, the button's highlight texture is drawn on top of its existing (normal or pushed) texture; thus, this method also allows specification of the texture's blend mode.

**Signature:** `Button:SetHighlightTexture(texture [, "mode"]) or Button:SetHighlightTexture("filename" [, "mode"])`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)
- `mode` - Blend mode for the texture; defaults to `ADD` if omitted (`string`) 

 - `ADD` - Adds texture color values to the underlying color values, using the alpha channel; light areas in the texture lighten the background while dark areas are more transparent
- `ALPHAKEY` - One-bit transparency; pixels with alpha values greater than ~0.8 are treated as fully opaque and all other pixels are treated as fully transparent
- `BLEND` - Normal color blending, using any alpha channel in the texture image
- `DISABLE` - Ignores any alpha channel, displaying the texture as fully opaque
- `MOD` - Ignores any alpha channel in the texture and multiplies texture color values by background color values; dark areas in the texture darken the background while light areas are more transparent

### Button:SetMotionScriptsWhileDisabled

Sets whether the button should fire OnEnter/OnLeave events while disabled

**Signature:** `Button:SetMotionScriptsWhileDisabled(enabled)`

**Arguments:**
- `enabled` - True to enable the scripts while the button is disabled, false otherwise (`boolean`)

### Button:SetNormalFontObject

Sets the font object used for the button's normal state

**Signature:** `Button:SetNormalFontObject(font)`

**Arguments:**
- `font` - Reference to a `Font` object to be used in the button's normal state (`font`)

### Button:SetNormalTexture

Sets the texture used for the button's normal state

**Signature:** `Button:SetNormalTexture(texture) or Button:SetNormalTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

### Button:SetPushedTextOffset

Sets the offset for moving the button's label text when pushed. Moving the button's text while it is being clicked can provide an illusion of 3D depth for the button -- in the default UI's standard button templates, this offset matches the apparent movement seen in the difference between the buttons' normal and pushed textures.

**Signature:** `Button:SetPushedTextOffset(x, y)`

**Arguments:**
- `x` - Horizontal offset for the text (in pixels; values increasing to the right) (`number`)
- `y` - Vertical offset for the text (in pixels; values increasing upward) (`number`)

### Button:SetPushedTexture

Sets the texture used when the button is pushed

**Signature:** `Button:SetPushedTexture(texture) or Button:SetPushedTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

### Button:SetText

Sets the text displayed as the button's label

**Signature:** `Button:SetText("text")`

**Arguments:**
- `text` - Text to be displayed as the button's label (`string`)

### Button:UnlockHighlight

Unlocks the button's highlight state. Can be used after a call to `:LockHighlight()` to restore the button's normal mouseover behavior.

**Signature:** `Button:UnlockHighlight()`

