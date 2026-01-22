-- Trigger: Kaaz_semantic_fight1
-- Zone: 360, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #36001

-- Converted from DG Script #36001: Kaaz_semantic_fight1
-- Original: MOB trigger, flags: FIGHT, probability: 14%

-- 14% chance to trigger
if not percent_chance(14) then
    return true
end
self:say("You've got nothing for me!")
self:command("mosh " .. tostring(actor.name))