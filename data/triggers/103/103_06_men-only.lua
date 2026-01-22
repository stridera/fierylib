-- Trigger: men-only
-- Zone: 103, ID: 6
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #10306

-- Converted from DG Script #10306: men-only
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    if actor.gender == "female" then
        actor:send("That room is for men only!")
        _return_value = false
    end
end
return _return_value