-- Trigger: meteorswarm_new_meteorite_replacement
-- Zone: 481, ID: 163
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48263

-- Converted from DG Script #48263: meteorswarm_new_meteorite_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I lost the meteorite (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i lost the meteorite", 1, true) then
    return true  -- Not the phrase
end
if actor:get_quest_stage("meteorswarm") > 2 and not actor:get_quest_var("meteorswarm:air") then
    wait(0.2)
    self:command("gasp")
    actor:send(tostring(self.name) .. " says, 'WHAT?!'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'How could you be so careless??''")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'You have no choice, you have to get a new meteorite.'")
    actor:set_quest_var("meteorswarm", "new", "yes")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You already know where the rock demon is.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Good luck.'")
end