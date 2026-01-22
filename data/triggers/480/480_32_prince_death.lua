-- Trigger: Prince death
-- Zone: 480, ID: 32
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48032

-- Converted from DG Script #48032: Prince death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if drop_head then
    self.room:spawn_object(480, 25)
end