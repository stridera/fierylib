-- Trigger: phase_3_anti-paladin_greet
-- Zone: 554, ID: 51
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55451

-- Converted from DG Script #55451: phase_3_anti-paladin_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if string.find(actor.class, "Anti") and actor.level >= 41 then
    if actor:get_quest_stage("phase_armor") == 2 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some armor quests?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, Yes I would like to do some armor quests\"")
    end
else
end