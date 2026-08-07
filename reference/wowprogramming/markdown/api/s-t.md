# WoW API — S (T*)

_37 functions_

---

## StablePet

Puts the player's current pet into the stables

**Signature:** `StablePet()`



## StartAttack

Begins auto-attack against a specified target

**Signature:** `StartAttack("unit") or StartAttack("name")`

**Arguments:**
- `unit` - A unit to attack (`string`, unitID)
- `name` - The name of a unit to attack (`string`)

**See also:** Combat functions.



## StartAuction

Creates an auction for the item currently in the "auction item" slot. Has no effect unless an item has been placed in the Create Auction UI's "auction item" slot (see `ClickAuctionSellItemButton()`). With patch 3.3.3 the runTime arg was changed from minutes to an index and the stackSize/numStacks args were added for batch posting.

**Signature:** `StartAuction(minBid, buyoutPrice, runTime, stackSize, numStacks)`

**Arguments:**
- `minBid` - Minimum bid for the auction (in copper) (`number`)
- `buyoutPrice` - Buyout price for the auction (in copper) (`number`)
- `runTime` - Run time until the auction expires (an index indicating number of hours) (`number`) 

 - `1` - 12 hours
- `2` - 24 hours
- `3` - 48 hours
- `stackSize` - Number of items to post in each auction (`number`)
- `numStacks` - Number of auctions (stacks) to post (`number`)



## StartDuel

Challenges another player to a duel

**Signature:** `StartDuel("unit") or StartDuel("name" [, exactMatch])`

**Arguments:**
- `unit` - A unit to target (`string`, unitID)
- `name` - Name of a unit to target (`string`)
- `exactMatch` - True to check only units whose name exactly matches the `name` given; false to allow partial matches (`boolean`)

**See also:** Duel functions.



## StopAttack

Stops auto-attack if active

**Signature:** `StopAttack()`



## StopCinematic

Exits a currently playing in-game cinematic. Applies to in-game-engine cinematics (such as when logging into a new character for the first time), not prerecorded movies.

**Signature:** `StopCinematic()`

**See also:** In-game movie playback functions.



## StopMacro

Stops execution of a running macro

**Signature:** `StopMacro()`

**See also:** Macro functions.



## StopMusic

Stops currently playing in-game music

**Signature:** `StopMusic()`



## StopTradeSkillRepeat

Cancels repetition of a trade skill recipe. If a recipe is currently being performed, it will continue, but further scheduled repetitions will be canceled.

**Signature:** `StopTradeSkillRepeat()`

**See also:** Tradeskill functions.



## Stopwatch_Clear

_No snapshot available (page did not exist in archive)._



## Stopwatch_FinishCountdown



## Stopwatch_IsPlaying



## Stopwatch_Pause



## Stopwatch_Play



## Stopwatch_StartCountdown



## Stopwatch_Toggle

Toggles visibility of the StopwatchFrame

**Signature:** `Stopwatch_Toggle()`

**See also:** Stopwatch functions.



## StrafeLeftStart

Begins moving the player character sideways to his or her left

**Signature:** `StrafeLeftStart()`

**See also:** Movement functions.



## StrafeLeftStop

Ends movement initiated by `StrafeLeftStart`

**Signature:** `StrafeLeftStop()`



## StrafeRightStart

Begins moving the player character sideways to his or her right

**Signature:** `StrafeRightStart()`



## StrafeRightStop

Ends movement initiated by `StrafeRightStart`

**Signature:** `StrafeRightStop()`



## strbyte

Returns the numeric code for one or more characters in a string. Alias for the standard library function `string.byte`.

**Signature:** `value, ... = strbyte("s" [, firstChar [, lastChar]])`

**Arguments:**
- `s` - A string (`string`)
- `firstChar` - Position of a character in the string (can be negative to count backwards from the end of the string); defaults to 1 if omitted (`number`)
- `lastChar` - Position of a later character in the string (can be negative to count backwards from the end of the string); defaults to `firstChar` if omitted (`number`)

**Returns:**
- `value` - Numeric code for the character at position `firstChar` in the string (`number`)
- `...` - A list of numbers, each the numeric codes of additional characters in the string if `lastChar` specifies a position later in the string than `firstChar` (`list`)

**See also:** Lua library functions.



## strchar

Returns the character(s) for one or more numeric codes. Alias for the standard library function `string.char`.

**Signature:** `s = strchar(n [, ...])`

**Arguments:**
- `n` - An integer (`number`)
- `...` - Additional integers (`number`)

**Returns:**
- `s` - A string containing the character(s) for the given numeric code(s) (`number`)



## strconcat

Joins a list of strings (with no separator). Equivalent to `strjoin("", ...)`. If no strings are provided, returns the empty string (`""`).

**Signature:** `result = strconcat("...")`

**Arguments:**
- `...` - A list of strings to concatenate (`string`)

**Returns:**
- `result` - The concatenated string (`string`)



## strfind

Returns information about matches for a pattern in a string. Alias for the standard library function `string.find`.

Returns `nil` if no matches are found.

**Signature:** `start, end, ... = strfind("s", "pattern" [, init [, plain]])`

**Arguments:**
- `s` - A string (`string`)
- `pattern` - A regular expression pattern (`string`, pattern)
- `init` - Initial position in the string `s` at which to begin the search; defaults to 1 if omitted (`number`)
- `plain` - True to perform a simple substring search (i.e. considering `pattern` only as a literal string, not a regular expression); false or omitted otherwise (`boolean`)

