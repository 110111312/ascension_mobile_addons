# Widget: Path

---

## Path

_No snapshot available for widget overview._

### Methods

### Path:CreateControlPoint

Creates a new control point for the given path

**Signature:** `Path:CreateControlPoint(["name" [, "template" [, order]]])`

**Arguments:**
- `name` - The name of the object (`string`)
- `template` - The template from which the new point should inherit (`string`)
- `order` - The order of the new control point (`number`)

### Path:GetControlPoints

Returns the control points that belong to a given path

**Signature:** `... = Path:GetControlPoints()`

**Returns:**
- `...` - A list of ControlPoint objects that belong to the given path. (`ControlPoint`)

### Path:GetCurve

Returns the curveType of the given path

**Signature:** `curveType = Path:GetCurve()`

**Returns:**
- `curveType` - The curse type for the given path (`string`) 

 - `NONE` - The control points are used literally.
- `SMOOTH` - The control points are used with a smoothing function that may give a more pleasing animation.

### Path:GetMaxOrder

Returns the maximum order of the control points belonging to a given path

**Signature:** `max = Path:GetMaxOrder()`

**Returns:**
- `max` - The maximum order of the control points belonging to the given path. This can be used to determine how many points a path contains. (`number`)

### Path:SetCurve

Sets the curve type for the path animation

**Signature:** `Path:SetCurve("curveType")`

**Arguments:**
- `curveType` - The curse type for the given path (`string`) 

 - `NONE` - The control points are used literally.
- `SMOOTH` - The control points are used with a smoothing function that may give a more pleasing animation.

