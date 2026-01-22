-- Trigger: Stone-statue-ring--dagger
-- Zone: 51, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5102

-- Converted from DG Script #5102: Stone-statue-ring--dagger
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if object.id == 5102 then
        _return_value = true
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
        run_room_trigger(5101)
        world.destroy(self.room:find_actor("stone-ring"))
        world.destroy(self.room:find_actor("statue"))
    else
        _return_value = false
        self.room:send_except(actor, tostring(actor.name) .. " offers " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        self.room:send_except(actor, tostring(self.name) .. " does not stir.")
        actor:send("You offer up " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but there is no reaction.")
    end
end
return _return_value