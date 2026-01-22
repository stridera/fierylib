-- Trigger: wall_ice_mobs_death
-- Zone: 533, ID: 11
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
-- Fixed: Changed ice to use self:get_var("ice") for mob variable
--
-- Original DG Script: #53311

-- Converted from DG Script #53311: wall_ice_mobs_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self:get_var("ice") == 1 then
    self.room:spawn_object(533, 27)
end