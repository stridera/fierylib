-- Trigger: hermit_speak2
-- Zone: 490, ID: 38
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49038

-- Converted from DG Script #49038: hermit_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: ladder?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "ladder?")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("griffin_quest") then
    self:say("I do have a slightly used rope ladder, which I will trade with you.")
    wait(1)
    self:say("It's magical and will automatically deploy if you drop it in the right area to get down to St. Marvin.")
end