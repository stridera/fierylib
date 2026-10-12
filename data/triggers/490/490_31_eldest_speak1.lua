-- Trigger: eldest_speak1
-- Zone: 490, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49031

-- Converted from DG Script #49031: eldest_speak1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"cult?", "cult", "cult", "?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send(tostring(self.name) .. " says, 'You don't know about the cult?  You need to read some")
self.room:send("</>history.'")
self.room:spawn_object(490, 38)
self:command("give book " .. tostring(actor.name))
self:say("Come back when you can help us.")