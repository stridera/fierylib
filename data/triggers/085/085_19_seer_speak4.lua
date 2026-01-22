-- Trigger: seer_speak4
-- Zone: 85, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8519

-- Converted from DG Script #8519: seer_speak4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: master?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "master?")) then
    return true  -- No matching keywords
end
self:emote("shakes his head in disgust.")
self:say("Yes, my master.")
wait(1)
self:say("Only those that are worthy of mind and body may enter.")