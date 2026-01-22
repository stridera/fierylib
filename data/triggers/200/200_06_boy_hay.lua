-- Trigger: boy_hay
-- Zone: 200, ID: 6
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #20006

-- Converted from DG Script #20006: boy_hay
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("forks hay into a stall.")
self:command("sigh")