-- Trigger: pirate_drummer_rand
-- Zone: 521, ID: 4
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #52104

-- Converted from DG Script #52104: pirate_drummer_rand
-- Original: MOB trigger, flags: RANDOM, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
self.room:send_to_adjacent("Drumming can be heard nearby.")