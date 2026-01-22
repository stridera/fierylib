-- Trigger: emerald_drake_death
-- Zone: 80, ID: 33
-- Type: MOB, Flags: DEATH
-- Status: CLEAN (reviewed)
--
-- Original DG Script: #8033

-- Converted from DG Script #8033: emerald_drake_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- 
-- Now for the cycle portion..
-- 
-- Does next mob in spawn cycle already exist?
if world.count_mobiles("8034") < 1 then
    -- Generate random room number to spawn drakes in.
    -- Thanks to the evil Pergus for inspiring me to be
    -- more evil.
    local rnd_range = random(1, 126)
    local rnd_room = rnd_range + 8049
    get_room(160, 95):at(function()
        self.room:spawn_mobile(80, 34)
    end)
    local rnd = random(1, 100)
    get_room(160, 95):at(function()
        local wug_drake = self.room:find_actor("wug")
        if wug_drake then
            wug_drake:teleport(get_room(80, rnd_room - 8000))
        end
    end)
    -- Sometimes creatures don't get teleported out of the loading
    -- room so we're gonna go back and purge it just incase.
    get_room(160, 95):at(function()
        self.room:purge()
    end)
    self.room:send(tostring(self.name) .. " cries out for help from his brother Wug!")
    self.room:send("From somewhere else in the farmlands comes another mighty roar!")
    self.room:spawn_object(80, 33)
end
-- 
-- 
-- 