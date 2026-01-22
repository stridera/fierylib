-- Trigger: creeping_doom_pixie_speech4
-- Zone: 615, ID: 59
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61559

-- Converted from DG Script #61559: creeping_doom_pixie_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: remember remember? how how? forgotten forgotten?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "remember") or string.find(string.lower(speech), "remember?") or string.find(string.lower(speech), "how") or string.find(string.lower(speech), "how?") or string.find(string.lower(speech), "forgotten") or string.find(string.lower(speech), "forgotten?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Druid") then
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