-- Trigger: theo_duck
-- Zone: 43, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4334

-- Converted from DG Script #4334: theo_duck
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"duck?", "duck", "otto?", "otto"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Mommy locked my duck Otto in her dressing room.")
wait(0.4)
self:command("sniff")
wait(3)
self:say("Otto must be getting so lonely!")