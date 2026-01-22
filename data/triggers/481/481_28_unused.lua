-- Trigger: UNUSED
-- Zone: 481, ID: 28
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48128

-- Converted from DG Script #48128: UNUSED
-- Original: MOB trigger, flags: GREET, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:say("Leave now, before Vulcera makes you hers!")
self:command("scan")
self:say("Hurry!")