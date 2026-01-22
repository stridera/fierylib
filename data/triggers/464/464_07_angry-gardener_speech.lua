-- Trigger: angry-gardener_speech
-- Zone: 464, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46407

-- Converted from DG Script #46407: angry-gardener_speech
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: gardener
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "gardener")) then
    return true  -- No matching keywords
end
wait(1)
self:say("Those bastards kill them all...")
self:command("grumble")
wait(1)
self:say("One day they'll all pay for what they did to my friends.")