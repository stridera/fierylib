-- Trigger: Demise_Cyprianum_Combat_2
-- Zone: 430, ID: 19
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #43019

-- Converted from DG Script #43019: Demise_Cyprianum_Combat_2
-- Original: MOB trigger, flags: FIGHT, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end
self:emote("ROARS!")
self:emote("crushes the marble just inches from your feet!")
self:say("Soon you too will be among my slaves!")