-- Trigger: TD WR Reset
-- Zone: 49, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4901

-- Converted from DG Script #4901: TD WR Reset
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: TDCommand Purge
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "tdcommand") or string.find(string.lower(speech), "purge")) then
    return true  -- No matching keywords
end
-- Team Domination War Room Reset (Speech) Trigger
if teams then
    local i = 0
    while i < teams do
        team[i] = nil
        abbr[i] = nil
        local i = i + 1
    end
    teams = nil
end
if pylons then
    local i = 0
    while i < pylons do
        pylon[i] = nil
        local i = i + 1
    end
    pylons = nil
end
pylonname = nil
if actor:get_mexists("4900") > 0 then
    world.destroy(self.room:find_actor("teamdominationmc"))
end
self.room:send("Team Domination War Room variables reset.")