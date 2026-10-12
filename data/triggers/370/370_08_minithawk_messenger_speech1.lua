-- Trigger: Minithawk_messenger_speech1
-- Zone: 370, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37008

-- Converted from DG Script #37008: Minithawk_messenger_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"killed", "killed?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes, killed...as in dead.  Mesmeriz would have my head if he'")
actor:send(tostring(self.name) .. " says to you, 'knew I were talking to you.  His direct orders were for me to'")
actor:send(tostring(self.name) .. " says to you, 'go to Templace, and deliver this rock.'")