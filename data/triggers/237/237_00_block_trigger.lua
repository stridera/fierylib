-- Trigger: Block_trigger
-- Zone: 237, ID: 0
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23700

-- Converted from DG Script #23700: Block_trigger
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: north
if not (cmd == "north") then
    return true  -- Not our command
end
actor.name:send("The guard smacks you in the head and says, 'No'.")
self.room:send_except(actor.name, "The guard smacks " .. tostring(actor.name) .. " in the head, and says 'No'.")