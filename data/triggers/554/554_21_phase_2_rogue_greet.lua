-- Trigger: phase_2_rogue_greet
-- Zone: 554, ID: 21
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55421

-- Converted from DG Script #55421: phase_2_rogue_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Rogue, thief, assassin, merc
wait(2)
if (actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary") and actor.level >= 21 then
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