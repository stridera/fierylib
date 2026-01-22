-- Trigger: baker_eat
-- Zone: 200, ID: 12
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #20012

-- Converted from DG Script #20012: baker_eat
-- Original: MOB trigger, flags: RANDOM, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
self:emote("looks all around the room.")
self:emote("opens the oven and gets a piece of bread out.")
self:emote("eats a dark loaf of bread hurridly.")
self:command("burp")