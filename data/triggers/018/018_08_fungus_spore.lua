-- Trigger: fungus_spore
-- Zone: 18, ID: 8
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1808

-- Converted from DG Script #1808: fungus_spore
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("releases a cloud of spores.")