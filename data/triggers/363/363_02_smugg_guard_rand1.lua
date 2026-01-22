-- Trigger: Smugg_guard_rand1
-- Zone: 363, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #36302

-- Converted from DG Script #36302: Smugg_guard_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:say("How am I ever gonna spend my wages stuck in this hole.")
self:command("sigh")
self:emote("looks dejected.")