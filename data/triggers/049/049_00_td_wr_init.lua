-- Trigger: TD WR Init
-- Zone: 49, ID: 0
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4900

-- Converted from DG Script #4900: TD WR Init
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: TDCommand Start
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "tdcommand") or string.find(string.lower(speech), "start")) then
    return true  -- No matching keywords
end
-- Team Domination War Room Init (Speech) Trigger
local teams = 4
local team0 = "Mielikki's Champions"
local abbr0 = "MC"
local team1 = "Rangers of the North"
local abbr1 = "RN"
local team2 = "The Invasion Army"
local abbr2 = "IA"
local team3 = "The Miner's Guild"
local abbr3 = "MG"
globals.teams = globals.teams or true
local i = 0
while i < teams do
    globals.team%i% = globals.team%i% or true
    globals.abbr%i% = globals.abbr%i% or true
    local i = i + 1
end
local pylons = 10
globals.pylons = globals.pylons or true
local i = 0
while i < pylons do
    pylon[i] = -1
    globals.pylon%i% = globals.pylon%i% or true
    local i = i + 1
end
local pylonname = "Caelian Pylon"
globals.pylonname = globals.pylonname or true
if actor:get_mexists("4900") < 1 then
    self.room:spawn_mobile(49, 0)
end
self.room:send("Team Domination War Room variables initialized to defaults.")