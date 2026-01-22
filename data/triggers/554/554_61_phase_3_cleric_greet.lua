-- Trigger: phase_3_cleric_greet
-- Zone: 554, ID: 61
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #55461

-- Converted from DG Script #55461: phase_3_cleric_greet
-- Original: MOB trigger, flags: GREET, probability: 99%

-- 99% chance to trigger
if not percent_chance(99) then
    return true
end
wait(2)
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 41 then
    if actor:get_quest_stage("phase_armor") == 2 then
        wait(2)
        actor:send(tostring(self.name) .. " tells you, \"Welcome, would you like to do some armor quests?\"")
        actor:send(tostring(self.name) .. " tells you, \"If so, just ask me, Yes I would like to do some armor quests\"")
    end
else
end