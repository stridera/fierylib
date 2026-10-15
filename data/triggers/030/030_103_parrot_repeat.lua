-- Trigger: parrot_repeat
-- Zone: 30, ID: 103
-- Type: MOB, Flags: RANDOM, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3103

-- Converted from DG Script #3103: parrot_repeat
-- Original: MOB trigger, flags: RANDOM, SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"cracker"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say(tostring(arg))
self:say("hi")