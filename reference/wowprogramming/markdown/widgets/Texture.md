# Widget: Texture

---

## Texture

_No snapshot available for widget overview._

### Methods

### Texture:GetBlendMode

Returns the blend mode of the texture

**Signature:** `mode = Texture:GetBlendMode()`

**Returns:**
- `mode` - Blend mode of the texture (`string`) 

 - `ADD` - Adds texture color values to the underlying color values, using the alpha channel; light areas in the texture lighten the background while dark areas are more transparent
- `ALPHAKEY` - One-bit transparency; pixels with alpha values greater than ~0.8 are treated as fully opaque and all other pixels are treated as fully transparent
- `BLEND` - Normal color blending, using any alpha channel in the texture image
- `DISABLE` - Ignores any alpha channel, displaying the texture as fully opaque
- `MOD` - Ignores any alpha channel in the texture and multiplies texture color values by background color values; dark areas in the texture darken the background while light areas are more transparent

### Texture:GetHorizTile

### Texture:GetNonBlocking

Returns whether the texture object loads its image file in the background. See `:SetNonBlocking()` for further details.

**Signature:** `nonBlocking = Texture:GetNonBlocking()`

**Returns:**
- `nonBlocking` - `1` if the texture object loads its image file in the background; `nil` if the game engine is halted while the texture loads (`1nil`)

### Texture:GetTexCoord

Returns corner coordinates for scaling or cropping the texture image. See `Texture:SetTexCoord()` example for details.

**Signature:** `ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = Texture:GetTexCoord()`

**Returns:**
- `ULx` - Upper left corner X position, as a fraction of the image's width from the left (`number`)
- `ULy` - Upper left corner Y position, as a fraction of the image's height from the top (`number`)
- `LLx` - Lower left corner X position, as a fraction of the image's width from the left (`number`)
- `LLy` - Lower left corner Y position, as a fraction of the image's height from the top (`number`)
- `URx` - Upper right corner X position, as a fraction of the image's width from the left (`number`)
- `URy` - Upper right corner Y position, as a fraction of the image's height from the top (`number`)
- `LRx` - Lower right corner X position, as a fraction of the image's width from the left (`number`)
- `LRy` - Lower right corner Y position, as a fraction of the image's height from the top (`number`)

### Texture:GetVertexColor

Returns the shading color of the texture. For details about vertex color shading, see `LayeredRegion:SetVertexColor()`.

**Signature:** `red, green, blue, alpha = Texture:GetVertexColor()`

