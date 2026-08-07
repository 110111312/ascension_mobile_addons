# Widget: ParentedObject

---

## ParentedObject

ParentedObject is an abstract UI type that provides support for querying the parent of a given object. Some object parents are set implicitly (such as in the case of font strings and textures) whereas others are set explicitly using the `SetParent()` method provided by the Region object type.

### Methods

### ParentedObject:GetParent

Returns the object's parent object

**Signature:** `parent = ParentedObject:GetParent()`

**Returns:**
- `parent` - Reference to the object's parent object, or `nil` if the object has no parent (`uiobject`)

