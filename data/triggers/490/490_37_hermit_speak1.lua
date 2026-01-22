-- Trigger: hermit_speak1
-- Zone: 490, ID: 37
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49037

-- Converted from DG Script #49037: hermit_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: trade?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "trade?")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("griffin_quest") then
    self:command("sigh")
    self:say("The one thing that I miss from the life I used to lead is whisky.")
    wait(1)
    self:say("If you bring me a bottle of whisky, the ladder is yours.")
end