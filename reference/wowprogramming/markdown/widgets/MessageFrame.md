# Widget: MessageFrame

---

## MessageFrame

MessageFrames are used to present series of messages or other lines of text, usually stacked on top of each other. Like most widgets relating to text display, MessageFrame inherits from FontInstance as well as Frame to provide methods for setting up text characteristics. Once the text settings for the frame are configured to your liking, you can add new messages to the frame with `:AddMessage()`. MessageFrame also supports methods for multi-line text display such as indented lines, as well as options for controlling how long messages should be displayed and how quickly they fade out when their time is up.

The stock UI uses the basic message frame for only one purpose, but it gets a lot of use; UIErrorsFrame, which displays messages like "Spell not ready yet" or "You're too far away", is a MessageFrame. MessageFrame also forms the basis for another, more sophisticated type, ScrollingMessageFrame.

### Methods

### MessageFrame:AddMessage

Adds a message to those listed in the frame. If the frame was already 'full' with messages, then the oldest message is discarded when the new one is added.

**Signature:** `MessageFrame:AddMessage("text" [, red [, green [, blue [, alpha]]]])`

**Arguments:**
- `text` - Text of the message (`string`)
- `red` - Red component of the text color for the message (0.0 - 1.0) (`number`)
- `green` - Green component of the text color for the message (0.0 - 1.0) (`number`)
- `blue` - Blue component of the text color for the message (0.0 - 1.0) (`number`)
- `alpha` - Alpha (opacity) for the message (0.0 = fully transparent, 1.0 = fully opaque) (`number`)

### MessageFrame:Clear

Removes all messages displayed in the frame

**Signature:** `MessageFrame:Clear()`

### MessageFrame:GetFadeDuration

Returns the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see `:GetTimeVisible()`.

**Signature:** `duration = MessageFrame:GetFadeDuration()`

**Returns:**
- `duration` - Duration of the fade-out animation for disappearing messages (in seconds) (`number`)

### MessageFrame:GetFading

Returns whether messages added to the frame automatically fade out after a period of time

**Signature:** `fading = MessageFrame:GetFading()`

**Returns:**
- `fading` - `1` if messages added to the frame automatically fade out after a period of time; otherwise `nil` (`1nil`)

### MessageFrame:GetIndentedWordWrap

Returns whether long lines of text are indented when wrapping

**Signature:** `indent = MessageFrame:GetIndentedWordWrap()`

**Returns:**
- `indent` - `1` if long lines of text are indented when wrapping; otherwise `nil` (`1nil`)

### MessageFrame:GetInsertMode

Returns the position at which new messages are added to the frame

**Signature:** `position = MessageFrame:GetInsertMode()`

**Returns:**
- `position` - Token identifying the position at which new messages are added to the frame (`string`) 

 - `BOTTOM`
- `TOP`

### MessageFrame:GetTimeVisible

Returns the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see `:GetFadeDuration()`.

**Signature:** `time = MessageFrame:GetTimeVisible()`

**Returns:**
- `time` - Amount of time for which a message remains visible before beginning to fade out (in seconds) (`number`)

### MessageFrame:SetFadeDuration

Sets the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see `:SetTimeVisible()`.

**Signature:** `MessageFrame:SetFadeDuration(duration)`

**Arguments:**
- `duration` - Duration of the fade-out animation for disappearing messages (in seconds) (`number`)

### MessageFrame:SetFading

Sets whether messages added to the frame automatically fade out after a period of time

**Signature:** `MessageFrame:SetFading(fading)`

**Arguments:**
- `fading` - True to cause messages added to the frame to automatically fade out after a period of time; false to leave message visible (`boolean`)

### MessageFrame:SetIndentedWordWrap

Sets whether long lines of text are indented when wrapping

**Signature:** `MessageFrame:SetIndentedWordWrap(indent)`

**Arguments:**
- `indent` - True to indent wrapped lines of text; false otherwise (`boolean`)

### MessageFrame:SetInsertMode

Sets the position at which new messages are added to the frame

**Signature:** `MessageFrame:SetInsertMode("position")`

**Arguments:**
- `position` - Token identifying the position at which new messages should be added to the frame (`string`) 

 - `BOTTOM`
- `TOP`

### MessageFrame:SetTimeVisible

Sets the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see `:SetFadeDuration()`.

**Signature:** `MessageFrame:SetTimeVisible(time)`

**Arguments:**
- `time` - Amount of time for which a message remains visible before beginning to fade out (in seconds) (`number`)

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
- OnKeyDown(self, "key") - Run when a keyboard key is pressed if the frame is keyboard enabled
- OnKeyUp(self, "key") - Run when a keyboard key is released if the frame is keyboard enabled
- OnLeave(self, motion) - Run when the mouse cursor leaves the frame's interactive area
- OnLoad(self) - Run when the frame is created
- OnMouseDown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- OnMouseUp(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- OnMouseWheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine
- onattributechanged(self, "name", value) - Run when a frame attribute is changed
- onchar(self, "text") - Run for each text character typed in the frame
- ondisable(self) - Run when the frame is disabled
- ondragstart(self, "button") - Run when the mouse is dragged starting in the frame
- ondragstop(self) - Run when the mouse button is released after a drag started in the frame
- onenable(self) - Run when the frame is enabled
- onenter(self, motion) - Run when the mouse cursor enters the frame's interactive area
- onevent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- onhide(self) - Run when the frame's visbility changes to hidden
- onkeydown(self, "key") - Run when a keyboard key is pressed if the frame is keyboard enabled
- onkeyup(self, "key") - Run when a keyboard key is released if the frame is keyboard enabled
- onleave(self, motion) - Run when the mouse cursor leaves the frame's interactive area
- onload(self) - Run when the frame is created
- onmousedown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- onmouseup(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- onmousewheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- onreceivedrag(self) - Run when the mouse button is released after dragging into the frame
- onshow(self) - Run when the frame becomes visible
- onsizechanged(self, width, height) - Run when a frame's size changes
- onupdate(self, elapsed) - Run each time the screen is drawn by the game engine

