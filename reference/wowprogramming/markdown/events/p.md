# WoW Events — P

_79 events_

---

## PARTY_CONVERTED_TO_RAID

Fires when the player's party becomes a raid group

**Payload:** `()`


## PARTY_INVITE_CANCEL

Fires when a pending invitation to join a group is no longer available

**Payload:** `()`


## PARTY_INVITE_REQUEST

Fires when the player is invited to join a group

**Payload:** `("sender")`

**Arguments:**
- `sender` - The name of the person who sent the invite. (`string`)


## PARTY_LEADER_CHANGED

Fires when information about the leadership of the player's party changes or becomes available

**Payload:** `()`


## PARTY_LFG_RESTRICTED


## PARTY_LOOT_METHOD_CHANGED

Fires when information about the loot rules for the player's party changes or becomes available

**Payload:** `()`


## PARTY_MEMBER_DISABLE

Fires when a party member goes offline

**Payload:** `(id)`

**Arguments:**
- `id` - The party id of the player disabled. (`number`)


## PARTY_MEMBER_ENABLE

Fires when an offline party member comes back online

**Payload:** `(id)`

**Arguments:**
- `id` - The id of the effected party member (`number`)


## PARTY_MEMBERS_CHANGED

Fires when information about the membership of the player's party changes or becomes available

**Payload:** `()`


## PET_ATTACK_START

Fires when the player's pet starts auto-attacking

**Payload:** `()`


## PET_ATTACK_STOP

Fires when the player's pet stops auto-attacking

**Payload:** `()`


## PET_BAR_HIDE

Fires when the pet action bar should be hidden. Does not fire in all cases where the default UI automatically hides the pet bar if inapplicable.

**Payload:** `()`


## PET_BAR_HIDEGRID

Fires when a pet ability is removed from the cursor. In the default UI, this event causes the grid of empty pet action bar slots to be hidden. (This grid only appears when something that can be dragged to the pet action bar slot is picked up.)

**Payload:** `()`


## PET_BAR_SHOWGRID

Fires when a pet ability is picked up onto the cursor. In the default UI, this event causes the grid of empty pet action bar slots to be shown. (This grid only appears when something that can be dragged to the pet action bar slot is picked up.)

**Payload:** `()`


## PET_BAR_UPDATE

Fires when information about the content of the pet action bar changes or becomes available

**Payload:** `()`


## PET_BAR_UPDATE_COOLDOWN

Fires when the cooldown begins or ends for an ability on the pet action bar

**Payload:** `()`


## PET_BAR_UPDATE_USABLE


## PET_DISMISS_START

Fires when the player's pet is dismissed. Applies to warlock minions, mind controlled units, quest-related pets, etc., but not to hunter pets.

**Payload:** `()`


## PET_FORCE_NAME_DECLENSION

Fires when the player is prompted to provide Russian declensions for a pet's name. Only applies in the Russian client.

**Payload:** `()`


## PET_RENAMEABLE

Fires when the player is prompted to rename a pet which has been renamed before. A hunter's pet can normally only be named once, but a Certificate of Ownership can be used to rename a pet which has been renamed before.

**Payload:** `()`


## PET_SPELL_POWER_UPDATE


## PET_STABLE_CLOSED

Fires when the player ends interaction with the pet stables

**Payload:** `()`


## PET_STABLE_SHOW

Fires when the player begins interaction with the pet stables

**Payload:** `()`


## PET_STABLE_UPDATE

Fires when information about the pet stables' content changes or becomes available

**Payload:** `()`


## PET_STABLE_UPDATE_PAPERDOLL

Fires when information about 3D models used in the pet stables becomes available. Generally, this information is available on `PET_STABLE_UPDATE`, but this event may fire if model information needed to be retrieved from the server.

**Payload:** `()`


## PET_TALENT_UPDATE

Fires when the player's pet talent information changes - that is, when the pet is summoned, dismissed, gains or spends talent points. May fire multiple times in a row.

**Payload:** `()`


## PET_UI_CLOSE

Fires when information about the player's pet is no longer available. Used in the default UI to determine whether the Pet section of the Character window should be shown; most often, this is determined in response to other events (e.g. `UNIT_PET`), but this event may fire in some cases where the player switches pets.

**Payload:** `()`


## PET_UI_UPDATE

Fires when information about the player's pet changes or becomes available

**Payload:** `()`


## PETITION_CLOSED

Fires when the player ends interaction with a guild or arena team charter

**Payload:** `()`


## PETITION_SHOW

