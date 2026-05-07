-- Trigger: ice_drake_death
-- Zone: 80, ID: 31
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8031
-- On death: advances the drake spawn cycle (ice -> ash) by loading the
-- next drake at the staging room (160, 95) and teleporting it to a
-- random room in zone 80, then dropping the cycle marker object.

if world.count_mobiles(80, 32) < 1 then
    -- Random destination room in zone 80, range 50..175
    local rnd_room = random(1, 126) + 49
    get_room(160, 95):at(function()
        self.room:spawn_mobile(80, 32)
    end)
    get_room(160, 95):at(function()
        self.room:find_actor("ash"):teleport(get_room(80, rnd_room))
    end)
    -- Purge the staging room in case the drake didn't teleport out.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
    self.room:send(tostring(self.name) .. " cries out for help from his ashen brother!")
    self.room:send("From somewhere else in the farmlands comes another mighty roar!")
    self.room:spawn_object(80, 31)
end