-- Trigger: doren greet
-- Zone: 87, ID: 3
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8703

-- Converted from DG Script #8703: doren greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    wait(1)
    self:shout("Help!  Help!")
    self.room:find_actor("bandit"):command("kill %actor%")
    wait(1)
    self.room:send("<green>A bandit flees from " .. tostring(actor.name) .. " into the undergrowth.</>")
    world.destroy(self.room:find_actor("2.bandit"))
    wait(10)
    self:emote("limps away from the bandit, blood running down his leg.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Thank you for saving me.  I can make it home but I must go now.")
    actor:send("</>Please take the handcart to my uncle in the logging camp to the east.  He is")
    actor:send("</>the blacksmith there.  He will reward you for saving me and getting the")
    actor:send("</>handcart safely to him.'")
    wait(2)
    self.room:send("<green>Doren limps though the grass heading for home.")
    world.destroy(self)
end