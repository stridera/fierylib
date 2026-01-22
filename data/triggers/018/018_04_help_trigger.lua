-- Trigger: help_trigger
-- Zone: 18, ID: 4
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1804

-- Converted from DG Script #1804: help_trigger
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
wait(1)
self.room:send("The wind whispers, 'Are you willing to help end the taint?'")