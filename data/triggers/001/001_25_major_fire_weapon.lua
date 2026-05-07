-- Trigger: Major fire weapon
-- Zone: 1, ID: 25
-- Type: OBJECT, Flags: ATTACK
-- Status: PARTIAL
--
-- Original DG Script: #125
--
-- TODO(parity): the "evade" branch (composition == air/bone/plant + miss)
-- recomputes a manual hit roll. The original DG used `%random.self.val2%` which
-- the converter mis-tokenised as `random.self.val2`; the intent was almost
-- certainly `random(1, self.val2) * self.val1` (val1=damdice, val2=damsize).
-- Encoded that interpretation here; verify against legacy lib output.
--
-- Adds 100% damage as fire on a normal hit, or rolls a fresh weapon hit when
-- the swing would otherwise miss against air/bone/plant compositions.
-- Converted from DG Script #125: Major fire weapon
-- Original: OBJECT trigger, flags: ATTACK, probability: 100%

if damage then
    local bonus = damage
    self.room:send("<red>" .. tostring(self.shortdesc) .. " burns " .. tostring(victim.name) .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
    victim:damage(bonus)  -- type: fire
else
    if victim.composition == "air" or victim.composition == "bone" or victim.composition == "plant" then
        local strmod = 0
        local s = actor.real_str
        if     s >= 61 and s < 63 then strmod = 1
        elseif s >= 64 and s < 66 then strmod = 2
        elseif s >= 67 and s < 69 then strmod = 3
        elseif s >= 70 and s < 72 then strmod = 4
        elseif s >= 73 and s < 75 then strmod = 5
        elseif s >= 76 and s < 78 then strmod = 6
        elseif s >= 79 and s < 81 then strmod = 7
        elseif s >= 82 and s < 84 then strmod = 8
        elseif s >= 85 and s < 87 then strmod = 9
        elseif s >= 88 and s < 90 then strmod = 10
        elseif s >= 91 and s < 93 then strmod = 11
        elseif s >= 94 and s < 96 then strmod = 12
        elseif s >= 97 and s < 99 then strmod = 13
        elseif s == 100             then strmod = 14
        end
        local bonus = strmod + actor.damroll + (random(1, self.val2) * self.val1) * 2
        if random(1, 20) == 20 then
            bonus = bonus * 2
        end
        self.room:send("<red>" .. tostring(self.shortdesc) .. " still burns " .. tostring(victim.name) .. "!</> (<yellow>" .. tostring(bonus) .. "</>)")
        victim:damage(bonus)  -- type: fire
    end
end