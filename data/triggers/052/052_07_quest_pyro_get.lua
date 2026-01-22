-- Trigger: quest_pyro_get
-- Zone: 52, ID: 7
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #5207

-- Converted from DG Script #5207: quest_pyro_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor:get_quest_stage("pyromancer_subclass") == 3 then
    actor.name:advance_quest("pyromancer_subclass")
end