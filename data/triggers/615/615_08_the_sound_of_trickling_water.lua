-- Trigger: The sound of trickling water
-- Zone: 615, ID: 8
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61508

-- Converted from DG Script #61508: The sound of trickling water
-- Original: WORLD trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self.room:send("You hear the distinct sound of trickling water.")