-- Trigger: pirate_feyd_rand
-- Zone: 521, ID: 6
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #52106

-- Converted from DG Script #52106: pirate_feyd_rand
-- Original: MOB trigger, flags: RANDOM, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
self:emote("chants, 'Farvium, freedium, requriet.'")
self:emote("chants, 'Tulosta, dyriist, omniscientia, Feyd.'")