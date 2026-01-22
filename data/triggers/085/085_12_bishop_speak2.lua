-- Trigger: bishop_speak2
-- Zone: 85, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8512

-- Converted from DG Script #8512: bishop_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: responsible this? you?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "responsible") or string.find(string.lower(speech), "this?") or string.find(string.lower(speech), "you?")) then
    return true  -- No matching keywords
end
self:command("wince")
self:say("The defiler.")