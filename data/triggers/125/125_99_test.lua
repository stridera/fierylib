-- Trigger: test
-- Zone: 125, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12599

-- Converted from DG Script #12599: test
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: foo
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "foo")) then
    return true  -- No matching keywords
end
get_room(125, 0):exit("north"):set_state({hidden = false})