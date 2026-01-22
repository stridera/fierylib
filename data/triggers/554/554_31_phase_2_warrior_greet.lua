-- Trigger: phase_2_warrior_greet
-- Zone: 554, ID: 31
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55431

-- Converted from DG Script #55431: phase_2_warrior_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.class == "warrior" and actor.level >= 21 then
    if actor:get_quest_stage("phase_armor") == 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some <b:white>armor quests</>?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end