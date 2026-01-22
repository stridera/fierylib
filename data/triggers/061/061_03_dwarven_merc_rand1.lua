-- Trigger: dwarven_merc_rand1
-- Zone: 61, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6103

-- Converted from DG Script #6103: dwarven_merc_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:emote("mutters to himself.")
self:say("That stupid Ruborg, saying I wasn't even in the wars.")
self:say("If I see him...")
self:command("grin")
self:say("Well, he won't like it.")