# Widget: FontInstance

---

## FontInstance

_No snapshot available for widget overview._

### Methods

### FontInstance:GetFont

Returns the font instance's basic font properties

**Signature:** `filename, fontHeight, flags = FontInstance:GetFont()`

**Returns:**
- `filename` - Path to a font file (`string`)
- `fontHeight` - Height (point size) of the font to be displayed (in pixels) (`number`)
- `flags` - Additional properties for the font specified by one or more (separated by commas) of the following tokens: (`string`) 

 - `MONOCHROME` - Font is rendered without antialiasing
- `OUTLINE` - Font is displayed with a black outline
- `THICKOUTLINE` - Font is displayed with a thick black outline

### FontInstance:GetFontObject

Returns the `Font` object from which the font instance's properties are inherited. See `FontInstance:SetFontObject()` for details.

**Signature:** `font = FontInstance:GetFontObject()`

**Returns:**
- `font` - Reference to the `Font` object from which the font instance's properties are inherited, or `nil` if the font instance has no inherited properties (`font`)

### FontInstance:GetJustifyH

Returns the font instance's horizontal text alignment style

**Signature:** `justify = FontInstance:GetJustifyH()`

**Returns:**
- `justify` - Horizontal text alignment style (`string`, justifyH) 

 - `CENTER`
- `LEFT`
- `RIGHT`

### FontInstance:GetJustifyV

Returns the font instance's vertical text alignment style

**Signature:** `justify = FontInstance:GetJustifyV()`

**Returns:**
- `justify` - Vertical text alignment style (`string`, justifyV) 

 - `BOTTOM`
- `MIDDLE`
- `TOP`

### FontInstance:GetShadowColor

Returns the color of the font's text shadow

**Signature:** `shadowR, shadowG, shadowB, shadowAlpha = FontInstance:GetShadowColor()`

**Returns:**
- `shadowR` - Red component of the shadow color (0.0 - 1.0) (`number`)
- `shadowG` - Green component of the shadow color (0.0 - 1.0) (`number`)
- `shadowB` - Blue component of the shadow color (0.0 - 1.0) (`number`)
- `shadowAlpha` - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### FontInstance:GetShadowOffset

Returns the offset of the font instance's text shadow from its text

**Signature:** `xOffset, yOffset = FontInstance:GetShadowOffset()`

**Returns:**
- `xOffset` - Horizontal distance between the text and its shadow (in pixels) (`number`)
- `yOffset` - Vertical distance between the text and its shadow (in pixels) (`number`)

### FontInstance:GetSpacing

Returns the font instance's amount of spacing between lines

**Signature:** `spacing = FontInstance:GetSpacing()`

**Returns:**
- `spacing` - Amount of space between lines of text (in pixels) (`number`)

### FontInstance:GetTextColor

Returns the font instance's default text color

**Signature:** `textR, textG, textB, textAlpha = FontInstance:GetTextColor()`

**Returns:**
- `textR` - Red component of the text color (0.0 - 1.0) (`number`)
- `textG` - Green component of the text color (0.0 - 1.0) (`number`)
- `textB` - Blue component of the text color (0.0 - 1.0) (`number`)
- `textAlpha` - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### FontInstance:SetFont

Sets the font instance's basic font properties. Font files included with the default WoW client:

 
 - `Fonts\\FRIZQT__.TTF` - Friz Quadrata, used by default for player names and most UI text
 
 - `Fonts\\ARIALN.TTF` - Arial Narrow, used by default for chat windows, action button numbers, etc.
 
 - `Fonts\\skurri.ttf` - Skurri, used by default for incoming damage/parry/miss/etc indicators on the Player and Pet frames
 
 - `Fonts\\MORPHEUS.ttf` - Morpheus, used by default for quest title headers, mail, and readable in-game objects.

Font files can also be included in addons.

**Signature:** `isValid = FontInstance:SetFont("filename", fontHeight, "flags")`

**Arguments:**
- `filename` - Path to a font file (`string`)
- `fontHeight` - Height (point size) of the font to be displayed (in pixels) (`number`)
- `flags` - Additional properties for the font specified by one or more (separated by commas) of the following tokens: (`string`) 

 - `MONOCHROME` - Font is rendered without antialiasing
- `OUTLINE` - Font is displayed with a black outline
- `THICKOUTLINE` - Font is displayed with a thick black outline

**Returns:**
- `isValid` - `1` if `filename` refers to a valid font file; otherwise `nil` (`1nil`)

### FontInstance:SetFontObject

Sets the `Font` object from which the font instance's properties are inherited. This method allows for easy standardization and reuse of font styles. For example, a button's normal font can be set to appear in the same style as many default UI elements by setting its font to `"GameFontNormal"` -- if Blizzard changes the main UI font in a future patch, or if the user installs another addon which changes the main UI font, the button's font will automatically change to match.

**Signature:** `FontInstance:SetFontObject(object) or FontInstance:SetFontObject("name")`

**Arguments:**
- `object` - Reference to a `Font` object (`font`)
- `name` - Global name of a `Font` object (`string`)

### FontInstance:SetJustifyH

Sets the font instance's horizontal text alignment style

**Signature:** `FontInstance:SetJustifyH("justify")`

**Arguments:**
- `justify` - Horizontal text alignment style (`string`, justifyH) 

 - `CENTER`
- `LEFT`
- `RIGHT`

### FontInstance:SetJustifyV

sets the vertical justification.

**Signature:** `FontInstance:SetJustifyV()`

### FontInstance:SetShadowColor

Sets the color of the font's text shadow

**Signature:** `FontInstance:SetShadowColor(shadowR, shadowG, shadowB, shadowAlpha)`

**Arguments:**
- `shadowR` - Red component of the shadow color (0.0 - 1.0) (`number`)
- `shadowG` - Green component of the shadow color (0.0 - 1.0) (`number`)
- `shadowB` - Blue component of the shadow color (0.0 - 1.0) (`number`)
- `shadowAlpha` - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### FontInstance:SetShadowOffset

Sets the offset of the font instance's text shadow from its text

**Signature:** `FontInstance:SetShadowOffset(xOffset, yOffset)`

**Arguments:**
- `xOffset` - Horizontal distance between the text and its shadow (in pixels) (`number`)
- `yOffset` - Vertical distance between the text and its shadow (in pixels) (`number`)

### FontInstance:SetSpacing

Sets the font instance's amount of spacing between lines

**Signature:** `FontInstance:SetSpacing(spacing)`

**Arguments:**
- `spacing` - Amount of space between lines of text (in pixels) (`number`)

### FontInstance:SetTextColor

Sets the font instance's default text color. This color is used for otherwise unformatted text displayed using the font instance; however, portions of the text may be colored differently using the `colorString` format (commonly seen in `hyperlink`s).

**Signature:** `FontInstance:SetTextColor(textR, textG, textB, textAlpha)`

**Arguments:**
- `textR` - Red component of the text color (0.0 - 1.0) (`number`)
- `textG` - Green component of the text color (0.0 - 1.0) (`number`)
- `textB` - Blue component of the text color (0.0 - 1.0) (`number`)
- `textAlpha` - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

