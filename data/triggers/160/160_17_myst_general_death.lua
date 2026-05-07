-- Trigger: myst_general_death
-- Zone: 160, ID: 17
-- Type: MOB, Flags: DEATH
--
-- General death — second link in the Mystwatch quest spawn-cycle. Only
-- fires the cycle if `globals.myst_gen_active` was set by the General's
-- RECEIVE trigger (160,16) — prevents the chain from advancing when the
-- General is killed by something other than the totem-bearing party.
--
-- 1. Advances every present group member from "general" → "skeleton".
-- 2. If the next mob in the cycle (charred skeleton, 160,15) isn't already
--    spawned, loads one in the staging room (160,95), maybe equips with
--    object 160,30 (75% chance), then teleports it to a random room in the
--    fortress (rooms 160,0–77).
-- 3. Purges any leftovers in the staging room.
--
-- TODO(sweep): the `get_room(160,95):at(function() self.room:... end)`
-- pattern is a converter idiom that doesn't yet redirect `self.room` to
-- the bound room. Once the runtime gains `:at` context-switching (or a
-- `room` upvalue), revisit across the spawn-cycle triggers (160,17–24).

if not globals.myst_gen_active then
    return true
end

-- Advance the quest for every group member present.
for i = 1, actor.group_size do
    local person = actor.group_member[i]
    if person and person.room == self.room then
        if person:get_quest_stage("mystwatch_quest") then
            person:set_quest_var("mystwatch_quest", "step", "skeleton")
            person:send("<b:white>You have advanced the quest!</>")
        end
    end
end

-- Does next mob in the spawn cycle already exist?
if world.count_mobiles(160, 15) < 1 then
    -- Random destination room (160,0..77). Thanks to the evil Pergus for
    -- inspiring me to be more evil.
    local rnd_room = random(1, 78) - 1
    get_room(160, 95):at(function()
        self.room:spawn_mobile(160, 15)
    end)
    if random(1, 100) <= 75 then
        get_room(160, 95):at(function()
            self.room:find_actor("charred"):spawn_object(160, 30)
        end)
    end
    get_room(160, 95):at(function()
        self.room:find_actor("charred"):teleport(get_room(160, rnd_room))
    end)
    -- Sometimes creatures don't get teleported out of the loading
    -- room so we go back and purge it just in case.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
    self.room:send(tostring(self.name) .. " rasps, 'You think you have won but my charred minions will finish you!'")
    self.room:send(tostring(self.name) .. " emits a terrible wail as his spirit is banished from this realm.")
end
