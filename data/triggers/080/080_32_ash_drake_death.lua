-- Trigger: ash_drake_death
-- Zone: 80, ID: 32
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8032

-- Converted from DG Script #8032: ash_drake_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- 
-- Now for the cycle portion..
-- 
-- Does next mob in spawn cycle already exist?
if world.count_mobiles("8033") < 1 then
    -- Generate random room number to spawn drakes in.
    -- Thanks to the evil Pergus for inspiring me to be
    -- more evil.
    local rnd_range = random(1, 126)
    local rnd_room = rnd_range + 8049
    get_room(160, 95):at(function()
        self.room:spawn_mobile(80, 33)
    end)
    local rnd = random(1, 100)
    get_room(160, 95):at(function()
        self.room:find_actor("emerald"):teleport(find_room_by_name("%rnd_room%"))
    end)
    -- Sometimes creatures don't get teleported out of the loading
    -- room so we're gonna go back and purge it just incase.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
    self.room:send(tostring(self.name) .. " cries out for help from his emerald brother!")
    self.room:send("From somewhere else in the farmlands comes another mighty roar!")
    self.room:spawn_object(80, 32)
end
-- 
-- 
-- 