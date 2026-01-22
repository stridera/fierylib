-- Trigger: evil_nymph_death
-- Zone: 18, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1806

-- Converted from DG Script #1806: evil_nymph_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send("running")
if self.room == 1802 and world.count_mobiles("1813") then
    self.room:send("As the nymph dies, the shade of Thelmor dissipates in peace.")
    world.destroy(self.room:find_actor("shade"))
end
local person = actor
local i = person.group_size
if i then
    local a = 1
    while i > a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person.class == "Ranger" and person.level > 80 and not person:get_quest_stage("blur") then
                person.name:start_quest("blur")
                person:send("A voice from the forest whispers, 'You have done the forest a great service.  Meet me at the nearby spring.'")
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person.class == "Ranger" and person.level > 80 and not person:get_quest_stage("blur") then
    person.name:start_quest("blur")
    person:send("A voice from the forest whispers, 'You have done the forest a great service.  Meet me at the nearby spring.'")
end