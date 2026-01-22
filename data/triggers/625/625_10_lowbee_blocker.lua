-- Trigger: lowbee blocker
-- Zone: 625, ID: 10
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #62510

-- Converted from DG Script #62510: lowbee blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 20 then
        _return_value = true
        self:whisper(actor.name, "You've wandered too far.")
        self:whisper(actor.name, "Try again in a few levels.")
        self:command("wink " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value