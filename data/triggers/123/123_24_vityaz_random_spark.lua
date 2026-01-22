-- Trigger: vityaz_random_spark
-- Zone: 123, ID: 24
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12324

-- Converted from DG Script #12324: vityaz_random_spark
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
self:say("hi")