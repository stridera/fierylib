-- Trigger: keeper_stop
-- Zone: 590, ID: 19
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59019

-- Converted from DG Script #59019: keeper_stop
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on arg
do
    local _sw1 = string.lower(tostring(arg or ""))
    if _sw1 == "door" or _sw1 == "door e" or _sw1 == "door ea" or _sw1 == "door eas" or _sw1 == "door east" or _sw1 == "door s" or _sw1 == "door so" or _sw1 == "door sou" or _sw1 == "door sout" or _sw1 == "door south" then
        actor:send("You reach towards the door to open it.")
        self.room:send_except(actor, tostring(actor.name) .. " leans towards the door to try and open it.")
        wait(0.2)
        actor:send(tostring(self.name) .. " pushes you away from the door.")
        self.room:send_except(actor, tostring(self.name) .. " gives " .. tostring(actor.name) .. " a swift shove sending " .. tostring(actor.object) .. " away from the door.")
        _return_value = false  -- block the open
    else
        _return_value = true
    end
end
return _return_value