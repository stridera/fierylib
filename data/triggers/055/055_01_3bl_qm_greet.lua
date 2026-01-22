-- Trigger: 3bl_qm_greet
-- Zone: 55, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #5501

-- Converted from DG Script #5501: 3bl_qm_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 0 then
    -- (empty send to actor)
    actor:send(tostring(self.name) .. " tells you, 'Hrm, a new recruit to fight the")
    actor:send("</>elven scum?'")
    -- (empty send to actor)
end