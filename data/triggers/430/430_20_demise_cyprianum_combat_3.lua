-- Trigger: Demise_Cyprianum_Combat_3
-- Zone: 430, ID: 20
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #43020

-- Converted from DG Script #43020: Demise_Cyprianum_Combat_3
-- Original: MOB trigger, flags: FIGHT, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
self:emote("flairs a darker shade of red.")
self:say("You have no magic which can harm me!")
self:emote("ROARS!")