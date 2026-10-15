-- Trigger: Knight_Champ_speech4
-- Zone: 550, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55013

-- Converted from DG Script #55013: Knight_Champ_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"worth", "worthy"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("trip " .. tostring(actor.name))
self.room:send(tostring(self.name) .. " says, 'You are unworthy!  Standing here like a helpless")
self.room:send("</>pig!'")
self:command("growl")