-- Trigger: Nukreth Spire tracker load kill captive
-- Zone: 462, ID: 37
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #46237

-- Converted from DG Script #46237: Nukreth Spire tracker load kill captive
-- Original: MOB trigger, flags: LOAD, probability: 100%
wait(2)
combat.engage(self, self.room:find_actor("captive"))