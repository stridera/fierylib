-- Trigger: fire_priest_death
-- Zone: 482, ID: 59
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48259

-- Converted from DG Script #48259: fire_priest_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("meteorswarm") == 3 then
                person.name:set_quest_var("meteorswarm", "fire", 1)
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("meteorswarm") == 3 then
    person.name:set_quest_var("meteorswarm", "fire", 1)
end