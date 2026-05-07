-- Trigger: phoenix_croaked
-- Zone: 510, ID: 13
-- Type: MOB, Flags: DEATH
--
-- Original DG Script: #51013
-- When the phoenix dies, suppresses the normal corpse drop in favor
-- of a flame-burst echo, drops the phoenix-heart object (510, 28),
-- and penalizes the killer 28,000 XP.
self.room:send("The phoenix closes its eyes and bursts into flame!")
self.room:spawn_object(510, 28)
actor:award_exp(-28000)
return false
