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
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(1)
self:say("Very funny, " .. tostring(actor.name) .. ".")