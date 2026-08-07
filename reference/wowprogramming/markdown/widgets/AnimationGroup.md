# Widget: AnimationGroup

---

## AnimationGroup

_No snapshot available for widget overview._

### Methods

### AnimationGroup:CreateAnimation

Creates an Animation as a child of this group

**Signature:** `animation = AnimationGroup:CreateAnimation("animationType" [, "name" [, "inheritsFrom"]])`

**Arguments:**
- `animationType` - Type of `Animation` object to be created (see widgets hierarchy for available subtypes) (`string`)
- `name` - Global name to use for the new animation (`string`)
- `inheritsFrom` - A template from which to inherit (`string`)

**Returns:**
- `animation` - The newly created animation (`animation`)

### AnimationGroup:Finish

Causes animations within the group to complete and stop. If the group is playing, animations will continue until the current loop cycle is complete before stopping. For example, in a group which manages a repeating fade-out-fade-in animation, the associated object will continue to fade completely back in, instead of the animation stopping and the object instantly switching from partial opacity to full opacity instantly. Does nothing if this group is not playing.

To instantly stop an animation, see `AnimationGroup:Stop()`.

**Signature:** `AnimationGroup:Finish()`

### AnimationGroup:GetAnimations

Returns a list of animations belonging to the group

**Signature:** `... = AnimationGroup:GetAnimations()`

**Returns:**
- `...` - A list of `Animation` objects belonging to the animation group (`list`)

### AnimationGroup:GetDuration

Returns the duration of a single loop cycle for the group, as determined by its child animations. Total duration is based on the durations, delays, and order of child animations; see example for details.

**Signature:** `duration = AnimationGroup:GetDuration()`

**Returns:**
- `duration` - Total duration of all child animations (in seconds) (`number`)

### AnimationGroup:GetInitialOffset

Returns the starting static translation for the animated region

**Signature:** `x, y = AnimationGroup:GetInitialOffset()`

**Returns:**
- `x` - Horizontal distance to offset the animated region (in pixels) (`number`)
- `y` - Vertical distance to offset the animated region (in pixels) (`number`)

### AnimationGroup:GetLooping

Returns the looping behavior of the group

**Signature:** `loopType = AnimationGroup:GetLooping()`

**Returns:**
- `loopType` - Looping type for the animation group (`string`) 

 - `BOUNCE` - Repeatedly animates forward from the initial state to the final state then backwards to the initial state
- `NONE` - No looping; animates from the initial state to the final state once and stops
- `REPEAT` - Repeatedly animates forward from the initial state to the final state (instantly resetting from the final state to the initial state between repetitions)

### AnimationGroup:GetLoopState

Returns the current loop state of the group

**Signature:** `loopState = AnimationGroup:GetLoopState()`

**Returns:**
- `loopState` - Loop state of the animation group (`string`) 

 - `FORWARD` - In transition from the start state to the final state
- `NONE` - Not looping
- `REVERSE` - In transition from the final state back to the start state

### AnimationGroup:GetMaxOrder

Returns the highest order amongst the animations in the group

**Signature:** `maxOrder = AnimationGroup:GetMaxOrder()`

**Returns:**
- `maxOrder` - Highest ordering value (see `Animation:GetOrder()`) of the animations in the group (`number`)

### AnimationGroup:GetProgress

Returns the current state of the animation group's progress

**Signature:** `progress = AnimationGroup:GetProgress()`

**Returns:**
- `progress` - Value indicating the current state of the group animation: between 0.0 (initial state, child animations not yet started) and 1.0 (final state, all child animations complete) (`number`)

### AnimationGroup:IsDone

Returns whether the group has finished playing. Only valid in the `OnFinished` and `OnUpdate` handlers, and only applies if the animation group does not loop.

**Signature:** `done = AnimationGroup:IsDone()`

**Returns:**
- `done` - True if the group has finished playing; false otherwise (`boolean`)

### AnimationGroup:IsPaused

Returns whether the group is paused

**Signature:** `paused = AnimationGroup:IsPaused()`

**Returns:**
- `paused` - True if animation of the group is currently paused; false otherwise (`boolean`)

### AnimationGroup:IsPendingFinish

Returns whether or not the animation group is pending finish

**Signature:** `isPending = AnimationGroup:IsPendingFinish()`

**Returns:**
- `isPending` - Whether or not the animation group is currently pending a finish command. Since the `Finish()` method does not immediately stop the animation group, this method can be used to test if `Finish()` has been called and the group will finish at the end of the current loop. (`boolean`)

### AnimationGroup:IsPlaying

Returns whether the group is playing

**Signature:** `playing = AnimationGroup:IsPlaying()`

**Returns:**
- `playing` - True if the group is currently animating; false otherwise (`boolean`)

### AnimationGroup:Pause

Pauses animation of the group. Unlike with `AnimationGroup:Stop()`, the animation is paused at its current progress state (e.g. in a fade-out-fade-in animation, the element will be at partial opacity) instead of reset to the initial state; animation can be resumed with `AnimationGroup:Play()`.

**Signature:** `AnimationGroup:Pause()`

### AnimationGroup:Play

Starts animating the group. If the group has been paused, animation resumes from the paused state; otherwise animation begins at the initial state.

**Signature:** `AnimationGroup:Play()`

### AnimationGroup:SetInitialOffset

Sets a static translation for the animated region. This translation is only used while the animation is playing.

For example, applying an initial offset of `0,-50` to an animation group which fades the PlayerPortrait in and out would cause the portrait image to jump down 50 pixels from its normal position when the animation begins playing, and return to its initial position when the animation is finished or stopped.

**Signature:** `AnimationGroup:SetInitialOffset(x, y)`

**Arguments:**
- `x` - Horizontal distance to offset the animated region (in pixels) (`number`)
- `y` - Vertical distance to offset the animated region (in pixels) (`number`)

### AnimationGroup:SetLooping

Sets the looping behavior of the group

**Signature:** `AnimationGroup:SetLooping("loopType")`

**Arguments:**
- `loopType` - Looping type for the animation group (`string`) 

 - `BOUNCE` - Repeatedly animates forward from the initial state to the final state then backwards to the initial state
- `NONE` - No looping; animates from the initial state to the final state once and stops
- `REPEAT` - Repeatedly animates forward from the initial state to the final state (instantly resetting from the final state to the initial state between repetitions)

### AnimationGroup:Stop

Stops animation of the group. Unlike with `AnimationGroup:Pause()`, the animation is reset to the initial state (e.g. in a fade-out-fade-in animation, the element will be instantly returned to full opacity) instead of paused at its current progress state.

**Signature:** `AnimationGroup:Stop()`

