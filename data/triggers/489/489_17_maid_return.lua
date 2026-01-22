-- Trigger: maid return
-- Zone: 489, ID: 17
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48917

-- Converted from DG Script #48917: maid return
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if self.room ~= 48980 then
    self:teleport(get_room(489, 80))
end