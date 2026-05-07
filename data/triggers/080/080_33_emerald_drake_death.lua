-- Trigger: emerald_drake_death
-- Zone: 80, ID: 33
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8033
-- On death: advances the drake spawn cycle (emerald -> wug) by loading
-- the next drake at the staging room (160, 95) and teleporting it to a
-- random room in zone 80, then dropping the cycle marker object.

if world.count_mobiles(80, 34) < 1 then
    -- Random destination room in zone 80, range 50..175
    local rnd_room = random(1, 126) + 49
    get_room(160, 95):at(function()
        self.room:spawn_mobile(80, 34)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("wug"):teleport(get_room(80, rnd_room))
    end)
    -- Purge the staging room in case the drake didn't teleport out.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
    self.room:send(tostring(self.name) .. " cries out for help from his brother Wug!")
    self.room:send("From somewhere else in the farmlands comes another mighty roar!")
    self.room:spawn_object(80, 33)
end