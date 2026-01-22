-- Trigger: bronze_guard_greet1
-- Zone: 520, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #52010

-- Converted from DG Script #52010: bronze_guard_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if actor.level > 100 then
        self:command("glare " .. tostring(actor.name))
        self:say("I was supposed to get PAID for this gig.")
        self:command("poke " .. tostring(actor.name))
    else
        self.room:send_except(actor.name, "The statue's eyes seem to follow " .. tostring(actor.name) .. " around for a moment, they look a bit uncomfortable.")
        actor.name:send("The statue's eyes seem to stare directly at you for a moment, how disturbing.")
    end
end