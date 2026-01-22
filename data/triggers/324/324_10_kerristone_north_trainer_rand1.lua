-- Trigger: Kerristone_north_trainer_rand1
-- Zone: 324, ID: 10
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #32410

-- Converted from DG Script #32410: Kerristone_north_trainer_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
self:say("</>I only deal in <b:yellow>gold</>!")
self:say("</>And No! I dont have change.</>")