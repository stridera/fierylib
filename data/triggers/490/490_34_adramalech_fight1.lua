-- Trigger: adramalech_fight1
-- Zone: 490, ID: 34
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #49034

-- Converted from DG Script #49034: adramalech_fight1
-- Original: MOB trigger, flags: FIGHT, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("utters a short gutteral command.")
self.room:send("A small bird-like demon swoops in to " .. tostring(self.name) .. "'s aid!")
self.room:spawn_mobile(490, 41)