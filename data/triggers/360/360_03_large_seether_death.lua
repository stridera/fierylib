-- Trigger: Large_seether_death
-- Zone: 360, ID: 3
-- Type: MOB, Flags: DEATH
-- Status: CLEAN (reviewed 2026-01-22)
--
-- Original DG Script: #36003

-- Converted from DG Script #36003: Large_seether_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- Does next mob in spawn cycle already exist?
if world.count_mobiles("8031") < 1 and (actor.level < 30 or actor:get_quest_stage("dragon_slayer") == 3) then
    run_room_trigger(36006)
    -- Generate random room number to spawn drakes in.
    -- Thanks to the evil Pergus for inspiring me to be
    -- more evil.
    local rnd_range = random(1, 126)
    -- rnd_room was 8050-8175, which is zone 80, locals 50-175
    local rnd_room_zone = 80
    local rnd_room_local = 49 + rnd_range
    get_room(160, 95):at(function()
        self.room:spawn_mobile(80, 31)
    end)
    local rnd = random(1, 100)
    get_room(160, 95):at(function()
        self.room:find_actor("ice"):teleport(get_room(rnd_room_zone, rnd_room_local))
    end)
    -- Sometimes creatures don't get teleported out of the loading
    -- room so we're gonna go back and purge it just in case.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
end