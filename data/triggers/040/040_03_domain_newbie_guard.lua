-- Trigger: Domain_Newbie_Guard
-- Zone: 40, ID: 3
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4003

-- Converted from DG Script #4003: Domain_Newbie_Guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 30 then
        self:whisper(actor.name, "Greetings young one, thou art brave but not strong enough to stride forth into these depths.")
        wait(1)
        self:whisper(actor.name, "Move towards the blackened sands to find battle for now.")
        self:command("wink " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value