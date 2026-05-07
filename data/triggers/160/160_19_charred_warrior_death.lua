-- Trigger: charred_warrior_death
-- Zone: 160, ID: 19
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle link 4: warrior → sentry. Advances every present
-- group member from "warrior" → "sentry", spawns a charred sentry
-- (160,17) in staging room (160,95), maybe equips object 160,32 (75%
-- chance), teleports to a random fortress room (160,0..77), and purges.

for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "sentry")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

if world.count_mobiles(160, 17) < 1 then
    local rnd_room = random(1, 78) - 1
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 17)
    end)
    if random(1, 100) <= 75 then
        get_room(160, 95):at(function()
            self.room:find_actor("sentry"):spawn_object(160, 32)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("sentry"):command("wear all")
        end)
    end
    get_room(160, 95):at(function()
        self.room:find_actor("sentry"):teleport(get_room(160, rnd_room))
    end)
    get_room(160, 95):at(function()
        self.room:purge()
    end)
end
