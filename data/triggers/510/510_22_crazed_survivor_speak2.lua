-- Trigger: crazed_survivor_speak2
-- Zone: 510, ID: 22
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51022
-- Reacts to "magic" — the survivor explains his family heirloom
-- protected him alone from the spell that turned his neighbours.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"magic?", "magic"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("peer " .. tostring(actor.name))
self:say("Hmm..yes..it's been in my family for years and we were taught as children that if we held it, we would be protected from some spells.")
self:say("Although, this is the only spell that has been affected by it.  All my neighbors became zombies in one night and I was the only one to remain sane.")
self:command("shiver")
self:say("I wish I'd never found that stupid book now.")
self:command("sigh")