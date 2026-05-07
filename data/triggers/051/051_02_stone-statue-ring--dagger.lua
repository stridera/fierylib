-- Trigger: Stone-statue-ring--dagger
-- Zone: 51, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5102

-- Converted from DG Script #5102: Stone-statue-ring--dagger
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- When the player offers the stone-ring (51/2) to the statue, the statue
-- "comes to life", consumes the ring, and triggers room script 51/1 which
-- spawns the stone dagger. Any other object: refuse with flavor text.
--
-- TODO: object.id == 5102 is a legacy DG vnum check. The receive trigger
-- here is matched on object 51/2 (the stone ring), so this comparison
-- still selects the right object, but it should be rewritten using the
-- composite (zone_id, local_id) check once we're confident in the API.
if not actor.is_player then
    return true
end
if object.id == 5102 then
    wait(2)
    self.room:send("<b:blue>The eyes of the immense stone statue glow <b:red>red</> <b:blue>as a deafening hum shakes the cavern!</>")
    wait(2)
    self.room:send("<b:yellow>The statue comes to life!</>")
    wait(1)
    self.room:send("<blue>The statue makes your soul quake with a vicious</> <b:red>ROOOOOAAAAAARRRRRR!</>")
    self.room:send("You panic, but you can not escape!")
    wait(1)
    self.room:send("<b:cyan>The statue shouts 'I will free you my master!'</>")
    wait(4)
    self.room:send("<b:yellow>The statue starts casting a spell...</>")
    wait(3)
    self.room:send("<b:yellow>The statue's molecules loosen and eventually compress into a ball of light!</>")
    wait(4)
    self.room:send("<b:cyan>The ball disappears like</> <b:blue>lightning</> <b:cyan>with a loud crackle of energy!</>")
    wait(4)
    self.room:send("A small stone dagger falls from its place, a gift for freedom.")
    run_room_trigger(51, 1)
    world.destroy(self.room:find_actor("stone-ring"))
    world.destroy(self.room:find_actor("statue"))
    return false
end
self.room:send_except(actor, actor.name .. " offers " .. object.shortdesc .. " to " .. self.name .. ".")
self.room:send_except(actor, self.name .. " does not stir.")
actor:send("You offer up " .. object.shortdesc .. " to " .. self.name .. ", but there is no reaction.")
return true