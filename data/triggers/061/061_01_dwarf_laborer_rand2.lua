-- Trigger: dwarf_laborer_rand2
-- Zone: 61, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6101

-- Converted from DG Script #6101: dwarf_laborer_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("glances at you for a second.")
self:command("chuckle")
self:say("Nope, not strong enough for the mines, need dwarven miners.")