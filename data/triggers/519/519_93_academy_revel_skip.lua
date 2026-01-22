-- Trigger: academy_revel_skip
-- Zone: 519, ID: 93
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51993

-- Converted from DG Script #51993: academy_revel_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: skip
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skip")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("school") == 5 then
    wait(2)
    actor:set_quest_var("school", "money", "complete")
    actor:set_quest_var("school", "rest", "complete")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
    actor:send(tostring(self.name) .. " says, <b:green>Say finish</> to end the school.'")
end