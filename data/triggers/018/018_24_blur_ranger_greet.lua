-- Trigger: blur_ranger_greet
-- Zone: 18, ID: 24
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #1824

-- Converted from DG Script #1824: blur_ranger_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if string.find(actor.class, "Ranger") then
    self:command("bow " .. tostring(actor))
    self:say("Welcome fellow warden.")
    wait(1)
else
    self.room:send(tostring(self.name) .. " says, 'Greetings traveler.  Be careful, this forest can")
    self.room:send("</>be... unpredictable.'")
end
if actor:get_quest_stage("blur") == 1 then
    self.room:send(tostring(self.name) .. " says, 'I see you have brought peace to the forest.  I am")
    self.room:send("</>impressed.  Perhaps you are ready to learn the deeper ways of nature?'")
elseif actor:get_quest_stage("blur") == 2 then
    self.room:send(tostring(self.name) .. " says, 'The Syric Warder still lives.  Relieve him of his")
    self.room:send("</>endless vigil.'")
elseif actor:get_quest_stage("blur") == 3 then
    self:say("Let me have the Warder's sword.")
elseif actor:get_quest_stage("blur") == 4 then
    self:say("Are you ready to race the four winds?")
elseif actor:get_has_failed("blur") then
    self:say("Back again I see.  Ready to try again?")
end