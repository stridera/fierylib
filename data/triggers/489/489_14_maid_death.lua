-- Trigger: maid death
-- Zone: 489, ID: 14
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48914

-- Converted from DG Script #48914: maid death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self.room ~= 48980 then
    self:teleport(get_room(489, 80))
end
run_room_trigger(48915)