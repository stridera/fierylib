-- Trigger: pippin_corner
-- Zone: 43, ID: 45
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4345

-- Converted from DG Script #4345: pippin_corner
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("looks out into the horizon.")
wait(1)
self:say("Gotta find my corner of the sky...")