-- Trigger: women-only
-- Zone: 103, ID: 7
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #10307

-- Converted from DG Script #10307: women-only
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    if actor.gender == "male" then
        actor:send("That room is for women only!")
        _return_value = false
    end
end
return _return_value