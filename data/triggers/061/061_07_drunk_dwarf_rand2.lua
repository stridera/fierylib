-- Trigger: drunk_dwarf_rand2
-- Zone: 61, ID: 7
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6107

-- Converted from DG Script #6107: drunk_dwarf_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:command("glare")
self:say("What are you looking at?")
self:emote("puts up his fists.")
self:say("Do you want some?  Do ya?")
self:command("fart")