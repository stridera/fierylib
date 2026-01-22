-- Trigger: phantom-guardian-block-west
-- Zone: 370, ID: 16
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #37016

-- Converted from DG Script #37016: phantom-guardian-block-west
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
actor:send("The phantom turns into a wall and blocks your way!")
self.room:send_except(actor, "Suddenly, the phantom guardian takes the shape of a wall, blocking passage.")