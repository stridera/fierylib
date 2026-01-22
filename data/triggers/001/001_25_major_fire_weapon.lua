-- Trigger: Major fire weapon
-- Zone: 1, ID: 25
-- Type: OBJECT, Flags: ATTACK
-- Status: CLEAN
--
-- Original DG Script: #125

-- Converted from DG Script #125: Major fire weapon
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%
-- 
-- This trigger adds 100% damage as fire damage or 200% fire damage against air, plant, or bone that evade
-- 
if damage then
    local bonus = damage
    self.room:send("<red>" .. self.shortdesc .. " burns " .. victim.name .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
    victim:damage(bonus)  -- type: fire
else
    if victim.composition == "air" or victim.composition == "bone" or victim.composition == "plant" then
        local strmod = 0
        if actor.real_str >= 61 and actor.real_str < 63 then
            strmod = 1
        elseif actor.real_str >= 64 and actor.real_str < 66 then
            strmod = 2
        elseif actor.real_str >= 67 and actor.real_str < 69 then
            strmod = 3
        elseif actor.real_str >= 70 and actor.real_str < 72 then
            strmod = 4
        elseif actor.real_str >= 73 and actor.real_str < 75 then
            strmod = 5
        elseif actor.real_str >= 76 and actor.real_str < 78 then
            strmod = 6
        elseif actor.real_str >= 79 and actor.real_str < 81 then
            strmod = 7
        elseif actor.real_str >= 82 and actor.real_str < 84 then
            strmod = 8
        elseif actor.real_str >= 85 and actor.real_str < 87 then
            strmod = 9
        elseif actor.real_str >= 88 and actor.real_str < 90 then
            strmod = 10
        elseif actor.real_str >= 91 and actor.real_str < 93 then
            strmod = 11
        elseif actor.real_str >= 94 and actor.real_str < 96 then
            strmod = 12
        elseif actor.real_str >= 97 and actor.real_str < 99 then
            strmod = 13
        elseif actor.real_str == 100 then
            strmod = 14
        end
        local bonus = strmod + actor.damroll + (random(1, self.val2) * self.val1) * 2
        if random(1, 20) == 20 then
            bonus = bonus * 2
        end
        self.room:send("<red>" .. self.shortdesc .. " still burns " .. victim.name .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
        victim:damage(bonus)  -- type: fire
    end
end