-- Trigger: jemnon_speak3
-- Zone: 482, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48204

-- Converted from DG Script #48204: jemnon_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: where? place? where place
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "where?") or string.find(string.lower(speech), "place?") or string.find(string.lower(speech), "where") or string.find(string.lower(speech), "place")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("meteorswarm") == 1 then
    actor.name:advance_quest("meteorswarm")
    actor:send(tostring(self.name) .. " says, 'Ooohhhhh you wann kno wheeeeere itis?!'")
    actor:send(tostring(self.name) .. " angrily shouts, 'You outta jus' say so!!'")
    wait(2)
    self:emote("blinks drunkenly.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Wat wuz I sayin'?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh yeah, the ROOK MONSTER.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Itz in a hole.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Yep.  Great big hole.'")
    wait(2)
    self:emote("becomes deathly still.")
    wait(6)
    actor:send("In a suddenly clear voice, " .. tostring(self.name) .. " speaks.  'I remember the smoke and ruins of the city. A fountain of blood gushed up from the town square.  I avoided the demons as best I could, but by accident I stumbled into a collapsed house at the end of a road...'")
    wait(2)
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