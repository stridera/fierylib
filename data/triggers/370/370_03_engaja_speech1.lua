-- Trigger: Engaja_speech1
-- Zone: 370, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37003

-- Converted from DG Script #37003: Engaja_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: expected expected?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "expected") or string.find(string.lower(speech), "expected?")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'He knew you were on your way, so he tried to make your'")
actor:send(tostring(self.name) .. " says to you, 'journey as easy as possible, but I guess you aren't as'")
actor:send(tostring(self.name) .. " says to you, 'good as he thought. He always overestimates his opponents.'")