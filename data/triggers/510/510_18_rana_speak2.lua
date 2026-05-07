-- Trigger: rana_speak2
-- Zone: 510, ID: 18
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51018
-- Reacts to "shema" — Rana retells how Luchiaans deceived the
-- Council and a cleaner's discovered book exposed his true plans.

-- Speech keyword: "shema"
if not string.find(string.lower(speech or ""), "shema") then
    return true
end
self:command("look " .. tostring(actor.name))
self:command("nod")
wait(1)
self:say("Yes, Shema.  She used to be the cleric on the council until that upstart sorcerer came along.")
self:command("sigh")
self:say("He fooled us all, then a cleaner came across a book in his office that suddenly shed light on a lot of things.")
self:command("shake")
wait(1)
self:say("All that stuff about the insane and how he might be able to help them.")
self:command("whap me")
self:say("But now he has gone to ground and we are left to pick up the pieces of our once proud town.")
self:command("cry " .. tostring(actor.name))