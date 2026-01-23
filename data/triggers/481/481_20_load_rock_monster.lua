-- Trigger: Load rock monster
-- Zone: 481, ID: 20
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48120

-- Converted from DG Script #48120: Load rock monster
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor:get_quest_stage("fieryisle_quest") == 5 or actor:get_quest_stage("fieryisle_quest") == 6 then
    if world.count_mobiles("48127") == 0 then
        self.room:spawn_mobile(481, 27)
    end
end