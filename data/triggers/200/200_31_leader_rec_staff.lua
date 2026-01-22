-- Trigger: leader_rec staff
-- Zone: 200, ID: 31
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #20031

-- Converted from DG Script #20031: leader_rec staff
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 3217 then
    wait(1)
    self:say("Very Good!")
    wait(1)
    self:say("Here is your extra prize for working so hard.")
    self:emote("pulls something out from under the bed.")
    self.room:spawn_object(200, 54)
    wait(1)
    self:say("These will help you in fights against your enemy's.")
    wait(1)
    self:command("give bronze " .. tostring(actor.name))
    wait(1)
    self:command("grin")
    world.destroy(self.room:find_actor("staff"))
end  -- auto-close block