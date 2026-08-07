# WoW API — GetH*

_3 functions_

---

## GetHairCustomization

Returns a token used for displaying "hair" customization options. The token referred to by this function can be used to look up a global variable containing localized names for the customization options available to the player's race at character creation time and in the Barbershop UI; see example.

**Signature:** `token = GetHairCustomization()`

**Returns:**
- `token` - Part of a localized string token for displaying "hair" options for the player's race (`string`)




## GetHolidayBGHonorCurrencyBonuses

Returns the awarded honor and arena points for a Call to Arms battleground win or loss

**Signature:** `unk, honorWinReward, arenaWinReward, honorLossReward, arenaLossReward = GetHolidayBGHonorCurrencyBonuses()`

**Returns:**
- `unk` - Unknown (`boolean`)
- `honorWinReward` - Honor points rewarded for a win (`number`)
- `arenaWinReward` - Arena points rewarded for a win (`number`)
- `honorLossReward` - Honor points rewarded for a loss (`number`)
- `arenaLossReward` - Arena points rewarded for a loss (`number`)

**See also:** PvP functions, Currency functions.




## GetHonorCurrency

Returns the player's amount of honor points

**Signature:** `honorPoints, maxHonor = GetHonorCurrency()`

**Returns:**
- `honorPoints` - The player's current amount of honor points (`number`)
- `maxHonor` - The maximum amount of honor currency the player can accrue (`number`)



