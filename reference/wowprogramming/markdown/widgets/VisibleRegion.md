# Widget: VisibleRegion

---

## VisibleRegion

VisibleRegion is an abstract UI type used to describe the common functionality of objects that can be placed on the screen, and visible. In particular, methods exist to show and hide the frame, and change the alpha transparency.

### Methods

### VisibleRegion:GetAlpha

Returns the opacity of the region relative to its parent

**Signature:** `alpha = VisibleRegion:GetAlpha()`

**Returns:**
- `alpha` - Alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### VisibleRegion:Hide

Hides the region

**Signature:** `VisibleRegion:Hide()`

### VisibleRegion:IsShown

Returns whether the region is shown. Indicates only whether the region has been explicitly shown or hidden -- a region may be explicitly shown but not appear on screen because its parent region is hidden. See `VisibleRegion:IsVisible()` to test for actual visibility.

**Signature:** `shown = VisibleRegion:IsShown()`

**Returns:**
- `shown` - `1` if the region is shown; otherwise `nil` (`1nil`)

### VisibleRegion:IsVisible

Returns whether the region is visible. A region is "visible" if it has been explicitly shown (or not explicitly hidden) and its parent region (and parent's parent, etc) is also shown. 

A region may be "visible" and not appear on screen -- it may not have any anchor points set, its position and size may be outside the bounds of the screen, or it may not draw anything (e.g. a FontString with no text, a Texture with no image, or a Frame with no visible children).

**Signature:** `visible = VisibleRegion:IsVisible()`

**Returns:**
- `visible` - `1` if the region is visible; otherwise `nil` (`1nil`)

### VisibleRegion:SetAlpha

Sets the opacity of the region relative to its parent

**Signature:** `VisibleRegion:SetAlpha(alpha)`

**Arguments:**
- `alpha` - Alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### VisibleRegion:Show

Shows the region

**Signature:** `VisibleRegion:Show()`
