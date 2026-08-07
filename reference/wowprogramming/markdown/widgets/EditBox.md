# Widget: EditBox

---

## EditBox

EditBoxes are used to allow the player to type text into a UI component. They inherit from FontInstance as well as Frame in order to provide the needed support for text display, and add methods for entering text, such as positioning a cursor within text, establishing character limits, controlling whether text should be displayed in password-fashion (with bullets substituted for the characters), manipulating an entry history, or controlling and responding to changes in keyboard focus.

The most common use for an EditBox is to accept chat input from the player, but they are also used for commands, configuration, and confirmation, such as requiring you to type "DELETE" before destroying a valuable item, or entering the name of a new macro.

Most EditBoxes are derived from ChatFrameEditBoxTemplate, or use the same textures to create a visible frame around the editable area.

### Methods

### EditBox:AddHistoryLine

Adds a line of text to the edit box's stored history. Once added, the user can quickly set the edit box's contents to one of these lines by pressing the up or down arrow keys. (History lines are only accessible via the arrow keys if the edit box is not in multi-line mode.)

**Signature:** `EditBox:AddHistoryLine("text")`

**Arguments:**
- `text` - Text to be added to the edit box's list of history lines (`string`)

### EditBox:ClearFocus

Clears the input focus from an edit box.. Clears the input focus from an edit box. After this function is called the edit box in question will no longer receive keypresses.

**Signature:** `EditBox:ClearFocus()`

### EditBox:ClearHistory

### EditBox:Disable

### EditBox:Enable

### EditBox:GetAltArrowKeyMode

Returns whether arrow keys are ignored by the edit box unless the Alt key is held

**Signature:** `enabled = EditBox:GetAltArrowKeyMode()`

**Returns:**
- `enabled` - `1` if arrow keys are ignored by the edit box unless the Alt key is held; otherwise `nil` (`1nil`)

### EditBox:GetBlinkSpeed

Returns the rate at which the text insertion blinks when the edit box is focused

**Signature:** `duration = EditBox:GetBlinkSpeed()`

**Returns:**
- `duration` - Amount of time for which the cursor is visible during each "blink" (in seconds) (`number`)

### EditBox:GetCursorPosition

Returns the current cursor position inside a given edit box.. Returns the current cursor position inside a given edit box. The index starts at 0 at the front of the line.

**Signature:** `position = EditBox:GetCursorPosition()`

**Returns:**
- `position` - The position of the cursor (`number`)

### EditBox:GetHistoryLines

Returns the maximum number of history lines stored by the edit box

**Signature:** `count = EditBox:GetHistoryLines()`

**Returns:**
- `count` - Maximum number of history lines stored by the edit box (`number`)

### EditBox:GetHyperlinksEnabled

### EditBox:GetIndentedWordWrap

Returns whether long lines of text are indented when wrapping

**Signature:** `indent = EditBox:GetIndentedWordWrap()`

**Returns:**
- `indent` - `1` if long lines of text are indented when wrapping; otherwise `nil` (`1nil`)

### EditBox:GetInputLanguage

Returns the currently selected keyboard input language (character set / input method). Applies to keyboard input methods, not in-game languages or client locales.

**Signature:** `language = EditBox:GetInputLanguage()`

**Returns:**
- `language` - Token representing the current keyboard input method (`string`)

### EditBox:GetMaxBytes

Returns the maximum number of bytes of text allowed in the edit box. Note: Unicode characters may consist of more than one byte each, so the behavior of a byte limit may differ from that of a character limit in practical use.

**Signature:** `maxBytes = EditBox:GetMaxBytes()`

**Returns:**
- `maxBytes` - Maximum number of text bytes allowed in the edit box (`number`)

### EditBox:GetMaxLetters

Returns the maximum number of text characters allowed in the edit box

**Signature:** `maxLetters = EditBox:GetMaxLetters()`

**Returns:**
- `maxLetters` - Maximum number of text characters allowed in the edit box (`number`)

### EditBox:GetNumber

Returns the contents of the edit box as a number. Similar to `tonumber``(editbox:``GetText()``)`; returns `0` if the contents of the edit box cannot be converted to a number.

