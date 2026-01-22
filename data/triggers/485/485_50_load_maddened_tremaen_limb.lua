-- Trigger: load maddened tremaen limb
-- Zone: 485, ID: 50
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48550

-- Converted from DG Script #48550: load maddened tremaen limb
-- Original: MOB trigger, flags: DEATH, probability: 100%
local chance = random(1, 10)
if (chance > 6) and (world.count_objects("48417") < 2) then
    self.room:spawn_object(484, 17)
end