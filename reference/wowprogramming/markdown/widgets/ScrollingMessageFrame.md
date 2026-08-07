# Widget: ScrollingMessageFrame

---

## ScrollingMessageFrame

ScrollingMessageFrame expands on MessageFrame with the ability to store a much longer series of messages, and to move up and down through them by setting horizontal and vertical scroll values, or by using PageUp and PageDown methods.

ScrollingMessageFrames also support hyperlinks—such as the links posted in trade chat by people with items they want to sell—and provides an OnHyperlinkClicked script for displaying information related to the contents of the link.

The most common ScrollingMessageFrame in the stock UI is simply the chat frame, as well as the combat log. The raid warning and boss emote messages are presented in a ScrollingMessageFrame. The Guild Bank UI also uses one to display the transaction history.

### Methods

### ScrollingMessageFrame:AddMessage

Adds a message to those listed in the frame

**Signature:** `ScrollingMessageFrame:AddMessage("text" [, red [, green [, blue [, id [, addToTop]]]]])`

**Arguments:**
- `text` - Text of the message (`string`)
- `red` - Red component of the text color for the message (0.0 - 1.0) (`number`)
- `green` - Green component of the text color for the message (0.0 - 1.0) (`number`)
- `blue` - Blue component of the text color for the message (0.0 - 1.0) (`number`)
- `id` - Identifier for the message's type (see `:UpdateColorByID()`) (`number`)
- `addToTop` - True to insert the message above all others listed in the frame, even if the frame's insert mode is set to `BOTTOM`; false to insert according to the frame's insert mode (`boolean`)

### ScrollingMessageFrame:AtBottom

Returns whether the message frame is currently scrolled to the bottom of its contents

**Signature:** `atBottom = ScrollingMessageFrame:AtBottom()`

**Returns:**
- `atBottom` - `1` if the message frame is currently scrolled to the bottom of its contents; otherwise `nil` (`1nil`)

### ScrollingMessageFrame:AtTop

Returns whether the message frame is currently scrolled to the top of its contents

**Signature:** `atTop = ScrollingMessageFrame:AtTop()`

**Returns:**
- `atTop` - `1` if the message frame is currently scrolled to the top of its contents; otherwise `nil` (`1nil`)

### ScrollingMessageFrame:Clear

Removes all messages stored or displayed in the frame

**Signature:** `ScrollingMessageFrame:Clear()`

### ScrollingMessageFrame:GetCurrentLine

Returns a number identifying the last message added to the frame. This number starts at `0` when the frame is created and increments with each message AddMessage to the frame; however, it resets to `0` when a message is added beyond the frame's GetMaxLines.

**Signature:** `lineNum = ScrollingMessageFrame:GetCurrentLine()`

**Returns:**
- `lineNum` - A number identifying the last message added to the frame (`number`)

### ScrollingMessageFrame:GetCurrentScroll

Returns the message frame's current scroll position

**Signature:** `offset = ScrollingMessageFrame:GetCurrentScroll()`

**Returns:**
- `offset` - Number of lines by which the frame is currently scrolled back from the end of its message history (`number`)

### ScrollingMessageFrame:GetFadeDuration

Returns the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see `:GetTimeVisible()`.

**Signature:** `duration = ScrollingMessageFrame:GetFadeDuration()`

**Returns:**
- `duration` - Duration of the fade-out animation for disappearing messages (in seconds) (`number`)

### ScrollingMessageFrame:GetFading

Returns whether messages added to the frame automatically fade out after a period of time

**Signature:** `fading = ScrollingMessageFrame:GetFading()`

**Returns:**
- `fading` - `1` if messages added to the frame automatically fade out after a period of time; otherwise `nil` (`1nil`)

### ScrollingMessageFrame:GetHyperlinksEnabled

Returns whether hyperlinks in the frame's text are interactive

**Signature:** `enabled = ScrollingMessageFrame:GetHyperlinksEnabled()`

**Returns:**
- `enabled` - `1` if hyperlinks in the frame's text are interactive; otherwise `nil` (`1nil`)

