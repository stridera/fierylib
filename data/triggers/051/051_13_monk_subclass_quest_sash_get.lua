-- Trigger: monk_subclass_quest_sash_get
-- Zone: 51, ID: 13
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #5113

-- Converted from DG Script #5113: monk_subclass_quest_sash_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("monk_subclass") == 3 then
    actor.name:advance_quest("monk_subclass")
end