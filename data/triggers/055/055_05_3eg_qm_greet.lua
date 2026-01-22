-- Trigger: 3eg_qm_greet
-- Zone: 55, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #5505

-- Converted from DG Script #5505: 3eg_qm_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, a new recruit")
    actor:send("</>to fight the undead masses?'")
end