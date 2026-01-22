-- Trigger: swan_unic_rand
-- Zone: 584, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #58403

-- Converted from DG Script #58403: swan_unic_rand
-- Original: MOB trigger, flags: RANDOM, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
self.room:send("The slave girl sniffs sadly.")