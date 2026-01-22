-- Trigger: TD PY Init
-- Zone: 49, ID: 5
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #4905

-- Converted from DG Script #4905: TD PY Init
-- Original: OBJECT trigger, flags: DROP, probability: 100%
-- Team Domination Pylon Init (Drop) Trigger
local teams = 4
globals.teams = globals.teams or true
local owner = -1
globals.owner = globals.owner or true
local pylonname = "Caelian Pylon"
globals.pylonname = globals.pylonname or true
local pylon = 0
globals.pylon = globals.pylon or true