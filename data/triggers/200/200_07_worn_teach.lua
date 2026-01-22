-- Trigger: worn_teach
-- Zone: 200, ID: 7
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #20007

-- Converted from DG Script #20007: worn_teach
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("cracks his whip.")
self:say("No no thats not how its done.")
wait(2)
self:say("Like this.")
self:emote("sneaks around the room.")