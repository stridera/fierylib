-- Trigger: Dragon Guards Chest
-- Zone: 125, ID: 9
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12509

-- Converted from DG Script #12509: Dragon Guards Chest
-- Original: MOB trigger, flags: COMMAND, probability: 0%

-- Command filter: open chest
if not (cmd == "open" or cmd == "chest") then
    return true  -- Not our command
end
actor:send("As you reach towards the chest, " .. tostring(self.name) .. " swipes at you, forestalling the attempt!")
self.room:send_except(actor, tostring(self.name) .. " guards the chest as " .. tostring(actor.name) .. " approaches it.")