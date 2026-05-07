-- Trigger: charred_skeleton_death
-- Zone: 160, ID: 18
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle link 3: skeleton → warrior. Advances every
-- present group member from "skeleton" → "warrior", then loads a charred
-- warrior (160,16) in staging room (160,95), maybe equips with object
-- 160,31 (75% chance), and teleports them to a random fortress room
-- (160,0..77). Purges the staging room afterward.

-- Advance the quest for every group member present.
for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "warrior")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

if world.count_mobiles(160, 16) < 1 then
    local rnd_room = random(1, 78) - 1
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 16)
    end)
    if random(1, 100) <= 75 then
        get_room(160, 95):at(function()
            self.room:find_actor("warrior"):spawn_object(160, 31)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("warrior"):command("wear all")
        end)
    end
    get_room(160, 95):at(function()
        self.room:find_actor("warrior"):teleport(get_room(160, rnd_room))
    end)
    -- Cleanup: purge any leftovers in the staging room.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
end
