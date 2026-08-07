# WoW API Functions — X

_1 functions_

---

## xpcall

Executes a function in protected mode with a custom error handler

**Signature:** `status, ... = xpcall(f, err)`

**Arguments:**
- `f` - A function (`function`)
- `err` - Error handler function to be used should `f` cause an error (`function`)

**Returns:**
- `status` - True if the function succeeded without errors; false otherwise (`boolean`)
- `...` - If `status` is `false`, the error message produced by the function; if `status` is `true`, the return values from the function (`list or string`)

**See also:** Lua library functions.

