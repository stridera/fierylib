-- Trigger: quest_mayor_obj_cane(3033)
-- Zone: 60, ID: 19
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #6019

-- Converted from DG Script #6019: quest_mayor_obj_cane(3033)
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" then
    if actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
        if actor:get_quest_var("merc_ass_thi_subclass:mayor") == 1 then
            actor.name:advance_quest("merc_ass_thi_subclass")
            wait(1)
            actor:send("<b:red>You've got the cane!</>")
        else
            wait(1)
            actor:send("<b:yellow>You haven't killed the Mayor yet...</>")
        end
    end
end