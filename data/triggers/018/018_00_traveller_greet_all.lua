-- Trigger: traveller_greet_all
-- Zone: 18, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #1800

-- Converted from DG Script #1800: traveller_greet_all
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if self.room == 1802 and actor.level < 100 then
    wait(1)
    actor:send("Thelmor hugs you warmly.")
    actor:send("Thelmor tells you, 'Thank you for freeing me.'")
    actor:send("Thelmor mutters something about Izaro.")
    wait(2)
    if world.count_mobiles("1808") == 0 then
        actor:send("Thelmor wails pitifully.")
        actor:send("Thelmor says, 'My revenge is fulfilled, and I am free!'")
        self:command("rem blade")
        self:command("drop blade")
        actor:send("Thelmor dissipates before your very eyes.")
        if actor.class == "Ranger" and actor.level > 80 then
            actor.name:start_quest("blur")
            actor:send("A voice from the forest whispers, 'You have done the forest a great service.")
            actor:send("</>Meet me at the nearby spring.'")
        end
        world.destroy(self.room:find_actor("self"))
        return _return_value
    else
        actor:send("Thelmor shouts, 'Izaro!  It is time to end this.'")
        wait(2)
        actor:send("Izaro streaks in from the forest.")
        wait(1)
        self.room:find_actor("fallen-nymph"):teleport(find_room_by_name("thelmor"))
        combat.engage(self, self.room:find_actor("fallen-nymph"))
    end
end