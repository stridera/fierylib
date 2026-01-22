-- Trigger: object casts hellbolt
-- Zone: 1, ID: 13
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #113

-- Converted from DG Script #113: object casts hellbolt
-- Original: OBJECT trigger, flags: ATTACK, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
spells.cast(self, "hell bolt", victim, self.level)