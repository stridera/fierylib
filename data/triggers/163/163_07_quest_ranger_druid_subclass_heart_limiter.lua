-- Trigger: quest_ranger_druid_subclass_heart_limiter
-- Zone: 163, ID: 7
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #16307

-- Converted from DG Script #16307: quest_ranger_druid_subclass_heart_limiter
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("ran_dru_subclass") == 3 then
    actor.name:advance_quest("ran_dru_subclass")
end