Fires when a guild or arena team charter is presented to the player

**Payload:** `()`


## PETITION_VENDOR_CLOSED

Fires when the player ends interaction with an arena registrar

**Payload:** `()`


## PETITION_VENDOR_SHOW

Fires when the player begins interaction with an arena registrar

**Payload:** `()`


## PETITION_VENDOR_UPDATE

Fires when information about available options at an arena registrar becomes available

**Payload:** `()`


## PLAY_MOVIE

Fires when an in-game movie should be played. Currently used only for the video in the Wrathgate quest event.

**Payload:** `()`


## PLAYER_ALIVE

Fires when the player's spirit is released after death or when the player accepts a resurrection without releasing

**Payload:** `()`


## PLAYER_AURAS_CHANGED

Fires when the player gains or loses a buff or debuff. Removed in patch 3.02. Use `UNIT_AURA` instead.

**Payload:** `()`


## PLAYER_CAMPING

Fires when the player attempts to log out while not in a major city, inn, or other "resting" area

**Payload:** `()`


## PLAYER_CONTROL_GAINED

Fires when the player regains control of his or her character. Occurs when a fear, mind control, or similar effect wears off or when the player arrives at the end of an automated flight path.

**Payload:** `()`


## PLAYER_CONTROL_LOST

Fires when the player loses control of his or her character. Occurs when the player is afflicted by a fear, mind control, or similar effect or when the player takes an automated flight path.

**Payload:** `()`


## PLAYER_DAMAGE_DONE_MODS

Fires when an effect changes the player's spell bonus damage

**Payload:** `("unit")`

**Arguments:**
- `unit` - Is always 'player' (`string`)


## PLAYER_DEAD

Fires when the player dies

**Payload:** `()`


## PLAYER_DIFFICULTY_CHANGED


## PLAYER_ENTER_COMBAT

Fires when the player begins melee auto-attack mode. This event cannot be used to detect when the player is entering a combat situation (i.e. when targeted by a hostile creature); for such cases, see `PLAYER_REGEN_DISABLED`.

**Payload:** `()`


## PLAYER_ENTERING_BATTLEGROUND

Fires when the player enters a battleground instance. Otherwise equivalent to `PLAYER_ENTERING_WORLD`.

**Payload:** `()`


## PLAYER_ENTERING_WORLD

Fired when the player enters the world, reloads the UI, enters/leaves an instance or battleground, or respawns at a graveyard. Also fires any other time the player sees a loading screen

**Payload:** `()`


## PLAYER_EQUIPMENT_CHANGED

Fires when the player equips or unequips an item

**Payload:** `(slot, hasItem)`

**Arguments:**
- `slot` - The inventory slot affected by the equipment change. (`number`, inventoryID)
- `hasItem` - 1 if the slot contains an item, otherwise `nil`. (`1nil`)


## PLAYER_FARSIGHT_FOCUS_CHANGED

Fires when the player's viewpoint changes. Examples include spells such as Far Sight, Mind Vision, Eye of Kilrogg and various quest-related effects.

**Payload:** `()`


## PLAYER_FLAGS_CHANGED

Fires when a unit's AFK or DND status changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit of the effected player. (`string`)


## PLAYER_FOCUS_CHANGED

Fires when the player's focus unit changes

**Payload:** `()`


## PLAYER_GAINS_VEHICLE_DATA

Fires when the player gains vehicle-related attributes without necessarily entering a vehicle. This can occur when the player uses a multi-passenger mount -- like all other mounts it is considered an extension of the player rather than a separate vehicle unit, but it has vehicle-related attributes such as a seat diagram and passenger controls for exiting.

**Payload:** `()`


## PLAYER_GUILD_UPDATE

Fires when information about the player's guild membership changes

**Payload:** `("unitID")`

**Arguments:**
- `unitID` - The unit of the player effect. Most of the time this will be player, however sometimes it will be nil. (`string`)


## PLAYER_LEAVE_COMBAT

Fires when the player stops melee auto-attack mode. This event cannot be used to detect when the player is exiting a combat situation (i.e. after defeating for fleeing from a hostile creature); for such cases, see `PLAYER_REGEN_ENABLED`.

**Payload:** `()`


## PLAYER_LEAVING_WORLD

Fires when the player logs out or exits a world area. Can occur when leaving an instance or leaving one continent (or other separated world area) for another.

**Payload:** `()`


## PLAYER_LEVEL_UP

Fires when the player gains a character level. Ding!

