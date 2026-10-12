-- Trigger: quest_suralla_endquest
-- Zone: 550, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55026

-- Converted from DG Script #55026: quest_suralla_endquest
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: the shrub suffers no longer (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "the shrub suffers no longer", 1, true) then
    return true  -- Not the phrase
end
wait(2)
-- switch on actor:get_quest_stage("cryomancer_subclass")
if actor:get_quest_stage("cryomancer_subclass") == 1 or actor:get_quest_stage("cryomancer_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, how could you have completed the quest without actually knowing what it is?'")
elseif actor:get_quest_stage("cryomancer_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Nay, you did not partake in ending its suffering.'")
elseif actor:get_quest_stage("cryomancer_subclass") == 4 then
    self:command("thank " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Thank you so very much for righting my wrong.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'It is for the best.'")
    wait(2)
    self:command("bow " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type <b:cyan>'subclass'</> to proceed.'")
    actor:complete_quest("cryomancer_subclass")
else
    actor:send(tostring(self.name) .. " says, 'What is going on?  The voices again, it is all happening again......'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Wait, I seem to remember something about a quest...  Pity you were not on it.'")
end