-- Trigger: MIelikki South Guard
-- Zone: 30, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3075

-- Converted from DG Script #3075: MIelikki South Guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 30 then
        self:whisper(actor.name, "You are much too little to venture south of here.")
        wait(1)
        self:whisper(actor.name, "Try other areas first.")
        self:command("nudge " .. tostring(actor.name))
        self:emote("points at the sign.")
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value