-- Trigger: MOB_GREET_STEAL_40
-- Zone: 105, ID: 5
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #10505

-- Converted from DG Script #10505: MOB_GREET_STEAL_40
-- Original: MOB trigger, flags: GREET, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
self:command("steal coins " .. tostring(actor.name))