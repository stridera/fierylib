-- Trigger: Demoness kill
-- Zone: 125, ID: 24
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12524

-- Converted from DG Script #12524: Demoness kill
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"kill"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
self.room:send(tostring(self.name) .. " says, 'Well, yes.  The master likes his peace...  You will disturb")
self.room:send("</>his peace.'")
wait(1)
actor:send(tostring(self.name) .. " glares at you.")
self.room:send_except(actor, tostring(self.name) .. " glares at " .. tostring(actor.name) .. ".")