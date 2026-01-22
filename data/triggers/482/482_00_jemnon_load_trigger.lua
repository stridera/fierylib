-- Trigger: Jemnon Load Trigger
-- Zone: 482, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #48200

-- Converted from DG Script #48200: Jemnon Load Trigger
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor:get_quest_stage("meteorswarm") == 1 then
    if actor:get_quest_var("meteorswarm:bar_num") == self.id and not world.count_mobiles("48200") then
        self.room:spawn_mobile(482, 0)
        wait(2)
        self.room:find_actor("Jemnon"):emote("mutters something about " .. tostring(actor.class) .. "s.")
    end
end