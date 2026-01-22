-- Trigger: supernova_sunchild_death
-- Zone: 62, ID: 5
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #6205

-- Converted from DG Script #6205: supernova_sunchild_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("supernova") == 1 then
                person.name:advance_quest("supernova")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif actor:get_quest_stage("supernova") == 1 then
    actor.name:advance_quest("supernova")
end