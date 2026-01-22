-- Trigger: angry-gardener_speech1
-- Zone: 464, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46405

-- Converted from DG Script #46405: angry-gardener_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: friends
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "friends")) then
    return true  -- No matching keywords
end
self:say("My friends... in the topiary.  Even took their scissors.")