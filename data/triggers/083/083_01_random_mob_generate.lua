-- Trigger: Random_mob_generate
-- Zone: 83, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #8301

-- Converted from DG Script #8301: Random_mob_generate
-- Original: MOB trigger, flags: FIGHT, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self:command("roar")
wait(2)
self:emote("yells out for a guard to assist him.")
self.room:spawn_mobile(83, 0)