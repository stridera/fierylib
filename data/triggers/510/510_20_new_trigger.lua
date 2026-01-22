-- Trigger: new trigger
-- Zone: 510, ID: 20
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51020

-- Converted from DG Script #51020: new trigger
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: run test
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "run") or string.find(string.lower(speech), "test")) then
    return true  -- No matching keywords
end
self.room:send("trigger running")
wait_until(00, 00)
self.room:send("trigger over")