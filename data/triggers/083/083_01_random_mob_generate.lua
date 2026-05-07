-- Trigger: Random_mob_generate
-- Zone: 83, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- 25% chance per fight tick: this mob roars for help, and a backup guard
-- (mob 83/0) is spawned into the same room to assist.
--
-- Original DG Script: #8301
if not percent_chance(25) then
    return true
end
self:command("roar")
wait(2)
self:emote("yells out for a guard to assist him.")
self.room:spawn_mobile(83, 0)