-- Trigger: TowerZap
-- Zone: 125, ID: 33
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12533

-- Converted from DG Script #12533: TowerZap
-- Original: WORLD trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
local rnd = random(1, 10)
if rnd == 3 then
    self.room:send("A bolt of blue energy bursts from the tower, singing your arm! Ouch!")
else
    self.room:send("A bolt of blue energy eminates from the tower, striking a rock.")
    wait(3)
    self.room:send("Before your eyes, the rock is pulled against the tower.")
    wait(2)
    self.room:send("The rock is absorbed into the tower!")
    wait(4)
    self.room:send("Crackles of energy crawl up the side of the tower.")
end