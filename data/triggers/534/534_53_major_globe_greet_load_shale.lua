-- Trigger: major_globe_greet_load_shale
-- Zone: 534, ID: 53
-- Type: MOB, Flags: GLOBAL, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #53453

-- Converted from DG Script #53453: major_globe_greet_load_shale
-- Original: MOB trigger, flags: GLOBAL, GREET_ALL, probability: 100%
if actor:get_quest_stage("major_globe_spell") == 2 then
    self:destroy_item("majorglobe-shale")
    self.room:spawn_object(534, 51)
    wait(2)
    if world.count_mobiles("48125") and (self.room == 48112) then
        self.room:send("The savage children laugh and play, tossing a rock between themselves.")
        wait(1)
        self.room:send("One child, larger than the rest, suddenly grabs the rock out of the air.")
        self.room:send("She smiles wickedly and prances away from the group.")
        self:command("hold shale")
        wait(3)
        self.room:send("The other savage children sniffle and start playing another game.")
    else
        self.room:send("The lone savage child looks around herself and sighs.")
        self:command("hold shale")
        wait(3)
        self.room:send("The savage child plays with a rock in her hands.")
    end
end