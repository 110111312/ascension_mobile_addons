# WoW Events — U

_93 events_

---

## UI_ERROR_MESSAGE

Fires when a game error message should be displayed. e.g. "You cannot attack that target", "Your pet is dead", "Your inventory is full"

**Payload:** `("message")`

**Arguments:**
- `message` - The message thats to be displayed. (`string`)


## UI_INFO_MESSAGE

Fires when an informative message should be displayed. e.g. "No fish are hooked", "You must be at least level 80 and in a raid group to enter this instance"

**Payload:** `("message")`

**Arguments:**
- `message` - The message that needs to be displayed (`string`)


## UNIT_ATTACK

Fires when a unit's weapon (or standard melee attack damage) changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_ATTACK_POWER

Fires when a unit's attack power changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_ATTACK_SPEED

Fires when a unit's attack speed changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_AURA

Fires when a unit loses or gains a buff or debuff.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_CLASSIFICATION_CHANGED

Fires when a unit changes classification (e.g. if an elite unit becomes non-elite)

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_COMBAT

Fires when a unit takes or recovers from damage due to a combat effect

**Payload:** `("unitID", "action", "descriptor", damage, damageType)`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)
- `action` - The action type that happened, i.e. WOUND, DODGE, HEAL (`string`)
- `descriptor` - A descriptor that describes the action, i.e. CRITICAL, CRUSHING (`string`)
- `damage` - The ammount of damage or healing received (`number`)
- `damageType` - The type of damage dealt. Is 0(physical) for healing. (`number`)


## UNIT_COMBO_POINTS

Fires when a unit scores combo points on its target

**Payload:** `()`


## UNIT_DAMAGE

Fires when a unit's weapon damage changes.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_DEFENSE

Fires when a unit's defense changes.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_DISPLAYPOWER

Fires when a unit's primary power type (e.g. rage, energy, mana) changes. Occurs when a druid shapeshifts as well as in certain other cases.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_DYNAMIC_FLAGS

Fires when certain unit attributes change. Attribute changes covered by this event include `UnitIsCorpse()` and `UnitIsTapped()`.

**Payload:** `()`


## UNIT_ENERGY

_No snapshot available._


## UNIT_ENTERED_VEHICLE

Fires when a unit has entered a vehicle

**Payload:** `()`


## UNIT_ENTERING_VEHICLE

Fires when a unit begins entering a vehicle. See `UNIT_ENTERED_VEHICLE` for when the vehicle boarding animation finishes.

**Payload:** `()`


## UNIT_EXITED_VEHICLE

Fires when a unit has exited a vehicle

**Payload:** `()`


## UNIT_EXITING_VEHICLE

Fires when a unit begins exiting a vehicle. See `UNIT_EXITED_VEHICLE` for when the vehicle exiting animation finishes.

**Payload:** `()`


## UNIT_FACTION

Fires when a unit's PvP status changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_FLAGS

Fires when certain combat statuses for a unit change (e.g. stunned, feared)

**Payload:** `("unit")`

**Arguments:**
- `unit` - The id of the affected unit. (`string`)


## UNIT_FOCUS

_No snapshot available._


## UNIT_HAPPINESS

_No snapshot available._


## UNIT_HEALTH

Fires when a unit's health level changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_INVENTORY_CHANGED

Fires when the player (or inspected unit) equips or unequips items

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_LEVEL

Fires when a unit's character level changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_MANA

Fires when a unit's mana level changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_MAXENERGY

_No snapshot available._


## UNIT_MAXFOCUS

_No snapshot available._


## UNIT_MAXHAPPINESS

_No snapshot available._


## UNIT_MAXHEALTH

Fires when a unit's maximum health changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_MAXMANA

_No snapshot available._


## UNIT_MAXRAGE

_No snapshot available._


## UNIT_MAXRUNIC_POWER

_No snapshot available._


## UNIT_MODEL_CHANGED

Fires when a unit's 3D model changes (e.g. due to shapeshifting, being polymorphed, or equipping gear)

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_NAME_UPDATE

Fires when a unit's name is changed. Also fires when the client is first notified of a unit's name.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_PET

_No snapshot available._


## UNIT_PET_EXPERIENCE

_No snapshot available._


## UNIT_PORTRAIT_UPDATE

Fires when a unit's portrait changes (e.g. due to shapeshifting, being polymorphed, or equipping gear). Also fires when a unit's portrait changes from a generic race/gender image to one based on the unit's 3D model.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_QUEST_LOG_CHANGED

Fires when a unit's quests change (accepted/objective progress/abandoned/completed). This event will trigger both for your status changes, and that of others (when in a party/raid), and signifies that something has changed regarding the unit's current quests. This event triggering means that one of the following has occured: Accepted a new quest, abandoned an existing quest, achieved progress on the objectives of a quest, or completed (turned in) a quest.

 
 - 
