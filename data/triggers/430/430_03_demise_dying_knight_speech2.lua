-- Trigger: Demise_dying_knight_speech2
-- Zone: 430, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #43003

-- Converted from DG Script #43003: Demise_dying_knight_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: monster monsters
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "monster") or string.find(string.lower(speech), "monsters")) then
    return true  -- No matching keywords
end
self:say("i am too weak")
self:say("its...look to the one who cannot...")
self:emote("spits up blood.")