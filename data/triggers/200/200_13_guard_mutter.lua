-- Trigger: guard_mutter
-- Zone: 200, ID: 13
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #20013

-- Converted from DG Script #20013: guard_mutter
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("mutter")
self:say("She has to come this way to get out.")
self:command("peer")