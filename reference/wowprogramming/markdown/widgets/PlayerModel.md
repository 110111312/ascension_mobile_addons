# Widget: PlayerModel

---

## PlayerModel

_No snapshot available for widget overview._

### Methods

### PlayerModel:RefreshCamera

### PlayerModel:RefreshUnit

Updates the model's appearance to match that of its unit. Used in the default UI's inspect window when the player's target changes (changing the model to match the "new appearance" of the unit `"target"`) or when the `UNIT_MODEL_CHANGED` event fires for the inspected unit (updating the model's appearance to reflect changes in the unit's equipment or shapeshift form).

**Signature:** `PlayerModel:RefreshUnit()`

### PlayerModel:SetBarberShopAlternateForm

### PlayerModel:SetCamDistanceScale

### PlayerModel:SetCreature

Sets the model to display the 3D model of a specific creature. Used in the default UI to set the model used for previewing non-combat pets and mounts (see `GetCompanionInfo()`), but can also be used to display the model for any creature whose data is cached by the client. Creature IDs can commonly be found on database sites (e.g. creature ID #10181).

**Signature:** `PlayerModel:SetCreature(creature)`

**Arguments:**
- `creature` - Numeric ID of a creature (`number`)

### PlayerModel:SetCustomRace

Sets the race of the model to a playable race. Sets the model's race to a playable race with player character's current equipment. First parameter is Race ID which can be found on database sites (e.g. draenei race #11).

Second parameter is optional and will set the sex of the model (0 = male, 1 = female). If omitted the model uses the same sex as player character.

**Signature:** `PlayerModel:SetCustomRace(race_id [, sex])`

**Arguments:**
- `race_id` - Numeric ID of a playable race (`number`)
- `sex` - Numeric ID of the model sex: 0 = male, 1 = female. (`number`)

### PlayerModel:SetDisplayInfo

### PlayerModel:SetPortraitZoom

### PlayerModel:SetRotation

Sets the model's current rotation by animating the model. This method is similar to `Model:SetFacing()` in that it rotates the 3D model displayed about its vertical axis; however, since the `PlayerModel` object displays a unit's model, this method is provided to allow for animating the rotation using the model's built-in animations for turning right and left.

For example, if the model faces towards the viewer when its facing is set to 0, setting its facing to `math.pi` faces it away from the viewer.

**Signature:** `PlayerModel:SetRotation(facing)`

**Arguments:**
- `facing` - Rotation angle for the model (in radians) (`number`)

### PlayerModel:SetUnit

Sets the model to display the 3D model of a specific unit

**Signature:** `PlayerModel:SetUnit("unit")`

**Arguments:**
- `unit` - Unit ID of a visible unit (`string`, unitID)

