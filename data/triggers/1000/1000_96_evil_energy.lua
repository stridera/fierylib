-- Trigger: Evil energy
-- Zone: 0, ID: 96
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #96

-- Converted from DG Script #96: Evil energy
-- Original: WORLD trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self.room:send("The balcony crackles with evil energy!")