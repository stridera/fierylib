-- Trigger: Smugg_chief_rand1
-- Zone: 363, ID: 5
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #36305

-- Converted from DG Script #36305: Smugg_chief_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("glare")
self:say("Something's wrong here, but I just can't put my finger on it.")
self:command("stomp")