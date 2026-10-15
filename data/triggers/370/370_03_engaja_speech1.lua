-- Trigger: Engaja_speech1
-- Zone: 370, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37003

-- Converted from DG Script #37003: Engaja_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"expected", "expected?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'He knew you were on your way, so he tried to make your'")
actor:send(tostring(self.name) .. " says to you, 'journey as easy as possible, but I guess you aren't as'")
actor:send(tostring(self.name) .. " says to you, 'good as he thought. He always overestimates his opponents.'")