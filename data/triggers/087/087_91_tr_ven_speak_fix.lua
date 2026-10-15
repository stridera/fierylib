-- Trigger: Tr'ven (Speak fix)
-- Zone: 87, ID: 91
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8791

-- Converted from DG Script #8791: Tr'ven (Speak fix)
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"fix"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
self:say("Yes i can fix just about anything that is broken or outdated.")
wait(0.5)
self:say("Lots of old Adventures have been bringing me items like ivory weddingbands.")
wait(0.5)
self:say("or Armor That they have Earned from there guilds and haveing me fix them up.")
wait(0.5)
self:say("to be as good as the items the would be rewarded with today.")
wait(0.5)
self:say("just hand me items and I'll get started")