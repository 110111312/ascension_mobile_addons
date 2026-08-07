# WoW Events — E

_10 events_

---

## ENABLE_LOW_LEVEL_RAID


## ENABLE_TAXI_BENCHMARK

Fires when taxi benchmarking mode is enabled

**Payload:** `()`


## ENABLE_XP_GAIN

Fires when the player re-enabled experience point gain after disabling it

**Payload:** `()`


## END_BOUND_TRADEABLE

Fires when the player attempts an action which will make a looted Bind on Pickup item no longer tradeable. A Bind on Pickup item looted by the player can still be traded to other players (though only those who were eligible to loot it originally) for several minutes after looting, but certain actions can cancel this period early.

**Payload:** `()`


## END_REFUND

Fires when the player attempts an action which will make an item purchased with alternate currency no longer refundable. Certain items purchased with alternate currencies can be resold to the vendor for a full refund within a brief time after purchase, but performing certain actions may cancel this period early.

**Payload:** `()`


## EQUIP_BIND_CONFIRM

Fires when the player attempts to equip an item which will become soulbound in the process

**Payload:** `(slot)`

**Arguments:**
- `slot` - The slot you are equiping into. (`number`)


## EQUIPMENT_SETS_CHANGED

Fires when the player's list of equipment sets changes

**Payload:** `()`


## EQUIPMENT_SWAP_FINISHED

Fires when the process of switching equipment sets is complete. Many other events fire as the equipment swap takes place (each piece of equipment being equipped or placed into the character's bags, the character's combat attributes changing due to the new equipment, etc). An addon may not need to monitor each event that happens as part of this process, so it can unregister those events when `EQUIPMENT_SWAP_PENDING` fires and re-register for them when `EQUIPMENT_SWAP_FINISHED` fires.

**Payload:** `()`


## EQUIPMENT_SWAP_PENDING

Fires when the player begins to switch equipment sets. Many other events fire as the equipment swap takes place (each piece of equipment being equipped or placed into the character's bags, the character's combat attributes changing due to the new equipment, etc). An addon may not need to monitor each event that happens as part of this process, so it can unregister those events when `EQUIPMENT_SWAP_PENDING` fires and re-register for them when `EQUIPMENT_SWAP_FINISHED` fires.

**Payload:** `()`


## EXECUTE_CHAT_LINE

Fires when a chat message is encountered in a running macro

**Payload:** `()`

