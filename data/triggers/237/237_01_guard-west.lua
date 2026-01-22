-- Trigger: guard-west
-- Zone: 237, ID: 1
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23701

-- Converted from DG Script #23701: guard-west
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
actor:send("The guard roars at you!")
self.room:send_except(actor, "The guard roars at " .. tostring(actor.name) .. " and blocks the way.")