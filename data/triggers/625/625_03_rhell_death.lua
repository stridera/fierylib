-- Trigger: rhell death
-- Zone: 625, ID: 3
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #62503

-- Converted from DG Script #62503: rhell death
-- Original: MOB trigger, flags: DEATH, probability: 100%
if random(1, 10) < 4 then
    self.room:spawn_object(625, 2)
end