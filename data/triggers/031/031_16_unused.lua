-- Trigger: UNUSED
-- Zone: 31, ID: 16
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #3116

-- Converted from DG Script #3116: UNUSED
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
if (actor:get_worn("1") == -1) and (%actor.worn[2] == -1) then
    _return_value = true
else
    _return_value = false
    actor:send("You need two fingers free to wear this.")
end
return _return_value