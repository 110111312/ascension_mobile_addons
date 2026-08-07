# Widget: Frame

---

## Frame

_No snapshot available for widget overview._

### Methods

### Frame:AllowAttributeChanges

Temporarily allows insecure code to modify the frame's attributes during combat. This permission is automatically rescinded when the frame's `OnUpdate` script next runs.

**Signature:** `Frame:AllowAttributeChanges()`

### Frame:CanChangeAttribute

Returns whether secure frame attributes can currently be changed. Applies only to protected frames inheriting from one of the secure frame templates; frame attributes may only be changed by non-Blizzard scripts while the player is not in combat (or for a short time after a secure script calls `:AllowAttributeChanges()`).

**Signature:** `enabled = Frame:CanChangeAttribute()`

**Returns:**
- `enabled` - `1` if secure frame attributes can currently be changed; otherwise `nil` (`1nil`)

### Frame:CreateFontString

Creates a new FontString for the Frame on a given layer, possibly inheriting from a template

**Signature:** `Frame:CreateFontString(["name" [, "layer" [, "inherits"]]])`

**Arguments:**
- `name` - A global name to use for the new font string (`string`)
- `layer` - The graphic layer on which to create the font string. Default value is `ARTWORK`. (`string`, layer)
- `inherits` - A template from which the new front string should inherit (`string`)

### Frame:CreateTexture

Creates a new `Texture` as a child of the frame. The `sublevel` argument can be used to provide layering of textures within a draw layer. As it can be difficult to compute the proper layering, addon authors should avoid using this option, and it's XML equivalent `textureSubLevel` without reason. It should also be noted that `FontStrings` will always appear on top of all textures in a given draw layer.

**Signature:** `texture = Frame:CreateTexture(["name" [, "layer" [, "inherits" [, sublevel]]]])`

**Arguments:**
- `name` - Global name for the new texture (`string`)
- `layer` - Graphic layer on which to create the texture; defaults to `ARTWORK` if not specified (`string`, layer)
- `inherits` - Name of a template from which the new texture should inherit (`string`)
- `sublevel` - The sub-level on the given graphics layer ranging from `-8`- to `7`. The default value of this argument is `0` (`number`)

**Returns:**
- `texture` - Reference to the new `Texture` object (`texture`)

### Frame:CreateTitleRegion

Creates a title region for dragging the frame. Creating a title region allows a frame to be repositioned by the user (by clicking and dragging in the region) without requiring additional scripts. (This behavior only applies if the frame is mouse enabled.)

**Signature:** `region = Frame:CreateTitleRegion()`

**Returns:**
- `region` - Reference to the new `Region` object (`region`)

### Frame:DisableDrawLayer

Prevents display of all child objects of the frame on a specified graphics layer

**Signature:** `Frame:DisableDrawLayer("layer")`

**Arguments:**
- `layer` - Name of a graphics layer (`string`, layer)

### Frame:EnableDrawLayer

Allows display of all child objects of the frame on a specified graphics layer

**Signature:** `Frame:EnableDrawLayer("layer")`

**Arguments:**
- `layer` - Name of a graphics layer (`string`, layer)

### Frame:EnableJoystick

Enables or disables joystick interactivity. Joystick interactivity must be enabled in order for a frame's joystick-related script handlers to be run.

(As of this writing, joystick support is partially implemented but not enabled in the current version of World of Warcraft.)

**Signature:** `Frame:EnableJoystick(enable)`

**Arguments:**
- `enable` - True to enable joystick interactivity; false to disable (`boolean`)

### Frame:EnableKeyboard

Enables or disables keyboard interactivity for the frame. Keyboard interactivity must be enabled in order for a frame's `OnKeyDown`, `OnKeyUp`, or `OnChar` scripts to be run.

**Signature:** `Frame:EnableKeyboard(enable)`

**Arguments:**
- `enable` - True to enable keyboard interactivity; false to disable (`boolean`)

### Frame:EnableMouse

Enables or disables mouse interactivity for the frame. Mouse interactivity must be enabled in order for a frame's mouse-related script handlers to be run.

**Signature:** `Frame:EnableMouse(enable)`

