-- Trigger: storm_deamon_death
-- Zone: 160, ID: 24
-- Type: MOB, Flags: DEATH
--
-- Mystwatch spawn-cycle link 9: storm demon → demon lord. Advances every
-- present group member from "storm" → "lord", spawns the demon lord
-- (160,11) in staging room (160,95), 50% chance to additionally worn-
-- equip the demon shield (160,9), then unconditionally drops the emerald
-- shard key (160,23) into its inventory and teleports it to its throne
-- (164,6). Triggers the Demon Lord shout (zone-wide echo from 160,50).
--
-- Fixes a legacy bug: the original script loaded the key (160,23) twice
-- in the 50% branch (once inside the branch, once unconditionally). This
-- version loads the shield only on the 50% roll and the key exactly once.

for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "lord")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

if world.count_mobiles(160, 11) < 1 then
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 11)
    end)
    if random(1, 100) <= 50 then
        get_room(160, 95):at(function()
            self.room:find_actor("lord"):spawn_object(160, 9)
        end)
        get_room(160, 95):at(function()
            self.room:find_actor("lord"):command("wear all")
        end)
    end
    get_room(160, 95):at(function()
        self.room:find_actor("lord"):spawn_object(160, 23)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("lord"):teleport(get_room(164, 6))
    end)
    -- TODO(sweep): legacy uses `run_room_trigger(160, 50)` to fire the
    -- demon-lord-shout WORLD/GLOBAL trigger. The runtime doesn't yet bind
    -- run_room_trigger; preserved here for parity with 117/123/163/185.
    get_room(160, 95):at(function()
        run_room_trigger(160, 50)
    end)
end
