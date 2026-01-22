-- Trigger: The faint sound of trickling water
-- Zone: 615, ID: 6
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61506

-- Converted from DG Script #61506: The faint sound of trickling water
-- Original: WORLD trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self.room:send("You hear the faint sound of trickling water.")