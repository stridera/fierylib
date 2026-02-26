-- Trigger: command_trig_test
-- Zone: 0, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1

-- Converted from DG Script #1: command_trig_test
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: kneel
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "kneel")) then
    return true  -- No matching keywords
end
self:say("running the ASK trigger")
wait(3)
self:say("the speech was " .. tostring(speech))
wait(10)
self:say("finished")