-- Trigger: statue guards chest
-- Zone: 23, ID: 0
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2300

-- Converted from DG Script #2300: statue guards chest
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: unlock
if not (cmd == "unlock") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if (arg == "chest") or (arg == "oak") then
    _return_value = true
    self.room:send_except(actor, tostring(self.name) .. " steps between " .. tostring(actor.name) .. " and the oak chest.")
    actor:send(tostring(self.name) .. " steps between you and the oak chest.")
    self:say("I am charged with the protection of this chest.")
    self:say("I cannot let you have its contents.")
else
    _return_value = false
end
return _return_value