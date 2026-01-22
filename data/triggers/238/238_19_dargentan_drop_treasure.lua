-- Trigger: dargentan_drop_treasure
-- Zone: 238, ID: 19
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #23819

-- Converted from DG Script #23819: dargentan_drop_treasure
-- Original: MOB trigger, flags: DEATH, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
run_room_trigger(23820)
return _return_value