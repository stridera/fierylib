-- Trigger: abbot_talk
-- Zone: 200, ID: 21
-- Type: MOB, Flags: GREET, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #20021

-- Converted from DG Script #20021: abbot_talk
-- Original: MOB trigger, flags: GREET, GREET_ALL, probability: 100%
self:command("bow")
wait(1)
self:say("So you have come too see our great leader.")
self:command("ponder")
wait(1)
self:say("His quarters are in the next room but we have moved him to safer quarters.")
wait(1)
self:say("To see him you must prove yourself worthy by finding is quarters.")
self:say("I shall give you a small hint.")
self:whisper(actor.name, "He is located somewhere in the library.")
self.room:spawn_object(200, 43)
self:command("give key " .. tostring(actor.name))
self:say("Now on you go!")
actor.name:teleport(get_room(200, 5))