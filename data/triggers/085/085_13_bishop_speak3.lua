-- Trigger: bishop_speak3
-- Zone: 85, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8513

-- Converted from DG Script #8513: bishop_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: escape!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "escape!")) then
    return true  -- No matching keywords
end
self:say("Get out of here, don't worry about me!")
wait(1)
self:say("Save yourself!!")
self:command("wince")