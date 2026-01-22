-- Trigger: pirate_captain_greet
-- Zone: 521, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #52102

-- Converted from DG Script #52102: pirate_captain_greet
-- Original: MOB trigger, flags: GREET, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
wait(1)
self:shout("Leave here, or you shall die!")
self:say("She will kill you!")