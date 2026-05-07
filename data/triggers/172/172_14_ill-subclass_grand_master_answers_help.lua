-- Trigger: Ill-subclass: Grand Master answers 'help'
-- Zone: 172, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Player asks the Grand Master for 'help'. Reply branches on quest stage,
-- nudging them toward the right next action - drop the vial, stall the
-- leader, restart, or hand over the choker.
--
-- Original DG Script: #17214

local speech_lower = string.lower(speech)
if not string.find(speech_lower, "help") then
    return true  -- keyword not heard
end
wait(1)
-- switch on actor:get_quest_stage("illusionist_subclass")
if actor:get_quest_stage("illusionist_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Ok, ok, here's what you need to do: Go to the smuggler's hideout, <b:cyan>drop the vial</>, and go to see the leader.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Don't let anyone see you drop the vial!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'And get that choker!  Now go.'")
elseif actor:get_quest_stage("illusionist_subclass") == 2 or actor:get_quest_stage("illusionist_subclass") == 4 then
    actor:send(tostring(self.name) .. " says, 'Hmm.  Did things get confusing?  Say <b:cyan>'restart'</> if you want to try again.'")
elseif actor:get_quest_stage("illusionist_subclass") == 3 or actor:get_quest_stage("illusionist_subclass") == 5 then
    actor:send(tostring(self.name) .. " says, 'Someone saw you drop the vial?")
    wait(3)
    self:command("shake")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'You'll never fool them that way!'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Give it some time.  Then come back here and say <b:cyan>'restart'</> to try again.'")
elseif actor:get_quest_stage("illusionist_subclass") == 6 then
    actor:send(tostring(self.name) .. " says, 'You got the choker, you say?  Hand it over!'")
elseif actor:get_quest_stage("illusionist_subclass") == 0 then
    actor:send(tostring(self.name) .. " says, 'Help you?  Something the matter?'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Psyche!  You don't work for me, I wasn't really concerned.'")
end