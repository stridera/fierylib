-- Trigger: Chajin_speech
-- Zone: 581, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58106

-- Converted from DG Script #58106: Chajin_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: conspiracy conspiracy? key key? bowl bowl? Kannon kannon? Plot plot? Yajiro yajiro? Ceremony ceremony?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "conspiracy") or string.find(string.lower(speech), "conspiracy?") or string.find(string.lower(speech), "key") or string.find(string.lower(speech), "key?") or string.find(string.lower(speech), "bowl") or string.find(string.lower(speech), "bowl?") or string.find(string.lower(speech), "kannon") or string.find(string.lower(speech), "kannon?") or string.find(string.lower(speech), "plot") or string.find(string.lower(speech), "plot?") or string.find(string.lower(speech), "yajiro") or string.find(string.lower(speech), "yajiro?") or string.find(string.lower(speech), "ceremony") or string.find(string.lower(speech), "ceremony?")) then
    return true  -- No matching keywords
end
wait(2)
self:emote("sighs with the heavy weight of his burden.")
wait(6)
self:say("So the day has come.")
self:say("Surely I will be punished for this karma in my next life.")
self:say("I shall atone through my blood.")
wait(4)
self:emote("readies himself for combat.")