**Arguments:**
- `enable` - True to enable mouse interactivity; false to disable (`boolean`)

### Frame:EnableMouseWheel

Enables or disables mouse wheel interactivity for the frame. Mouse wheel interactivity must be enabled in order for a frame's `OnMouseWheel` script handler to be run.

**Signature:** `Frame:EnableMouseWheel(enable)`

**Arguments:**
- `enable` - True to enable mouse wheel interactivity; false to disable (`boolean`)

### Frame:GetAttribute

Returns the value of a secure frame attribute. See the secure template documentation for more information about frame attributes.

**Signature:** `value = Frame:GetAttribute("name")`

**Arguments:**
- `name` - Name of an attribute to query (`string`)

**Returns:**
- `value` - Value of the named attribute (`value`)

### Frame:GetBackdrop

Returns information about the frame's backdrop graphic. See SetBackdrop.

**Signature:** `backdrop = Frame:GetBackdrop()`

**Returns:**
- `backdrop` - A table containing the backdrop settings, or `nil` if the frame has no backdrop (`table`, backdrop)

### Frame:GetBackdropBorderColor

Returns the shading color for the frame's border graphic

**Signature:** `red, green, blue, alpha = Frame:GetBackdropBorderColor()`

**Returns:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Frame:GetBackdropColor

Returns the shading color for the frame's background graphic

**Signature:** `red, green, blue, alpha = Frame:GetBackdropColor()`

**Returns:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Frame:GetBoundsRect

Returns the position and dimension of the smallest area enclosing the frame and its children. This information may not match that returned by `:GetRect()` if the frame contains textures, font strings, or child frames whose boundaries lie outside its own.

**Signature:** `left, bottom, width, height = Frame:GetBoundsRect()`

**Returns:**
- `left` - Distance from the left edge of the screen to the left edge of the area (in pixels) (`number`)
- `bottom` - Distance from the bottom edge of the screen to the bottom of the area (in pixels) (`number`)
- `width` - Width of the area (in pixels) (`number`)
- `height` - Height of the area (in pixels) (`number`)

### Frame:GetChildren

Returns a list of child frames of the frame

**Signature:** `... = Frame:GetChildren()`

**Returns:**
- `...` - A list of the frames which are children of this frame (`list`)

### Frame:GetClampRectInsets

Returns offsets from the frame's edges used when limiting user movement or resizing of the frame. Note: despite the name of this method, the values are all offsets along the normal axes, so to inset the frame's clamping area from its edges, the left and bottom measurements should be positive and the right and top measurements should be negative.

**Signature:** `left, right, top, bottom = Frame:GetClampRectInsets()`

**Returns:**
- `left` - Offset from the left edge of the frame to the left edge of its clamping area (in pixels) (`number`)
- `right` - Offset from the right edge of the frame's clamping area to the right edge of the frame (in pixels) (`number`)
- `top` - Offset from the top edge of the frame's clamping area to the top edge of the frame (in pixels) (`number`)
- `bottom` - Offset from the bottom edge of the frame to the bottom edge of its clamping area (in pixels) (`number`)

### Frame:GetDepth

Returns the 3D depth of the frame (for stereoscopic 3D setups)

**Signature:** `depth = Frame:GetDepth()`

**Returns:**
- `depth` - Apparent 3D depth of this frame relative to that of its parent frame (`number`)

### Frame:GetDontSavePosition

### Frame:GetEffectiveAlpha

Returns the overall opacity of the frame. Unlike `:GetAlpha()` which returns the opacity of the frame relative to its parent, this function returns the absolute opacity of the frame, taking into account the relative opacity of parent frames.

**Signature:** `alpha = Frame:GetEffectiveAlpha()`

**Returns:**
- `alpha` - Effective alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Frame:GetEffectiveDepth

Returns the overall 3D depth of the frame (for stereoscopic 3D configurations). Unlike `:GetDepth()` which returns the apparent depth of the frame relative to its parent, this function returns the absolute depth of the frame, taking into account the relative depths of parent frames.

**Signature:** `depth = Frame:GetEffectiveDepth()`

