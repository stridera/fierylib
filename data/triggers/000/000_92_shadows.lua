-- Trigger: shadows
-- Zone: 0, ID: 92
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #92

-- Converted from DG Script #92: shadows
-- Original: WORLD trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self.room:send("Out of the corner of your eye you notice a strange shadow through the window.")