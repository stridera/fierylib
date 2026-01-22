-- Trigger: StoneCultWhat
-- Zone: 125, ID: 32
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #12532

-- Converted from DG Script #12532: StoneCultWhat
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
local delay = rand(5)
wait(delay)
self:emote("bows before the statue.")
wait(2)
self:emote("chants, 'Bring her back to flesh, back to life.'")