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
local _return_value = true  -- Default: allow action
-- switch on arg
if arg == "door" or arg == "door e" or arg == "door ea" or arg == "door eas" or arg == "door east" or arg == "door s" or arg == "door so" or arg == "door sou" or arg == "door sout" or arg == "door south" then
    actor:send("You reach towards the door to open it.")
    self.room:send_except(actor, tostring(actor.name) .. " leans towards the door to try and open it.")
    wait(2)
    actor:send(tostring(self.name) .. " pushes you away from the door.")
    self.room:send_except(actor, tostring(self.name) .. " gives " .. tostring(actor.name) .. " a swift shove sending " .. tostring(actor.object) .. " away from the door.")
else
    _return_value = false
end
return _return_value