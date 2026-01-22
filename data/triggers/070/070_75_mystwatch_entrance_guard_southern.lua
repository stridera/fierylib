-- Trigger: Mystwatch Entrance Guard (southern)
-- Zone: 70, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #7075

-- Converted from DG Script #7075: Mystwatch Entrance Guard (southern)
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: north
if not (cmd == "north") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 30 then
        self:whisper(actor.name, "Young adventurer, you are far too small to venture north of here.")
        wait(1)
        self:whisper(actor.name, "Try a safer location to pick battles for now.")
        self:command("smile " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value