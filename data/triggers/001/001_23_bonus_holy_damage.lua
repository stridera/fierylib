-- Trigger: Bonus holy damage
-- Zone: 1, ID: 23
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #123

-- Converted from DG Script #123: Bonus holy damage
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- adds 5% alignment damage against neutral targets and 10% against evil targets
-- 
if damage then
    local bonus = nil
    if victim.alignment < 350 and victim.alignment > -350 then
        bonus = damage / 20
    elseif victim.alignment < -350 then
        bonus = damage / 10
    end
    if bonus and victim.hit >= -10 then
        self.room:send_except(victim, "<b:white>" .. self.shortdesc .. " smites " .. victim.name .. " with radiant light!</> (<yellow>" .. tostring(bonus) .. "</>)")
        victim:send("<b:white>" .. self.shortdesc .. " smites you with radiant light!</> (<yellow>" .. tostring(bonus) .. "</>)")
        victim:damage(bonus)  -- type: align
    end
end