-- Trigger: dargentan-battle
-- Zone: 238, ID: 5
-- Type: MOB, Flags: FIGHT
--
-- Random combat behavior for Dargentan (25% chance per round).
-- Roll 1-10: 1 = frost breath, 2-3 = sweep, 4-5 = roar, otherwise growl.

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
local val = random(1, 10)
if val == 1 then
    self:breath_attack("frost", nil)
elseif val == 2 or val == 3 then
    self:command("sweep")
elseif val == 4 or val == 5 then
    self:command("roar")
else
    self:command("growl")
end
