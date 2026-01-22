-- Trigger: phase_2_sorcerer_greet
-- Zone: 554, ID: 41
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55441

-- Converted from DG Script #55441: phase_2_sorcerer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- Set up test mud to test if these parenthesis work on the conditionals.. They do!!
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 21 then
    if actor:get_quest_stage("phase_armor") == 0 then
        actor.name:start_quest("phase_armor")
    end
    if actor:get_quest_stage("phase_armor") <= 1 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some <b:white>armor quests</>?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, <b:white>Yes</> I would like to do some <b:white>armor quests</>\"")
    end
else
end