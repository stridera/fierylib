-- Trigger: treant receive
-- Zone: 625, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62516

-- Converted from DG Script #62516: treant receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if world.count_mobiles("62500") > 0 then
    wait(2)
    world.destroy(object)
    wait(8)
    self:say("You've done pretty well clearing out those pests for me.  The trees thank you, and so do I.")
    self:emote("grabs his shoulder and peels some bark off.")
    wait(1)
    self:say("Accept this token of gratitude on behalf of the forest.")
    self.room:spawn_object(625, 6)
    self:command("give badge " .. tostring(actor))
elseif world.count_mobiles("62500") == 0 then
    wait(2)
    world.destroy(object)
    wait(8)
    self:say("You've done exceptionally well clearing out those pests for me.  The trees thank you, and so do I.")
    self:emote("grabs a branch growing off his back and breaks it off!")
    wait(1)
    self:say("Accept this token of gratitude on behalf of the forest.")
    self.room:spawn_object(625, 3)
    self:command("give limb " .. tostring(actor))
end