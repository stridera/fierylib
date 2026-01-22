-- Trigger: Demon_block
-- Zone: 125, ID: 16
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12516

-- Converted from DG Script #12516: Demon_block
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: open door
if not (cmd == "open" or cmd == "door") then
    return true  -- Not our command
end
actor.name:send("The demon stands before the door, guarding it.")
self.room:send_except(actor.name, "The demon guards the door, preventing " .. tostring(actor.name) .. " from opening it.")