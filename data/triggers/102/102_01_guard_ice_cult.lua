-- Trigger: Guard Ice Cult
-- Zone: 102, ID: 1
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #10201

-- Converted from DG Script #10201: Guard Ice Cult
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 40 then
        self:whisper(actor.name, "You are much too weak to venture through this tunnel.")
        wait(1)
        self:whisper(actor.name, "Try other areas first.")
        self:command("nudge " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value