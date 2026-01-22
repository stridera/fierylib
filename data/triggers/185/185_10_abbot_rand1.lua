-- Trigger: abbot_rand1
-- Zone: 185, ID: 10
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #18510

-- Converted from DG Script #18510: abbot_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("fume")
self:say("Not another blackmail note about my prior.")
self:emote("rips up a letter into tiny pieces.")
self:command("stomp")