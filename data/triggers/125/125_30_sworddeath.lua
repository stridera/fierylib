-- Trigger: SwordDeath
-- Zone: 125, ID: 30
-- Type: MOB, Flags: DEATH, HIT_PERCENT
-- Status: CLEAN
-- Num arg: 20
--
-- Original DG Script: #12530

-- Converted from DG Script #12530: SwordDeath
-- Original: MOB trigger, flags: DEATH, HIT_PERCENT, num_arg: 20 (HIT_PERCENT threshold; DEATH has no roll, not a probability)
local _return_value = true  -- Default: allow action
run_room_trigger(125, 31)
_return_value = true
self:teleport(get_room(125, 94))
return _return_value