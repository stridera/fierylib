-- Trigger: treant receive
-- Zone: 625, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62516

-- Converted from DG Script #62516: treant receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (62504): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 625 and object.id == 4)
) then
    return true
end

if world.count_mobiles(625, 0) > 0 then
    wait(0.2)
    world.destroy(object)
    wait(0.8)
    self:say("You've done pretty well clearing out those pests for me.  The trees thank you, and so do I.")
    self:emote("grabs his shoulder and peels some bark off.")
    wait(1)
    self:say("Accept this token of gratitude on behalf of the forest.")
    self.room:spawn_object(625, 6)
    self:command("give badge " .. tostring(actor))
elseif world.count_mobiles(625, 0) == 0 then
    wait(0.2)
    world.destroy(object)
    wait(0.8)
    self:say("You've done exceptionally well clearing out those pests for me.  The trees thank you, and so do I.")
    self:emote("grabs a branch growing off his back and breaks it off!")
    wait(1)
    self:say("Accept this token of gratitude on behalf of the forest.")
    self.room:spawn_object(625, 3)
    self:command("give limb " .. tostring(actor))
end