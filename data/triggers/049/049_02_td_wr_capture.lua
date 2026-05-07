-- Trigger: TD WR Capture
-- Zone: 49, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4902
-- Original: WORLD trigger, flags: SPEECH, probability: 0%
--
-- Records a pylon capture: the pylon countdown trigger (049_08) makes the
-- war-room mob say "TDCommand Capture T<team>T P<pylon>P", and this trigger
-- updates globals.pylon[<pylon>] = <team> and gossips the capture.

if not percent_chance(0) then
    return true
end

-- Speech keywords: "TDCommand Capture"
if not (string.find(string.lower(speech), "tdcommand")
        and string.find(string.lower(speech), "capture")) then
    return true
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Capture fired before Init")
    return true
end

-- Parse "T<team>T P<pylon>P" out of the speech.
local team_idx = tonumber(string.match(speech, "T(%d+)T"))
local pylon_idx = tonumber(string.match(speech, "P(%d+)P"))

if not pylon_idx or pylon_idx < 0 or pylon_idx >= globals.pylons then
    trigger_log("TD Error: Bad pylon identifier to WR Capture trigger")
    return true
end
if not team_idx or team_idx < 0 or team_idx >= globals.teams then
    trigger_log("TD Error: Bad team identifier to WR Capture trigger")
    return true
end

globals.pylon[pylon_idx] = team_idx

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
    mc:command("gossip " .. team_name .. " captures the " .. num .. suffix
               .. " " .. tostring(globals.pylonname) .. "!")
end
self.room:send("Team Domination pylon " .. pylon_idx
               .. " captured by team " .. team_idx .. ".")
return true
