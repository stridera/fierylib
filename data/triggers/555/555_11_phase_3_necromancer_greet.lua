-- Trigger: phase_3_necromancer_greet
-- Zone: 555, ID: 11
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55511

-- Converted from DG Script #55511: phase_3_necromancer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.class == "necromancer" and actor.level >= 41 then
    if actor:get_quest_stage("phase_armor") == 2 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some armor quests?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, Yes I would like to do some armor quests\"")
    end
else
end