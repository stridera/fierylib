-- Trigger: drunk_socail_stunts3
-- Zone: 60, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6002

-- Converted from DG Script #6002: drunk_socail_stunts3
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:command("sing")
self:command("hiccup")
self:say("I used to be a big cheese round here you know.")
self:command("hiccup")