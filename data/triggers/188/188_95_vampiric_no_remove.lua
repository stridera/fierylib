-- Trigger: vampiric_no_remove
-- Zone: 188, ID: 95
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #18895

-- Converted from DG Script #18895: vampiric_no_remove
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
local _return_value = true  -- Default: allow action
actor:send("The teeth have grown themselves into your jaws and won't budge!")
_return_value = false
return _return_value