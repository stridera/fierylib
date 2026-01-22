-- Trigger: Master Shaman receive tear
-- Zone: 550, ID: 6
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55006

-- Converted from DG Script #55006: Master Shaman receive tear
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(1)
self:command("eye " .. tostring(actor.name))
self:destroy_item("golden")
self:say("This looks like one of the legendary keys!")
wait(2)
self:command("thank " .. tostring(actor.name))
wait(2)
self:say("Oh thank you!  Take this as a reward.")
self.room:spawn_object(550, 19)
self:command("give fang " .. tostring(actor.name))
self:command("drop fang")