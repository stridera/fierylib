-- Trigger: SwordDeath
-- Zone: 125, ID: 30
-- Type: MOB, Flags: DEATH, HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #12530

-- Converted from DG Script #12530: SwordDeath
-- Original: MOB trigger, flags: DEATH, HIT_PERCENT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
local _return_value = true  -- Default: allow action
run_room_trigger(12531)
_return_value = false
self:teleport(get_room(125, 94))
return _return_value