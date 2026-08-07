# Widget: Font

---

## Font

The Font object is the only type of object that is not attached to a parent widget; indeed, its purpose is to be shared between other objects that share font characteristics. In this way, changes to the Font object will update the text appearance of all text objects that have it set as their Font using `:SetFontObject()`. This allows a coder to maintain a consistent appearance between UI elements, as well as simplifying the resourcs and work required to update multiple text-based UI elements.

### Methods

### Font:CopyFontObject

Sets the font's properties to match those of another Font object. Unlike `FontInstance:SetFontObject()`, this method allows one-time reuse of another font object's properties without continuing to inherit future changes made to the other object's properties.

**Signature:** `Font:CopyFontObject(object) or Font:CopyFontObject("name")`

**Arguments:**
- `object` - Reference to a `Font` object (`font`)
- `name` - Global name of a `Font` object (`string`)

### Font:GetAlpha

Returns the opacity for text displayed by the font

**Signature:** `alpha = Font:GetAlpha()`

**Returns:**
- `alpha` - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Font:GetIndentedWordWrap

### Font:SetAlpha

Sets the opacity for text displayed by the font

**Signature:** `Font:SetAlpha(alpha)`

**Arguments:**
- `alpha` - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Font:SetIndentedWordWrap

