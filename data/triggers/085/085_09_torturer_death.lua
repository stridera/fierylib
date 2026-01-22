-- Trigger: torturer_death
-- Zone: 85, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8509

-- Converted from DG Script #8509: torturer_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("resurrection_quest") == 2 then
                person.name:advance_quest("resurrection_quest")
                local run = "yes"
            elseif person:get_quest_var("resurrection_quest:new") == "yes" then
                person.name:set_quest_var("resurrection_quest", "new", "new")
                local run = "yes"
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("resurrection_quest") == 2 then
    person.name:advance_quest("resurrection_quest")
    local run = "yes"
elseif person:get_quest_var("resurrection_quest:new") == "yes" then
    person.name:set_quest_var("resurrection_quest", "new", "new")
    local run = "yes"
end
if string.find(run, "yes") then
    run_room_trigger(8553)
end