-- Trigger: apprentice_speak2
-- Zone: 178, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17805

-- Converted from DG Script #17805: apprentice_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help")) then
    return true  -- No matching keywords
end
self:say("If you want to return to the shaman say 'I have failed my quest'.")
wait(1)
self:say("Then I will return you to the shaman.")