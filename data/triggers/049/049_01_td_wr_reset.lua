-- Trigger: TD WR Reset
-- Zone: 49, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4901
-- Original: WORLD trigger, flags: SPEECH, probability: 0%
--
-- Tears down all shared Team Domination state and despawns the war-room
-- control mob. Triggered by an admin saying "TDCommand Purge" in the war
-- room. Companion to 049_00.

-- Speech phrase: tdcommand purge (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]tdcommand purge[%s%p]") then
    return true  -- Not the phrase
end

globals.teams = nil
globals.pylons = nil
globals.pylonname = nil
globals.team = nil
globals.abbr = nil
globals.pylon = nil

if world.count_mobiles(49, 0) > 0 then
    local mob = self.room:find_actor("teamdominationmc")
    if mob then
        world.destroy(mob)
    end
end

self.room:send("Team Domination War Room variables reset.")
return true
