-- Trigger: theo_duck
-- Zone: 43, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4334

-- Converted from DG Script #4334: theo_duck
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: duck? Otto?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "duck?") or string.find(string.lower(speech), "otto?")) then
    return true  -- No matching keywords
end
self:say("Mommy locked my duck Otto in her dressing room.")
wait(4)
self:command("sniff")
wait(3)
self:say("Otto must be getting so lonely!")