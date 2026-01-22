-- Trigger: object casts stygian eruption
-- Zone: 1, ID: 14
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #114

-- Converted from DG Script #114: object casts stygian eruption
-- Original: OBJECT trigger, flags: ATTACK, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
spells.cast(self, "stygian eruption", victim, self.level)