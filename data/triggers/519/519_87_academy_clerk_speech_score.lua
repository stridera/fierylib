-- Trigger: academy_clerk_speech_score
-- Zone: 519, ID: 87
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51987

-- Converted from DG Script #51987: academy_clerk_speech_score
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"score"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "score", 1)
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
    actor:send("Experience, Hit and Movement Points, Stats, Saves, blah blah blah.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
end