-- Trigger: Demise_Cronkneb_Combat_3
-- Zone: 430, ID: 24
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #43024

-- Converted from DG Script #43024: Demise_Cronkneb_Combat_3
-- Original: MOB trigger, flags: FIGHT, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end
self:emote("throws back its head and howls!")
self:emote("bares its fangs at you!")