-- Trigger: crowley_rand1
-- Zone: 490, ID: 19
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #49019

-- Converted from DG Script #49019: crowley_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("shakes his empty watersack.")
self:emote("mutters something about topping up the whisky.")
self:say("I must have left the bottle at home...")