**Returns:**
- `depth` - Apparent 3D depth of this frame relative to the screen (`number`)

### Frame:GetEffectiveScale

Returns the frame's effective scale

**Signature:** `Frame:GetEffectiveScale()`

### Frame:GetFrameLevel

Sets the level at which the frame is layered relative to others in its strata. Frames with higher frame level are layered "in front of" frames with a lower frame level. When not set manually, a frame's level is determined by its place in the frame hierarchy -- e.g. UIParent's level is 1, children of UIParent are at level 2, children of those frames are at level 3, etc.

**Signature:** `level = Frame:GetFrameLevel()`

**Returns:**
- `level` - Layering level of the frame relative to others in its `frameStrata` (`number`)

### Frame:GetFrameStrata

Returns the general layering strata of the frame

**Signature:** `strata = Frame:GetFrameStrata()`

**Returns:**
- `strata` - Token identifying the strata in which the frame should be layered (`string`, frameStrata) 

 - `BACKGROUND`
- `DIALOG`
- `FULLSCREEN`
- `FULLSCREEN_DIALOG`
- `HIGH`
- `LOW`
- `MEDIUM`
- `PARENT`
- `TOOLTIP`

### Frame:GetFrameType

Returns the type of the frame, as a string

**Signature:** `Frame:GetFrameType()`

### Frame:GetHitRectInsets

Returns the insets from the frame's edges which determine its mouse-interactable area

**Signature:** `left, right, top, bottom = Frame:GetHitRectInsets()`

**Returns:**
- `left` - Distance from the left edge of the frame to the left edge of its mouse-interactive area (in pixels) (`number`)
- `right` - Distance from the right edge of the frame to the right edge of its mouse-interactive area (in pixels) (`number`)
- `top` - Distance from the top edge of the frame to the top edge of its mouse-interactive area (in pixels) (`number`)
- `bottom` - Distance from the bottom edge of the frame to the bottom edge of its mouse-interactive area (in pixels) (`number`)

### Frame:GetID

Returns the frame's numeric identifier. Frame IDs have no effect on frame behavior, but can be a useful way to keep track of multiple similar frames, especially in cases where a list of frames is created from a template (such as for action buttons, loot slots, or lines in a FauxScrollFrame).

**Signature:** `id = Frame:GetID()`

**Returns:**
- `id` - A numeric identifier for the frame (`number`)

### Frame:GetMaxResize

Returns the maximum size of the frame for user resizing. Applies when resizing the frame with the mouse via `:StartSizing()`.

**Signature:** `maxWidth, maxHeight = Frame:GetMaxResize()`

**Returns:**
- `maxWidth` - Maximum width of the frame (in pixels), or `0` for no limit (`number`)
- `maxHeight` - Maximum height of the frame (in pixels), or `0` for no limit (`number`)

### Frame:GetMinResize

Returns the minimum size of the frame for user resizing. Applies when resizing the frame with the mouse via `:StartSizing()`.

**Signature:** `minWidth, minHeight = Frame:GetMinResize()`

**Returns:**
- `minWidth` - Minimum width of the frame (in pixels), or `0` for no limit (`number`)
- `minHeight` - Minimum height of the frame (in pixels), or `0` for no limit (`number`)

### Frame:GetNumChildren

Returns the number of child frames belonging to the frame

**Signature:** `numChildren = Frame:GetNumChildren()`

**Returns:**
- `numChildren` - Number of child frames belonging to the frame (`number`)

### Frame:GetNumRegions

Returns the number of non-Frame child regions belonging to the frame

**Signature:** `numRegions = Frame:GetNumRegions()`

**Returns:**
- `numRegions` - Number of non-Frame child regions (`FontString`s and `Texture`s) belonging to the frame (`number`)

### Frame:GetPropagateKeyboardInput

### Frame:GetRegions

Returns a list of non-Frame child regions belonging to the frame

**Signature:** `... = Frame:GetRegions()`

**Returns:**
- `...` - A list of each non-Frame child region (`FontString` or `Texture`) belonging to the frame (`list`)

### Frame:GetScale

Returns the scale of the frame

**Signature:** `Frame:GetScale()`

### Frame:GetScript

