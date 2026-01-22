-- Trigger: bite or wag animals
-- Zone: 31, ID: 15
-- Type: MOB, Flags: ACT
-- Status: CLEAN
--
-- Original DG Script: #3115

-- Converted from DG Script #3115: bite or wag animals
-- Original: MOB trigger, flags: ACT, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
if actor.cha > 65 then
    self:command("lick " .. tostring(actor))
    actor:heal(2)
else
    self:command("bite " .. tostring(actor))
    actor:heal(5)
end