# Widget: ControlPoint

---

## ControlPoint

A `ControlPoint` is a special type of UIObject that represent a point in a Path Animation. The offset for each control point is from the origin of the animated Region. See Path for more details.

### Methods

### ControlPoint:GetOffset

Returns the offset for the control point

**Signature:** `x, y = ControlPoint:GetOffset()`

**Returns:**
- `x` - The x coordinate offset for the control point (`number`)
- `y` - The y coordinate offset for the control point (`number`)

### ControlPoint:GetOrder

Returns the order of the control point in a path animation. When the parent path animation plays, the control points with a lower number are traversed before those with a higher number. Control points must have distinct order indices, and these will be assigned automatically as new points are created.

**Signature:** `order = ControlPoint:GetOrder()`

**Returns:**
- `order` - Position at which the control point will be traversed relative to others in the same path animation (between 0 and 100) (`number`)

### ControlPoint:SetOffset

Sets the offset for the control point

**Signature:** `ControlPoint:SetOffset(x, y)`

**Arguments:**
- `x` - The x coordinate offset for the control point (`number`)
- `y` - The y coordinate offset for the control point (`number`)

### ControlPoint:SetOrder

Sets the order of the control point in a path animation. When the parent path animation plays, the control points with a lower number are traversed before those with a higher number. Control points must have distinct order indices, and these will be assigned automatically as new points are created.

**Signature:** `ControlPoint:SetOrder(order)`

**Arguments:**
- `order` - Position at which the control point will be traversed relative to others in the same path animation (between 0 and 100) (`number`)

### ControlPoint:SetParent

Sets a new path animation parent for a control point

**Signature:** `ControlPoint:SetParent([path [, order]]) or ControlPoint:SetParent(["path" [, order]])`

**Arguments:**
- `path` - The path object to be set as parent. (`table`)
- `path` - The name of a path object to be set as parent. (`string`)
- `order` - The order index to set for the control point in the new parent animation. (`number`)

