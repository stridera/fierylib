-- Trigger: dancer_quest_banter
-- Zone: 584, ID: 10
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #58410

-- Converted from DG Script #58410: dancer_quest_banter
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 13%

-- 13% chance to trigger
if not percent_chance(13) then
    return true
end
self:emote("sighs and returns to cleaning the wagon, barely noticed by the prince.")