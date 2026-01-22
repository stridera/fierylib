-- Trigger: GY_newbie_guard
-- Zone: 470, ID: 75
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #47075

-- Converted from DG Script #47075: GY_newbie_guard
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.level < 30 then
        _return_value = true
        actor:send(tostring(self.name) .. " places a hand in front of you.")
        self.room:send_except(actor, tostring(self.name) .. " places a hand up in front of " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "Hold on there!  South of here is terribly dangerous for someone of your skill.")
        wait(1)
        self:whisper(actor.name, "I suggest adventuring elsewhere for now.")
        self:command("bow " .. tostring(actor.name))
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value