-- Trigger: degeneration_cat_speech2
-- Zone: 55, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5520

-- Converted from DG Script #5520: degeneration_cat_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: cat cat?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "cat") or string.find(string.lower(speech), "cat?")) then
    return true  -- No matching keywords
end
wait(2)
self:say("Yes, I'm a cat.  A talking cat.  What of it?")
wait(4)
self:say("I still know more about magic than you do.")
self:command("hiss " .. tostring(actor.name))