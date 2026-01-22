-- Trigger: wake-dargentan
-- Zone: 238, ID: 1
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23801

-- Converted from DG Script #23801: wake-dargentan
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: wake
if not (cmd == "wake") then
    return true  -- Not our command
end
self:command("mutter")
actor.name:send(tostring(self.name) .. " says, 'This had better be good!'")
self.room:send_except(actor.name, "The dragon glares balefully at " .. tostring(actor.name) .. ".")