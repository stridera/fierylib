-- Trigger: Kaaz_semantic_fight2
-- Zone: 360, ID: 2
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #36002

-- Converted from DG Script #36002: Kaaz_semantic_fight2
-- Original: MOB trigger, flags: FIGHT, probability: 16%

-- 16% chance to trigger
if not percent_chance(16) then
    return true
end
self:say("So you think you are mighty enough to take me?!")
self:command("laugh " .. tostring(actor.name))