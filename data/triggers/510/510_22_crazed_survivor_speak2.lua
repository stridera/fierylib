-- Trigger: crazed_survivor_speak2
-- Zone: 510, ID: 22
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51022
-- Reacts to "magic" — the survivor explains his family heirloom
-- protected him alone from the spell that turned his neighbours.

-- Speech keyword: "magic"
if not string.find(string.lower(speech or ""), "magic") then
    return true
end
self:command("peer " .. tostring(actor.name))
self:say("Hmm..yes..it's been in my family for years and we were taught as children that if we held it, we would be protected from some spells.")
self:say("Although, this is the only spell that has been affected by it.  All my neighbors became zombies in one night and I was the only one to remain sane.")
self:command("shiver")
self:say("I wish I'd never found that stupid book now.")
self:command("sigh")