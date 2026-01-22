-- Trigger: kingpriest_allgreet1
-- Zone: 480, ID: 8
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48008

-- Converted from DG Script #48008: kingpriest_allgreet1
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor.alignment > 350 then
    self:say("I think my god must have thought I had forgotten him.")
    self:command("grin " .. tostring(actor.name))
    self:say("If you can be my message.")
end