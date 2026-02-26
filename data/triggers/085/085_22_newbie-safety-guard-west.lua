-- Trigger: newbie-safety-guard-west
-- Zone: 85, ID: 22
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #8522

-- Converted from DG Script #8522: newbie-safety-guard-west
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.is_player then
    if actor.level < 30 then
        _return_value = false
        self:whisper(actor.name, "Beyond this point is out of your grasp.")
        self:whisper(actor.name, "I suggest other places.")
        wait(1)
        self:command("bow " .. tostring(actor.name))
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value