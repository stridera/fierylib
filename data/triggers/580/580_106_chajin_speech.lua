-- Trigger: Chajin_speech
-- Zone: 580, ID: 106
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- The tea master Chajin, confronted about the conspiracy, accepts his
-- karma and readies for combat.

-- Speech keywords: conspiracy / key / bowl / kannon / plot / yajiro /
-- ceremony
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "conspiracy") or string.find(speech_lower, "key") or string.find(speech_lower, "bowl") or string.find(speech_lower, "kannon") or string.find(speech_lower, "plot") or string.find(speech_lower, "yajiro") or string.find(speech_lower, "ceremony")) then
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