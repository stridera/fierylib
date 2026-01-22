-- Trigger: academy_clerk_speech_score
-- Zone: 519, ID: 87
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51987

-- Converted from DG Script #51987: academy_clerk_speech_score
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: score
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "score")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "score", 1)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
    actor:send("Experience, Hit and Movement Points, Stats, Saves, blah blah blah.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
end