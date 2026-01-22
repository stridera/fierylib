-- Trigger: meteorite_get
-- Zone: 482, ID: 5
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #48205

-- Converted from DG Script #48205: meteorite_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("meteorswarm") == 2 then
    actor.name:advance_quest("meteorswarm")
end