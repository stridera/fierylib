-- Trigger: abbot_speak1
-- Zone: 185, ID: 11
-- Type: MOB, Flags: SPEECH
--
-- "Prior" → Abbot defends his prior Berack against gossip.
if not string.find(string.lower(speech), "prior") then
    return true
end
self:command("peer " .. tostring(actor.name))
self:say("Anything you heard about Berack is pure hearsay.")
self:command("sigh")
self:say("That young man has enough to worry about without people bringing up his family all the time.")