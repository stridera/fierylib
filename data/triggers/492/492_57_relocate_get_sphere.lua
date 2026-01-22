-- Trigger: relocate_get_sphere
-- Zone: 492, ID: 57
-- Type: OBJECT, Flags: GET, GIVE
-- Status: CLEAN
--
-- Original DG Script: #49257

-- Converted from DG Script #49257: relocate_get_sphere
-- Original: OBJECT trigger, flags: GET, GIVE, probability: 100%
if actor:get_quest_stage("relocate_spell_quest") == 3 then
    actor.name:advance_quest("relocate_spell_quest")
    local echo = 1
end
if victim:get_quest_stage("relocate_spell_quest") == 3 then
    victim.name:advance_quest("relocate_spell_quest")
    local echo = 1
end
if echo then
    wait(2)
    self.room:send("The globe glares brightly with power!")
end