-- Trigger: Obz Kwan Yin Release
-- Zone: 0, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #15

-- Converted from DG Script #15: Obz Kwan Yin Release
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 58200 then
    self:emote("stares at the key in astonishment.")
    self:say("You.. you're releasing me?")
    self:command("remove pearl")
    self:command("remove pearl")
    self:say("Take these as tokens of my appreciation, kind one.")
    self:command("give pearl $n")
    self:command("give pearl $n")
    self:emote("turns and flies out of the cage, in the blink of an eye, and is gone.")
    world.destroy(object)  -- from MPROG
    self.room:purge()
end  -- auto-close block