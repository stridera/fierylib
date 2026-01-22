-- Trigger: Ash crown give
-- Zone: 481, ID: 8
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN
--
-- Original DG Script: #48108

-- Converted from DG Script #48108: Ash crown give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
if victim.id == -1 then
    if victim:get_quest_stage("fieryisle_quest") == 3 then
        victim.name:advance_quest("fieryisle_quest")
        victim:send("<b:white>You have advanced your quest!</>")
    end
end