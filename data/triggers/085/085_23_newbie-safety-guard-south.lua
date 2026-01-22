-- Trigger: newbie-safety-guard-south
-- Zone: 85, ID: 23
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #8523

-- Converted from DG Script #8523: newbie-safety-guard-south
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 30 then
        _return_value = true
        self:whisper(actor.name, "Beyond this point is out of your grasp.")
        self:whisper(actor.name, "I suggest other places.")
        wait(1)
        self:command("bow " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value