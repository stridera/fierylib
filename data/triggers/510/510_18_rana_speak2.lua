-- Trigger: rana_speak2
-- Zone: 510, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51018

-- Converted from DG Script #51018: rana_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: shema?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "shema?")) then
    return true  -- No matching keywords
end
self:command("look " .. tostring(actor.name))
self:command("nod")
wait(1)
self:say("Yes, Shema.  She used to be the cleric on the council until that upstart sorcerer came along.")
self:command("sigh")
self:say("He fooled us all, and then a cleaner came across a book in his office that suddenly shed light on a lot of things.")
self:command("shake")
wait(1)
self:say("All that stuff about the insane and how he might be able to help them.")
self:command("whap me")
self:say("But now he has gone to ground and we are left to pick up the pieces of our once proud town.")
self:command("cry " .. tostring(actor.name))