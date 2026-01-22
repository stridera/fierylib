-- Trigger: group_heal_bandit_death
-- Zone: 185, ID: 19
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #18519

-- Converted from DG Script #18519: group_heal_bandit_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
local person = actor
local i = actor.group_size
if i then
    local a = 1
    person = nil
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("group_heal") == 1 then
                person.name:advance_quest("group_heal")
                self.room:spawn_object(185, 13)
            elseif person.id == -1 then
                local what_gem_drop = random(1, 11)
                local gem_vnum = what_gem_drop + 55736
                self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
elseif person:get_quest_stage("group_heal") == 1 then
    person.name:advance_quest("group_heal")
    self.room:spawn_object(185, 13)
end