-- Trigger: berserker_target_fight
-- Zone: 364, ID: 14
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- When a Wild Hunt quarry is engaged, scan the room for any group member on
-- stage 4 of the subclass quest with this mob as their target. If found,
-- punt them to a random room in the surrounding wilderness zone with a
-- flavor message keyed on the quarry's home zone.
--
-- Original DG Script: #36414

-- Per-quarry banishment flavor + destination zone. Keys are the quarry's
-- own zone (self.zone_id). `dest_zone` is the wilderness zone the player is
-- exiled into; `room_max` is the highest valid local id in that zone.
local BANISH = {
    [161] = { -- desert cave
        msg_self  = " whips you with her tail and sends you flying into a sandstorm!",
        msg_other = " whips %s with her tail and sends %s flying into a sandstorm!",
        dest_zone = 161, room_max = 85,
    },
    [163] = { -- forested highlands
        msg_self  = " howls and sends you fleeing in terror!",
        msg_other = " howls and sends %s fleeing in terror!",
        dest_zone = 163, room_max = 80,
    },
    [203] = { -- vast plain
        msg_self  = " roars and hurdles you into the blinding heat!",
        msg_other = " roars and hurdles %s into the blinding heat!",
        dest_zone = 203, room_max = 78,
    },
    [552] = { -- frozen tundra
        msg_self  = " roars and hurdles you into the blinding snow!",
        msg_other = " roars and hurdles %s into the blinding snow!",
        dest_zone = 555, room_max = 99,
    },
}

local entry = BANISH[self.zone_id]
if not entry then
    return true
end

-- TODO(parity): the legacy script iterated `room.people` linked-list. The
-- new runtime exposes `room.actors` as an indexable list. If the API uses a
-- different name, this loop needs adjusting.
local actors = self.room.actors or self.room.people or {}
for _, person in ipairs(actors) do
    if person.is_player
        and person:get_quest_stage("berserker_subclass") == 4
        and person.group_size and person.group_size ~= 0
        and person:get_quest_var("berserker_subclass:target") == self.id
    then
        wait(2)
        person:send("<b:red>You must hunt this creature alone!  No groups allowed!</>")
        person:send(tostring(self.name) .. entry.msg_self)
        local their_pronoun = person.himher or person.name
        self.room:send_except(person, tostring(self.name) .. string.format(entry.msg_other, person.name, their_pronoun))
        self.room:send_except(person, tostring(person.name) .. " is gone!")
        local roll = random(1, entry.room_max)
        person:teleport(get_room(entry.dest_zone, roll))
    end
end