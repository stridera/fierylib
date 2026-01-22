-- Trigger: down _REMOVE_ME_ON_4k
-- Zone: 18, ID: 97
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1897

-- Converted from DG Script #1897: down _REMOVE_ME_ON_4k
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: downme
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "downme")) then
    return true  -- No matching keywords
end
actor.name:award_exp(-100000)
actor.name:award_exp(-100000)
actor.name:award_exp(-100000)
actor.name:award_exp(-100000)
actor.name:award_exp(-100000)