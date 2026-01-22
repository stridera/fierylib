-- Trigger: drunk_death_bottle_break
-- Zone: 60, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #6001

-- Converted from DG Script #6001: drunk_death_bottle_break
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("The bottle of whisky slips from " .. tostring(self.name) .. "'s hand and shatters as it hits the ground!")
self:destroy_item("all.drunkdrink")