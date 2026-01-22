-- Trigger: Spectre load
-- Zone: 502, ID: 12
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #50212

-- Converted from DG Script #50212: Spectre load
-- Original: MOB trigger, flags: LOAD, probability: 100%
self.room:spawn_object(502, 15)
self:command("wear all")