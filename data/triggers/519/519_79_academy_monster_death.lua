-- Trigger: academy_monster_death
-- Zone: 519, ID: 79
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #51979

-- Converted from DG Script #51979: academy_monster_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local fight = actor:get_quest_var("school:fight")
if fight == "last" then
    actor:set_quest_var("school", "fight", "complete")
    actor:advance_quest("school")
else
    if world.count_mobiles("51900") == 0 then
        self.room:spawn_mobile(519, 0)
        self.room:send("Another horrible monster appears!")
    end
end