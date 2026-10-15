-- Trigger: jemnon_speak2
-- Zone: 481, ID: 103
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48203

-- Converted from DG Script #48203: jemnon_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"rock", "monster", "stone", "guardian", "demon"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("meteorswarm") == 1 then
    actor:send(tostring(self.name) .. " says, 'Itsss made outta rocks!  So much rocks!  A rack MONSTER!'")
    wait(1)
    self:emote("looks confused.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Nuuuuuhhh a ROOK mahnster!'")
    wait(1)
    self:command("shake")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Uuuuhhhhhh ROCK monster!  Yeah, a rock monster.  Terrible place I saw it.'")
end