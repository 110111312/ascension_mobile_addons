# Widget: UIObject

---

## UIObject

UIObject is an abstract UI object type that is used to group together methods that are common to all user interface types. All of the various user interface elements in World of Warcraft are derived from UIObject.

### Methods

### UIObject:GetName

Returns the widget object's name

**Signature:** `name = UIObject:GetName()`

**Returns:**
- `name` - Name of the object (`string`)

### UIObject:GetObjectType

Returns the object's widget type

**Signature:** `type = UIObject:GetObjectType()`

**Returns:**
- `type` - Name of the object's type (e.g. `Frame`, `Button`, `FontString`, etc.) (`string`)

### UIObject:IsObjectType

Returns whether the object belongs to a given widget type

**Signature:** `isType = UIObject:IsObjectType("type")`

**Arguments:**
- `type` - Name of an object type (e.g. `Frame`, `Button`, `FontString`, etc.) (`string`)

**Returns:**
- `isType` - `1` if the object belongs to the given type (or a subtype thereof); otherwise `nil` (`1nil`)

