-- Trigger: bloodline
-- Zone: 133, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #13300

-- Converted from DG Script #13300: bloodline
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    self:say("Hello " .. tostring(actor.name))
    self:say("How are you today?")
    wait(2)
    self:say("Good weather yes?")
    self:say("You know a Bum named doal i hear their is a price on his head")
    self.room:spawn_object(133, 1)
    self:command("give pick " .. tostring(actor.name))
    actor.name:command("wield pick")
end