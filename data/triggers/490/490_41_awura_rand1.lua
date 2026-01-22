-- Trigger: awura_rand1
-- Zone: 490, ID: 41
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #49041

-- Converted from DG Script #49041: awura_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("mutters to herself about the state of the trees these days.")
self:say("Must go and talk to Earle about this.")