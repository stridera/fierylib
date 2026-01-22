-- Trigger: dagger_lightning_bolt
-- Zone: 51, ID: 18
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #5118

-- Converted from DG Script #5118: dagger_lightning_bolt
-- Original: OBJECT trigger, flags: ATTACK, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
spells.cast(self, "lightning bolt", victim, self.level)