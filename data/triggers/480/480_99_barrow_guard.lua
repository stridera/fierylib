-- Trigger: Barrow guard
-- Zone: 480, ID: 99
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48099

-- Converted from DG Script #48099: Barrow guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 60 then
        self:whisper(actor.name, "This barrow is far too dangerous without more experience.")
        self:whisper(actor.name, "Very few who venture further have ever returned.")
        wait(1)
        self:whisper(actor.name, "Come back when you're ready for imminent danger.")
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value