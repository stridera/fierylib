-- Trigger: fetch_is_dead
-- Zone: 178, ID: 0
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #17800

-- Converted from DG Script #17800: fetch_is_dead
-- Original: MOB trigger, flags: DEATH, probability: 100%
actor:teleport(get_room(178, 68))
actor:send("Your vision suddenly blurs, and you find yourself back at the shaman.")
-- actor looks around
if world.count_mobiles("17806") == 0 then
    get_room(178, 68):at(function()
        self.room:spawn_mobile(178, 6)
    end)
end
get_room(178, 68):at(function()
    self.room:find_actor("shaman"):say("Well done, " .. tostring(actor.name) .. "!")
end)
get_room(178, 68):at(function()
    self.room:find_actor("shaman"):spawn_object(178, 9)
end)
get_room(178, 68):at(function()
    self.room:find_actor("shaman"):say("You have passed the test and earned this.")
end)
get_room(178, 68):at(function()
    self.room:find_actor("shaman"):command("give mask-self-knowledge " .. tostring(actor.name))
end)