### ScrollingMessageFrame:GetIndentedWordWrap

Returns whether long lines of text are indented when wrapping

**Signature:** `indent = ScrollingMessageFrame:GetIndentedWordWrap()`

**Returns:**
- `indent` - `1` if long lines of text are indented when wrapping; otherwise `nil` (`1nil`)

### ScrollingMessageFrame:GetInsertMode

Returns the position at which new messages are added to the frame

**Signature:** `position = ScrollingMessageFrame:GetInsertMode()`

**Returns:**
- `position` - Token identifying the position at which new messages are added to the frame (`string`) 

 - `BOTTOM`
- `TOP`

### ScrollingMessageFrame:GetMaxLines

Returns the maximum number of messages kept in the frame

**Signature:** `ScrollingMessageFrame:GetMaxLines(maxLines)`

**Arguments:**
- `maxLines` - Maximum number of messages kept in the frame (`number`)

### ScrollingMessageFrame:GetMessageInfo

### ScrollingMessageFrame:GetNumLinesDisplayed

Returns the number of lines displayed in the message frame. This number reflects the list of messages currently displayed, not including those which are stored for display if the frame is scrolled.

**Signature:** `count = ScrollingMessageFrame:GetNumLinesDisplayed()`

**Returns:**
- `count` - Number of messages currently displayed in the frame (`number`)

### ScrollingMessageFrame:GetNumMessages

Returns the number of messages currently kept in the frame's message history. This number reflects the list of messages which can be seen by scrolling the frame, including (but not limited to) the list of messages currently displayed.

**Signature:** `count = ScrollingMessageFrame:GetNumMessages()`

**Returns:**
- `count` - Number of messages currently kept in the frame's message history (`number`)

### ScrollingMessageFrame:GetTimeVisible

Returns the amount of time for which a message remains visible before beginning to fade out

**Signature:** `time = ScrollingMessageFrame:GetTimeVisible()`

**Returns:**
- `time` - Amount of time for which a message remains visible before beginning to fade out (in seconds) (`number`)

### ScrollingMessageFrame:PageDown

Scrolls the message frame's contents down by one page. One "page" is slightly less than the number of lines displayed in the frame.

**Signature:** `ScrollingMessageFrame:PageDown()`

### ScrollingMessageFrame:PageUp

Scrolls the message frame's contents up by one page. One "page" is slightly less than the number of lines displayed in the frame.

**Signature:** `ScrollingMessageFrame:PageUp()`

### ScrollingMessageFrame:RemoveMessagesByAccessID

### ScrollingMessageFrame:ScrollDown

Scrolls the message frame's contents down by two lines

**Signature:** `ScrollingMessageFrame:ScrollDown()`

### ScrollingMessageFrame:ScrollToBottom

Scrolls to the bottom of the message frame's contents

**Signature:** `ScrollingMessageFrame:ScrollToBottom()`

### ScrollingMessageFrame:ScrollToTop

Scrolls to the top of the message frame's contents

**Signature:** `ScrollingMessageFrame:ScrollToTop()`

### ScrollingMessageFrame:ScrollUp

Scrolls the message frame's contents up by two lines

**Signature:** `ScrollingMessageFrame:ScrollUp()`

### ScrollingMessageFrame:SetFadeDuration

Sets the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see `:SetTimeVisible()`.

**Signature:** `ScrollingMessageFrame:SetFadeDuration(duration)`

**Arguments:**
- `duration` - Duration of the fade-out animation for disappearing messages (in seconds) (`number`)

### ScrollingMessageFrame:SetFading

Sets whether messages added to the frame automatically fade out after a period of time

**Signature:** `ScrollingMessageFrame:SetFading(fading)`

**Arguments:**
- `fading` - True to cause messages added to the frame to automatically fade out after a period of time; false to leave message visible (`boolean`)

### ScrollingMessageFrame:SetHyperlinksEnabled

Enables or disables hyperlink interactivity in the frame. The frame's hyperlink-related script handlers will only be run if hyperlinks are enabled.

