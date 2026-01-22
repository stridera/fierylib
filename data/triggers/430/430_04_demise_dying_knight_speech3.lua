-- Trigger: Demise_dying_knight_speech3
-- Zone: 430, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #43004

-- Converted from DG Script #43004: Demise_dying_knight_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: awful
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "awful")) then
    return true  -- No matching keywords
end
self:emote("says, 'the blood....all the blood, the monsters.'")
self:command("cough")