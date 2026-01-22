-- Trigger: Rhodes_frog
-- Zone: 365, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36500

-- Converted from DG Script #36500: Rhodes_frog
-- Original: MOB trigger, flags: GREET, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:emote("ribbits.")