-- Trigger: weapon_cast_fireball
-- Zone: 1, ID: 26
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #126

-- Converted from DG Script #126: weapon_cast_fireball
-- Original: OBJECT trigger, flags: ATTACK, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
spells.cast(self, "fireball", victim, self.level)