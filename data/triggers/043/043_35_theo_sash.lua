-- Trigger: theo_sash
-- Zone: 43, ID: 35
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #4335

-- Converted from DG Script #4335: theo_sash
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
self:set_flag("sentinel", true)
if object.id == 4311 then
    wait(2)
    self.room:send("Theo's face lights up with childish joy.")
    wait(3)
    self:command("cheer")
    self:command("hug " .. tostring(actor.name))
    wait(4)
    self:say("Thank you!!")
    wait(4)
    self:command("hold duck")
    wait(3)
    self:emote("pets a stuffed duck lovingly.")
    wait(3)
    self:command("pur")
    wait(4)
    self:say("You can have this for being nice to me.")
    self.room:spawn_object(43, 20)
    wait(3)
    self:command("give sash " .. tostring(actor.name))
else
    wait(2)
    self:say("That's not a duck, dummy!")
    self:command("pout")
end
self:set_flag("sentinel", false)