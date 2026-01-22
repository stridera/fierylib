-- Trigger: hellfire_brimstone_fiery_death
-- Zone: 23, ID: 11
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2311

-- Converted from DG Script #2311: hellfire_brimstone_fiery_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local room = self.room
local person = room.people
while person do
    if person:get_quest_stage("hellfire_brimstone") then
        local drop = person:get_quest_var("hellfire_brimstone:drop")
        local chance = random(1, 10)
        if chance > 6 then
            self.room:spawn_object(23, 37)
        end
    end
    local person = person.next_in_room
end