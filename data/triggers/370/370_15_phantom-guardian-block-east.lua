-- Trigger: phantom-guardian-block-east
-- Zone: 370, ID: 15
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #37015

-- Converted from DG Script #37015: phantom-guardian-block-east
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
actor:send("The phantom turns into a wall and blocks your way!")
self.room:send_except(actor, "Suddenly, the phantom guardian takes the shape of a wall, blocking passage.")