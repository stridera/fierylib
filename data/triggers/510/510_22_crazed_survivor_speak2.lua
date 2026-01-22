-- Trigger: crazed_survivor_speak2
-- Zone: 510, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51022

-- Converted from DG Script #51022: crazed_survivor_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: magic?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "magic?")) then
    return true  -- No matching keywords
end
self:command("peer " .. tostring(actor.name))
self:say("Hmm..yes..it's been in my family for years and we were taught as children that if we held it, we would be protected from some spells.")
self:say("Although, this is the only spell that has been affected by it.  All my neighbors became zombies in one night and I was the only one to remain sane.")
self:command("shiver")
self:say("I wish I'd never found that stupid book now.")
self:command("sigh")