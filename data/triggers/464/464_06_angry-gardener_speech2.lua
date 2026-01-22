-- Trigger: angry-gardener_speech2
-- Zone: 464, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46406

-- Converted from DG Script #46406: angry-gardener_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: scissors
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "scissors")) then
    return true  -- No matching keywords
end
self:say("I know it was them that did it... they took his scissors and left him for dead.")