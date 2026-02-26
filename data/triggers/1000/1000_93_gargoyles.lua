-- Trigger: gargoyles
-- Zone: 0, ID: 93
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #93

-- Converted from DG Script #93: gargoyles
-- Original: WORLD trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self.room:send("High above a gargoyle is perched, ready to pounce!")