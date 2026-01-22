-- Trigger: blur_syric_warder_death
-- Zone: 18, ID: 26
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1826

-- Converted from DG Script #1826: blur_syric_warder_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local i = actor.group_size
local person = actor
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("blur") == 2 then
                person.name:advance_quest("blur")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("blur") == 2 then
    person.name:advance_quest("blur")
end