Returns the widget handler for "type"

**Signature:** `Frame:GetScript()`

### Frame:GetTitleRegion

Returns the frame's TitleRegion object. See `:CreateTitleRegion()` for more information.

**Signature:** `region = Frame:GetTitleRegion()`

**Returns:**
- `region` - Reference to the frame's TitleRegion object (`region`)

### Frame:HasScript

Returns whether or not the frame has the widget handler "type"

**Signature:** `Frame:HasScript()`

### Frame:HookScript

Securely hooks a widget handler script

**Signature:** `Frame:HookScript()`

### Frame:IgnoreDepth

Sets whether the frame's depth property is ignored (for stereoscopic 3D setups). If a frame's depth property is ignored, the frame itself is not rendered with stereoscopic 3D separation, but 3D graphics within the frame may be; this property is used on the default UI's WorldFrame.

**Signature:** `Frame:IgnoreDepth(enable)`

**Arguments:**
- `enable` - True to ignore the frame's depth property; false to disable (`boolean`)

### Frame:IsClampedToScreen

Returns whether the frame's boundaries are limited to those of the screen

**Signature:** `enabled = Frame:IsClampedToScreen()`

**Returns:**
- `enabled` - `1` if the frame's boundaries are limited to those of the screen when user moving/resizing; otherwise `nil` (`1nil`)

### Frame:IsEventRegistered

Returns whether the frame is registered for a given event

**Signature:** `registered = Frame:IsEventRegistered("event")`

**Arguments:**
- `event` - Name of an event (`string`)

**Returns:**
- `registered` - `1` if the frame is registered for the event; otherwise `nil` (`1nil`)

### Frame:IsFrameType

Returns whether or not the frame is of the given type

**Signature:** `Frame:IsFrameType()`

### Frame:IsIgnoringDepth

Returns whether the frame's depth property is ignored (for stereoscopic 3D setups)

**Signature:** `enabled = Frame:IsIgnoringDepth()`

**Returns:**
- `enabled` - `1` if the frame's depth property is ignored; otherwise `nil` (`1nil`)

### Frame:IsJoystickEnabled

Returns whether joystick interactivity is enabled for the frame. (As of this writing, joystick support is partially implemented but not enabled in the current version of World of Warcraft.)

**Signature:** `enabled = Frame:IsJoystickEnabled()`

**Returns:**
- `enabled` - `1` if joystick interactivity is enabled for the frame; otherwise `nil` (`1nil`)

### Frame:IsJumpNavigateEnabled

### Frame:IsJumpNavigateStart

### Frame:IsKeyboardEnabled

Returns whether keyboard interactivity is enabled for the frame

**Signature:** `enabled = Frame:IsKeyboardEnabled()`

**Returns:**
- `enabled` - `1` if keyboard interactivity is enabled for the frame; otherwise `nil` (`1nil`)

### Frame:IsMouseEnabled

Returns whether mouse interactivity is enabled for the frame

**Signature:** `enabled = Frame:IsMouseEnabled()`

**Returns:**
- `enabled` - `1` if mouse interactivity is enabled for the frame; otherwise `nil` (`1nil`)

### Frame:IsMouseWheelEnabled

Returns whether mouse wheel interactivity is enabled for the frame

**Signature:** `enabled = Frame:IsMouseWheelEnabled()`

**Returns:**
- `enabled` - `1` if mouse wheel interactivity is enabled for the frame; otherwise `nil` (`1nil`)

### Frame:IsMovable

Returns whether the frame can be moved by the user

**Signature:** `movable = Frame:IsMovable()`

**Returns:**
- `movable` - `1` if the frame can be moved by the user; otherwise `nil` (`1nil`)

### Frame:IsResizable

Returns whether the frame can be resized by the user

**Signature:** `enabled = Frame:IsResizable()`

**Returns:**
- `enabled` - `1` if the frame can be resized by the user; otherwise `nil` (`1nil`)

### Frame:IsToplevel

Returns whether the frame is automatically raised to the front when clicked

**Signature:** `enabled = Frame:IsToplevel()`

**Returns:**
- `enabled` - `1` if the frame is automatically raised to the front when clicked; otherwise `nil` (`1nil`)

