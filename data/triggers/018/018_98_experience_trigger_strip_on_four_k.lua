-- Trigger: experience_trigger_STRIP_ON_FOUR_k
-- Zone: 18, ID: 98
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1898

-- Converted from DG Script #1898: experience_trigger_STRIP_ON_FOUR_k
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: upme
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "upme")) then
    return true  -- No matching keywords
end
actor:award_exp(100000)
actor:award_exp(100000)
actor:award_exp(100000)
actor:award_exp(100000)