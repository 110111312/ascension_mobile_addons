# Widget: Region

---

## Region

Region is the basic type for anything that can occupy an area of the screen. As such, Frames, Textures and FontStrings are all various kinds of Region. Region provides most of the functions that support size, position and anchoring, including animation. It is a "real virtual" type; it cannot be instantiated, but objects can return true when asked if they are Regions.

### Methods

### Region:CanChangeProtectedState

Returns whether protected properties of the region can be changed by non-secure scripts. Addon scripts are allowed to change protected properties for non-secure frames, or for secure frames while the player is not in combat.

**Signature:** `canChange = Region:CanChangeProtectedState()`

**Returns:**
- `canChange` - `1` if addon scripts are currently allowed to change protected properties of the region (e.g. showing or hiding it, changing its position, or altering frame attributes); otherwise `nil` (`value`, 1nil)

### Region:ClearAllPoints

Removes all anchor points from the region

**Signature:** `Region:ClearAllPoints()`

### Region:CreateAnimationGroup

Creates a new AnimationGroup as a child of the region

**Signature:** `animationGroup = Region:CreateAnimationGroup(["name" [, "inheritsFrom"]])`

**Arguments:**
- `name` - A global name to use for the new animation group (`string`)
- `inheritsFrom` - Template from which the new animation group should inherit (`string`)

**Returns:**
- `animationGroup` - The newly created `AnimationGroup` (`animgroup`)

### Region:GetAnimationGroups

Returns a list of animation groups belonging to the region

**Signature:** `... = Region:GetAnimationGroups()`

**Returns:**
- `...` - A list of `AnimationGroup` objects for which the region is parent (`list`)

### Region:GetBottom

Returns the distance from the bottom of the screen to the bottom of the region

**Signature:** `bottom = Region:GetBottom()`

**Returns:**
- `bottom` - Distance from the bottom edge of the screen to the bottom edge of the region (in pixels) (`number`)

### Region:GetCenter

Returns the screen coordinates of the region's center

**Signature:** `x, y = Region:GetCenter()`

**Returns:**
- `x` - Distance from the left edge of the screen to the center of the region (in pixels) (`number`)
- `y` - Distance from the bottom edge of the screen to the center of the region (in pixels) (`number`)

### Region:GetHeight

Returns the height of the region

**Signature:** `height = Region:GetHeight()`

**Returns:**
- `height` - Height of the region (in pixels) (`number`)

### Region:GetLeft

Returns the distance from the left edge of the screen to the left edge of the region

**Signature:** `left = Region:GetLeft()`

**Returns:**
- `left` - Distance from the left edge of the screen to the left edge of the region (in pixels) (`number`)

### Region:GetNumPoints

Returns the number of anchor points defined for the region

**Signature:** `numPoints = Region:GetNumPoints()`

**Returns:**
- `numPoints` - Number of defined anchor points for the region (`number`)

### Region:GetParent

Returns the Region's parent object.

**Signature:** `Region:GetParent()`

### Region:GetPoint

Returns information about one of the region's anchor points

**Signature:** `point, relativeTo, relativePoint, xOffset, yOffset = Region:GetPoint(index)`

**Arguments:**
- `index` - Index of an anchor point defined for the region (between `1` and `region:``GetNumPoints()`) (`number`)

**Returns:**
- `point` - Point on this region at which it is anchored to another (`string`, anchorPoint)
- `relativeTo` - Reference to the other region to which this region is anchored (`region`)
- `relativePoint` - Point on the other region to which this region is anchored (`string`, anchorPoint)
- `xOffset` - Horizontal distance between `point` and `relativePoint` (in pixels; positive values put `point` to the right of `relativePoint`) (`number`)
- `yOffset` - Vertical distance between `point` and `relativePoint` (in pixels; positive values put `point` below `relativePoint`) (`number`)

### Region:GetRect

Returns the position and dimensions of the region

**Signature:** `left, bottom, width, height = Region:GetRect()`

**Returns:**
- `left` - Distance from the left edge of the screen to the left edge of the region (in pixels) (`number`)
- `bottom` - Distance from the bottom edge of the screen to the bottom of the region (in pixels) (`number`)
- `width` - Width of the region (in pixels) (`number`)
- `height` - Height of the region (in pixels) (`number`)

### Region:GetRight

Returns the distance from the left edge of the screen to the right edge of the region

