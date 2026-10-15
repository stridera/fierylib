-- Trigger: down _REMOVE_ME_ON_4k
-- Zone: 18, ID: 97
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1897

-- Converted from DG Script #1897: down _REMOVE_ME_ON_4k
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"downme"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
actor:award_exp(-100000)
actor:award_exp(-100000)
actor:award_exp(-100000)
actor:award_exp(-100000)
actor:award_exp(-100000)