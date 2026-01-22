-- Trigger: Malpinscher blocks western movement
-- Zone: 615, ID: 9
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61509

-- Converted from DG Script #61509: Malpinscher blocks western movement
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
self.room:send_except(actor, tostring(self.name) .. " moves quickly to block " .. tostring(actor.name) .. ".")
actor:send(tostring(self.name) .. " quickly blocks your path!")