# Widget: ColorSelect

---

## ColorSelect

_No snapshot available for widget overview._

### Methods

### ColorSelect:GetColorHSV

Returns the hue, saturation and value of the currently selected color

**Signature:** `hue, saturation, value = ColorSelect:GetColorHSV()`

**Returns:**
- `hue` - Hue of the selected color (angle on the color wheel in degrees; 0 = red, increasing counter-clockwise) (`number`)
- `saturation` - Saturation of the selected color (0.0 - 1.0) (`number`)
- `value` - Value of the selected color (0.0 - 1.0) (`number`)

### ColorSelect:GetColorRGB

Returns the red, green and blue components of the currently selected color

**Signature:** `red, blue, green = ColorSelect:GetColorRGB()`

**Returns:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)

### ColorSelect:GetColorValueTexture

Returns the texture for the color picker's value slider background. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.)

**Signature:** `texture = ColorSelect:GetColorValueTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for drawing the value slider background (`texture`)

### ColorSelect:GetColorValueThumbTexture

Returns the texture for the color picker's value slider thumb. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.) The thumb texture is the movable part indicating the current value selection.

**Signature:** `texture = ColorSelect:GetColorValueThumbTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for drawing the slider thumb (`texture`)

### ColorSelect:GetColorWheelTexture

Returns the texture for the color picker's hue/saturation wheel

**Signature:** `texture = ColorSelect:GetColorWheelTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for drawing the hue/saturation wheel (`texture`)

### ColorSelect:GetColorWheelThumbTexture

Returns the texture for the selection indicator on the color picker's hue/saturation wheel

**Signature:** `texture = ColorSelect:GetColorWheelThumbTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for drawing the hue/saturation wheel's selection indicator (`texture`)

### ColorSelect:SetColorHSV

Sets the color picker's selected color by hue, saturation and value

**Signature:** `ColorSelect:SetColorHSV(hue, saturation, value)`

**Arguments:**
- `hue` - Hue of a color (angle on the color wheel in degrees; 0 = red, increasing counter-clockwise) (`number`)
- `saturation` - Saturation of a color (0.0 - 1.0) (`number`)
- `value` - Value of a color (0.0 - 1.0) (`number`)

### ColorSelect:SetColorRGB

Sets the color picker's selected color by red, green and blue components

**Signature:** `ColorSelect:SetColorRGB(red, blue, green)`

**Arguments:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)

### ColorSelect:SetColorValueTexture

Sets the `Texture` object used to display the color picker's value slider. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.

This method does not allow changing the texture image displayed for the slider background; rather, it allows customization of the size and placement of the `Texture` object into which the game engine draws the color value gradient.

**Signature:** `ColorSelect:SetColorValueTexture(texture)`

**Arguments:**
- `texture` - Reference to a `Texture` object (`texture`)

### ColorSelect:SetColorValueThumbTexture

Sets the texture for the color picker's value slider thumb. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.) The thumb texture is the movable part indicating the current value selection.

**Signature:** `ColorSelect:SetColorValueThumbTexture(texture) or ColorSelect:SetColorValueThumbTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

### ColorSelect:SetColorWheelTexture

Sets the `Texture` object used to display the color picker's hue/saturation wheel. This method does not allow changing the texture image displayed for the color wheel; rather, it allows customization of the size and placement of the `Texture` object into which the game engine draws the standard color wheel image.

**Signature:** `ColorSelect:SetColorWheelTexture(texture)`

**Arguments:**
- `texture` - Reference to a `Texture` object (`texture`)

### ColorSelect:SetColorWheelThumbTexture

Sets the texture for the selection indicator on the color picker's hue/saturation wheel

**Signature:** `ColorSelect:SetColorWheelThumbTexture(texture) or ColorSelect:SetColorWheelThumbTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

