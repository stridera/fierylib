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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if (self.room.zone_id == 30 and self.room.local_id == 62) then
    -- switch on arg
    do
        local _sw1 = string.lower(tostring(arg or ""))
        if _sw1 == "d" or _sw1 == "do" or _sw1 == "doo" or _sw1 == "door" then
            actor:send("You begin to pick the lock when " .. tostring(self.name) .. " interrupts you.")
            self.room:send(tostring(self.name) .. " says, 'Hey!  You there!  What are you doing?!'")
            self.room:send_except(actor, tostring(self.name) .. " shoves " .. tostring(actor.name) .. " away from the door.")
            actor:send(tostring(self.name) .. " shoves you away from the door.")
        else
            _return_value = true
        end
    end
else
    _return_value = true
end
return _return_value