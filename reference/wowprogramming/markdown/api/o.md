# WoW API Functions — O

_5 functions_

---

## OfferPetition

Requests an arena or guild charter signature from the targeted unit

**Signature:** `OfferPetition()`

**See also:** Petition functions.


## OffhandHasWeapon

Returns whether the player has an equipped weapon in the off hand slot

**Signature:** `hasWeapon = OffhandHasWeapon()`

**Returns:**
- `hasWeapon` - 1 if the player has a weapon equipped in the off hand slot; otherwise nil (`1nil`)

**See also:** Player information functions.


## OpenCalendar

Queries the server for calendar status information. May cause one or more `CALENDAR_UPDATE_*` events to fire depending on the contents of the player's calendar. In the default UI, called when the calendar is shown.

**Signature:** `OpenCalendar()`

**See also:** Calendar functions.


## OpeningCinematic

Displays the introductory cinematic for the player's race. Only has effect if the player has never gained any experience.

**Signature:** `OpeningCinematic()`


## OpenTrainer

. Was used in early betas of World of Warcraft before trainer NPCs existed. Only remaining use is equivalent to `CloseTrainer()`.

**Signature:** `OpenTrainer()`

