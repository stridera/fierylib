-- Trigger: Knight_Champ_speech5
-- Zone: 550, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55014

-- Converted from DG Script #55014: Knight_Champ_speech5
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"prove"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
actor:send("The Knight Champion whispers to you 'Yes prove you are worthy of honour and")
actor:send("</>respect.'")
self:command("think")
wait(1)
actor:send("The Knight Champion whispers to you 'Perhaps win a great victory over a great")
actor:send("</>evil.'")