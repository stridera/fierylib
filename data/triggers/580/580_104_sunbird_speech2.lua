-- Trigger: Sunbird_speech2
-- Zone: 580, ID: 104
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- After the Kannon cinematic, the Sunbird explains the conspiracy
-- around Yajiro and asks the player to investigate.

-- Speech keywords: what / terrible / something / happened
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "what") or string.find(speech_lower, "terrible") or string.find(speech_lower, "something") or string.find(speech_lower, "happened")) then
    return true  -- No matching keywords
end
wait(5)
self:command("nod")
wait(10)
self:say("A conspiracy has infected Odaishyozen.")
self:say("Shadowy figures have been plotting with Yajiro,")
self:say("the court sorcerer, to capture Kannons light.")
self:say("It seems they have even ensnared innocent souls in their trap.")
wait(12)
self:command("ponder")
wait(12)
self:say("But perhaps you can help untangle these threads of karma")
self:say("Will you investigate what has happened to Kannon?")