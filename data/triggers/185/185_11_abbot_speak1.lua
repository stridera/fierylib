-- Trigger: abbot_speak1
-- Zone: 185, ID: 11
-- Type: MOB, Flags: SPEECH
--
-- "Prior" → Abbot defends his prior Berack against gossip.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"prior", "prior?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("peer " .. tostring(actor.name))
self:say("Anything you heard about Berack is pure hearsay.")
self:command("sigh")
self:say("That young man has enough to worry about without people bringing up his family all the time.")