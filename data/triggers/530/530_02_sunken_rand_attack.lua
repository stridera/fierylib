-- Trigger: sunken_rand_attack
-- Zone: 530, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53002

-- Converted from DG Script #53002: sunken_rand_attack
-- Original: MOB trigger, flags: RANDOM, probability: 35%

-- 35% chance to trigger
if not percent_chance(35) then
    return true
end
-- At a random chance attack a player in the room
local rnd = room.actors[random(1, #room.actors)]
if rnd.level < 100 then
    if rnd.id == -1 then
        combat.engage(self, rnd.name)
    else
    end
else
end