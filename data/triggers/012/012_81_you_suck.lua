-- Trigger: you suck
-- Zone: 12, ID: 81
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1281

-- Converted from DG Script #1281: you suck
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: look fighter
if not (cmd == "look" or cmd == "fighter") then
    return true  -- Not our command
end
self:say("YOU SUCK!")