-- Trigger: Nukreth Spire start path1 human
-- Zone: 462, ID: 0
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #46200

-- Converted from DG Script #46200: Nukreth Spire start path1 human
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if world.count_mobiles("46220") < 1 and world.count_mobiles("46221") < 1 and world.count_mobiles("46222") < 1 and world.count_mobiles("46223") < 1 then
    wait(2)
    zone.echo(462, "With the chieftain's death the slaves begin to rise up!")
    zone.echo(462, "Mad cackling tears through the caverns followed by shouts and cries.")
    wait(1)
    get_room(462, 78):at(function()
        self.room:spawn_mobile(462, 20)
    end)
    get_room(462, 78):at(function()
        self.room:send("A woman rises up in defiance!")
    end)
    get_room(462, 78):at(function()
        self.room:find_actor("captive"):shout("Help me!!  Where is my husband?!")
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
        self.room:find_actor("captive"):shout("You'll never take me alive!")
    end)
    get_room(462, 78):at(function()
        self.room:find_actor("spiritbreaker"):command("kill captive")
    end)
end