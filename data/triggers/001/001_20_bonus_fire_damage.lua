-- Trigger: Bonus fire damage
-- Zone: 1, ID: 20
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #120

-- Converted from DG Script #120: Bonus fire damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- This trigger adds 10% damage as fire damage
-- 
if damage then
    local bonus = damage / 10
    self.room:send("<red>" .. tostring(self.shortdesc) .. " burns " .. tostring(victim.name) .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
    local damage_dealt = victim:damage(bonus)  -- type: fire
end