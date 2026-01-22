-- Trigger: major_globe_channel_advance
-- Zone: 534, ID: 61
-- Type: OBJECT, Flags: GLOBAL, GET, GIVE
-- Status: CLEAN
--
-- Original DG Script: #53461

-- Converted from DG Script #53461: major_globe_channel_advance
-- Original: OBJECT trigger, flags: GLOBAL, GET, GIVE, probability: 100%
if victim then
    if victim:get_quest_stage("major_globe_spell") == 9 then
        victim.name:advance_quest("major_globe_spell")
    end
else
    if actor:get_quest_stage("major_globe_spell") == 9 then
        actor.name:advance_quest("major_globe_spell")
    end
end