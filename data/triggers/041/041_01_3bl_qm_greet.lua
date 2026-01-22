-- Trigger: 3bl_qm_greet
-- Zone: 41, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #4101

-- Converted from DG Script #4101: 3bl_qm_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 0 then
    actor:send(tostring(self.name) .. " tells you, 'Hrm, fresh meat to fight the reach of the")
    actor:send("</>elven scum?'")
end