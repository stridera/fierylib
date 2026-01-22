-- Trigger: seer_rand3
-- Zone: 85, ID: 24
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #8524

-- Converted from DG Script #8524: seer_rand3
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
self:command("smirk " .. tostring(actor.name))
self:say("Perhaps you are not worthy.")