unitID will be "player" when the event relates to you. This event is VERY reliable for players, and is the preferred event when you ONLY care about changes relating to the player's quests and don't care about all the other triggerings that come with using the player-only `QUEST_LOG_UPDATE` (that event should really only be used if you are writing a Quest Log replacement addon, as it triggers on many, many non-quest related things).

 
 - 
unitID will be partyX/raidX when the event relates to a party or raid member. However, this event is EXTREMELY unreliable for party and raid members, as it will ONLY trigger if you are at a very close range to them; and it will only trigger when they GAIN a quest (accepting) or LOSE a quest (abandon/turn in), meaning that you can't expect to use this event to monitor the quest status of other units, as you may be out of range when they accept or finish a quest (and then your client won't trigger this event and you won't know that they have a new quest/no longer has a certain quest). Also, even if they ARE in range it won't trigger for PROGRESS updates (such as finishing or achieving progress on certain objectives). It's best to just completely ignore that this event claims to be for other units, as its range limitation makes it useless for keeping an accurate look at other unit's quest state.

Note: If you are in a party or raid and YOUR status changes, this event will be triggered twice; once with a unitID of "player", and once with your current "partyX/raidX" unitID (be aware that your ID changes whenever the party/raid layout changes; one call you may be raid37, and another call you may be raid21, so never store the value and assume it to stay the same).

Warning Regarding Use: If your addon's operation relies on building an internal table of the user's quests, and you want that table available immediately at logon/UI reload, you MUST complement this event with `QUEST_LOG_UPDATE` (which fires 2 times on logon and 1 time on UI reload), and build/update your quest table on BOTH `QUEST_LOG_UPDATE` and `UNIT_QUEST_LOG_CHANGED`. That's because the latter event only fires on actual CHANGES to your quests, and NOT on logon/UI reload. However, as soon as `QUEST_LOG_UPDATE` has fired you don't need it anymore, and you should use UnregisterEvent to remove it. This ensures that your addon starts out watching for QLU, uses it once to grab the "initial state", unregisters from it since we don't need it anymore, and then uses UQLC from then on to monitor CHANGES to the quests. (Also note that, no, you can't use `PLAYER_LOGIN` since the quest log data is received later than that.)

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_RAGE

Fires when a unit's rage level changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_RANGED_ATTACK_POWER

Fires when a unit's ranged attack power changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_RANGEDDAMAGE

Fires when a unit's ranged attack damage changes. Also fires when a unit's ranged attack speed changes.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_RESISTANCES

Fires when a unit's magic resistances change. Also seems to fire when a unit's armor value changes.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that was affected. (`string`)


## UNIT_RUNIC_POWER

_No snapshot available._


## UNIT_SPELLCAST_CHANNEL_START

Fires when a unit starts channeling a spell

**Payload:** `("unitID", "spell", "rank", lineID, spellID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `lineID` - Spell lineID counter. This number is always 0 for channels. (`number`)
- `spellID` - The id of the spell that's being casted. (`number`, spellID)


## UNIT_SPELLCAST_CHANNEL_STOP

Fires when a unit stops or cancels a channeled spell

**Payload:** `("unitID", "spell", "rank")`

**Arguments:**
- `unitID` - The unit that was casting. (`string`)
- `spell` - The name of the spell that wass being casted. (`string`)
- `rank` - The rank of the spell that wass being casted. (`string`)


## UNIT_SPELLCAST_CHANNEL_UPDATE

Fires when a unit's channeled spell is interrupted or delayed

**Payload:** `("unitID", "spell", "rank", lineID, spellID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `lineID` - Spell lineID counter. This number is always 0 for channels. (`number`)
- `spellID` - The id of the spell that's being casted. (`number`, spellID)


## UNIT_SPELLCAST_DELAYED

Fires when a unit's spell cast is delayed

**Payload:** `("unitID", "spell", "rank")`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)


## UNIT_SPELLCAST_FAILED

Fires when a unit's spell cast fails

