-- Trigger: catherine_theo
-- Zone: 43, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4331

-- Converted from DG Script #4331: catherine_theo
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: I want my duck!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "want") or string.find(string.lower(speech), "my") or string.find(string.lower(speech), "duck!")) then
    return true  -- No matching keywords
end
if actor.id == 4310 then
    self:say("Theo, I don't have time for this!")
    wait(2)
    self:say("We'll get your duck as soon as I can find my key!")
end