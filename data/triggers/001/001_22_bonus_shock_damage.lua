-- Trigger: Bonus shock damage
-- Zone: 1, ID: 22
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #122

-- Converted from DG Script #122: Bonus shock damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- This trigger adds 10% damage as shock damage
-- 
if damage then
    local bonus = damage / 10
    self.room:send_except(victim, "<yellow>" .. tostring(self.shortdesc) .. " shocks " .. tostring(victim.name) .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
    victim:send("<yellow>" .. tostring(self.shortdesc) .. " shocks you!</> (<yellow>" .. tostring(bonus) .. "</>)")
    local damage_dealt = victim:damage(bonus)  -- type: shock
end