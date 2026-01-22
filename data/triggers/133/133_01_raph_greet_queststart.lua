-- Trigger: raph_greet_queststart
-- Zone: 133, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #13301

-- Converted from DG Script #13301: raph_greet_queststart
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor:get_has_completed("raph_quest") then
    self:command("smile " .. tostring(actor.name))
    self:emote("tosses an empty canteen across the room.")
    self:say("Do you have anything for me, or have you already tried to help me once?")
    wait(2)
    self:say("If you have something for me, gimme.  If you have done this quest, go away.")
else
    self:say("I have been looking for something to eat in this world but to no avail, can you help me?")
    self:command("glare " .. tostring(actor.name))
    -- this is a quest for group heal for cleric classes, major globe for mages
    -- and either switch or picklock skill enhancements for other classes
end