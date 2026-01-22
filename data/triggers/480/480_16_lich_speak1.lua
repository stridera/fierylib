-- Trigger: lich_speak1
-- Zone: 480, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48016

-- Converted from DG Script #48016: lich_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: ureal
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "ureal")) then
    return true  -- No matching keywords
end
self:command("ponder")
self:say("You know my name, but do you know my power?")
spells.cast(self, "disintegrate", actor.name)