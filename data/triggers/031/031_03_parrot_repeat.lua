-- Trigger: parrot_repeat
-- Zone: 31, ID: 3
-- Type: MOB, Flags: RANDOM, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3103

-- Converted from DG Script #3103: parrot_repeat
-- Original: MOB trigger, flags: RANDOM, SPEECH, probability: 100%

-- Speech keywords: cracker
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "cracker")) then
    return true  -- No matching keywords
end
self:say(tostring(arg))
self:say("hi")