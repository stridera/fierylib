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

-- Speech phrase: tdcommand countdown (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]tdcommand countdown[%s%p]") then
    return true  -- Not the phrase
end

if not globals.pylons or not globals.teams then
    trigger_log("TD Error: WR Countdown fired before Init")
    return true
end

local team_idx = tonumber(string.match(speech, "t(%d+)t"))
local pylon_idx = tonumber(string.match(speech, "p(%d+)p"))

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
