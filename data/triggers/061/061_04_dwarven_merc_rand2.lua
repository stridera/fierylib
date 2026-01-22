-- Trigger: dwarven_merc_rand2
-- Zone: 61, ID: 4
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6104

-- Converted from DG Script #6104: dwarven_merc_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("expounds loudly on the virtues of the battleaxe over the sword.")