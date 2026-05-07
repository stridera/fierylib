-- Trigger: King of dreams (Swan Princess)
-- Zone: 0, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #14
-- Quest hand-in: receiving the right item rewards the player with a feather;
-- otherwise the gift is destroyed and the giver is rebuffed.

if object.zone_id == 584 and object.local_id == 17 then
    self:emote("sighs in great relief.")
    self:say("Thank you from the bottom of my heart, kind adventurer.")
    self:say("Your deeds shall not go unrewarded.")
    self.room:spawn_object(584, 1)
    self:command("give feather " .. tostring(actor.name))
else
    self:say("No, I thank you but this will not do.")
    self:say("Not do at all.")
    world.destroy(object)
end
