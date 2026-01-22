-- Trigger: infidel_allgreet1
-- Zone: 480, ID: 23
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48023

-- Converted from DG Script #48023: infidel_allgreet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment > -350 then
    self:say("So " .. tostring(actor.name) .. ", do you dare to challenge me?")
else
    self:say("So " .. tostring(actor.name) .. ", will you help me seek my revenge?")
end