-- Trigger: quest_relocate_staff_get
-- Zone: 492, ID: 27
-- Type: OBJECT, Flags: GET, GIVE
-- Status: CLEAN
--
-- Original DG Script: #49227

-- Converted from DG Script #49227: quest_relocate_staff_get
-- Original: OBJECT trigger, flags: GET, GIVE, probability: 100%
if actor:get_quest_stage("relocate_spell_quest") == 1 then
    actor.name:advance_quest("relocate_spell_quest")
end
if victim:get_quest_stage("relocate_spell_quest") == 1 then
    victim.name:advance_quest("relocate_spell_quest")
end