**Returns:**
- `start` - Character position in `s` at which the first match begins (`number`)
- `end` - Character position in `s` at which the first match ends (`number`)
- `...` - Captured substrings from `s`, if `pattern` specifies captures (`list`)



## strjoin

Joins a list of strings together with a given separator. If given a list of strings not already in a table, this function can be used instead of `table.concat` for better performance.

Also available as `string.join` (though not provided by the Lua standard library).

**Signature:** `text = strjoin("sep", ...)`

**Arguments:**
- `sep` - A separator to insert between joined strings (`string`)
- `...` - A list of strings to be joined together (`list`)

**Returns:**
- `text` - The list of strings joined together with the given separator string (`string`)



## strlen

Returns the number of characters in a string. Alias for the standard library function `string.len`.

**Signature:** `length = strlen("s")`

**Arguments:**
- `s` - A string (`string`)

**Returns:**
- `length` - Number of characters in the string (`number`)



## strlenutf8

Returns the length of a string, taking UTF-8 multi-byte characters into account

**Signature:** `length = strlenutf8("string")`

**Arguments:**
- `string` - The string to query. (`string`)

**Returns:**
- `length` - The length of the given string, taking UTF-8 multi-byte characters into account. (`number`)



## strlower

Returns a copy of a string with all uppercase letters converted to lowercase. Alias for the standard library function `string.lower`

**Signature:** `lowerCase = strlower("s")`

**Arguments:**
- `s` - A string (`string`)

**Returns:**
- `lowerCase` - A copy of the string `s` with all uppercase letters converted to lowercase (`string`)



## strmatch

Returns the matches for a for a pattern in a string. Alias for the standard library function `string.match`.

**Signature:** `match, ... = strmatch("s", "pattern")`

**Arguments:**
- `s` - A string (`string`)
- `pattern` - A regular expression pattern (`string`, pattern)

**Returns:**
- `match` - First substring of `s` matching `pattern`, or the first capture if `pattern` specifies captures; nil if no match is found (`string`)
- `...` - Additional captures found, if `pattern` specifies multiple captures (`list`)



## strrep

Returns a string produced by a number of repetitions of another string. Alias for the standard library function `string.rep`.

**Signature:** `repeated = strrep("s", n)`

**Arguments:**
- `s` - A string (`string`)
- `n` - A number (`number`)

**Returns:**
- `repeated` - The concatenation of `n` copies of the string `s` (`string`)

**See also:** Lua library functions.



## strreplace

Fast simple substring substitution. Matches the semantics of `string.gsub`, but only finds and replaces specific substrings rather than using more powerful and more computationally expensive regular expression matching. Thus, this function can be used in place of `string.gsub` in performance-critical situations where only simple matching is needed.

Also available as `string.replace` (though not provided by the Lua standard library).

**Signature:** `newText, count = strreplace("text", "pattern", "replacement", "count")`

**Arguments:**
- `text` - Text to be altered (`string`)
- `pattern` - A substring to be located within the source text (`string`)
- `replacement` - Text to be inserted in place of the found pattern (`string`)
- `count` - Maximum number of replacements to be made (`string`)

**Returns:**
- `newText` - The input string with matching substrings replaced (`string`)
- `count` - Number of occurrences of the substring replaced (`number`)



## strrev

Returns the reverse of a string. Alias for the standard library function `string.reverse`.

**Signature:** `s = strrev("s")`

**Arguments:**
- `s` - A string (`string`)

**Returns:**
- `s` - A string containing the characters of string `s` in reverse order (`string`)



## strsplit

Splits a string based on another seperator string. Also available as `string.split` (though not provided by the Lua standard library).

**Signature:** `... = strsplit("sep", "text", limit)`

**Arguments:**
- `sep` - The seperator string to use (`string`)
- `text` - The text to split (`string`)
- `limit` - The maximum number of pieces to split the string into (`number`)

**Returns:**
- `...` - A list of strings, split from the input text based on the seperator string (`string`)



## strsub

Returns a substring of a string. Alias for the standard library function `string.sub`.

**Signature:** `s = strsub("s", firstChar [, lastChar])`

**Arguments:**
- `s` - A string (`string`)
- `firstChar` - Position of a character in the string (can be negative to count backwards from the end of the string) (`number`)
- `lastChar` - Position of a later character in the string (can be negative to count backwards from the end of the string); defaults to -1 if omitted (`number`)

**Returns:**
- `s` - The substring of `s` starting at the character `firstChar` and ending with the character `lastChar` (`string`)



## strtrim

Trims leading and trailing characters (whitespace by default) from a string. Also available as `string.trim` (though not provided by the Lua standard library).

**Signature:** `text = strtrim("str" [, "trimChars"])`

**Arguments:**
- `str` - A string to trim (`string`)
- `trimChars` - A string listing the characters to be trimmed (e.g. `"[]{}()"` to trim leading and trailing brackets, braces, and parentheses); if `nil` or omitted, whitespace characters (space, tab, newline, etc) are trimmed (`string`)

**Returns:**
- `text` - The trimmed string (`string`)



## strupper

Returns a copy of a string with all lowercase letters converted to uppercase. Alias for the standard library function `string.upper`.

**Signature:** `lowerCase = strupper("str")`

**Arguments:**
- `str` - A string (`string`)

**Returns:**
- `lowerCase` - A copy of the string `s` with all lowercase letters converted to uppercase (`string`)

**See also:** Lua library functions.



## Stuck

Uses the auto-unstuck feature

**Signature:** `Stuck()`

**See also:** GM Ticket functions.


