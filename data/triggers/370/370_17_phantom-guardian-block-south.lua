-- Trigger: phantom-guardian-block-south
-- Zone: 370, ID: 17
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #37017

-- Converted from DG Script #37017: phantom-guardian-block-south
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
actor:send("The phantom turns into a wall and blocks your way!")
self.room:send_except(actor, "Suddenly, the phantom guardian takes the shape of a wall, blocking passage.")