-- Trigger: test trigger
-- Zone: 188, ID: 84
-- Type: MOB, Flags: SPEECH, BRIBE
-- Status: CLEAN
--
-- Original DG Script: #18884

-- Converted from DG Script #18884: test trigger
-- Original: MOB trigger, flags: SPEECH, BRIBE, probability: 100%

-- Speech keywords: 10
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "10")) then
    return true  -- No matching keywords
end
trigger_log("test test this is a test")
self.room:send(tostring(actor.class) .. " " .. tostring(actor.race))