**Returns:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the texture (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Texture:GetVertTile

### Texture:IsDesaturated

Returns whether the texture image should be displayed with zero saturation (i.e. converted to grayscale). The texture may not actually be displayed in grayscale if the current display hardware doesn't support that feature; see `Texture:SetDesaturated()` for details.

**Signature:** `desaturated = Texture:IsDesaturated()`

**Returns:**
- `desaturated` - `1` if the texture should be displayed in grayscale; otherwise `nil` (`1nil`)

### Texture:SetBlendMode

Sets the blend mode of the texture

**Signature:** `Texture:SetBlendMode("mode")`

**Arguments:**
- `mode` - Blend mode of the texture (`string`) 

 - `ADD` - Adds texture color values to the underlying color values, using the alpha channel; light areas in the texture lighten the background while dark areas are more transparent
- `ALPHAKEY` - One-bit transparency; pixels with alpha values greater than ~0.8 are treated as fully opaque and all other pixels are treated as fully transparent
- `BLEND` - Normal color blending, using any alpha channel in the texture image
- `DISABLE` - Ignores any alpha channel, displaying the texture as fully opaque
- `MOD` - Ignores any alpha channel in the texture and multiplies texture color values by background color values; dark areas in the texture darken the background while light areas are more transparent

### Texture:SetDesaturated

Sets whether the texture image should be displayed with zero saturation (i.e. converted to grayscale). Returns `nil` if the current system does not support texture desaturation; in such cases, this method has no visible effect (but still flags the texture object as desaturated). Authors may wish to implement an alternative to desaturation for such cases (see example).

**Signature:** `supported = Texture:SetDesaturated(desaturate)`

**Arguments:**
- `desaturate` - True to display the texture in grayscale; false to display original texture colors (`boolean`)

**Returns:**
- `supported` - `1` if the current system supports texture desaturation; otherwise `nil` (`1nil`)

### Texture:SetGradient

Sets a gradient color shading for the texture. Gradient color shading does not change the underlying color of the texture image, but acts as a filter: see `LayeredRegion:SetVertexColor()` for details.

**Signature:** `Texture:SetGradient("orientation", startR, startG, startB, endR, endG, endB)`

**Arguments:**
- `orientation` - Token identifying the direction of the gradient (`string`) 

 - `HORIZONTAL` - Start color on the left, end color on the right
- `VERTICAL` - Start color at the bottom, end color at the top
- `startR` - Red component of the start color (0.0 - 1.0) (`number`)
- `startG` - Green component of the start color (0.0 - 1.0) (`number`)
- `startB` - Blue component of the start color (0.0 - 1.0) (`number`)
- `endR` - Red component of the end color (0.0 - 1.0) (`number`)
- `endG` - Green component of the end color (0.0 - 1.0) (`number`)
- `endB` - Blue component of the end color (0.0 - 1.0) (`number`)

### Texture:SetGradientAlpha

Sets a gradient color shading for the texture (including opacity in the gradient). Gradient color shading does not change the underlying color of the texture image, but acts as a filter: see `LayeredRegion:SetVertexColor()` for details.

**Signature:** `Texture:SetGradientAlpha("orientation", startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)`

**Arguments:**
- `orientation` - Token identifying the direction of the gradient (`string`) 

 - `HORIZONTAL` - Start color on the left, end color on the right
- `VERTICAL` - Start color at the bottom, end color at the top
- `startR` - Red component of the start color (0.0 - 1.0) (`number`)
- `startG` - Green component of the start color (0.0 - 1.0) (`number`)
- `startB` - Blue component of the start color (0.0 - 1.0) (`number`)
- `startAlpha` - Alpha (opacity) for the start side of the gradient (0.0 = fully transparent, 1.0 = fully opaque) (`number`)
- `endR` - Red component of the end color (0.0 - 1.0) (`number`)
- `endG` - Green component of the end color (0.0 - 1.0) (`number`)
- `endB` - Blue component of the end color (0.0 - 1.0) (`number`)
- `endAlpha` - Alpha (opacity) for the end side of the gradient (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Texture:SetHorizTile

### Texture:SetNonBlocking

Sets whether the texture object loads its image file in the background. Texture loading is normally synchronous, so that UI objects are not shown partially textured while loading; however, non-blocking (asynchronous) texture loading may be desirable in some cases where large numbers of textures need to be loaded in a short time. This feature is used in the default UI's icon chooser window for macros and equipment sets, allowing a large number of icon textures to be loaded without causing the game's frame rate to stagger.

**Signature:** `Texture:SetNonBlocking(nonBlocking)`

**Arguments:**
- `nonBlocking` - True to allow the texture object to load its image file in the background; false (default) to halt the game engine while the texture loads (`boolean`)

### Texture:SetRotation

Rotates the texture image. This is an efficient shorthand for the more complex `Texture:SetTexCoord()`.

**Signature:** `Texture:SetRotation(radians)`

**Arguments:**
- `radians` - Amount by which the texture image should be rotated (in radians; positive values for counter-clockwise rotation, negative for clockwise) (`number`)

### Texture:SetTexCoord

Sets corner coordinates for scaling or cropping the texture image. See example for details.

**Signature:** `Texture:SetTexCoord(left, right, top, bottom) or Texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)`

**Arguments:**
- `left` - Left edge of the scaled/cropped image, as a fraction of the image's width from the left (`number`)
- `right` - Right edge of the scaled/cropped image, as a fraction of the image's width from the left (`number`)
- `top` - Top edge of the scaled/cropped image, as a fraction of the image's height from the top (`number`)
- `bottom` - Bottom edge of the scaled/cropped image, as a fraction of the image's height from the top (`number`)
- `ULx` - Upper left corner X position, as a fraction of the image's width from the left (`number`)
- `ULy` - Upper left corner Y position, as a fraction of the image's height from the top (`number`)
- `LLx` - Lower left corner X position, as a fraction of the image's width from the left (`number`)
- `LLy` - Lower left corner Y position, as a fraction of the image's height from the top (`number`)
- `URx` - Upper right corner X position, as a fraction of the image's width from the left (`number`)
- `URy` - Upper right corner Y position, as a fraction of the image's height from the top (`number`)
- `LRx` - Lower right corner X position, as a fraction of the image's width from the left (`number`)
- `LRy` - Lower right corner Y position, as a fraction of the image's height from the top (`number`)

### Texture:SetTexture

Sets the texture object's image or color. Returns `nil` if the texture could not be set (e.g. if the file path is invalid or points to a file which cannot be used as a texture).

**Signature:** `visible = Texture:SetTexture("texture") or Texture:SetTexture(red, green, blue [, alpha])`

**Arguments:**
- `texture` - Path to a texture image (`string`)
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the color (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

**Returns:**
- `visible` - `1` if the texture was successfully changed; otherwise `nil` (`1nil`)

### Texture:SetVertTile

