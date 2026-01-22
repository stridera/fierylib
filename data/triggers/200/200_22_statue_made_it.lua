-- Trigger: statue_made_it
-- Zone: 200, ID: 22
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #20022

-- Converted from DG Script #20022: statue_made_it
-- Original: MOB trigger, flags: GREET, probability: 100%
self:command("grin " .. tostring(actor.name))
self:say("So you have made it.")
wait(1)
self:say("You have proved yourself so now you will see the leader.")
self:say("When you are ready say the name of our great leader and you will go to him.")