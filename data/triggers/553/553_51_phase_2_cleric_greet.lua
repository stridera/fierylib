-- Trigger: phase_2_cleric_greet
-- Zone: 553, ID: 51
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55351

-- Converted from DG Script #55351: phase_2_cleric_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 21 then
    if actor:get_quest_stage("phase_armor") == 0 then
        actor.name:start_quest("phase_armor")
    end
    if actor:get_quest_stage("phase_armor") == 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some <b:white>armor quests</>?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end