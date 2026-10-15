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
-- Legacy mteleport to a room that is not there is a no-op, and zone 324 has no rooms at 324:97,
-- 324:98 or 324:65 (legacy 32597, 32598, 32565 are not in 324.wld either), so the hops through
-- them are skipped instead of raising an error halfway through the ride.
local function ride_to(zone, id)
    local room = get_room(zone, id)
    if room then
        actor:teleport(room)
        self:teleport(room)
    end
    return room
end
if actor.is_player then
    if object.zone_id == 324 and object.local_id == 25 then
        wait(0.1)
        ride_to(324, 197)
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
        ride_to(324, 198)
        wait(0.1)
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
        wait(0.5)
        self.room:send("PHEW Nearly teeth, hair, and eyeballs everywhere!")
        wait(0.3)
        ride_to(324, 165)
        wait(0.1)
        actor:command("look")
        self:command("pant")
        self.room:send(tostring(self.name) .. " wiggles from underneath you.")
        wait(0.1)
        self.room:send(tostring(self.name) .. " is summoned by his master.")  -- from MPROG
        self.room:send(tostring(self.name) .. " disappears in a puff of smoke.")  -- from MPROG
    else
        wait(0.1)
        self:command("eye " .. tostring(actor.name))
        wait(0.3)
        self:command("bite " .. tostring(actor.name))
        self:command("smile me")
    end
end
-- Legacy `purge_me`: the horse is gone once the ride (or the refusal) is over.
world.destroy(self)
