-- Trigger: Long live the king
-- Zone: 12, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1201

-- Converted from DG Script #1201: Long live the king
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: chinok
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "chinok")) then
    return true  -- No matching keywords
end
self:say("Long live his fame and long live his glory.")
self:emote("bows their head briefly.")