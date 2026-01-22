-- Trigger: Druid is prevented from going up
-- Zone: 120, ID: 5
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12005

-- Converted from DG Script #12005: Druid is prevented from going up
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == 12018 then
    _return_value = false
end
return _return_value