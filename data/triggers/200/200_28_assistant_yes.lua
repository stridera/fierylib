-- Trigger: assistant_yes
-- Zone: 200, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20028

-- Converted from DG Script #20028: assistant_yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
self:command("smile")
wait(1)
self:say("Very good.")
wait(1)
self:say("But first you must prove your worth.")