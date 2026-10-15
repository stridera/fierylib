-- Trigger: academy_instructor_speech_skip
-- Zone: 519, ID: 85
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51985

-- Converted from DG Script #51985: academy_instructor_speech_skip
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
wait(0.2)
if actor:get_quest_stage("school") == 1 then
    actor:advance_quest("school")
    actor:set_quest_var("school", "speech", "complete")
    actor:set_quest_var("school", "gear", "complete")
    actor:set_quest_var("school", "explore", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  You'll continue to the east.'")
    actor:command("search curtain")
    self:command("open curtain")
    actor:move("east")
end