### Frame:IsUserPlaced

Returns whether the frame is flagged for automatic saving and restoration of position and dimensions

**Signature:** `enabled = Frame:IsUserPlaced()`

**Returns:**
- `enabled` - `1` if the frame is flagged for automatic saving and restoration of position and dimensions; otherwise `nil` (`1nil`)

### Frame:Lower

Reduces the frame's frame level below all other frames in its strata

**Signature:** `Frame:Lower()`

### Frame:Raise

Increases the frame's frame level above all other frames in its strata

**Signature:** `Frame:Raise()`

### Frame:RegisterAllEvents

Registers the frame for all events. This method is recommended for debugging purposes only, as using it will cause the frame's `OnEvent` script handler to be run very frequently for likely irrelevant events. (For code that needs to be run very frequently, use an `OnUpdate` script handler.)

**Signature:** `Frame:RegisterAllEvents()`

### Frame:RegisterEvent

Registers the frame for an event. The frame's `OnEvent` script handler will be run whenever the event fires. See the event documentation for details on event arguments.

**Signature:** `Frame:RegisterEvent("event")`

**Arguments:**
- `event` - Name of an event (`string`)

### Frame:RegisterForDrag

Registers the frame for dragging. Once the frame is registered for dragging (and mouse enabled), the frame's `OnDragStart` and `OnDragStop` scripts will be called when the specified mouse button(s) are clicked and dragged starting from within the frame (or its mouse-interactive area).

**Signature:** `Frame:RegisterForDrag(...)`

**Arguments:**
- `...` - A list of strings, each the name of a mouse button for which the frame should respond to drag actions (`list`) 

 - `Button4`
- `Button5`
- `LeftButton`
- `MiddleButton`
- `RightButton`

### Frame:SetAttribute

Sets a secure frame attribute. See the secure template documentation for more information about frame attributes.

**Signature:** `Frame:SetAttribute("name", value)`

**Arguments:**
- `name` - Name of an attribute, case insensitive (`string`)
- `value` - New value to set for the attribute (`value`)

### Frame:SetBackdrop

Sets a backdrop graphic for the frame. See example for details of the backdrop table format.

**Signature:** `Frame:SetBackdrop(backdrop)`

**Arguments:**
- `backdrop` - A table containing the backdrop settings, or `nil` to remove the frame's backdrop (`table`, backdrop)

### Frame:SetBackdropBorderColor

Sets a shading color for the frame's border graphic. As with `Texture:SetVertexColor()`, this color is a shading applied to the colors of the texture image; a color of `(1, 1, 1)` allows the image's original colors to show.

**Signature:** `Frame:SetBackdropBorderColor(red, green, blue [, alpha])`

**Arguments:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Frame:SetBackdropColor

Sets a shading color for the frame's background graphic. As with `Texture:SetVertexColor()`, this color is a shading applied to the colors of the texture image; a color of `(1, 1, 1)` allows the image's original colors to show.

**Signature:** `Frame:SetBackdropColor(red, green, blue [, alpha])`

**Arguments:**
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### Frame:SetClampedToScreen

Sets whether the frame's boundaries should be limited to those of the screen. Applies to user moving/resizing of the frame (via `:StartMoving()`, `:StartSizing()`, or title region); attempting to move or resize the frame beyond the edges of the screen will move/resize it no further than the edge of the screen closest to the mouse position. Does not apply to programmatically setting the frame's position or size.

**Signature:** `Frame:SetClampedToScreen(enable)`

**Arguments:**
- `enable` - True to limit the frame's boundaries to those of the screen; false to allow the frame to be moved/resized without such limits (`boolean`)

### Frame:SetClampRectInsets

Sets the clamp rect insets for the frame, so portion of it could move offscreen

**Signature:** `Frame:SetClampRectInsets()`

### Frame:SetDepth

Sets the 3D depth of the frame (for stereoscopic 3D configurations)

**Signature:** `Frame:SetDepth(depth)`

**Arguments:**
- `depth` - Apparent 3D depth of this frame relative to that of its parent frame (`number`)

### Frame:SetDontSavePosition

