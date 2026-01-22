-- Trigger: dancer_quest_banter2
-- Zone: 584, ID: 11
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #58411

-- Converted from DG Script #58411: dancer_quest_banter2
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("sweeps dirt from a corner.")
wait(4)
self:command("sigh")