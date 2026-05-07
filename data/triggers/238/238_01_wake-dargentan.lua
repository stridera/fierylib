-- Trigger: wake-dargentan
-- Zone: 238, ID: 1
-- Type: MOB, Flags: COMMAND
--
-- When a player tries to "wake" Dargentan, he mutters, complains, and glares.

-- Command filter: wake
if not (cmd == "wake") then
    return true  -- Not our command
end
self:command("mutter")
actor:send(tostring(self.name) .. " says, 'This had better be good!'")
self.room:send_except(actor, "The dragon glares balefully at " .. tostring(actor.name) .. ".")
