-- Trigger: Infernal Blade bonus damage
-- Zone: 237, ID: 21
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #23721

-- Converted from DG Script #23721: Infernal Blade bonus damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- This trigger adds 10% damage as fire damage and 10% damage as unholy damage
-- 
if damage then
    local fire_dam = damage / 10
    local unholy_dam = damage / 10
    local bonus = fire_dam + unholy_dam
    self.room:send("<red>" .. tostring(self.shortdesc) .. " burns " .. tostring(victim.name) .. " with unholy fire!</> (<yellow>" .. tostring(bonus) .. "</>)")
    local damage_dealt = victim:damage(fire_dam)  -- type: fire
    local damage_dealt = victim:damage(unholy_dam)  -- type: align
end