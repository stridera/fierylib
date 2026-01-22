-- Trigger: stop_east_58
-- Zone: 590, ID: 17
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59017

-- Converted from DG Script #59017: stop_east_58
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open
if not (cmd == "open") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.class == "Paladin" then
    _return_value = false
else
    -- switch on arg
    if arg == "door" or arg == "door e" or arg == "door ea" or arg == "door eas" or arg == "door east" then
        self.room:send_except(actor, tostring(self.name) .. " slaps " .. tostring(actor.name) .. "'s hand away from the door.")
        actor:send(tostring(self.name) .. " slaps your hand away from the door.")
    else
        actor:send("There doesn't seem to be an " .. tostring(arg) .. " here.")
    end
end
return _return_value