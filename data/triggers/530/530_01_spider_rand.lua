-- Trigger: spider_rand
-- Zone: 530, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53001

-- Converted from DG Script #53001: spider_rand
-- Original: MOB trigger, flags: RANDOM, probability: 45%

-- 45% chance to trigger
if not percent_chance(45) then
    return true
end
-- At a random chance attack a player in the room
local rnd = room.actors[random(1, #room.actors)]
if rnd.level < 100 then
    if rnd.id == -1 then
        combat.engage(self, rnd.name)
    end
end