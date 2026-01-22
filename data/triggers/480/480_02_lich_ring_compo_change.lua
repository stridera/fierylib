-- Trigger: lich_ring_compo_change
-- Zone: 480, ID: 2
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #48002

-- Converted from DG Script #48002: lich_ring_compo_change
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
actor:send("As you slide " .. tostring(self.shortdesc) .. " on your finger, your flesh starts to die and slump off.")
actor:send("You transform into a skeleton!")