-- Trigger: blur_vulcera_death
-- Zone: 18, ID: 36
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1836

-- Converted from DG Script #1836: blur_vulcera_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    local a = 1
else
    local a = 0
end
person = nil
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if (person:get_quest_stage("blur") == 4) and (not person:get_quest_var("blur:east")) and world.count_mobiles("1821") then
            local lair = get_room("12597")
            person:send(tostring(mobiles.template(18, 21).name) .. " thanks you heartily!")
            self.room:send_except(person, "%get.mob_shortdesc[1821]% thanks %person.name% heartily!")
            person:send("%get.mob_shortdesc[1821]% tells you, 'See if you can get to<b:yellow> %lair.name% </>first!'")
            person:send("'I already started the clock...'")
            self.room:send(tostring(mobiles.template(18, 21).name) .. " takes off like a rocket and vanishes!")
            person.name:set_quest_var("blur", "east", 1)
            local person = person.next_in_room
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
end