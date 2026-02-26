-- Trigger: tree branch
-- Zone: 0, ID: 95
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #95

-- Converted from DG Script #95: tree branch
-- Original: WORLD trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self.room:send("A tree branch makes a lunge for your head!")