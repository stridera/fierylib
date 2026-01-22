-- Trigger: dargentan-battle
-- Zone: 238, ID: 5
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #23805

-- Converted from DG Script #23805: dargentan-battle
-- Original: MOB trigger, flags: FIGHT, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
local val = random(1, 10)
-- switch on val
if val == 1 then
    self:breath_attack("frost", nil)
elseif val == 2 or val == 3 then
    self:command("sweep")
elseif val == 4 or val == 5 then
    self:command("roar")
else
    self:command("growl")
end