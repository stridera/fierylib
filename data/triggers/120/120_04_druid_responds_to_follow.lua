-- Trigger: Druid responds to 'follow'
-- Zone: 120, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12004

-- Converted from DG Script #12004: Druid responds to 'follow'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: follow
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "follow")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("twisted_sorrow") == 1 then
    wait(4)
    self:emote("nods solemnly.")
    wait(8)
    self:follow(actor.name)
end