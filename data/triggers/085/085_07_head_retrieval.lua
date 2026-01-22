-- Trigger: head_retrieval
-- Zone: 85, ID: 7
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #8507

-- Converted from DG Script #8507: head_retrieval
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("nec_dia_ant_subclass") == 3 then
    actor.name:advance_quest("nec_dia_ant_subclass")
end