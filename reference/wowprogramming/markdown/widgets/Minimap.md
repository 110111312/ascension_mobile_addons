# Widget: Minimap

---

## Minimap

Minimap is a frame type whose backdrop is filled in with a top-down representation of the area around the character being played. You can have more than one if you are so inclined, but they can't have different coordinates or locations, and tracking blips do not work correctly unless they're the exact same size. You can use methods to control the textures that are used by the minimap to display different elements such as group members or arrows to nearby points of interest, but you cannot determine where these things are. You can also adjust the zoom on a Minimap or determine where it is being pinged by you or another member of your group.

The stock UI uses a Minimap only once, predictably for the minimap in the upper right, but some mods will move it or create a larger, fainter version to use as a "heads-up display."

### Methods

### Minimap:GetPingPosition

Returns the location of the last "ping" on the minimap. Coordinates are pixel distances relative to the center of the minimap (not fractions of the minimap's size as with `:GetPingPosition()`); positive coordinates are above or to the right of the center, negative are below or to the left.

**Signature:** `x, y = Minimap:GetPingPosition()`

**Returns:**
- `x` - Horizontal coordinate of the "ping" position (`number`)
- `y` - Vertical coordinate of the "ping" position (`number`)

### Minimap:GetZoom

Returns the minimap's current zoom level

**Signature:** `zoomLevel = Minimap:GetZoom()`

**Returns:**
- `zoomLevel` - Index of the current zoom level (between 0 for the widest possible zoom and `(minimap:``GetZoomLevels()``- 1)` for the narrowest possible zoom) (`number`)

### Minimap:GetZoomLevels

Returns the number of available zoom settings for the minimap

**Signature:** `zoomLevels = Minimap:GetZoomLevels()`

**Returns:**
- `zoomLevels` - Number of available zoom settings for the minimap (`number`)

### Minimap:PingLocation

"Pings" the minimap at a given location. Coordinates are pixel distances relative to the center of the minimap (not fractions of the minimap's size as with `:GetPingPosition()`); positive coordinates are above or to the right of the center, negative are below or to the left.

**Signature:** `Minimap:PingLocation(x, y)`

**Arguments:**
- `x` - Horizontal coordinate of the "ping" position (in pixels) (`number`)
- `y` - Vertical coordinate of the "ping" position (in pixels) (`number`)

### Minimap:SetBlipTexture

Sets the texture used to display quest and tracking icons on the minimap. The replacement texture must match the specifications of the default texture (`Interface\\Minimap\\ObjectIcons`): 256 pixels wide by 64 pixels tall, containing an 8x2 grid of icons each 32x32 pixels square.

**Signature:** `Minimap:SetBlipTexture("filename")`

**Arguments:**
- `filename` - Path to a texture containing display quest and tracking icons for the minimap (`string`)

### Minimap:SetClassBlipTexture

Sets the texture used to display party and raid members on the minimap. Usefulness of this method to addons is limited, as the replacement texture must match the specifications of the default texture (`Interface\\Minimap\\PartyRaidBlips`): 256 pixels wide by 128 pixels tall, containing an 8x4 grid of icons each 32x32 pixels square.

**Signature:** `Minimap:SetClassBlipTexture("filename")`

**Arguments:**
- `filename` - Path to a texture containing icons for party and raid members (`string`)

### Minimap:SetCorpsePOIArrowTexture

Sets the texture used to the player's corpse when located beyond the scope of the minimap. The default texture is `Interface\\Minimap\\ROTATING-MINIMAPCORPSEARROW`.

**Signature:** `Minimap:SetCorpsePOIArrowTexture("filename")`

**Arguments:**
- `filename` - Path to a texture image (`string`)

### Minimap:SetIconTexture

Sets the texture used to display various points of interest on the minimap. Usefulness of this method to addons is limited, as the replacement texture must match the specifications of the default texture (`Interface\\Minimap\\POIIcons`): a 256x256 pixel square containing a 16x16 grid of icons each 16x16 pixels square.

**Signature:** `Minimap:SetIconTexture("filename")`

**Arguments:**
- `filename` - Path to a texture containing icons for various map landmarks (`string`)

### Minimap:SetMaskTexture

Sets the texture used to mask the shape of the minimap. White areas in the texture define where the dynamically drawn minimap is visible. The default mask (`Textures\\MinimapMask`) is circular; a texture image consisting of an all-white square will result in a square minimap.

**Signature:** `Minimap:SetMaskTexture("filename")`

**Arguments:**
- `filename` - Path to a texture used to mask the shape of the minimap (`string`)

### Minimap:SetPlayerTexture

Sets the texture used to represent the player on the minimap. The default texture is `Interface\Minimap\MinimapArrow`.

**Signature:** `Minimap:SetPlayerTexture("filename")`

**Arguments:**
- `filename` - Path to a texture image (`string`)

### Minimap:SetPlayerTextureHeight

Sets the height of the texture used to represent the player on the minimap

**Signature:** `Minimap:SetPlayerTextureHeight(height)`

**Arguments:**
- `height` - Height of the texture used to represent the player on the minimap (`number`)

### Minimap:SetPlayerTextureWidth

Sets the width of the texture used to represent the player on the minimap

**Signature:** `Minimap:SetPlayerTextureWidth(width)`

**Arguments:**
- `width` - Width of the texture used to represent the player on the minimap (`number`)

### Minimap:SetPOIArrowTexture

Sets the texture used to represent points of interest located beyond the scope of the minimap. This texture is used for points of interest such as those which appear when asking a city guard for directions. The default texture is `Interface\Minimap\ROTATING-MINIMAPGUIDEARROW`.

**Signature:** `Minimap:SetPOIArrowTexture("filename")`

**Arguments:**
- `filename` - Path to a texture image (`string`)

### Minimap:SetStaticPOIArrowTexture

Sets the texture used to represent static points of interest located beyond the scope of the minimap. This texture is used for static points of interest such as nearby towns and cities. The default texture is `Interface\\Minimap\\ROTATING-MINIMAPARROW`.

**Signature:** `Minimap:SetStaticPOIArrowTexture("filename")`

**Arguments:**
- `filename` - Path to a texture image (`string`)

### Minimap:SetZoom

Sets the minimap's zoom level

**Signature:** `Minimap:SetZoom(zoomLevel)`

**Arguments:**
- `zoomLevel` - Index of a zoom level (between 0 for the widest possible zoom and `(minimap:``GetZoomLevels()``- 1)` for the narrowest possible zoom) (`number`)

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

