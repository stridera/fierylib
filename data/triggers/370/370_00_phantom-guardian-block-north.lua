-- Trigger: phantom-guardian-block-north
-- Zone: 370, ID: 0
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #37000

-- Converted from DG Script #37000: phantom-guardian-block-north
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: north
if not (cmd == "north") then
    return true  -- Not our command
end
actor:send("The phantom turns into a wall and blocks your way!")
self.room:send_except(actor, "Suddenly, the phantom guardian takes the shape of a wall, blocking passage.")