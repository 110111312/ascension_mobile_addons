# WoW API Functions — W

_2 functions_

---

## wipe

Removes all entries from a table

**Signature:** `emptyTable = wipe(aTable)`

**Arguments:**
- `aTable` - A table whose contents are to be erased (`table`)

**Returns:**
- `emptyTable` - The input table, with all entries removed (`table`)


## WithdrawGuildBankMoney

Attempts to withdraw money from the guild bank. Causes a `PLAYER_MONEY` event to fire, indicating the amount withdrawn has been added to the player's total (see `GetMoney()`). Causes an error or system message if `amount` exceeds the amount of money in the guild bank or the player's allowed daily withdrawal amount.

**Signature:** `WithdrawGuildBankMoney(amount)`

**Arguments:**
- `amount` - Amount of money to withdraw (in copper) (`number`)

**See also:** Guild bank functions, Money functions.

