-- Trigger: fv_ysgarran_greet1
-- Zone: 534, ID: 3
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53403

-- Converted from DG Script #53403: fv_ysgarran_greet1
-- Original: MOB trigger, flags: GREET, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:say("Please enjoy the hospitality of our keep.")
self:command("smile " .. tostring(actor.name))