-- Trigger: maid-cleric healing
-- Zone: 489, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48913

-- Converted from DG Script #48913: maid-cleric healing
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
--
-- One-shot world trigger fired by trigger 4 once Lokari hits 50% HP. Sets a
-- persistent flag that biases the cleric maid's spell loop (trigger 12) toward
-- group heal instead of the consecration/sacrilege AOE.
globals.healing = 1