-- Trigger: dargentan-sleep
-- Zone: 238, ID: 2
-- Type: MOB, Flags: SPEECH
--
-- When someone mentions sleep/nap/etc to Dargentan, he yawns and goes back to sleep.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"sleep", "nap", "naptime", "sleepytime"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("yawn")
wait(2)
actor:send(tostring(self.name) .. " says, 'Very well, then.  I will go back to sleep.'")
wait(1)
self:command("sleep")