**Signature:** `num = EditBox:GetNumber()`

**Returns:**
- `num` - Contents of the edit box as a number (`number`)

### EditBox:GetNumLetters

Returns the number of text characters in the edit box

**Signature:** `numLetters = EditBox:GetNumLetters()`

**Returns:**
- `numLetters` - Number of text characters in the edit box (`number`)

### EditBox:GetText

Returns the edit box's text contents

**Signature:** `text = EditBox:GetText()`

**Returns:**
- `text` - Text contained in the edit box (`string`)

### EditBox:GetTextInsets

Returns the insets from the edit box's edges which determine its interactive text area

**Signature:** `left, right, top, bottom = EditBox:GetTextInsets()`

**Returns:**
- `left` - Distance from the left edge of the edit box to the left edge of its interactive text area (in pixels) (`number`)
- `right` - Distance from the right edge of the edit box to the right edge of its interactive text area (in pixels) (`number`)
- `top` - Distance from the top edge of the edit box to the top edge of its interactive text area (in pixels) (`number`)
- `bottom` - Distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels) (`number`)

### EditBox:GetUTF8CursorPosition

Returns the cursor's numeric position in the edit box, taking UTF-8 multi-byte character into account. If the `EditBox` contains multi-byte Unicode characters, the `GetCursorPosition()` method will not return correct results, as it considers each eight byte character to count as a single glyph. This method properly returns the position in the edit box from the perspective of the user.

**Signature:** `position = EditBox:GetUTF8CursorPosition()`

**Returns:**
- `position` - The cursor's numeric position (leftmost position is 0), taking UTF8 multi-byte characters into account. (`number`)

### EditBox:HasFocus

Returns whether the edit box is currently focused for keyboard input

**Signature:** `enabled = EditBox:HasFocus()`

**Returns:**
- `enabled` - `1` if the edit box is currently focused for keyboard input; otherwise `nil` (`1nil`)

### EditBox:HighlightText

Selects all or a portion of the text in the edit box

**Signature:** `EditBox:HighlightText([start [, end]])`

**Arguments:**
- `start` - Character position at which to begin the selection (between 0, for the position before the first character, and `editbox:``GetNumLetters()`, for the position after the last character); defaults to 0 if not specified (`number`)
- `end` - Character position at which to end the selection; if not specified or if less than `start`, selects all characters after the `start` position; if equal to `start`, selects nothing and positions the cursor at the `start` position (`number`)

### EditBox:Insert

Inserts text into the edit box at the current cursor position

**Signature:** `EditBox:Insert("text")`

**Arguments:**
- `text` - Text to be inserted (`string`)

### EditBox:IsAutoFocus

Returns whether the edit box automatically acquires keyboard input focus

**Signature:** `enabled = EditBox:IsAutoFocus()`

**Returns:**
- `enabled` - `1` if the edit box automatically acquires keyboard input focus; otherwise `nil` (`1nil`)

### EditBox:IsCountInvisibleLetters

### EditBox:IsEnabled

### EditBox:IsInIMECompositionMode

Returns whether the edit box is in Input Method Editor composition mode. Character composition mode is used for input methods in which multiple keypresses generate one printed character. In such input methods, the edit box's `OnChar` script is run for each keypress -- if the `OnChar` script should act only when a complete character is entered in the edit box, `:IsInIMECompositionMode()` can be used to test for such cases.

This mode is common in clients for languages using non-Roman characters (such as Chinese or Korean), but can still occur in client languages using Roman scripts (e.g. English) -- such as when typing accented characters on the Mac client (e.g. typing "option-u" then "e" to insert the character "ë").

**Signature:** `enabled = EditBox:IsInIMECompositionMode()`

**Returns:**
- `enabled` - `1` if the edit box is in IME character composition mode; otherwise `nil` (`1nil`)

### EditBox:IsMultiLine

Returns whether the edit box shows more than one line of text

**Signature:** `multiLine = EditBox:IsMultiLine()`

**Returns:**
- `multiLine` - `1` if the edit box shows more than one line of text; otherwise `nil` (`1nil`)

