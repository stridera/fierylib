-- Trigger: Ickle East Guard
-- Zone: 100, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #10075

-- Converted from DG Script #10075: Ickle East Guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.is_player then
    if actor.level < 20 then
        self:whisper(actor.name, "You are much too little to venture east of here.")
        wait(1)
        self:whisper(actor.name, "Try other areas first.")
        self:command("nudge " .. tostring(actor.name))
    else
        _return_value = true
    end
else
    _return_value = true
end
return _return_value