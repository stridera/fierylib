-- Trigger: captain_guard_speak3
-- Zone: 86, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8604

-- Converted from DG Script #8604: captain_guard_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "no")) then
    return true  -- No matching keywords
end
wait(1)
self:say("Very funny, " .. tostring(actor.name) .. ".")