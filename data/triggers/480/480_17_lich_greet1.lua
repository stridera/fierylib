-- Trigger: lich_greet1
-- Zone: 480, ID: 17
-- Type: MOB, Flags: GREET, HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #48017

-- Converted from DG Script #48017: lich_greet1
-- Original: MOB trigger, flags: GREET, HIT_PERCENT, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
self:command("cackle")
self:say("So, " .. tostring(actor.name) .. " do you know who you face?")