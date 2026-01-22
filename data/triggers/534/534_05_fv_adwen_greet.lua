-- Trigger: fv_adwen_greet
-- Zone: 534, ID: 5
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #53405

-- Converted from DG Script #53405: fv_adwen_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
actor:send(tostring(self.name) .. " tells you, 'Hello Traveller, my name is Adwen.'")
self:command("curtsey " .. tostring(actor.name))