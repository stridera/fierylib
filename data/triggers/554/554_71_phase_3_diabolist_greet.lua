-- Trigger: phase_3_diabolist_greet
-- Zone: 554, ID: 71
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55471

-- Converted from DG Script #55471: phase_3_diabolist_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.class == "diabolist" and actor.level >= 41 then
    if actor:get_quest_stage("phase_armor") == 2 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some armor quests?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, Yes I would like to do some armor quests\"")
    end
else
end