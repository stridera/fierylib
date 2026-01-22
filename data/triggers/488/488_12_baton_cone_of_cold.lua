-- Trigger: baton_cone_of_cold
-- Zone: 488, ID: 12
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #48812

-- Converted from DG Script #48812: baton_cone_of_cold
-- Original: OBJECT trigger, flags: ATTACK, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
spells.cast(self, "cone of cold", victim, self.level)