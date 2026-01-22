-- Trigger: woman_help
-- Zone: 200, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20015

-- Converted from DG Script #20015: woman_help
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
self:command("nod")
self:say("I am trapped in this chamber and there are guards all over looking for me.")
wait(1)
self:say("You see, i came to the living place of the dark monks to see my husband.")
self:say("But i was caught and the dark monks do not allow women in their abbey.")
wait(1)
self:say("So they imprisoned me.")
self:command("sigh")
wait(1)
self:say("But i have managed to escape my cell,")
self:say("and have only one more thing between me and freedom.")
self:say("Will you help me escape?")