-- Trigger: creeping_doom_pixie_speech4
-- Zone: 615, ID: 59
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61559

-- Converted from DG Script #61559: creeping_doom_pixie_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"remember", "remember?", "how", "how?", "forgotten", "forgotten?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            self:say("I can teach you the power from Nature's darkest of")
            self.room:send("'dreams, Creeping Doom.'")
            wait(3)
            self:say("Use it to annihilate those who would defile the")
            self.room:send("'natural order.'")
            wait(3)
            self:say("Are you ready to be our avenger?")
        end
    end
end