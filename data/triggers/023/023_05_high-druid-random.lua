-- Trigger: high-druid-random
-- Zone: 23, ID: 5
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #2305

-- Converted from DG Script #2305: high-druid-random
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("sigh")
wait(2)
self:say("If only the blessings hadn't been lost...")