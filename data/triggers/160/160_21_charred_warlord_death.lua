-- Trigger: charred_warlord_death
-- Zone: 160, ID: 21
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle link 6: warlord → blacksmith. Advances every
-- present group member from "warlord" → "blacksmith", spawns a charred
-- blacksmith (160,19) in staging room (160,95), 75% chance to equip
-- object 160,34, teleports to the smithy (160,53), and purges.

for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "blacksmith")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

if world.count_mobiles(160, 19) < 1 then
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 19)
    end)
    if random(1, 100) <= 75 then
        get_room(160, 95):at(function()
            self.room:find_actor("blacksmith"):spawn_object(160, 34)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("blacksmith"):command("wear all")
        end)
    end
    get_room(160, 95):at(function()
        self.room:find_actor("blacksmith"):teleport(get_room(160, 53))
    end)
    get_room(160, 95):at(function()
        self.room:purge()
    end)
end
