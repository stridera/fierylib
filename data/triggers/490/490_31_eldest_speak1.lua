-- Trigger: eldest_speak1
-- Zone: 490, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49031

-- Converted from DG Script #49031: eldest_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: cult? cult cult ?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "cult?") or string.find(string.lower(speech), "cult") or string.find(string.lower(speech), "cult") or string.find(string.lower(speech), "?")) then
    return true  -- No matching keywords
end
self.room:send(tostring(self.name) .. " says, 'You don't know about the cult?  You need to read some")
self.room:send("</>history.'")
self.room:spawn_object(490, 38)
self:command("give book " .. tostring(actor.name))
self:say("Come back when you can help us.")