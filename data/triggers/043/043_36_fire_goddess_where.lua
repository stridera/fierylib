-- Trigger: fire_goddess_where
-- Zone: 43, ID: 36
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4336

-- Converted from DG Script #4336: fire_goddess_where
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("puts her hands on her hips and looks around, exasperated.")
wait(4)
self:say("Where is he?  We can't start the show without him.")