-- Trigger: crazed_survivor_greet1
-- Zone: 510, ID: 23
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #51023
-- On greet, the survivor panics that newcomers want to take his
-- protective magic.
self:command("panic")
self:say("You have come for my magic haven't you?")
self:say("Well you can't have it, you can't!  I need it!")