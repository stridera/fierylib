-- Trigger: howls
-- Zone: 0, ID: 91
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #91

-- Converted from DG Script #91: howls
-- Original: WORLD trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self.room:send("You hear the screams of the tortured.")