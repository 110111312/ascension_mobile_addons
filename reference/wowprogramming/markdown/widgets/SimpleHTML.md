# Widget: SimpleHTML

---

## SimpleHTML

_No snapshot available for widget overview._

### Methods

### SimpleHTML:GetFont

Returns basic properties of a font used in the frame

**Signature:** `filename, fontHeight, flags = SimpleHTML:GetFont(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return font information (e.g. `p`, `h1`); if omitted, returns information about the frame's default font (`string`)

**Returns:**
- `filename` - Path to a font file (`string`)
- `fontHeight` - Height (point size) of the font to be displayed (in pixels) (`number`)
- `flags` - Additional properties for the font specified by one or more (separated by commas) of the following tokens: (`string`) 

 - `MONOCHROME` - Font is rendered without antialiasing
- `OUTLINE` - Font is displayed with a black outline
- `THICKOUTLINE` - Font is displayed with a thick black outline

### SimpleHTML:GetFontObject

Returns the `Font` object from which the properties of a font used in the frame are inherited

**Signature:** `font = SimpleHTML:GetFontObject(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return font information (e.g. `p`, `h1`); if omitted, returns information about the frame's default font (`string`)

**Returns:**
- `font` - Reference to the `Font` object from which font properties are inherited, or `nil` if no properties are inherited (`font`)

### SimpleHTML:GetHyperlinkFormat

Returns the format string used for displaying hyperlinks in the frame. See `:SetHyperlinkFormat()` for details.

**Signature:** `format = SimpleHTML:GetHyperlinkFormat()`

**Returns:**
- `format` - Format string used for displaying hyperlinks in the frame (`string`)

### SimpleHTML:GetHyperlinksEnabled

Returns whether hyperlinks in the frame's text are interactive

**Signature:** `enabled = SimpleHTML:GetHyperlinksEnabled()`

**Returns:**
- `enabled` - `1` if hyperlinks in the frame's text are interactive; otherwise `nil` (`1nil`)

### SimpleHTML:GetIndentedWordWrap

Returns whether long lines of text are indented when wrapping

**Signature:** `indent = SimpleHTML:GetIndentedWordWrap(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return text style information (e.g. `p`, `h1`); if omitted, returns information about the frame's default text style (`string`)

**Returns:**
- `indent` - `1` if long lines of text are indented when wrapping; otherwise `nil` (`1nil`)

### SimpleHTML:GetJustifyH

Returns the horizontal alignment style for text in the frame

**Signature:** `justify = SimpleHTML:GetJustifyH(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return text style information (e.g. `p`, `h1`); if omitted, returns information about the frame's default text style (`string`)

**Returns:**
- `justify` - Horizontal text alignment style (`string`, justifyH) 

 - `CENTER`
- `LEFT`
- `RIGHT`

### SimpleHTML:GetJustifyV

Returns the vertical alignment style for text in the frame

**Signature:** `justify = SimpleHTML:GetJustifyV(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return text style information (e.g. `p`, `h1`); if omitted, returns information about the frame's default text style (`string`)

**Returns:**
- `justify` - Vertical text alignment style (`string`, justifyV) 

 - `BOTTOM`
- `MIDDLE`
- `TOP`

### SimpleHTML:GetShadowColor

Returns the shadow color for text in the frame

**Signature:** `shadowR, shadowG, shadowB, shadowAlpha = SimpleHTML:GetShadowColor(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return font information (e.g. `p`, `h1`); if omitted, returns information about the frame's default font (`string`)

**Returns:**
- `shadowR` - Red component of the shadow color (0.0 - 1.0) (`number`)
- `shadowG` - Green component of the shadow color (0.0 - 1.0) (`number`)
- `shadowB` - Blue component of the shadow color (0.0 - 1.0) (`number`)
- `shadowAlpha` - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### SimpleHTML:GetShadowOffset

Returns the offset of text shadow from text in the frame

**Signature:** `xOffset, yOffset = SimpleHTML:GetShadowOffset(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return font information (e.g. `p`, `h1`); if omitted, returns information about the frame's default font (`string`)

**Returns:**
- `xOffset` - Horizontal distance between the text and its shadow (in pixels) (`number`)
- `yOffset` - Vertical distance between the text and its shadow (in pixels) (`number`)

### SimpleHTML:GetSpacing

Returns the amount of spacing between lines of text in the frame

**Signature:** `spacing = SimpleHTML:GetSpacing(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return font information (e.g. `p`, `h1`); if omitted, returns information about the frame's default font (`string`)

**Returns:**
- `spacing` - Amount of space between lines of text (in pixels) (`number`)

### SimpleHTML:GetTextColor

Returns the color of text in the frame

**Signature:** `textR, textG, textB, textAlpha = SimpleHTML:GetTextColor(["element"])`

**Arguments:**
- `element` - Name of an HTML element for which to return font information (e.g. `p`, `h1`); if omitted, returns information about the frame's default font (`string`)

**Returns:**
- `textR` - Red component of the text color (0.0 - 1.0) (`number`)
- `textG` - Green component of the text color (0.0 - 1.0) (`number`)
- `textB` - Blue component of the text color (0.0 - 1.0) (`number`)
- `textAlpha` - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### SimpleHTML:SetFont

Sets basic properties of a font used in the frame

**Signature:** `isValid = SimpleHTML:SetFont(["element",] "filename", fontHeight, "flags")`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `filename` - Path to a font file (`string`)
- `fontHeight` - Height (point size) of the font to be displayed (in pixels) (`number`)
- `flags` - Additional properties for the font specified by one or more (separated by commas) of the following tokens: (`string`) 

 - `MONOCHROME` - Font is rendered without antialiasing
- `OUTLINE` - Font is displayed with a black outline
- `THICKOUTLINE` - Font is displayed with a thick black outline

**Returns:**
- `isValid` - `1` if `filename` refers to a valid font file; otherwise `nil` (`1nil`)

### SimpleHTML:SetFontObject

Sets the `Font` object from which the properties of a font used in the frame are inherited. This method allows for easy standardization and reuse of font styles. For example, a SimpleHTML frame's normal font can be set to appear in the same style as many default UI elements by setting its font to `"GameFontNormal"` -- if Blizzard changes the main UI font in a future path, or if the user installs another addon which changes the main UI font, the button's font will automatically change to match.

**Signature:** `SimpleHTML:SetFontObject(["element",] font) or SimpleHTML:SetFontObject(["element",] "name")`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `font` - Reference to a `Font` object (`table`)
- `name` - Global name of a `Font` object (`string`)

### SimpleHTML:SetHyperlinkFormat

Sets the format string used for displaying hyperlinks in the frame. Hyperlinks are specified via HTML in the text input to a `SimpleHTML` frame, but in order to be handled as hyperlinks by the game's text engine they need to be formatted like the hyperlinks used elsewhere. 

This property specifies the translation between formats: its default value of `|H%s|h%s|h` provides minimal formatting, turning (for example) `<a href="achievement:892">The Right Stuff</a>` into `|Hachievement:892|hThe Right Stuff|h`. Using a `colorString` or other formatting may be useful for making hyperlinks distinguishable from other text.

**Signature:** `SimpleHTML:SetHyperlinkFormat("format")`

**Arguments:**
- `format` - Format string used for displaying hyperlinks in the frame (`string`)

### SimpleHTML:SetHyperlinksEnabled

Enables or disables hyperlink interactivity in the frame. The frame's hyperlink-related script handlers will only be run if hyperlinks are enabled.

**Signature:** `SimpleHTML:SetHyperlinksEnabled(enable)`

**Arguments:**
- `enable` - True to enable hyperlink interactivity in the frame; false to disable (`boolean`)

### SimpleHTML:SetIndentedWordWrap

Sets whether long lines of text are indented when wrapping

**Signature:** `SimpleHTML:SetIndentedWordWrap(["element",] indent)`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `indent` - True to indent wrapped lines of text; false otherwise (`boolean`)

### SimpleHTML:SetJustifyH

Sets the horizontal alignment style for text in the frame

**Signature:** `SimpleHTML:SetJustifyH(["element",] "justify")`

**Arguments:**
- `element` - Name of an HTML element for which to set properties (e.g. `p`, `h1`); if omitted, sets properties of the frame's default text style (`string`)
- `justify` - Horizontal text alignment style (`string`, justifyH) 

 - `CENTER`
- `LEFT`
- `RIGHT`

### SimpleHTML:SetJustifyV

Sets the vertical alignment style for text in the frame

**Signature:** `SimpleHTML:SetJustifyV(["element",] "justify")`

**Arguments:**
- `element` - Name of an HTML element for which to return text style information (e.g. `p`, `h1`); if omitted, returns information about the frame's default text style (`string`)
- `justify` - Vertical text alignment style (`string`, justifyV) 

 - `BOTTOM`
- `MIDDLE`
- `TOP`

### SimpleHTML:SetShadowColor

Sets the shadow color for text in the frame

**Signature:** `SimpleHTML:SetShadowColor(["element",] shadowR, shadowG, shadowB, shadowAlpha)`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `shadowR` - Red component of the shadow color (0.0 - 1.0) (`number`)
- `shadowG` - Green component of the shadow color (0.0 - 1.0) (`number`)
- `shadowB` - Blue component of the shadow color (0.0 - 1.0) (`number`)
- `shadowAlpha` - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### SimpleHTML:SetShadowOffset

Returns the offset of text shadow from text in the frame

**Signature:** `SimpleHTML:SetShadowOffset(["element",] xOffset, yOffset)`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `xOffset` - Horizontal distance between the text and its shadow (in pixels) (`number`)
- `yOffset` - Vertical distance between the text and its shadow (in pixels) (`number`)

### SimpleHTML:SetSpacing

Sets the amount of spacing between lines of text in the frame

**Signature:** `SimpleHTML:SetSpacing(["element",] spacing)`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `spacing` - Amount of space between lines of text (in pixels) (`number`)

### SimpleHTML:SetText

Sets the text to be displayed in the SimpleHTML frame. Text for display in the frame can be formatted using a simplified version of HTML markup:

 
 - For HTML formatting, the entire text must be enclosed in `<html><body>` and `</body></html>` tags.
 
 - All tags must be closed (`img` and `br` must use self-closing syntax; e.g. `<br/>`, not `<br>`).
 
 - Tags are case insensitive, but closing tags must match the case of opening tags.
 
 - Attribute values must be enclosed in single or double quotation marks (`"` or `'`).
 
 - Characters occurring in HTML markup must be entity-escaped (`&quot;` `&lt;` `&gt;` `&amp;`); no other entity-escapes are supported.
 
 - Unrecognized tags and their contents are ignored (e.g. given `<h1><foo>bar</foo>baz</h1>`, only "baz" will appear).
 
 - Any HTML parsing error will result in the raw HTML markup being displayed.

Only the following tags and attributes are supported:

 
 - 
`p`, `h1`, `h2`, `h3` - Block elements; e.g. `<p align="left">`

 

 
 - `align` - Text alignment style (optional); allowed values are `left`, `center`, and `right`.
 

 
 - 
`img` - Image; may only be used as a block element (not inline with text); e.g. `<img src="Interface\Icons\INV_Misc_Rune_01" />`.

 

 
 - `src` - Path to the image file (filename extension omitted).
 
 - `align` - Alignment of the image block in the frame (optional); allowed values are `left`, `center`, and `right`.
 
 - `width` - Width at which to display the image (in pixels; optional).
 
 - `height` - Height at which to display the image (in pixels; optional).
 

 
 - 
`a` - Inline hyperlink; e.g. `<a href="aLink">text</a>`

 

 
 - `href` - String identifying the link; passed as argument to hyperlink-related scripts when the player interacts with the link.
 

 
 - 
`br` - Explicit line break in text; e.g. `<br />`.

Inline escape sequences used in FontStrings (e.g. `colorString`s) may also be used.

**Signature:** `SimpleHTML:SetText("text")`

**Arguments:**
- `text` - Text (with HTML markup) to be displayed (`string`)

### SimpleHTML:SetTextColor

Sets the color of text in the frame

**Signature:** `SimpleHTML:SetTextColor(["element",] textR, textG, textB, textAlpha)`

**Arguments:**
- `element` - Name of an HTML element for which to set font properties (e.g. `p`, `h1`); if omitted, sets properties for the frame's default font (`string`)
- `textR` - Red component of the text color (0.0 - 1.0) (`number`)
- `textG` - Green component of the text color (0.0 - 1.0) (`number`)
- `textB` - Blue component of the text color (0.0 - 1.0) (`number`)
- `textAlpha` - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