### EditBox:IsNumeric

Returns whether the edit box only accepts numeric input

**Signature:** `enabled = EditBox:IsNumeric()`

**Returns:**
- `enabled` - `1` if only numeric input is allowed; otherwise `nil` (`1nil`)

### EditBox:IsPassword

Returns whether the text entered in the edit box is masked

**Signature:** `enabled = EditBox:IsPassword()`

**Returns:**
- `enabled` - `1` if text entered in the edit box is masked with asterisk characters (`*`); otherwise `nil` (`1nil`)

### EditBox:SetAltArrowKeyMode

Sets whether arrow keys are ignored by the edit box unless the Alt key is held

**Signature:** `EditBox:SetAltArrowKeyMode(enable)`

**Arguments:**
- `enable` - True to cause the edit box to ignore arrow key presses unless the Alt key is held; false to allow unmodified arrow key presses for cursor movement (`boolean`)

### EditBox:SetAutoFocus

Sets whether the edit box automatically acquires keyboard input focus. If auto-focus behavior is enabled, the edit box automatically acquires keyboard focus when it is shown and when no other edit box is focused.

**Signature:** `EditBox:SetAutoFocus(enable)`

**Arguments:**
- `enable` - True to enable the edit box to automatically acquire keyboard input focus; false to disable (`boolean`)

### EditBox:SetBlinkSpeed

