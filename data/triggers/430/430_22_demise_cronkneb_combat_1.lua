-- Trigger: Demise_Cronkneb_Combat_1
-- Zone: 430, ID: 22
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #43022

-- Converted from DG Script #43022: Demise_Cronkneb_Combat_1
-- Original: MOB trigger, flags: FIGHT, probability: 8%

-- 8% chance to trigger
if not percent_chance(8) then
    return true
end
self:emote("hisses at you!")
self:say("My master will reward me for bringing him a fresh soul!")