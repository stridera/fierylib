-- Trigger: degeneration_cat_speech2
-- Zone: 55, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5520

-- Converted from DG Script #5520: degeneration_cat_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"cat", "cat?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self:say("Yes, I'm a cat.  A talking cat.  What of it?")
wait(0.4)
self:say("I still know more about magic than you do.")
self:command("hiss " .. tostring(actor.name))