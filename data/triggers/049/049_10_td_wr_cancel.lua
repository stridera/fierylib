-- Trigger: TD WR Cancel
-- Zone: 49, ID: 10
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4910
-- Original: WORLD trigger, flags: SPEECH, probability: 0%
--
-- The pylon (049_07) makes the war-room mob say
--   "TDCommand Cancel T<team>T P<pylon>P"
-- when an owner returns mid-capture and disrupts a rival countdown. This
-- trigger gossips the disruption world-wide.

if not percent_chance(0) then
    return true
end

if not (string.find(string.lower(speech), "tdcommand")
        and string.find(string.lower(speech), "cancel")) then
    return true
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Cancel fired before Init")
    return true
end

local team_idx = tonumber(string.match(speech, "T(%d+)T"))
local pylon_idx = tonumber(string.match(speech, "P(%d+)P"))

if not pylon_idx or pylon_idx < 0 or pylon_idx >= globals.pylons then
    trigger_log("TD Error: Bad pylon identifier to WR Cancel trigger")
    return true
end
if not team_idx or team_idx < 0 or team_idx >= globals.teams then
    trigger_log("TD Error: Bad team identifier to WR Cancel trigger")
    return true
end

local team_name = globals.team and globals.team[team_idx] or ("team " .. team_idx)
local num = pylon_idx + 1

local mc = self.room:find_actor("teamdominationmc")
if mc then
    mc:command("gossip " .. team_name .. " disrupts the countdown for "
               .. tostring(globals.pylonname) .. " " .. num .. "'s capture!")
end
self.room:send("Team Domination countdown cancelled for pylon "
               .. pylon_idx .. "'s capture.")
return true
