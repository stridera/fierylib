-- Trigger: Nukreth Spire start path2 kobold
-- Zone: 462, ID: 1
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #46201

-- Converted from DG Script #46201: Nukreth Spire start path2 kobold
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if world.count_mobiles("46220")get.mob_count[46221] < 1 and world.count_mobiles("46222")get.mob_count[46223] < 1 then
    wait(2)
    zone.echo(462, "With the chieftain's death the slaves begin to rise up!")
    zone.echo(462, "Mad cackling tears through the caverns followed by shouts and cries.")
    wait(1)
    get_room(462, 78):at(function()
        self.room:spawn_mobile(462, 21)
    end)
    get_room(462, 78):at(function()
        self.room:send("A kobold rises up in defiance!")
    end)
    get_room(462, 78):at(function()
        self.room:find_actor("captive"):shout("Help meeeeee!!")
    end)
    wait(4)
    get_room(462, 78):at(function()
        self.room:spawn_mobile(462, 24)
    end)
    get_room(462, 78):at(function()
        self.room:send("A gnoll spiritbreaker appears to stop her!")
    end)
    get_room(462, 78):at(function()
        self.room:find_actor("spiritbreaker"):shout("Kill the slave!")
    end)
    wait(4)
    get_room(462, 78):at(function()
        self.room:find_actor("captive"):shout("Nooo!  Save meee!!")
    end)
    get_room(462, 78):at(function()
        self.room:find_actor("spiritbreaker"):command("kill captive")
    end)
end