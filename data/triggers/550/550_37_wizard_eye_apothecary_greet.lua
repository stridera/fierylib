-- Trigger: wizard_eye_apothecary_greet
-- Zone: 550, ID: 37
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55037

-- Converted from DG Script #55037: wizard_eye_apothecary_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.id == -1 then
    actor:send(tostring(self.name) .. " says, 'What can I get for ya dearie?'")
    if actor:get_quest_stage("wizard_eye") == 6 then
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Hmmm, there's something odd about you.  What have you come for?'")
    end
end