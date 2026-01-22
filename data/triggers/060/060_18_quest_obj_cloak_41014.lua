-- Trigger: quest_obj_cloak(41014)
-- Zone: 60, ID: 18
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #6018

-- Converted from DG Script #6018: quest_obj_cloak(41014)
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "mercenary" and actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor.name:advance_quest("merc_ass_thi_subclass")
    actor:send("You've located the cloak!")
end