### Frame:SetFrameLevel

Sets the level at which the frame is layered relative to others in its strata. Frames with higher frame level are layered "in front of" frames with a lower frame level.

**Signature:** `Frame:SetFrameLevel(level)`

**Arguments:**
- `level` - Layering level of the frame relative to others in its `frameStrata` (`number`)

### Frame:SetFrameStrata

Sets the general layering strata of the frame. Where frame level provides fine control over the layering of frames, frame strata provides a coarser level of layering control: frames in a higher strata always appear "in front of" frames in lower strata regardless of frame level.

**Signature:** `Frame:SetFrameStrata("strata")`

**Arguments:**
- `strata` - Token identifying the strata in which the frame should be layered (`string`, frameStrata)

### Frame:SetHitRectInsets

Sets the insets from the frame's edges which determine its mouse-interactable area

**Signature:** `Frame:SetHitRectInsets(left, right, top, bottom)`

**Arguments:**
- `left` - Distance from the left edge of the frame to the left edge of its mouse-interactive area (in pixels) (`number`)
- `right` - Distance from the right edge of the frame to the right edge of its mouse-interactive area (in pixels) (`number`)
- `top` - Distance from the top edge of the frame to the top edge of its mouse-interactive area (in pixels) (`number`)
- `bottom` - Distance from the bottom edge of the frame to the bottom edge of its mouse-interactive area (in pixels) (`number`)

### Frame:SetID

Sets a numeric identifier for the frame. Frame IDs have no effect on frame behavior, but can be a useful way to keep track of multiple similar frames, especially in cases where a list of frames is created from a template (such as for action buttons, loot slots, or lines in a FauxScrollFrame).

**Signature:** `Frame:SetID(id)`

**Arguments:**
- `id` - A numeric identifier for the frame (`number`)

### Frame:SetJumpNavigateEnabled

### Frame:SetJumpNavigateStart

### Frame:SetMaxResize

Sets the maximum size of the frame for user resizing. Applies when resizing the frame with the mouse via `:StartSizing()`.

**Signature:** `Frame:SetMaxResize(maxWidth, maxHeight)`

**Arguments:**
- `maxWidth` - Maximum width of the frame (in pixels), or `0` for no limit (`number`)
- `maxHeight` - Maximum height of the frame (in pixels), or `0` for no limit (`number`)

### Frame:SetMinResize

Sets the minimum size of the frame for user resizing. Applies when resizing the frame with the mouse via `:StartSizing()`.

**Signature:** `Frame:SetMinResize(minWidth, minHeight)`

**Arguments:**
- `minWidth` - Minimum width of the frame (in pixels), or `0` for no limit (`number`)
- `minHeight` - Minimum height of the frame (in pixels), or `0` for no limit (`number`)

### Frame:SetMovable

Sets whether the frame can be moved by the user. Enabling this property does not automatically implement behaviors allowing the frame to be dragged by the user -- such behavior must be implemented in the frame's mouse script handlers. If this property is not enabled, `Frame:StartMoving()` causes a Lua error.

For simple automatic frame dragging behavior, see `Frame:CreateTitleRegion()`.

**Signature:** `Frame:SetMovable(enable)`

**Arguments:**
- `enable` - True to allow the frame to be moved by the user; false to disable (`boolean`)

### Frame:SetPropagateKeyboardInput

### Frame:SetResizable

Sets whether the frame can be resized by the user. Enabling this property does not automatically implement behaviors allowing the frame to be drag-resized by the user -- such behavior must be implemented in the frame's mouse script handlers. If this property is not enabled, `Frame:StartSizing()` causes a Lua error.

**Signature:** `Frame:SetResizable(enable)`

**Arguments:**
- `enable` - True to allow the frame to be resized by the user; false to disable (`boolean`)

### Frame:SetScale

Sets the frame's scale factor. A frame's scale factor affects the size at which it appears on the screen relative to that of its parent. The entire interface may be scaled by changing `UIParent`'s scale factor (as can be done via the Use UI Scale setting in the default interface's Video Options panel).

**Signature:** `Frame:SetScale(scale)`

