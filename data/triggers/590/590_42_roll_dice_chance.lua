-- Trigger: roll_dice_chance
-- Zone: 590, ID: 42
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59042

-- Converted from DG Script #59042: roll_dice_chance
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: roll
if not (cmd == "roll") then
    return true  -- Not our command
end
self:say("My trigger commandlist is not complete!")