**Signature:** `ScrollingMessageFrame:SetHyperlinksEnabled(enable)`

**Arguments:**
- `enable` - True to enable hyperlink interactivity in the frame; false to disable (`boolean`)

### ScrollingMessageFrame:SetIndentedWordWrap

Sets whether long lines of text are indented when wrapping

**Signature:** `ScrollingMessageFrame:SetIndentedWordWrap(indent)`

**Arguments:**
- `indent` - True to indent wrapped lines of text; false otherwise (`boolean`)

### ScrollingMessageFrame:SetInsertMode

Sets the position at which new messages are added to the frame

**Signature:** `ScrollingMessageFrame:SetInsertMode("position")`

**Arguments:**
- `position` - Token identifying the position at which new messages should be added to the frame (`string`) 

 - `BOTTOM`
- `TOP`

### ScrollingMessageFrame:SetMaxLines

Sets the maximum number of messages to be kept in the frame. If additional messages are added beyond this number, the oldest lines are discarded and can no longer be seen by scrolling.

**Signature:** `ScrollingMessageFrame:SetMaxLines(maxLines)`

**Arguments:**
- `maxLines` - Maximum number of messages to be kept in the frame (`number`)

### ScrollingMessageFrame:SetScrollOffset

Sets the message frame's scroll position

**Signature:** `ScrollingMessageFrame:SetScrollOffset(offset)`

**Arguments:**
- `offset` - Number of lines to scroll back from the end of the frame's message history (`number`)

### ScrollingMessageFrame:SetTimeVisible

Sets the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see `:SetFadeDuration()`.

**Signature:** `ScrollingMessageFrame:SetTimeVisible(time)`

**Arguments:**
- `time` - Amount of time for which a message remains visible before beginning to fade out (in seconds) (`number`)

### ScrollingMessageFrame:UpdateColorByID

Updates the color of a set of messages already added to the frame. Used in the default UI to allow customization of chat window message colors by type: each type of chat window message (party, raid, emote, system message, etc.) has a numeric identifier found in the global table `ChatTypeInfo`; this is passed as the fifth argument to `:AddMessage()` when messages are added to the frame, allowing them to be identified for recoloring via this method.

**Signature:** `ScrollingMessageFrame:UpdateColorByID(id, red, green, blue)`

**Arguments:**
- `id` - Identifier for a message's type (as set when the messages were added to the frame) (`number`)
- `red` - Red component of the new text color (0.0 - 1.0) (`number`)
- `green` - Green component of the new text color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the new text color (0.0 - 1.0) (`number`)

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
- OnHyperlinkClick(self, "linkData", "link", "button") - Run when the mouse clicks a hyperlink in the scrolling message frame or SimpleHTML frame
- OnHyperlinkEnter(self, "linkData", "link") - Run when the mouse moves over a hyperlink in the scrolling message frame or SimpleHTML frame
- OnHyperlinkLeave(self, "linkData", "link") - Run when the mouse moves away from a hyperlink in the scrolling message frame or SimpleHTML frame
- OnKeyDown(self, "key") - Run when a keyboard key is pressed if the frame is keyboard enabled
- OnKeyUp(self, "key") - Run when a keyboard key is released if the frame is keyboard enabled
- OnLeave(self, motion) - Run when the mouse cursor leaves the frame's interactive area
- OnLoad(self) - Run when the frame is created
- OnMessageScrollChanged(self) - Run when the scrolling message frame's scroll position changes
- OnMouseDown(self, "button") - Run when a mouse button is pressed while the cursor is over the frame
- OnMouseUp(self, "button") - Run when the mouse button is released following a mouse down action in the frame
- OnMouseWheel(self, delta) - Run when the frame receives a mouse wheel scrolling action
- OnReceiveDrag(self) - Run when the mouse button is released after dragging into the frame
- OnShow(self) - Run when the frame becomes visible
- OnSizeChanged(self, width, height) - Run when a frame's size changes
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

