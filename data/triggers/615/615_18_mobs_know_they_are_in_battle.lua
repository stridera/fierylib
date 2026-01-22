-- Trigger: Mobs know they are in battle
-- Zone: 615, ID: 18
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #61518

-- Converted from DG Script #61518: Mobs know they are in battle
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local in_battle = 1
globals.in_battle = globals.in_battle or true