**Arguments:**
- `scale` - Scale factor for the frame relative to its parent (`number`)

### Frame:SetScript

Sets a function to call for the given widget handler on this frame

**Signature:** `Frame:SetScript("type", function)`

**Arguments:**
- `type` - The frame script to set a handler for (`string`) 

 - `OnAnimFinished`
- `OnAttributeChanged`
- `OnChar`
- `OnCharComposition`
- `OnClick`
- `OnColorSelect`
- `OnCursorChanged`
- `OnDoubleClick`
- `OnDragStart`
- `OnDragStop`
- `OnEditFocusGained`
- `OnEditFocusLost`
- `OnEnter`
- `OnEnterPressed`
- `OnEscapePressed`
- `OnEvent`
- `OnHide`
- `OnHorizontalScroll`
- `OnHyperlinkClick`
- `OnHyperlinkEnter`
- `OnHyperlinkLeave`
- `OnInputLanguageChanged`
- `OnKeyDown`
- `OnKeyUp`
- `OnLeave`
- `OnLoad`
- `OnMessageScrollChanged`
- `OnMouseDown`
- `OnMouseUp`
- `OnMouseWheel`
- `OnReceiveDrag`
- `OnScrollRangeChanged`
- `OnShow`
- `OnSizeChanged`
- `OnSpacePressed`
- `OnTabPressed`
- `OnTextChanged`
- `OnTextSet`
- `OnTooltipAddMoney`
- `OnTooltipCleared`
- `OnTooltipSetDefaultAnchor`
- `OnTooltipSetItem`
- `OnTooltipSetQuest`
- `OnTooltipSetSpell`
- `OnTooltipSetUnit`
- `OnUpdate`
- `OnUpdateModel`
- `OnValueChanged`
- `OnVerticalScroll`
- `PostClick`
- `PreClick`
- `function` - The function to use as the given script handler. The signature of this function depends on the script. (`function`)

### Frame:SetToplevel

Sets whether the frame should automatically come to the front when clicked. When a frame with `Toplevel` behavior enabled is clicked, it automatically changes its frame level such that it is greater than (and therefore drawn "in front of") all other frames in its strata.

**Signature:** `Frame:SetToplevel(enable)`

**Arguments:**
- `enable` - True to cause the frame to automatically come to the front when clicked; false otherwise (`boolean`)

### Frame:SetUserPlaced

Flags the frame for automatic saving and restoration of position and dimensions. The position and size of frames so flagged is automatically saved when the UI is shut down (as when quitting, logging out, or reloading) and restored when the UI next starts up (as when logging in or reloading). If the frame does not have a name (set at creation time) specified, its position will not be saved. As implied by its name, enabling this property is useful for frames which can be moved or resized by the user.

This function is automatically called with the value true when frame:StartMoving() is called.

**Signature:** `Frame:SetUserPlaced(enable)`

**Arguments:**
- `enable` - True to enable automatic saving and restoration of the frame's position and dimensions; false to disable (`boolean`)

### Frame:StartMoving

Begins repositioning the frame via mouse movement

**Signature:** `Frame:StartMoving()`

### Frame:StartSizing

Begins resizing the frame via mouse movement

**Signature:** `Frame:StartSizing()`

### Frame:StopMovingOrSizing

Ends movement or resizing of the frame initiated with `:StartMoving()` or `:StartSizing()`

**Signature:** `Frame:StopMovingOrSizing()`

### Frame:UnregisterAllEvents

Unregisters the frame from any events for which it is registered

**Signature:** `Frame:UnregisterAllEvents()`

### Frame:UnregisterEvent

Unregisters the frame for an event. Once unregistered, the frame's `OnEvent` script handler will not be called for that event. 

Unregistering from notifications for an event can be useful for improving addon performance at times when it's not necessary to process the event. For example, a frame which monitors target health does not need to receive the `UNIT_HEALTH` event while the player has no target. An addon that sorts the contents of the player's bags can register for the `BAG_UPDATE` event to keep track of when items are picked up, but unregister from the event while it performs its sorting.

**Signature:** `Frame:UnregisterEvent("event")`

**Arguments:**
- `event` - Name of an event (`string`)

