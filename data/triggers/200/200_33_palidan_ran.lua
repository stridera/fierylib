-- Trigger: palidan_ran
-- Zone: 200, ID: 33
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #20033

-- Converted from DG Script #20033: palidan_ran
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:command("bleed")
wait(3)
self:say("why did i agree to fight against the dark monks, I knew they where to strong.")
self:command("shake")
wait(4)
self:command("choke")
wait(2)
self:say("now i must face my foolish mistakes.")