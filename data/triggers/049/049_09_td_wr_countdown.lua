-- Trigger: TD WR Countdown
-- Zone: 49, ID: 9
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4909
-- Original: WORLD trigger, flags: SPEECH, probability: 0%
--
-- The pylon (049_07) makes the war-room mob say
--   "TDCommand Countdown T<team>T P<pylon>P"
-- when a team starts a capture attempt. This trigger gossips it world-wide.

if not percent_chance(0) then
    return true
end

if not (string.find(string.lower(speech), "tdcommand")
        and string.find(string.lower(speech), "countdown")) then
    return true
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Countdown fired before Init")
    return true
end

local team_idx = tonumber(string.match(speech, "T(%d+)T"))
local pylon_idx = tonumber(string.match(speech, "P(%d+)P"))

if not pylon_idx or pylon_idx < 0 or pylon_idx >= globals.pylons then
    trigger_log("TD Error: Bad pylon identifier to WR Countdown trigger")
    return true
end
if not team_idx or team_idx < 0 or team_idx >= globals.teams then
    trigger_log("TD Error: Bad team identifier to WR Countdown trigger")
    return true
end

local team_name = globals.team and globals.team[team_idx] or ("team " .. team_idx)
local num = pylon_idx + 1
local suffix
if num == 1 then suffix = "st"
elseif num == 2 then suffix = "nd"
elseif num == 3 then suffix = "rd"
else suffix = "th"
end

local mc = self.room:find_actor("teamdominationmc")
if mc then
    mc:command("gossip " .. team_name .. " infiltrates the " .. num .. suffix
               .. " " .. tostring(globals.pylonname)
               .. "!  1 minute to capture!")
end
self.room:send("Team Domination countdown started for pylon " .. pylon_idx
               .. "'s capture by team " .. team_idx .. ".")
return true
