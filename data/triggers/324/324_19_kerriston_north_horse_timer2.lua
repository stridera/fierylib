-- Trigger: Kerriston_north_horse_timer2
-- Zone: 324, ID: 19
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #32419

-- Converted from DG Script #32419: Kerriston_north_horse_timer2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- This is the reception of the strawberry
-- that kicks off the whole affair to Mugnork
if actor.id == -1 then
    if object.id == 32425 then
        wait(1)
        actor:teleport(get_room(325, 97))
        self:teleport(get_room(325, 97))
        self:destroy_item("strawberry")
        -- Label reference: do_it_to_it
        wait(5)
        self.room:send("The world spins by you as you struggle to hang on!")
        wait(5)
        self.room:send("The sound of thundering hooves is almost deafening!")
        wait(5)
        self.room:send("You slip and nearly fall off!")
        wait(5)
        self.room:send("The horse bucks wildly almost throwing you!")
        wait(5)
        self.room:send("The tall grass whips by your feet so quickly it stings!")
        wait(5)
        actor:teleport(get_room(325, 98))
        self:teleport(get_room(325, 98))
        wait(1)
        -- Label reference: do_it_to_it2
        self.room:send("Are you slowing down?")
        wait(5)
        self.room:send("A small speckled rabbit runs between the horses legs! SPLAT")
        wait(5)
        self.room:send("The world spins by you as you struggle to hang on!")
        wait(5)
        self.room:send("You slip and nearly fall off!")
        wait(5)
        self.room:send("A Northern Deer darts across the trail infront of you!")
        wait(5)
        self.room:send("PHEW Nearly teeth, hair, and eyeballs everywhere!")
        wait(3)
        actor:teleport(get_room(325, 65))
        self:teleport(get_room(325, 65))
        wait(1)
        -- actor looks around
        self:command("pant")
        self.room:send(tostring(self.name) .. " wiggles from underneath you.")
        wait(1)
        self.room:send(tostring(self.name) .. " is summoned by his master.")  -- from MPROG
        self.room:send(tostring(self.name) .. " disappears in a puff of smoke.")  -- from MPROG
    else
        wait(1)
        self:command("eye " .. tostring(actor.name))
        wait(3)
        self:command("bite " .. tostring(actor.name))
        self:command("smile me")
    end
else
end
-- Label reference: purge_me