-- Trigger: dagon_gets_healed
-- Zone: 490, ID: 5
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #49005

-- Converted from DG Script #49005: dagon_gets_healed
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:find_actor("dagon"):heal(2000)