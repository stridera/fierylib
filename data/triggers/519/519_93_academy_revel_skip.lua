-- Trigger: academy_revel_skip
-- Zone: 519, ID: 93
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51993

-- Converted from DG Script #51993: academy_revel_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"skip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("school") == 5 then
    wait(0.2)
    actor:set_quest_var("school", "money", "complete")
    actor:set_quest_var("school", "rest", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
    actor:send(tostring(self.name) .. " says, <b:green>Say finish</> to end the school.'")
end