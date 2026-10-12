-- Trigger: Cirion_speech2
-- Zone: 370, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37006

-- Converted from DG Script #37006: Cirion_speech2
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"summon", "summoned"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Don't think you came here on your own free will.'")
actor:send(tostring(self.name) .. " says to you, 'If you do then you are only deceiving yourself even more.'")
actor:send(tostring(self.name) .. " says to you, 'Mesmeriz brought you here.'")