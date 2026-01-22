-- Trigger: Demise_Cronkneb_Combat_2
-- Zone: 430, ID: 23
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #43023

-- Converted from DG Script #43023: Demise_Cronkneb_Combat_2
-- Original: MOB trigger, flags: ENTRY, probability: 9%

-- 9% chance to trigger
if not percent_chance(9) then
    return true
end
self:command("cackle")
self:emote("mumbles something under its breath.")