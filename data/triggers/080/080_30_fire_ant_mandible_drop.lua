-- Trigger: fire ant mandible drop
-- Zone: 80, ID: 30
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8030

-- Converted from DG Script #8030: fire ant mandible drop
-- Original: MOB trigger, flags: DEATH, probability: 100%
if random(1, 20) == 20 then
    self.room:spawn_object(80, 50)
end