-- Trigger: abbot_rand2
-- Zone: 185, ID: 12
-- Type: MOB, Flags: RANDOM
--
-- 10% chance: Abbot mutters about monastic life and sighs.
if not percent_chance(10) then
    return true
end
self:emote("mutters about the tribulations of monastic life.")
self:command("sigh")