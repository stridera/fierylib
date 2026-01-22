-- Trigger: hermit_speak4
-- Zone: 490, ID: 49
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49049

-- Converted from DG Script #49049: hermit_speak4
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: where where?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "where") or string.find(string.lower(speech), "where?")) then
    return true  -- No matching keywords
end
wait(2)
self:say("I believe the St. Marvin wrecked near the cliffs on the western shores.")