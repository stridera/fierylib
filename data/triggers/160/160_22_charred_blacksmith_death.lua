-- Trigger: charred_blacksmith_death
-- Zone: 160, ID: 22
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle link 7: blacksmith → shadow demon. Advances every
-- present group member from "blacksmith" → "shadow", spawns the shadow
-- demon (160,10) in staging room (160,95), unconditionally equips both
-- demon keys (objects 160,20 and 160,21), teleports to the demon's lair
-- (160,52), and purges. Always announces the transition.
--
-- TODO: legacy comment requested an "are the keys already in the world?"
-- check before loading them; once a `world.count_objects(zone,id)` helper
-- exists, gate the spawn_object calls on it to avoid duplicate keys.

for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "shadow")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

if world.count_mobiles(160, 10) < 1 then
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 10)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("demon"):spawn_object(160, 20)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("demon"):spawn_object(160, 21)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("demon"):teleport(get_room(160, 52))
    end)
end
self.room:send(tostring(self.name) .. " rasps, 'You think you have won, but the demons have taken notice of you now..'")
get_room(160, 95):at(function()
    self.room:purge()
end)
