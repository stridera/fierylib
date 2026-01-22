-- Trigger: seer_speak5
-- Zone: 85, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8520

-- Converted from DG Script #8520: seer_speak5
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: seek?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "seek?")) then
    return true  -- No matching keywords
end
self:say("yes, to gain access to my master, you must call out his name.")