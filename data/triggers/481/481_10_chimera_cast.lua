-- Trigger: chimera_cast
-- Zone: 481, ID: 10
-- Type: MOB, Flags: GREET, FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48110

-- Converted from DG Script #48110: chimera_cast
-- Original: MOB trigger, flags: GREET, FIGHT, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
if actor.id == -1 then
    wait(2)
    self:emote("turns its dragon head to look at you.")
    spells.cast(self, "ray of enf", actor)
end