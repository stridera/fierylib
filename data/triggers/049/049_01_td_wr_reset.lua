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

if not percent_chance(0) then
    return true
end

-- Speech keywords: "TDCommand Purge"
if not (string.find(string.lower(speech), "tdcommand")
        and string.find(string.lower(speech), "purge")) then
    return true
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
