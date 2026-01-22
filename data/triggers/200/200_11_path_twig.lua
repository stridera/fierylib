-- Trigger: path_twig
-- Zone: 200, ID: 11
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #20011

-- Converted from DG Script #20011: path_twig
-- Original: WORLD trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self.room:send("A twig snaps somewhere close by.")