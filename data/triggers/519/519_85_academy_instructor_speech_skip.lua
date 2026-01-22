-- Trigger: academy_instructor_speech_skip
-- Zone: 519, ID: 85
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51985

-- Converted from DG Script #51985: academy_instructor_speech_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: skip
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skip")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 1 then
    actor:advance_quest("school")
    actor:set_quest_var("school", "speech", "complete")
    actor:set_quest_var("school", "gear", "complete")
    actor:set_quest_var("school", "exploration", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  You'll continue to the east.'")
    actor:command("search curtain")
    self:command("open curtain")
    actor:move("east")
end