-- Trigger: spider_rand
-- Zone: 530, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53001

-- Converted from DG Script #53001: spider_rand
-- Original: MOB trigger, flags: RANDOM, probability: 45%
-- Picks a random actor in the room and attacks them if they are a low-level player.

if not percent_chance(45) then
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