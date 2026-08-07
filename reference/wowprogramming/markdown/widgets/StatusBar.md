# Widget: StatusBar

---

## StatusBar

_No snapshot available for widget overview._

### Methods

### StatusBar:GetMinMaxValues

Returns the minimum and maximum values of the status bar

**Signature:** `minValue, maxValue = StatusBar:GetMinMaxValues()`

**Returns:**
- `minValue` - Lower boundary for values represented on the status bar (`number`)
- `maxValue` - Upper boundary for values represented on the status bar (`number`)

### StatusBar:GetOrientation

Returns the orientation of the status bar

**Signature:** `orientation = StatusBar:GetOrientation()`

**Returns:**
- `orientation` - Token describing the orientation and direction of the status bar (`string`) 

 - `HORIZONTAL` - Fills from left to right as the status bar value increases
- `VERTICAL` - Fills from top to bottom as the status bar value increases

### StatusBar:GetRotatesTexture

Returns whether the status bar's texture is rotated to match its orientation

**Signature:** `rotate = StatusBar:GetRotatesTexture()`

**Returns:**
- `rotate` - `1` if the status bar texture should be rotated 90 degrees counter-clockwise when the status bar is vertically oriented; otherwise `nil` (`1nil`)

### StatusBar:GetStatusBarColor

Returns the color shading used for the status bar's texture

**Signature:** `red, green, blue, alpha = StatusBar:GetStatusBarColor()`

**Returns:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### StatusBar:GetStatusBarTexture

Returns the `Texture` object used for drawing the filled-in portion of the status bar

**Signature:** `texture = StatusBar:GetStatusBarTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used for drawing the filled-in portion of the status bar (`texture`)

### StatusBar:GetValue

Returns the current value of the status bar

**Signature:** `value = StatusBar:GetValue()`

**Returns:**
- `value` - Value indicating the amount of the status bar's area to be filled in (between `minValue` and `maxValue`, where `minValue, maxValue = StatusBar``:GetMinMaxValues()`) (`number`)

### StatusBar:SetMinMaxValues

Sets the minimum and maximum values of the status bar

**Signature:** `StatusBar:SetMinMaxValues(minValue, maxValue)`

**Arguments:**
- `minValue` - Lower boundary for values represented on the status bar (`number`)
- `maxValue` - Upper boundary for values represented on the status bar (`number`)

### StatusBar:SetOrientation

Sets the orientation of the status bar

**Signature:** `StatusBar:SetOrientation("orientation")`

**Arguments:**
- `orientation` - Token describing the orientation and direction of the status bar (`string`) 

 - `HORIZONTAL` - Fills from left to right as the status bar value increases (default)
- `VERTICAL` - Fills from top to bottom as the status bar value increases

### StatusBar:SetRotatesTexture

Sets whether the status bar's texture is rotated to match its orientation

**Signature:** `StatusBar:SetRotatesTexture(rotate)`

**Arguments:**
- `rotate` - True to rotate the status bar texture 90 degrees counter-clockwise when the status bar is vertically oriented; false otherwise (`1nil`)

### StatusBar:SetStatusBarColor

Sets the color shading for the status bar's texture. As with `:SetVertexColor()`, this color is a shading applied to the texture image.

**Signature:** `StatusBar:SetStatusBarColor(red, green, blue [, alpha])`

**Arguments:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### StatusBar:SetStatusBarTexture

Sets the texture used for drawing the filled-in portion of the status bar. The texture image is stretched to fill the dimensions of the entire status bar, then cropped to show only a portion corresponding to the status bar's current value.

**Signature:** `StatusBar:SetStatusBarTexture(texture [, "layer"]) or StatusBar:SetStatusBarTexture("filename" [, "layer"])`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)
- `layer` - Graphics layer in which the texture should be drawn; defaults to `ARTWORK` if not specified (`string`, layer)

### StatusBar:SetValue

Sets the value of the status bar

**Signature:** `StatusBar:SetValue(value)`

**Arguments:**
- `value` - Value indicating the amount of the status bar's area to be filled in (between `minValue` and `maxValue`, where `minValue, maxValue = StatusBar``:GetMinMaxValues()`) (`number`)

