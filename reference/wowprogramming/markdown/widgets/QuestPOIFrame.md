# Widget: QuestPOIFrame

---

## QuestPOIFrame

_No snapshot available for widget overview._

### Methods

### QuestPOIFrame:DrawBlob

Draws the Blob for the Quest.. If a quest has a area where the quest need to be completed at, this function will draw a Blob to show that area.

Also, Drawing it more than once does nothing, to make any changes to it you have to QuestPOIFrame:DrawBlob(ID,false)... Make changes ... QuestPOIFrame:DrawBlob(ID,true)

**Signature:** `QuestPOIFrame:DrawBlob(QuestId, Draw)`

**Arguments:**
- `QuestId` - The Id of the Quest (`number`)
- `Draw` - Draw the Blob (True = Yes, False = No) (`bool`)

### QuestPOIFrame:DrawNone

### QuestPOIFrame:EnableMerging

### QuestPOIFrame:EnableSmoothing

### QuestPOIFrame:GetNumTooltips

### QuestPOIFrame:GetTooltipIndex

### QuestPOIFrame:SetBorderAlpha

Set the alpha for the border texture

**Signature:** `QuestPOIFrame:SetBorderAlpha(Alpha)`

**Arguments:**
- `Alpha` - How bright the border texture is drawn (`number`)

### QuestPOIFrame:SetBorderScalar

Set the Border Scalar

**Signature:** `QuestPOIFrame:SetBorderScalar(Scalar)`

**Arguments:**
- `Scalar` - Set the glow(size) of the border (`number`)

### QuestPOIFrame:SetBorderTexture

Sets the border Texture for the Blob

**Signature:** `QuestPOIFrame:SetBorderTexture("Texture")`

**Arguments:**
- `Texture` - Path to a texture image (`string`)

### QuestPOIFrame:SetFillAlpha

Set the Alpha for the fill Texture

**Signature:** `QuestPOIFrame:SetFillAlpha(Alpha)`

**Arguments:**
- `Alpha` - How bright the fill texture is drawn. (`number`)

### QuestPOIFrame:SetFillTexture

Set the fill Texture for the Blob.

**Signature:** `QuestPOIFrame:SetFillTexture("Texture")`

**Arguments:**
- `Texture` - Path to a texture image (`string`)

### QuestPOIFrame:SetMergeThreshold

### QuestPOIFrame:SetNumSplinePoints

### QuestPOIFrame:UpdateMouseOverTooltip

