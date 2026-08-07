# Widget: FontString

---

## FontString

_No snapshot available for widget overview._

### Methods

### FontString:CanNonSpaceWrap

Returns whether long lines of text will wrap within or between words

**Signature:** `enabled = FontString:CanNonSpaceWrap()`

**Returns:**
- `enabled` - `1` if long lines of text will wrap at any character boundary (i.e possibly in the middle of a word); `nil` to only wrap at whitespace characters (i.e. only between words) (`1nil`)

### FontString:GetIndentedWordWrap

### FontString:GetStringHeight

Returns the height of the text displayed in the font string. This value is based on the text currently displayed; e.g. a long block of text wrapped to several lines results in a greater height than that for a short block of text that fits on fewer lines.

**Signature:** `height = FontString:GetStringHeight()`

**Returns:**
- `height` - Height of the text currently displayed in the font string (in pixels) (`number`)

### FontString:GetStringWidth

Returns the width of the text displayed in the font string. This value is based on the text currently displayed; e.g. a short text label results in a smaller width than a longer block of text. Very long blocks of text that don't fit the font string's dimensions all result in similar widths, because this method measures the width of the text displayed, which is truncated with an ellipsis ("…").

**Signature:** `width = FontString:GetStringWidth()`

**Returns:**
- `width` - Width of the text currently displayed in the font string (in pixels) (`number`)

### FontString:GetText

Returns the text currently set for display in the font string. This is not necessarily the text actually displayed: text that does not fit within the `FontString`'s dimensions will be truncated with an ellipsis ("…") for display.

**Signature:** `text = FontString:GetText()`

**Returns:**
- `text` - Text to be displayed in the font string (`string`)

### FontString:SetAlphaGradient

Creates an opacity gradient over the text in the font string. Seen in the default UI when quest text is presented by a questgiver (if the "Instant Quest Text" feature is not turned on): This method is used with a length of 30 to fade in the letters of the description, starting at the first character; then the start value is incremented in an `OnUpdate` script, creating the animated fade-in effect.

**Signature:** `FontString:SetAlphaGradient(start, length)`

**Arguments:**
- `start` - Character position in the font string's text at which the gradient should begin (between `0` and `string.len(fontString:``GetText()``) - 6`) (`number`)
- `length` - Width of the gradient in pixels, or `0` to restore the text to full opacity (`number`)

### FontString:SetFormattedText

Sets the text displayed in the font string using format specifiers. Equivalent to `:SetText(``format(format, ...)``)`, but does not create a throwaway Lua string object, resulting in greater memory-usage efficiency.

**Signature:** `FontString:SetFormattedText("formatString", ...)`

**Arguments:**
- `formatString` - A string containing format specifiers (as with `string.format()`) (`string`)
- `...` - A list of values to be included in the formatted string (`list`)

### FontString:SetIndentedWordWrap

### FontString:SetNonSpaceWrap

Sets whether long lines of text will wrap within or between words

**Signature:** `FontString:SetNonSpaceWrap(enable)`

**Arguments:**
- `enable` - True to wrap long lines of text at any character boundary (i.e possibly in the middle of a word); false to only wrap at whitespace characters (i.e. only between words) (`boolean`)

### FontString:SetText

Sets the text to be displayed in the font string

**Signature:** `FontString:SetText()`

### FontString:SetTextHeight

Scales the font string's rendered text to a different height. This method scales the image of the text as already rendered at its existing height by the game's graphics engine -- producing an effect which is efficient enough for use in fast animations, but with reduced visual quality in the text. To re-render the text at a new point size, see `:SetFont()`.

**Signature:** `FontString:SetTextHeight(height)`

**Arguments:**
- `height` - Height (point size) to which the text should be scaled (in pixels) (`number`)

