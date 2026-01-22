-- Trigger: Sunbird_speech2
-- Zone: 581, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58104

-- Converted from DG Script #58104: Sunbird_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: what? terrible? something? happened?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "what?") or string.find(string.lower(speech), "terrible?") or string.find(string.lower(speech), "something?") or string.find(string.lower(speech), "happened?")) then
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