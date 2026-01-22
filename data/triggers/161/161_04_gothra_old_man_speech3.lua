-- Trigger: Gothra_Old_Man_speech3
-- Zone: 161, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16104

-- Converted from DG Script #16104: Gothra_Old_Man_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: trouble
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trouble")) then
    return true  -- No matching keywords
end
self:command("nod " .. tostring(actor.name))
self:say("Yes I said trouble, kids today, why when I was your age I was taming the realms! And I even caught me a giant scorpion!")
self:command("nod man")