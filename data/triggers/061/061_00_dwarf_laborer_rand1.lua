-- Trigger: dwarf_laborer_rand1
-- Zone: 61, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6100

-- Converted from DG Script #6100: dwarf_laborer_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:say("Ah, almost time to get back.")
self:say("I still haven't found anyone decent...")
self:emote("looks concerned.")
self:command("comfort worker")