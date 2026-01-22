-- Trigger: efreeti_fight
-- Zone: 485, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48507

-- Converted from DG Script #48507: efreeti_fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local breathe_chance = random(1, 4)
if breathe_chance == 4 then
    wait(2)
    self:breath_attack("fire", nil)
end