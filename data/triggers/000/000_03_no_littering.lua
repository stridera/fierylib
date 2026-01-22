-- Trigger: no littering
-- Zone: 0, ID: 3
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #3

-- Converted from DG Script #3: no littering
-- Original: WORLD trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
actor:send("You cannot litter here!")
_return_value = false
return _return_value