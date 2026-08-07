# Widget: LayeredRegion

---

## LayeredRegion

LayeredRegion is an abstract UI type that groups together the functionality of layered graphical regions, specifically Textures and FontStrings. These objects can be moved from one layer to another, or can be suppressed by turning off the layer on the frame to which they are attached. These layered regions can also be colorized in the graphics engine using the `:SetVertexColor()` method.

### Methods

### LayeredRegion:GetDrawLayer

Returns the layer at which the region's graphics are drawn relative to others in its frame

**Signature:** `layer = LayeredRegion:GetDrawLayer()`

**Returns:**
- `layer` - String identifying a graphics layer; one of the following values: (`string`, layer) 

 - `ARTWORK`
- `BACKGROUND`
- `BORDER`
- `HIGHLIGHT`
- `OVERLAY`

### LayeredRegion:SetDrawLayer

Sets the layer at which the region's graphics are drawn relative to others in its frame

**Signature:** `LayeredRegion:SetDrawLayer("layer")`

**Arguments:**
- `layer` - String identifying a graphics layer; one of the following values: (`string`, layer) 

 - `ARTWORK`
- `BACKGROUND`
- `BORDER`
- `HIGHLIGHT`
- `OVERLAY`

### LayeredRegion:SetVertexColor

Sets a color shading for the region's graphics. The effect of changing this property differs by the type of region:

For `FontString`s, this color overrides the normal text color (as set by `FontInstance:SetTextColor()`).

For `Texture`s, this color acts as a filter applied to the texture image: each color component value is a factor by which the corresponding component values in the image are multiplied. (See examples.)

**Signature:** `LayeredRegion:SetVertexColor(red, green, blue [, alpha])`

**Arguments:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

