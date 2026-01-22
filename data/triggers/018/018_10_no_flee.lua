-- Trigger: no_flee
-- Zone: 18, ID: 10
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1810

-- Converted from DG Script #1810: no_flee
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: flee
if not (cmd == "flee") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
self.room:send_except(actor, tostring(actor.name) .. " panics, but cannot flee the void!")
actor:send("You PANIC as you cannot flee the void!")
_return_value = true
return _return_value