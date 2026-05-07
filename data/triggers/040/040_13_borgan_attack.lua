-- Trigger: Borgan_Attack
-- Zone: 40, ID: 13
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #4013
-- Per combat round, 20% chance Borgan picks a special attack:
--   1/10  fire breath (AOE)
--   2/10  sweep
--   2/10  roar
--   5/10  growl

if not percent_chance(20) then
    return true
end

local val = random(1, 10)
if val == 1 then
    self:breath_attack("fire", nil)
elseif val == 2 or val == 3 then
    self:command("sweep")
elseif val == 4 or val == 5 then
    self:command("roar")
else
    self:command("growl")
end