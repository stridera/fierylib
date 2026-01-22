-- Trigger: Demise_Cyprianum_Combat_1
-- Zone: 430, ID: 18
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #43018

-- Converted from DG Script #43018: Demise_Cyprianum_Combat_1
-- Original: MOB trigger, flags: FIGHT, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end
self:emote("nearly flails you with a whiplike tentacle of energy!")
self:say("Your mortality binds you to slower flesh!")
self:command("cackle")