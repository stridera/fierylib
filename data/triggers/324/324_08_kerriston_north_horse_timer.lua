-- Trigger: Kerriston_north_horse_timer
-- Zone: 324, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #32408

-- Converted from DG Script #32408: Kerriston_north_horse_timer
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- This is the reception of the carrot
-- that kicks off the whole affair.
if actor.id == -1 then
    if object.id == 32421 then
        wait(1)
        actor:teleport(get_room(325, 97))
        self:teleport(get_room(325, 97))
        self:destroy_item("carrot")
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
        self.room:send("Are you slowing down?")
        wait(2)
        actor:teleport(get_room(324, 61))
        self:teleport(get_room(324, 61))
        wait(1)
        -- actor looks around
        self:command("pant")
        self.room:send("The trained <yellow>horse</> wiggles from underneath you.")
        wait(1)
        self.room:send("The trained <yellow>horse</> is summoned by his master.")  -- from MPROG
        self.room:send("The trained <yellow>horse</> disappears in a puff of smoke.")  -- from MPROG
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