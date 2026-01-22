-- Trigger: hellfire_brimstone_meat_death
-- Zone: 23, ID: 9
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2309

-- Converted from DG Script #2309: hellfire_brimstone_meat_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("hellfire_brimstone") == 1 then
                local chance = random(1, 10)
                if chance > 7 then
                    self.room:spawn_object(23, 38)
                end
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("hellfire_brimstone") == 1 then
    local chance = random(1, 10)
    if chance > 7 then
        self.room:spawn_object(23, 38)
    end
end