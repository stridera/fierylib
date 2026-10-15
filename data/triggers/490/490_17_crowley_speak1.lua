-- Trigger: crowley_speak1
-- Zone: 490, ID: 17
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49017

-- Converted from DG Script #49017: crowley_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"forget?", "forget"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.4)
self.room:send(tostring(self.name) .. " says, 'I drink to forget until I forget to drink.  The chapel")
self.room:send("</>was the most horrible place I have ever seen.  The sight of it is burned into")
self.room:send("</>my mind.'")
wait(2)
actor:send(tostring(self.name) .. " falls to the ground before you.")
self.room:send_except(actor, tostring(self.name) .. " falls to the ground before " .. tostring(actor.name) .. ".")
self:say("I beg you to destroy that place utterly.")
wait(3)
self.room:send(tostring(self.name) .. " stands and dusts off his clothes.")
self:say("May the tree spirits guard you.")