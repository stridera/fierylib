-- Trigger: seer_speak1
-- Zone: 85, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8516

-- Converted from DG Script #8516: seer_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hourglass hourglass?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hourglass") or string.find(string.lower(speech), "hourglass?")) then
    return true  -- No matching keywords
end
self:command("grin")
self:say("Very well done indeed!")
self:emote("lifts his head and utters some obscure magical phrase.")
actor.name:teleport(get_room(85, 83))