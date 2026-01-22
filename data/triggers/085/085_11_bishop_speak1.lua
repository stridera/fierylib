-- Trigger: bishop_speak1
-- Zone: 85, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8511

-- Converted from DG Script #8511: bishop_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: defiler?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "defiler?")) then
    return true  -- No matching keywords
end
self:command("nod")
self:say("Yes, the Defiler, Ziijhan, the Defiler.")
self:command("wince")