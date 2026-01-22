-- Trigger: dog_rand1
-- Zone: 61, ID: 13
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6113

-- Converted from DG Script #6113: dog_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:command("bark")
self:emote("starts licking itself.")