-- Trigger: Dire Wolf Death
-- Zone: 625, ID: 21
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #62521

-- Converted from DG Script #62521: Dire Wolf Death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if random(1, 10) > 5 then
    self.room:spawn_object(625, 13)
end