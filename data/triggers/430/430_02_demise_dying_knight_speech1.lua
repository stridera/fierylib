-- Trigger: Demise_dying_knight_speech1
-- Zone: 430, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #43002

-- Converted from DG Script #43002: Demise_dying_knight_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: them
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "them")) then
    return true  -- No matching keywords
end
self:say("monsters....everywhere...too many.")
self:command("cough")