-- Trigger: blur_ranger_preentry
-- Zone: 18, ID: 32
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1832

-- Converted from DG Script #1832: blur_ranger_preentry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if (actor:get_quest_stage("blur") > 0 or actor:get_has_failed("blur")) and world.count_mobiles(18, 18) == 0 then
    self.room:spawn_mobile(18, 18)
end