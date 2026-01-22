-- Trigger: dwarf_laborer_rand3
-- Zone: 61, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6102

-- Converted from DG Script #6102: dwarf_laborer_rand3
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("mutters to himself and looks at his watch.")
self:command("sigh")
self:say("So little time, and so much to do.")