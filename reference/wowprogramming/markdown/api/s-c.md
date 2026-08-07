# WoW API — S (C*)

_2 functions_

---

## Screenshot

Saves an image of the current game display. Screenshot images are saved to the folder `Screenshots` within the folder where the World of Warcraft client is installed.

Taking a screenshot fires the `SCREENSHOT_SUCCEEDED` event (or the `SCREENSHOT_FAILED` event in case of an error), which causes the default UI to display a message in the middle of the screen. Additional screenshots taken while this message is displayed will include it -- the default UI's `TakeScreenshot()` function hides this message so it is not included in screenshots.

**Signature:** `Screenshot()`

**See also:** Client control and information functions.



## scrub

Replaces non-simple values in a list with nil. 
All simple values (strings, numbers, and booleans) are passed from the input list to the output list unchanged. Non-simple values (tables, functions, threads, and userdata) are replaced by nil in the output list.

**Signature:** `... = scrub(...)`

**Arguments:**
- `...` - A list of values (`list`)

**Returns:**
- `...` - The list of input values, with all non-simple values replaced by nil (`list`)

**See also:** Utility functions.


