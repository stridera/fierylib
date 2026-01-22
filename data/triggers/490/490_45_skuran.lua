-- Trigger: skuran
-- Zone: 490, ID: 45
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #49045

-- Converted from DG Script #49045: skuran
-- Original: MOB trigger, flags: GREET, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
self:command("peer " .. tostring(actor.id))
if actor.id == -1 then
    self:say("I hope you are not here to cause any trouble, " .. tostring(actor.name) .. ".")
    actor.name:send("Skuran flexes a very large set of claws in your face.")
end