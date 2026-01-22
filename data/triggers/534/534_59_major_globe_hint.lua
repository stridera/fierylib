-- Trigger: major_globe_hint
-- Zone: 534, ID: 59
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53459

-- Converted from DG Script #53459: major_globe_hint
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:command("scratch")
self:say("Lirne has been gone for quite a while now...")
wait(2)
self:say("I wonder where that rascal has gotten to.")
self:command("ponder")