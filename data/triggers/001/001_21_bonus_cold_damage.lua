-- Trigger: Bonus cold damage
-- Zone: 1, ID: 21
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #121

-- Converted from DG Script #121: Bonus cold damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- This trigger adds 10% damage as cold damage
-- 
if damage then
    local bonus = damage / 10
    self.room:send("<b:cyan>" .. tostring(self.shortdesc) .. " freezes " .. tostring(victim.name) .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
    local damage_dealt = victim:damage(bonus)  -- type: cold
end