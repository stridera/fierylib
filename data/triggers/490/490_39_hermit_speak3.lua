-- Trigger: hermit_speak3
-- Zone: 490, ID: 39
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49039

-- Converted from DG Script #49039: hermit_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: marvin marvin?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "marvin") or string.find(string.lower(speech), "marvin?")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("griffin_quest") then
    self:command("sigh")
    self:say("Ah, the St. Marvin was lost with all hands many years ago.  They say the wreck has never been found.")
    self:command("peer")
    wait(1)
    self:say("I can guess where it is though, but you will need a ladder to get to it.")
end