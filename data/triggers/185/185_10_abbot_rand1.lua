-- Trigger: abbot_rand1
-- Zone: 185, ID: 10
-- Type: MOB, Flags: RANDOM
--
-- 10% chance: Abbot rips up a blackmail letter about his prior, Berack.
if not percent_chance(10) then
    return true
end
self:command("fume")
self:say("Not another blackmail note about my prior.")
self:emote("rips up a letter into tiny pieces.")
self:command("stomp")