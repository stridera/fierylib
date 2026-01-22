-- Trigger: titan death
-- Zone: 486, ID: 38
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48638

-- Converted from DG Script #48638: titan death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if self:has_equipped("48424") then
    -- get rid of the staff sphere and load the key one
    self:destroy_item("timuns-golden-sphere")
    self.room:spawn_object(484, 22)
end