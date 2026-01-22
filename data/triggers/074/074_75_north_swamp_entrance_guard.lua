-- Trigger: North Swamp Entrance Guard
-- Zone: 74, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #7475

-- Converted from DG Script #7475: North Swamp Entrance Guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 20 then
        _return_value = true
        self:whisper(actor.name, "My, my, young adventurer, you are ambitious.")
        self:whisper(actor.name, "It is just a bit too dangerous for you to head further east.")
        wait(1)
        self:whisper(actor.name, "It is safer to head back the other way.")
        self:command("bow " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value