-- Trigger: fv_guard_greet
-- Zone: 534, ID: 12
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53412

-- Converted from DG Script #53412: fv_guard_greet
-- Original: MOB trigger, flags: GREET, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
if actor.id == -1 then
    self:command("consider " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Ok " .. tostring(actor.name) .. ", we don't want any trouble here.'")
else
    self:command("bow")
end