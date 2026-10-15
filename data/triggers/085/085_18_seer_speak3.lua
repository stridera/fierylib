-- Trigger: seer_speak3
-- Zone: 85, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8518

-- Converted from DG Script #8518: seer_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"worthy?", "worthy"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Only the sharpest of minds can answer the riddle my master dictated to me.")
self:command("sigh")
wait(0.1)
self:say("You, I fear, are not of sharp mind.")
self:emote("casts his hollow eye sockets upon you.")
self:say("Or body.")
self:command("smile seer")