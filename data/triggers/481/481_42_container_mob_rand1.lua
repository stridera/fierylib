-- Trigger: container_mob_rand1
-- Zone: 481, ID: 42
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48142

-- Converted from DG Script #48142: container_mob_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 100%
self:command("give flag ai")
world.destroy(self.room:find_actor("container-mob"))