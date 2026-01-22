-- Trigger: Sunbird_speech1
-- Zone: 581, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58103

-- Converted from DG Script #58103: Sunbird_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: kannon kannon? who? goddess goddes? mercy mercy?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "kannon") or string.find(string.lower(speech), "kannon?") or string.find(string.lower(speech), "who?") or string.find(string.lower(speech), "goddess") or string.find(string.lower(speech), "goddes?") or string.find(string.lower(speech), "mercy") or string.find(string.lower(speech), "mercy?")) then
    return true  -- No matching keywords
end
wait(7)
self:say("Through her holy benevolence, I once protected this entire island.")
self.room:send("The Sunbird spreads its wings and begins to radiate a <b:white>glowing</> <b:yellow>l</><b:white>i<b:yellow>g</><b:white>h</><b:yellow>t.</>")
wait(15)
self.room:send("<b:white>The light grows...</>")
wait(15)
self.room:send("The light suddenly <b:white>FL</><b:yellow>AR</><b:white>ES!</>")
wait(7)
self.room:send("The Sunbird falters and stumbles before the altar.")
wait(8)
self:say("But now her divine presence has waned")
self:say("Now I can only shelter this small space near her shrine.")
self:say("I fear something terrible has happened to her...")