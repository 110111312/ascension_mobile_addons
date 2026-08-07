# Widget: CheckButton

---

## CheckButton

_No snapshot available for widget overview._

### Methods

### CheckButton:GetChecked

Returns whether the check button is checked

**Signature:** `enabled = CheckButton:GetChecked()`

**Returns:**
- `enabled` - `1` if the button is checked; `nil` if the button is unchecked (`1nil`)

### CheckButton:GetCheckedTexture

Returns the texture used when the button is checked

**Signature:** `texture = CheckButton:GetCheckedTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used when the button is checked (`texture`)

### CheckButton:GetDisabledCheckedTexture

Returns the texture used when the button is disabled and checked

**Signature:** `texture = CheckButton:GetDisabledCheckedTexture()`

**Returns:**
- `texture` - Reference to the `Texture` object used when the button is disabled and checked (`texture`)

### CheckButton:SetChecked

Sets whether the check button is checked

**Signature:** `CheckButton:SetChecked(enable)`

**Arguments:**
- `enable` - True to check the button; false to uncheck (`boolean`)

### CheckButton:SetCheckedTexture

Sets the texture used when the button is checked

**Signature:** `CheckButton:SetCheckedTexture(texture) or CheckButton:SetCheckedTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

### CheckButton:SetDisabledCheckedTexture

Sets the texture used when the button is disabled and checked

**Signature:** `CheckButton:SetDisabledCheckedTexture(texture) or CheckButton:SetDisabledCheckedTexture("filename")`

**Arguments:**
- `texture` - Reference to an existing `Texture` object (`texture`)
- `filename` - Path to a texture image file (`string`)

