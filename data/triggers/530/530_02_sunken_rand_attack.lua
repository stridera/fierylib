-- Trigger: sunken_rand_attack
-- Zone: 530, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53002

-- Converted from DG Script #53002: sunken_rand_attack
-- Original: MOB trigger, flags: RANDOM, probability: 35%
-- Picks a random actor in the room and attacks them if they are a low-level player.

if not percent_chance(35) then
    return true
end
local actors = self.room.actors
if #actors == 0 then
    return true
end
local rnd = actors[random(1, #actors)]
if rnd.is_player and rnd.level < 100 then
    combat.engage(rnd)
end