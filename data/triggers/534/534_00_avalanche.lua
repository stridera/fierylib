-- Trigger: avalanche
-- Zone: 534, ID: 0
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53400

-- Converted from DG Script #53400: avalanche
-- Original: WORLD trigger, flags: RANDOM, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
if actor.id == -1 then
    self.room:send("You notice some larger clumps of snow slipping onto you.")
    wait(2)
    self.room:send("AVALANCHE!!! Run for your lives!")
    wait(1)
    self.room:teleport_all(get_room(535, 67))
end