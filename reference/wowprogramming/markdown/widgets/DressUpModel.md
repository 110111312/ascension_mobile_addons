# Widget: DressUpModel

---

## DressUpModel

The DressUpModel type was added to provide support for the "dressing room" functionality when it was introduced. This model can be set to a particular unit, and then given different pieces of gear to display on that unit with the TryOn function. It also provides an Undress feature which can be used to view how your character's gear will look without concealing articles such as a cloak or tabard that you might be wearing.

### Methods

### DressUpModel:Dress

Updates the model to reflect the character's currently equipped items

**Signature:** `DressUpModel:Dress()`

### DressUpModel:TryOn

Updates the model to reflect the character's appearance after equipping a specific item

**Signature:** `DressUpModel:TryOn(itemID) or DressUpModel:TryOn("itemName") or DressUpModel:TryOn("itemLink")`

**Arguments:**
- `itemID` - An item's ID (`number`)
- `itemName` - An item's name (`string`)
- `itemLink` - An item's hyperlink, or any string containing the `itemString` portion of an item link (`string`)

### DressUpModel:Undress

Updates the model to reflect the character's appearance without any equipped items

**Signature:** `DressUpModel:Undress()`

### DressUpModel:UndressSlot

### Script Handlers

- OnAnimFinished(self) - Run when the model's animation finishes
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
- OnUpdateModel(self) - Run when a model changes or animates

