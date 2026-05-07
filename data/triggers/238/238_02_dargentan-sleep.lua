-- Trigger: dargentan-sleep
-- Zone: 238, ID: 2
-- Type: MOB, Flags: SPEECH
--
-- When someone mentions sleep/nap/etc to Dargentan, he yawns and goes back to sleep.

-- Speech keywords: sleep nap naptime sleepytime
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "sleep") or string.find(speech_lower, "nap") or string.find(speech_lower, "naptime") or string.find(speech_lower, "sleepytime")) then
    return true  -- No matching keywords
end
self:command("yawn")
wait(2)
actor:send(tostring(self.name) .. " says, 'Very well, then.  I will go back to sleep.'")
wait(1)
self:command("sleep")
