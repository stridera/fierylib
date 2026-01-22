-- Trigger: bittern_rand_attack
-- Zone: 464, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #46403

-- Converted from DG Script #46403: bittern_rand_attack
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
-- Random chance to attack!
local rnd = room.actors[random(1, #room.actors)]
if rnd.id == -1 then
    if rnd.level < 100 then
        wait(1)
        self.room:send_except(rnd, tostring(self.name) .. " flies into a rage!")
        rnd:send(tostring(self.name) .. " flies into a rage and attacks you!")
        combat.engage(self, rnd.name)
    end
end