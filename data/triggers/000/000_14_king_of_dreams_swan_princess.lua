-- Trigger: King of dreams (Swan Princess)
-- Zone: 0, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #14

-- Converted from DG Script #14: King of dreams (Swan Princess)
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 58417 then
    self:emote("sighs in great relief.")
    self:say("Thank you from the bottom of my heart, kind adventurer.")
    self:say("Your deeds shall not go unrewarded.")
    self.room:spawn_object(584, 1)
    self:command("give feather " .. actor.name)
else
    self:say("No, I thank you but this will not do.")
    self:say("Not do at all.")
    world.destroy(object)
end