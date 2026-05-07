-- Trigger: Obz Kwan Yin Release
-- Zone: 0, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #15
-- Releasing Kwan Yin: receive the correct key, hand over two pearls,
-- and have the mob purge itself out of its cage.

if object.zone_id == 580 and object.local_id == 200 then
    self:emote("stares at the key in astonishment.")
    self:say("You.. you're releasing me?")
    self:command("remove pearl")
    self:command("remove pearl")
    self:say("Take these as tokens of my appreciation, kind one.")
    self:command("give pearl " .. tostring(actor.name))
    self:command("give pearl " .. tostring(actor.name))
    self:emote("turns and flies out of the cage, in the blink of an eye, and is gone.")
    world.destroy(object)
    self.room:purge()
end
