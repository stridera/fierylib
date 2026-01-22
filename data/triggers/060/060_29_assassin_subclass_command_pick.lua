-- Trigger: assassin_subclass_command_pick
-- Zone: 60, ID: 29
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6029

-- Converted from DG Script #6029: assassin_subclass_command_pick
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: pick
if not (cmd == "pick") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if self.room == 3062 then
    -- switch on arg
    if arg == "d" or arg == "do" or arg == "doo" or arg == "door" then
        actor:send("You begin to pick the lock when " .. tostring(self.name) .. " interrupts you.")
        self.room:send(tostring(self.name) .. " says, 'Hey!  You there!  What are you doing?!'")
        self.room:send_except(actor, tostring(self.name) .. " shoves " .. tostring(actor.name) .. " away from the door.")
        actor:send(tostring(self.name) .. " shoves you away from the door.")
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value