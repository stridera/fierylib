-- Trigger: guard_assist_leader
-- Zone: 200, ID: 25
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #20025

-- Converted from DG Script #20025: guard_assist_leader
-- Original: MOB trigger, flags: FIGHT, probability: 28%

-- 28% chance to trigger
if not percent_chance(28) then
    return true
end
self:command("panic")
self:emote("screams for his guardians to come to his aid.")
wait(2)
self.room:spawn_mobile(200, 34)