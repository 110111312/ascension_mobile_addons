# Widget: ScrollFrame

---

## ScrollFrame

ScrollFrame is how a large body of content can be displayed through a small window. The ScrollFrame is the size of the "window" through which you want to see the larger content, and it has another frame set as a "ScrollChild" containing the full content. The proportion by which the ScrollChild is larger than the ScrollFrame automatically determines the horizontal and vertical scroll range of the ScrollFrame. You can get these ranges or position the ScrollChild "behind" the ScrollFrame within those ranges using ScrollFrame's methods. It also allows you to set a new frame as the ScrollChild.

When a ScrollFrame is used for repetitive content, such as the buttons for assigning key bindings or the friends in your social frame, it is often implemented as a "FauxScrollFrame," which contains enough of these subframes in the ScrollChild to fill the ScrollFrame, plus one. It then saves an offset and maps which of the elements in an internal list are displayed.

To create a ScrollFrame's ScrollChild in XML, include a `<ScrollChild>` element as a direct child of the `<ScrollFrame>` element. The `<ScrollChild>` element should have one child, of any type descended from `<Frame>`. To create the scroll child in Lua, create the frame using `CreateFrame()`, and then attach the child to the scroll frame using `ScrollFrame:SetScrollChild(child)`. The child frame must always have an absolute size set with `<AbsDimension>` in XML or using both `SetWidth()` and `SetHeight()` in Lua.

A ScrollFrame does not automatically include an element that sets the scroll range. Typically, you add a Slider as a child of a ScrollFrame, with an OnValueChanged handler that sets the scroll value.

ScrollFrames are common throughout the UI, used for quest text, readable items, lists of friends and guild members, and similar applications.

### Methods

### ScrollFrame:GetHorizontalScroll

Returns the scroll frame's current horizontal scroll position

**Signature:** `scroll = ScrollFrame:GetHorizontalScroll()`

**Returns:**
- `scroll` - Current horizontal scroll position (0 = at left edge, `frame:``GetHorizontalScrollRange()` = at right edge) (`number`)

### ScrollFrame:GetHorizontalScrollRange

Returns the scroll frame's maximum horizontal (rightmost) scroll position

**Signature:** `maxScroll = ScrollFrame:GetHorizontalScrollRange()`

**Returns:**
- `maxScroll` - Maximum horizontal scroll position (representing the right edge of the scrolled area) (`number`)

### ScrollFrame:GetScrollChild

Returns the frame scrolled by the scroll frame

**Signature:** `scrollChild = ScrollFrame:GetScrollChild()`

**Returns:**
- `scrollChild` - Reference to the Frame object scrolled by the scroll frame (`frame`)

### ScrollFrame:GetVerticalScroll

Returns the scroll frame's current vertical scroll position

**Signature:** `scroll = ScrollFrame:GetVerticalScroll()`

**Returns:**
- `scroll` - Current vertical scroll position (0 = at top edge, `frame:``GetVerticalScrollRange()` = at bottom edge) (`number`)

### ScrollFrame:GetVerticalScrollRange

Returns the scroll frame's maximum vertical (bottom) scroll position

**Signature:** `maxScroll = ScrollFrame:GetVerticalScrollRange()`

**Returns:**
- `maxScroll` - Maximum vertical scroll position (representing the bottom edge of the scrolled area) (`number`)

### ScrollFrame:SetHorizontalScroll

Sets the scroll frame's horizontal scroll position

**Signature:** `ScrollFrame:SetHorizontalScroll(scroll)`

**Arguments:**
- `scroll` - Current horizontal scroll position (0 = at left edge, `frame:``GetHorizontalScrollRange()` = at right edge) (`number`)

### ScrollFrame:SetScrollChild

Sets the scroll child for the scroll frame. The scroll child frame represents the (generally larger) area into which the scroll frame provides a (generally smaller) movable "window". The child must have an absolute size, set either by `<AbsDimension>` in XML or using both `SetWidth()` and `SetHeight()` in Lua.

Setting a frame's scroll child involves changing the child frame's parent -- thus, if the frame's scroll child is protected, this operation cannot be performed while in combat.

**Signature:** `ScrollFrame:SetScrollChild(frame)`

**Arguments:**
- `frame` - Reference to another frame to be the ScrollFrame's child. (`frame`)

### ScrollFrame:SetVerticalScroll

Sets the scroll frame's vertical scroll position

**Signature:** `ScrollFrame:SetVerticalScroll(scroll)`

**Arguments:**
- `scroll` - Current vertical scroll position (0 = at top edge, `frame:``GetVerticalScrollRange()` = at bottom edge) (`number`)

### ScrollFrame:UpdateScrollChildRect

Updates the position of the scroll frame's child. The `ScrollFrame` automatically adjusts the position of the child frame when scrolled, but manually updating its position may be necessary when changing the size or contents of the child frame.

**Signature:** `ScrollFrame:UpdateScrollChildRect()`

### Script Handlers

- OnAttributeChanged(self, "name", value) - Run when a frame attribute is changed
- OnChar(self, "text") - Run for each text character typed in the frame
- OnDisable(self) - Run when the frame is disabled
- OnDragStart(self, "button") - Run when the mouse is dragged starting in the frame
- OnDragStop(self) - Run when the mouse button is released after a drag started in the frame
- OnEnable(self) - Run when the frame is enabled
- OnEnter(self, motion) - Run when the mouse cursor enters the frame's interactive area
- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnHide(self) - Run when the frame's visbility changes to hidden
- OnHorizontalScroll(self, offset) - Run when the scroll frame's horizontal scroll position changes
- OnKeyDown(self, "key") - Run when a keyboard key is pressed if the frame is keyboard enabled
- OnKeyUp(self, "key") - Run when a keyboard key is released if the frame is keyboard enabled
- OnLeave(self, motion) - Run when the mouse cursor leaves the frame's interactive area
- OnLoad(self) - Run when the frame is created
- OnMouseDown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- OnMouseUp(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- OnMouseWheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnScrollRangeChanged(self, xOffset, yOffset) - Run when the scroll frame's scroll position is changed
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine
- OnVerticalScroll(self, offset) - Run when the scroll frame's vertical scroll position changes

