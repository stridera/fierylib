-- Trigger: quest_eleweiss_ranger_druid_subclass_exit
-- Zone: 163, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16306

-- Converted from DG Script #16306: quest_eleweiss_ranger_druid_subclass_exit
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: exit exit? leave leave?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "exit") or string.find(string.lower(speech), "exit?") or string.find(string.lower(speech), "leave") or string.find(string.lower(speech), "leave?")) then
    return true  -- No matching keywords
end
self:say("Very well, goodbye little one.")
actor:send("A gust of wind, commanded by Eleweiss, catches you and moves you away.")
self.room:send_except(actor, "A gust of wind from Eleweiss moves " .. tostring(actor.name) .. " away.")
actor:teleport(get_room(163, 74))