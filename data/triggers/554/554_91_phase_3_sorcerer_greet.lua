-- Trigger: phase_3_sorcerer_greet
-- Zone: 554, ID: 91
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55491

-- Converted from DG Script #55491: phase_3_sorcerer_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- Set up test mud to test if these parenthesis work on the conditionals.. They Do!!
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 41 then
    if actor:get_quest_stage("phase_armor") == 2 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some armor quests?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, Yes I would like to do some armor quests\"")
    end
else
end