**Payload:** `("level", hp, mp, talentPoints, strength, agility, stamina, intellect, spirit)`

**Arguments:**
- `level` - The new player level. More accurate than UnitLevel at that time. (`string`)
- `hp` - Hit points gained. (`number`)
- `mp` - Mana points gained. (`number`)
- `talentPoints` - Talent points gained. (`number`)
- `strength` - Strength points gained. (`number`)
- `agility` - Agility points gained. (`number`)
- `stamina` - Stamina points gained. (`number`)
- `intellect` - Intellect points gained. (`number`)
- `spirit` - Spirit points gained. (`number`)


## PLAYER_LOGIN

Fires immediately before `PLAYER_ENTERING_WORLD` on login and UI reload. But unlike `PLAYER_ENTERING_WORLD`, this event ONLY fires for login/reload.

**Payload:** `()`


## PLAYER_LOGOUT

Fires immediately before the player is logged out of the game. Unlike `PLAYER_LEAVING_WORLD`, this event only fires upon logout and not when moving to different areas.

**Payload:** `()`


## PLAYER_LOSES_VEHICLE_DATA

Fires when the player loses vehicle-related attributes without necessarily having been in a vehicle. This can occur when the player uses a multi-passenger mount -- like all other mounts it is considered an extension of the player rather than a separate vehicle unit, but it has vehicle-related attributes such as a seat diagram and passenger controls for exiting.

**Payload:** `()`


## PLAYER_MONEY


## PLAYER_PVP_KILLS_CHANGED

Fires whenever a player's number of Honorable Kills changes

**Payload:** `()`


## PLAYER_PVP_RANK_CHANGED

Fires when the player's PvP rank changes. Related to the old PvP rewards system from before WoW Patch 2.0; no longer used.

**Payload:** `()`


## PLAYER_QUITING

Fires when the player attempts to exit WoW while not in a major city, inn, or other "resting" area

**Payload:** `()`


## PLAYER_REGEN_DISABLED

Fires when the player enters combat status. When in combat, normal health and mana regeneration is disabled.

**Payload:** `()`


## PLAYER_REGEN_ENABLED

Fires when the player leaves combat status. When in combat, normal health and mana regeneration is disabled.

**Payload:** `()`


## PLAYER_ROLES_ASSIGNED


## PLAYER_SKINNED

Fires when another character takes the insignia from the player's corpse in a battleground or world PvP zone. The player can no longer resurrect by returning to his or her corpse once it has been looted.

**Payload:** `()`


## PLAYER_TALENT_UPDATE

Fires when the player gains or spends talent points

**Payload:** `()`


## PLAYER_TARGET_CHANGED

Fires when the player changes targets

**Payload:** `()`


## PLAYER_TOTEM_UPDATE

Fires when information about the player's placed totems changes or becomes available. Also used for ghouls summoned by a Death Knight's Raise Dead ability (if the ghoul is not made a controllable pet by the Master of Ghouls talent).

**Payload:** `()`


## PLAYER_TRADE_MONEY

Fires when the amount of money offered for trade by the player changes

**Payload:** `()`


## PLAYER_UNGHOST

Fires when a player resurrects after being in spirit form

**Payload:** `()`


## PLAYER_UPDATE_RESTING

Fires when the player enters or leaves a major city, inn or other "resting" area

**Payload:** `()`


## PLAYER_XP_UPDATE


## PLAYERBANKBAGSLOTS_CHANGED

Fires when the number of bank bag slots purchased by the player changes

**Payload:** `()`


## PLAYERBANKSLOTS_CHANGED

Fires when the contents of a bank slot or bank bag slot are changed

**Payload:** `(slotID)`

**Arguments:**
- `slotID` - The slot id that changes. 1-28 is the bank slots. 29-35 are the bank bags. (`number`)


## PLAYTIME_CHANGED

Fires when changes to the player's limited play time status take effect. Only used in locales where the length of play sessions is restricted (e.g. mainland China).

**Payload:** `()`


## PREVIEW_PET_TALENT_POINTS_CHANGED

Fires when pet talent points are spent or unspent in preview mode

**Payload:** `()`


## PREVIEW_TALENT_POINTS_CHANGED

Fires when the player spends or unspends talent points in preview mode

**Payload:** `()`


## PVPQUEUE_ANYWHERE_SHOW

Fires when the player begins interacting with the UI feature allowing battleground queueing from any location

**Payload:** `()`


## PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE

Fires when information for the any-battleground queueing UI changes or becomes available

**Payload:** `()`

