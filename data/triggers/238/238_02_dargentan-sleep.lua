-- Trigger: dargentan-sleep
-- Zone: 238, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23802

-- Converted from DG Script #23802: dargentan-sleep
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: sleep nap naptime sleepytime
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "sleep") or string.find(string.lower(speech), "nap") or string.find(string.lower(speech), "naptime") or string.find(string.lower(speech), "sleepytime")) then
    return true  -- No matching keywords
end
self:command("yawn")
wait(2)
actor:send(tostring(self.name) .. " says, 'Very well, then.  I will go back to sleep.'")
wait(1)
self:command("sleep")