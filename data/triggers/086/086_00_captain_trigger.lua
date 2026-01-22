-- Trigger: captain trigger
-- Zone: 86, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8600

-- Converted from DG Script #8600: captain trigger
-- Original: MOB trigger, flags: GREET, probability: 100%
if direction == "south" then
    self:say("Greetings, " .. tostring(actor.name) .. ".  Welcome to the Kingdom of the Meer Cats!")
    self:say("Are you a friend or a foe?")
elseif direction == "north" then
    self:say("Fare thee well, " .. tostring(actor.name) .. ".")
end