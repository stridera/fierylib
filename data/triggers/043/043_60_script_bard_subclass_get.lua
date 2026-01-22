-- Trigger: script_bard_subclass_get
-- Zone: 43, ID: 60
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #4360

-- Converted from DG Script #4360: script_bard_subclass_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("bard_subclass") == 3 then
    actor:advance_quest("bard_subclass")
end