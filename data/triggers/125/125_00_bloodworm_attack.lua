-- Trigger: Bloodworm_attack
-- Zone: 125, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #12500

-- Converted from DG Script #12500: Bloodworm_attack
-- Original: MOB trigger, flags: GREET, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
-- Basically, let them stew in the pit for a little bit before they get whacked.
if actor.level < 100 then
    wait(14)
    combat.engage(self, actor.name)
end