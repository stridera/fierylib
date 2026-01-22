-- Trigger: LP_finale
-- Zone: 43, ID: 50
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4350

-- Converted from DG Script #4350: LP_finale
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: join?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "join?")) then
    return true  -- No matching keywords
end
self:say("Watch our performance!  Come and waste an hour or two.")
self:emote("closes his eyes and smiles a seductively evil smile.")
wait(3)
self:say("All the preparations are set for the only perfect act in our repertoire.")