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
-- RANDOM triggers have no actor; pick a random player from the room
local actors = self.room.actors
if #actors > 0 then
    local target = actors[random(1, #actors)]
    self:command("smirk " .. tostring(target.name))
    self:say("Perhaps you are not worthy.")
end
