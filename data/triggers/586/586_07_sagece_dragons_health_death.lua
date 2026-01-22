-- Trigger: sagece_dragons_health_death
-- Zone: 586, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #58607

-- Converted from DG Script #58607: sagece_dragons_health_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("dragons_health") == 4 then
                person.name:set_quest_var("dragons_health", "sagece", 1)
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("dragons_health") == 4 then
    person.name:set_quest_var("dragons_health", "sagece", 1)
end