**Signature:** `right = Region:GetRight()`

**Returns:**
- `right` - Distance from the left edge of the screen to the right edge of the region (in pixels) (`number`)

### Region:GetSize

Returns the width and height of the region

**Signature:** `width, height = Region:GetSize()`

**Returns:**
- `width` - The width of the region (`number`)
- `height` - The height of the region (`number`)

### Region:GetTop

Returns the distance from the bottom of the screen to the top of the region

**Signature:** `top = Region:GetTop()`

**Returns:**
- `top` - Distance from the bottom edge of the screen to the top edge of the region (in pixels) (`number`)

### Region:GetWidth

Returns the width of the region

**Signature:** `width = Region:GetWidth()`

**Returns:**
- `width` - Width of the region (in pixels) (`number`)

### Region:IsDragging

Returns whether the region is currently being dragged

**Signature:** `isDragging = Region:IsDragging()`

**Returns:**
- `isDragging` - `1` if the region (or its parent or ancestor) is currently being dragged; otherwise `nil` (`1nil`)

### Region:IsMouseOver

Returns whether the mouse cursor is over the given region. This function replaces the previous `MouseIsOver` FrameXML function.

**Signature:** `isOver = Region:IsMouseOver()`

**Returns:**
- `isOver` - `1` if the mouse is over the region; otherwise `nil` (`1nil`)

### Region:IsProtected

Returns whether the region is protected. Non-secure scripts may change certain properties of a protected region (e.g. showing or hiding it, changing its position, or altering frame attributes) only while the player is not in combat. Regions may be explicitly protected by Blizzard scripts or XML; other regions can become protected by becoming children of protected regions or by being positioned relative to protected regions.

**Signature:** `isProtected, explicit = Region:IsProtected()`

**Returns:**
- `isProtected` - `1` if the region is protected; otherwise `nil` (`value`, 1nil)
- `explicit` - `1` if the region is explicitly protected; `nil` if the frame is only protected due to relationship with a protected region (`value`, 1nil)

### Region:SetAllPoints

Sets all anchor points of the region to match those of another region. If no region is specified, the region's anchor points are set to those of its parent.

**Signature:** `Region:SetAllPoints([region]) or Region:SetAllPoints(["name"])`

**Arguments:**
- `region` - Reference to a region (`region`)
- `name` - Global name of a region (`string`)

### Region:SetHeight

Sets the region's height

**Signature:** `Region:SetHeight(height)`

**Arguments:**
- `height` - New height for the region (in pixels); if `0`, causes the region's height to be determined automatically according to its anchor points (`number`)

### Region:SetParent

Makes another frame the parent of this region

**Signature:** `Region:SetParent(frame) or Region:SetParent("name")`

**Arguments:**
- `frame` - The new parent frame (`frame`)
- `name` - Global name of a frame (`string`)

### Region:SetPoint

Sets an anchor point for the region

**Signature:** `Region:SetPoint("point" [, relativeTo [, "relativePoint" [, xOffset [, yOffset]]]])`

**Arguments:**
- `point` - Point on this region at which it is to be anchored to another (`string`, anchorPoint)
- `relativeTo` - Reference to the other region to which this region is to be anchored; if `nil` or omitted, anchors the region relative to its parent (or to the screen dimensions if the region has no parent) (`region`)
- `relativePoint` - Point on the other region to which this region is to be anchored; if `nil` or omitted, defaults to the same value as `point` (`string`, anchorPoint)
- `xOffset` - Horizontal distance between `point` and `relativePoint` (in pixels; positive values put `point` to the right of `relativePoint`); if `nil` or omitted, defaults to `0` (`number`)
- `yOffset` - Vertical distance between `point` and `relativePoint` (in pixels; positive values put `point` below `relativePoint`); if `nil` or omitted, defaults to `0` (`number`)

### Region:SetSize

Sets the size of the region to the specified values

**Signature:** `Region:SetSize(width, height)`

**Arguments:**
- `width` - The width to set for the region (`number`)
- `height` - The height to set for the region (`number`)

### Region:SetWidth

Sets the region's width

**Signature:** `Region:SetWidth(width)`

**Arguments:**
- `width` - New width for the region (in pixels); if `0`, causes the region's width to be determined automatically according to its anchor points (`number`)

### Region:StopAnimating

Stops any active animations involving the region or its children

**Signature:** `Region:StopAnimating()`

