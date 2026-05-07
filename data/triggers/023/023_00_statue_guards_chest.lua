-- Trigger: statue guards chest
-- Zone: 23, ID: 0
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2300
-- Statue blocks any attempt to unlock the oak chest.

-- Command filter: unlock
if cmd ~= "unlock" then
    return true  -- Not our command
end
if arg == "chest" or arg == "oak" then
    self.room:send_except(actor, tostring(self.name) .. " steps between " .. tostring(actor.name) .. " and the oak chest.")
    actor:send(tostring(self.name) .. " steps between you and the oak chest.")
    self:say("I am charged with the protection of this chest.")
    self:say("I cannot let you have its contents.")
    return false  -- Block the unlock
end
return true