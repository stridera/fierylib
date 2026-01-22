-- Trigger: rana_rand1
-- Zone: 510, ID: 19
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #51019

-- Converted from DG Script #51019: rana_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:command("sigh")
self:say("I should have known it was all too good to be true.  I should have listened to Shema.")
self:command("whap me")