-- Trigger: jemnon_speak3
-- Zone: 481, ID: 104
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48204

-- Converted from DG Script #48204: jemnon_speak3
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where?", "place?", "where", "place"}) do
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
    actor:advance_quest("meteorswarm")
    actor:send(tostring(self.name) .. " says, 'Ooohhhhh you wann kno wheeeeere itis?!'")
    actor:send(tostring(self.name) .. " angrily shouts, 'You outta jus' say so!!'")
    wait(2)
    self:emote("blinks drunkenly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Wat wuz I sayin'?'")
    wait(0.1)
    actor:send(tostring(self.name) .. " says, 'Oh yeah, the ROOK MONSTER.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Itz in a hole.'")
    wait(0.1)
    actor:send(tostring(self.name) .. " says, 'Yep.  Great big hole.'")
    wait(2)
    self:emote("becomes deathly still.")
    wait(6)
    actor:send("In a suddenly clear voice, " .. tostring(self.name) .. " speaks.  'I remember the smoke and ruins of the city. A fountain of blood gushed up from the town square.  I avoided the demons as best I could, but by accident I stumbled into a collapsed house at the end of a road...'")
    wait(0.2)
    self:command("shiver")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'That's where I saw it, in a cave under the rubble...'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I wish I could forget...'")
    self:command("cry")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Please, let me forget...'")
    self:emote("quickly downs another drink.")
    wait(4)
    self:command("sleep")
    wait(20)
    self:command("wake")
    self:emote("looks around very confused.")
end