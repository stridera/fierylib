-- Trigger: waterform_tri_death
-- Zone: 28, ID: 4
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2804

-- Converted from DG Script #2804: waterform_tri_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("waterform") == 2 or person:get_quest_var("waterform:new") /= yes then
                self.room:spawn_object(28, 7)
                person.name:advance_quest("waterform")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif actor:get_quest_stage("waterform") == 2 or actor:get_quest_var("waterform:new") /= yes then
    self.room:spawn_object(28, 7)
    actor.name:advance_quest("waterform")
end