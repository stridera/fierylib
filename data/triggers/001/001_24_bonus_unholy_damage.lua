-- Trigger: Bonus unholy damage
-- Zone: 1, ID: 24
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #124

-- Converted from DG Script #124: Bonus unholy damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- adds 5% alignment damage against neutral targets and 10% against good targets
-- 
if damage then
    if victim.alignment < 350 and victim.alignment > -350 then
        local bonus = damage / 20
    elseif victim.alignment > 350 then
        local bonus = damage / 10
    end
    if bonus then
        self.room:send("&9<blue>" .. tostring(self.shortdesc) .. " smites " .. tostring(victim.name) .. " with unholy might!</> (<yellow>" .. tostring(bonus) .. "</>)")
        local damage_dealt = victim:damage(bonus)  -- type: align
    end
end