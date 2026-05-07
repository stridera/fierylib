-- Trigger: vityaz_random_spark
-- Zone: 123, ID: 24
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12324

-- Converted from DG Script #12324: vityaz_random_spark
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 0%
--
-- TODO(parity): the converted body is just `self:say("hi")` which doesn't
-- match the trigger name. The original DG Script likely had a sparks
-- wecho similar to the rndm == 2 branch in 123_25 (vityaz_random_move).
-- Recover the original wecho before relying on this trigger.

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
self:say("hi")