Sets the rate at which the text insertion blinks when the edit box is focused. The speed indicates how long the cursor stays in each state (shown and hidden); e.g. if the blink speed is 0.5 (the default, the cursor is shown for one half second and then hidden for one half second (thus, a one-second cycle); if the speed is 1.0, the cursor is shown for one second and then hidden for one second (a two-second cycle).

**Signature:** `EditBox:SetBlinkSpeed(duration)`

**Arguments:**
- `duration` - Amount of time for which the cursor is visible during each "blink" (in seconds) (`number`)

### EditBox:SetCountInvisibleLetters

### EditBox:SetCursorPosition

Sets the cursor position in the edit box

**Signature:** `EditBox:SetCursorPosition(position)`

**Arguments:**
- `position` - New position for the keyboard input cursor (between 0, for the position before the first character, and `editbox:``GetNumLetters()`, for the position after the last character) (`number`)

### EditBox:SetFocus

Focuses the edit box for keyboard input. Only one edit box may be focused at a time; setting focus to one edit box will remove it from the currently focused edit box.

**Signature:** `EditBox:SetFocus()`

### EditBox:SetHistoryLines

Sets the maximum number of history lines stored by the edit box. Lines of text can be added to the edit box's history by calling `:AddHistoryLine()`; once added, the user can quickly set the edit box's contents to one of these lines by pressing the up or down arrow keys. (History lines are only accessible via the arrow keys if the edit box is not in multi-line mode.)

**Signature:** `EditBox:SetHistoryLines(count)`

**Arguments:**
- `count` - Maximum number of history lines to be stored by the edit box (`number`)

### EditBox:SetHyperlinksEnabled

### EditBox:SetIndentedWordWrap

Sets whether long lines of text are indented when wrapping

**Signature:** `EditBox:SetIndentedWordWrap(indent)`

**Arguments:**
- `indent` - True to indent wrapped lines of text; false otherwise (`boolean`)

### EditBox:SetMaxBytes

Sets the maximum number of bytes of text allowed in the edit box. Attempts to type more than this number into the edit box will produce no results; programmatically inserting text or setting the edit box's text will truncate input to the maximum length.

Note: Unicode characters may consist of more than one byte each, so the behavior of a byte limit may differ from that of a character limit in practical use.

**Signature:** `EditBox:SetMaxBytes(maxBytes)`

**Arguments:**
- `maxBytes` - Maximum number of text bytes allowed in the edit box, or `0` for no limit (`number`)

### EditBox:SetMaxLetters

Sets the maximum number of text characters allowed in the edit box. Attempts to type more than this number into the edit box will produce no results; programmatically inserting text or setting the edit box's text will truncate input to the maximum length.

**Signature:** `EditBox:SetMaxLetters(maxLetters)`

**Arguments:**
- `maxLetters` - Maximum number of text characters allowed in the edit box, or `0` for no limit (`number`)

### EditBox:SetMultiLine

Sets whether the edit box shows more than one line of text. When in multi-line mode, the edit box's height is determined by the number of lines shown and cannot be set directly -- enclosing the edit box in a `ScrollFrame` may prove useful in such cases.

**Signature:** `EditBox:SetMultiLine(multiLine)`

**Arguments:**
- `multiLine` - True to allow the edit box to display more than one line of text; false for single-line display (`boolean`)

### EditBox:SetNumber

Set the contents of the editbox to the specified number.

**Signature:** `EditBox:SetNumber()`

### EditBox:SetNumeric

Sets whether the edit box should only accept numbers.. Note: flag must be false false, not nil, in order to turn off numeric mode.

**Signature:** `EditBox:SetNumeric()`

### EditBox:SetPassword

Sets whether the text entered in the edit box is masked

**Signature:** `EditBox:SetPassword(enable)`

**Arguments:**
- `enable` - True to mask text entered in the edit box with asterisk characters (`*`); false to show the actual text entered (`boolean`)

### EditBox:SetText

Sets the contents of the EditBox to text. This fires the OnTextChanged handler.

**Signature:** `EditBox:SetText()`

### EditBox:SetTextInsets

Sets the padding between the edges of the edit box and its text.

**Signature:** `EditBox:SetTextInsets()`

### EditBox:ToggleInputLanguage

Switches the edit box's language input mode. If the edit box is in `ROMAN` mode and an alternate Input Method Editor composition mode is available (as determined by the client locale and system settings), switches to the alternate input mode. If the edit box is in IME composition mode, switches back to `ROMAN`.

**Signature:** `EditBox:ToggleInputLanguage()`

### Script Handlers

- OnAttributeChanged(self, "name", value) - Run when a frame attribute is changed
- OnChar(self, "text") - Run for each text character typed in the frame
- OnCharComposition(self, "text") - Run when the edit box's input composition mode changes
- OnCursorChanged(self, x, y, width, height) - Run when the position of the text insertion cursor in the edit box changes
- OnDisable(self) - Run when the frame is disabled
- OnDragStart(self, "button") - Run when the mouse is dragged starting in the frame
- OnDragStop(self) - Run when the mouse button is released after a drag started in the frame
- OnEditFocusGained(self) - Run when the edit box becomes focused for keyboard input
- OnEditFocusLost(self) - Run when the edit box loses keyboard input focus
- OnEnable(self) - Run when the frame is enabled
- OnEnter(self, motion) - Run when the mouse cursor enters the frame's interactive area
- OnEnterPressed(self) - Run when the Enter (or Return) key is pressed while the edit box has keyboard focus
- OnEscapePressed(self) - Run when the Escape key is pressed while the edit box has keyboard focus
- OnEvent(self, "event", ...) - Run whenever an [[docs/events|event]] fires for which the frame is registered
- OnHide(self) - Run when the frame's visbility changes to hidden
- OnHyperlinkClick(self, "linkData", "link", "button") - Run when the mouse clicks a hyperlink in the scrolling message frame or SimpleHTML frame
- OnHyperlinkEnter(self, "linkData", "link") - Run when the mouse moves over a hyperlink in the scrolling message frame or SimpleHTML frame
- OnHyperlinkLeave(self, "linkData", "link") - Run when the mouse moves away from a hyperlink in the scrolling message frame or SimpleHTML frame
- OnInputLanguageChanged(self, "language") - Run when the edit box's language input mode changes
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
- OnSpacePressed(self) - Run when the space bar is pressed while the edit box has keyboard focus
- OnTabPressed(self) - Run when the Tab key is pressed while the edit box has keyboard focus
- OnTextChanged(self, userInput) - Run when the edit box's text is changed
- OnTextSet(self) - Run when the edit box's text is set programmatically
- OnUpdate(self, elapsed) - Run each time the screen is drawn by the game engine

