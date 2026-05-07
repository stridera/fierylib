-- Trigger: fire ant mandible drop
-- Zone: 80, ID: 30
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8030
-- On death: 5% chance to drop a fire ant mandible (object 80/50).

if random(1, 20) == 20 then
    self.room:spawn_object(80, 50)
end