-- Trigger: karla_me
-- Zone: 43, ID: 8
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4308

-- Converted from DG Script #4308: karla_me
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:say("Look at me look at me look at me now!")
wait(4)
self:emote("hits a pose!")
wait(2)
self:command("grin")