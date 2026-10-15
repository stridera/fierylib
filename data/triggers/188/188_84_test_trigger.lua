-- Trigger: test trigger
-- Zone: 188, ID: 84
-- Type: MOB, Flags: SPEECH, BRIBE
-- Status: CLEAN
-- Num arg: 100
--
-- Original DG Script: #18884

-- Converted from DG Script #18884: test trigger
-- Original: MOB trigger, flags: SPEECH, BRIBE, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"10"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
trigger_log("test test this is a test")
self.room:send(tostring(actor.class) .. " " .. tostring(actor.race))