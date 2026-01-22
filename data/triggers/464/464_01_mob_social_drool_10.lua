-- Trigger: MOB_SOCIAL_DROOL_10
-- Zone: 464, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #46401

-- Converted from DG Script #46401: MOB_SOCIAL_DROOL_10
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("drool")