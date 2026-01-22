-- Trigger: Jerajai_Attack
-- Zone: 480, ID: 25
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48025

-- Converted from DG Script #48025: Jerajai_Attack
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
local val = random(1, 10)
-- switch on val
if val == 1 then
    self:breath_attack("acid", nil)
elseif val == 2 or val == 3 then
    self:command("sweep")
elseif val == 4 or val == 5 then
    self:command("roar")
else
    self:command("growl")
end