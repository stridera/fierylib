-- Trigger: TD WR Init
-- Zone: 49, ID: 0
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4900
-- Original: WORLD trigger, flags: SPEECH, probability: 0%
--
-- Initializes shared Team Domination state held in globals: team names and
-- abbreviations, per-pylon owner array (-1 = unowned), and the pylon name.
-- Spawns the war-room control mob (49:0) if not present. Triggered by an
-- admin saying "TDCommand Start" in the war room.
--
-- TODO(converter): probability=0% in source means this never auto-fires; the
-- intent is purely manual admin invocation. Left intact for fidelity.

if not percent_chance(0) then
    return true
end

-- Speech keywords: "TDCommand Start"
if not (string.find(string.lower(speech), "tdcommand")
        and string.find(string.lower(speech), "start")) then
    return true
end

local NUM_TEAMS = 4
local NUM_PYLONS = 10

globals.teams = NUM_TEAMS
globals.pylons = NUM_PYLONS
globals.pylonname = "Caelian Pylon"

globals.team = {
    [0] = "Mielikki's Champions",
    [1] = "Rangers of the North",
    [2] = "The Invasion Army",
    [3] = "The Miner's Guild",
}
globals.abbr = {
    [0] = "MC",
    [1] = "RN",
    [2] = "IA",
    [3] = "MG",
}

globals.pylon = {}
for i = 0, NUM_PYLONS - 1 do
    globals.pylon[i] = -1
end

-- Spawn the war-room control mob if not already present.
if world.count_mobiles(49, 0) < 1 then
    self.room:spawn_mobile(49, 0)
end

self.room:send("Team Domination War Room variables initialized to defaults.")
return true