**Payload:** `("unitID", "spell", "rank", unknownid, spellid)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `unknownid` - A numeric identifier, likely some client-generated sequence id, probably related to `UNIT_SPELLCAST_SENT`. (`number`)
- `spellid` - The numeric spell id of the spell that was attempted (`number`, blizzid)


## UNIT_SPELLCAST_FAILED_QUIET

Fires when a unit's spell cast fails and no error message should be displayed. The default UI displays an error message when `UNIT_SPELLCAST_FAILED` fires; in some situations (e.g. if the player attempts to cast while mind controlled), this event is used instead, preventing an error message from being displayed while still notifying interested scripts of the failure.

**Payload:** `("unitID", "spell", "rank")`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)


## UNIT_SPELLCAST_INTERRUPTED

Fires when a unit's spell cast is interrupted

**Payload:** `("unitID", "spell", "rank", lineID, spellID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `lineID` - Spell lineID counter. The Nth spell that UNIT_SPELLCAST events have fired for. Unique to each spell cast - UNIT_SPELLCAST_START and UNIT_SPELLCAST_SUCCESS events referring to the same cast will have the same lineID. Resets to 0 when the count reaches 255, but this number may just always be 0 for some spells. (`number`)
- `spellID` - The id of the spell that's being casted. (`number`, spellID)


## UNIT_SPELLCAST_INTERRUPTIBLE

Fires when a unit's spell cast becomes interruptible again

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit who's casted spell has become interruptible again. (`string`, unitID)


## UNIT_SPELLCAST_NOT_INTERRUPTIBLE

Fires when a unit's spell cast becomes uninterruptible

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit who's currently casting spell has cannot be interrupted. (`string`, unitID)


## UNIT_SPELLCAST_SENT

Fires when a request to cast a spell (on behalf of the player or a unit controlled by the player) is sent to the server

**Payload:** `("unitID", "spell", "rank", "target", lineID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `target` - The name of the target of your spell. (`string`)
- `lineID` - Spell lineID counter. The Nth spell that UNIT_SPELLCAST events have fired for. Unique to each spell cast - UNIT_SPELLCAST_START and UNIT_SPELLCAST_SUCCESS events referring to the same cast will have the same lineID. Resets to 0 when the count reaches 255, but this number may just always be 0 for some spells. (`number`)


## UNIT_SPELLCAST_START

Fires when a unit begins casting a spell

**Payload:** `("unitID", "spell", "rank", lineID, spellID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `lineID` - Spell lineID counter. The Nth spell that UNIT_SPELLCAST events have fired for. Unique to each spell cast - UNIT_SPELLCAST_START and UNIT_SPELLCAST_SUCCESS events referring to the same cast will have the same lineID. Resets to 0 when the count reaches 255, but this number may just always be 0 for some spells. (`number`)
- `spellID` - The id of the spell that's being casted. (`number`, spellID)


## UNIT_SPELLCAST_STOP

Fires when a unit stops or cancels casting a spell

**Payload:** `("unitID", "spell", "rank", lineID, spellID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `lineID` - Spell lineID counter. The Nth spell that UNIT_SPELLCAST events have fired for. Unique to each spell cast - UNIT_SPELLCAST_START and UNIT_SPELLCAST_SUCCESS events referring to the same cast will have the same lineID. Resets to 0 when the count reaches 255, but this number may just always be 0 for some spells. (`number`)
- `spellID` - The id of the spell that's being casted. (`number`, spellID)


## UNIT_SPELLCAST_SUCCEEDED

Fires when a unit's spell cast succeeds

**Payload:** `("unitID", "spell", "rank", ?, spellID)`

**Arguments:**
- `unitID` - The unit that's casting. (`string`)
- `spell` - The name of the spell that's being casted. (`string`)
- `rank` - The rank of the spell that's being casted. (`string`)
- `?` - unknown. (`number`)
- `spellID` - The id of the spell that's being casted. (`number`)


## UNIT_STATS

Fires when a unit's primary attributes change. Primary attributes are Strength, Stamina, Agility, Intellect, and Spirit.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that's being affected by the event. (`string`)


## UNIT_TARGET

Fires when a unit's target changes.

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit that's being affected by the event. (`string`)


## UNIT_THREAT_LIST_UPDATE

Fires when a non-player unit's threat list is updated

**Payload:** `()`


## UNIT_THREAT_SITUATION_UPDATE

Fires when a unit's threat state changes. Only fires when changes in the unit's general threat state (see `UnitThreatSituation()`) occur, not due to changes in the underlying threat values.

**Payload:** `()`


## UPDATE_BATTLEFIELD_SCORE

Fires when information for the battleground scoreboard changes or becomes available

**Payload:** `()`


## UPDATE_BATTLEFIELD_STATUS

Fires when the player's status in a battleground or queue changes

**Payload:** `()`


## UPDATE_BINDINGS

Fires when information about the player's key binding settings changes or becomes available

**Payload:** `()`


## UPDATE_BONUS_ACTIONBAR

Fires when information about the bonus action bar changes or becomes available. The bonus action bar is used for state-dependent sets of actions, such as those used for warrior stances, druid shapeshift forms, rogue stealth, and possession of other units; this event fires when entering such states.

**Payload:** `()`


## UPDATE_CHAT_COLOR

Fires when the color settings for chat message types are updated

**Payload:** `("type", red, green, blue)`

**Arguments:**
- `type` - Chat message type for which the color setting has changed (`string`)
- `red` - Red component of the color (0.0 - 1.0) (`number`)
- `green` - Green component of the color (0.0 - 1.0) (`number`)
- `blue` - Blue component of the color (0.0 - 1.0) (`number`)


## UPDATE_CHAT_COLOR_NAME_BY_CLASS

Fires when settings for per-class color-coding of character names in chat are updated

**Payload:** `()`


## UPDATE_CHAT_WINDOWS

Fires when saved chat window settings are loaded

**Payload:** `()`


## UPDATE_EXHAUSTION

Fires when the player's rest state or amount of rested XP changes

**Payload:** `()`


## UPDATE_FACTION

Fires when the contents of the reputation listing change or become available. Fires both for changes to the listing as displayed in the reputation UI (i.e. expanding or collapsing headers, moving factions to the Inactive group, or changing at-war status) and for changes to the player's reputation with any faction.

**Payload:** `()`


## UPDATE_FLOATING_CHAT_WINDOWS

Fires when chat window layout should be updated

**Payload:** `()`


## UPDATE_GM_STATUS

Fires when the player's GM ticket status (or ability to submit tickets) changes

**Payload:** `(avilable)`

**Arguments:**
- `avilable` - Is 1 if the gms are available, 0 if they are not. (`number`)


## UPDATE_INSTANCE_INFO

Fires when information about instances to which the player is saved changes or becomes available

**Payload:** `()`


## UPDATE_INVENTORY_ALERTS

Fires when an equipped item's durability alert status changes. Only fires for changes affecting durability alert status (conditions displayed as red or yellow on the default UI's durability warning frame); for other changes to item durability levels, see `UPDATE_INVENTORY_DURABILITY`.

**Payload:** `()`


## UPDATE_INVENTORY_DURABILITY

Fires when an equipped item's durability changes

**Payload:** `()`


## UPDATE_LFG_LIST

Fires when results of a Looking for More query become available

**Payload:** `()`


## UPDATE_LFG_LIST_INCREMENTAL

Fires when results of a Looking for More query are updated

**Payload:** `()`


## UPDATE_LFG_TYPES

Fires when information about possible Looking for Group settings changes or becomes available

**Payload:** `()`


## UPDATE_MACROS

Fires when information about the player's macros changes or becomes available

**Payload:** `()`


## UPDATE_MASTER_LOOT_LIST

Fires when the contents of the master loot candidate list change or become available

**Payload:** `()`


## UPDATE_MOUSEOVER_UNIT

Fires when the mouse cursor moves over a visible unit. Fires both when mousing over units in the 3D world or when mousing over secure frames whose `unit` attribute refers to a unit in the player's area of interest.

**Payload:** `()`


## UPDATE_MULTI_CAST_ACTIONBAR

Fires when the contents of the multi-cast action bar change or become available. This action bar is currently used only for allowing shaman characters to place multiple totems at once.

**Payload:** `()`


## UPDATE_PENDING_MAIL

Fires when information about newly received mail messages (not yet seen at a mailbox) becomes available

**Payload:** `()`


## UPDATE_SHAPESHIFT_COOLDOWN

Fires when the cooldown begins or ends for an action on the stance/shapeshift bar

**Payload:** `()`


## UPDATE_SHAPESHIFT_FORM


## UPDATE_SHAPESHIFT_FORMS

Fires when the contents of the stance/shapeshift bar change or become available

**Payload:** `()`


## UPDATE_SHAPESHIFT_USABLE

Fires when an ability on the stance/shapeshift bar becomes usable or unusable. For example, the availability of druid aquatic, travel, and flight forms can change as the player moves around, as those forms are only usable when the player is swimming, outside, or in an area that allows flight.

**Payload:** `()`


## UPDATE_STEALTH

Fires when the player uses or cancels a stealth ability

**Payload:** `()`


## UPDATE_TICKET

Fires when information about an active GM ticket changes or becomes available

**Payload:** `()`


## UPDATE_TRADESKILL_RECAST

Fires for each cast when performing multiple casts of a trade skill recipe. Fires before each cast and when casting is canceled.

**Payload:** `()`


## UPDATE_WORLD_STATES

Fires when information for world state UI elements changes or becomes available. World State UI elements include PvP, instance, and quest objective information (displayed at the top center of the screen in the default UI) as well as more specific information for "control point" style PvP objectives. Examples: the Horde/Alliance score in Arathi Basin, the tower status and capture progress bars in Hellfire Peninsula, the progress text in the Black Morass and Violet Hold instances, and the event status text for quests The Light of Dawn and The Battle For The Undercity.

**Payload:** `()`


## USE_BIND_CONFIRM

Fires when the player attempts to use an item which will become soulbound in the process

**Payload:** `()`


## USE_GLYPH

Fires when the player begins to use a glyph. In the default UI, this event causes the glyph interface to open when the player right-clicks a glyph item, allowing quick targeting of a socket for the glyph.

**Payload:** `()`

