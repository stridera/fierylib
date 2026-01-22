-- Trigger: to_small_wield
-- Zone: 87, ID: 51
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #8751

-- Converted from DG Script #8751: to_small_wield
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if actor.size == "tiny" or actor.size == "small" or actor.size == "medium" then
    actor:send("It's too big for you!")
    _return_value = false
else
    _return_value = true
end
return _return_value