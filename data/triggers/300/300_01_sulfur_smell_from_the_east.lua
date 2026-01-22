-- Trigger: Sulfur smell from the east
-- Zone: 300, ID: 1
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #30001

-- Converted from DG Script #30001: Sulfur smell from the east
-- Original: WORLD trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
-- switch on random(1, 8)
if random(1, 8) == 1 then
    self.room:send("A breath of sulphur drifts in from the east.")
elseif random(1, 8) == 2 then
    self.room:send("Stinking fumes waft in from the ruined building east of here.")
elseif random(1, 8) == 3 then
    self.room:send("Smoke drifts in from the east, bringing with it the stink of rotten eggs.")
elseif random(1, 8) == 4 then
    self.room:send("A sulphurous odor fills your nose.")
elseif random(1, 8) == 5 then
    self.room:send("Yellowish vapors creep in from the wreckage to the east.")
elseif random(1, 8) == 6 then
    self.room:send("A repulsive smell from the east invades your nose.")
elseif random(1, 8) == 7 then
    self.room:send("Swirling currents of air carry the odor of sulphur.")
else
    self.room:send("An offensive smell appears to be emanating from the building to the east.")
end