# WoW API — C (R*)

_5 functions_

---

## CreateFont

Creates a new Font object

**Signature:** `fontObject = CreateFont("name")`

**Arguments:**
- `name` - Name to assign to the newly created object; used both as the name of the object (retrievable with `Font:GetName()`) and as a global variable referencing the object (unless another global by that name already exists) (`string`)

**Returns:**
- `fontObject` - The newly created Font object (`table`)

**See also:** Utility functions.



## CreateFrame

Creates a new Frame object

**Signature:** `frame = CreateFrame("frameType" [, "name" [, parent [, "template"]]])`

**Arguments:**
- `frameType` - Type of frame to create; see the widget documentation for details (`string`)
- `name` - Name to assign to the newly created object; used both as the name of the object (retrievable via the GetName method) and as a global variable referencing the object, unless another global by that name already exists (`string`)
- `parent` - Reference to another frame to be the new frame's parent (`table`)
- `template` - Name of a template to be used in creating the frame; if creating a frame from multiple templates, a comma-separated list of names (`string`)

**Returns:**
- `frame` - A reference to the newly created Frame (`table`)



## CreateMacro

Creates a new macro

**Signature:** `index = CreateMacro("name", icon, "body", perCharacter)`

**Arguments:**
- `name` - Name for the new macro (up to 16 characters); need not be unique, though duplicate names can cause issues for other Macro API functions (`string`)
- `icon` - Index of a macro icon (between 1 and `GetNumMacroIcons()`) (`number`)
- `body` - Body of the macro (up to 255 characters) (`string`)
- `perCharacter` - 1 if the macro should be stored as a character-specific macro; otherwise nil (`1nil`)

**Returns:**
- `index` - Index of the newly created macro (`number`, macroID)



## CreateMiniWorldMapArrowFrame



## CreateWorldMapArrowFrame


