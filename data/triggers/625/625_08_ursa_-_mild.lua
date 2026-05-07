-- Trigger: Ursa -> mild
-- Zone: 625, ID: 8
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62508

-- Converted from DG Script #62508: Ursa -> mild
-- Original: MOB trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
-- If Ursa is alone in his room, revert to the mild merchant form.
-- DG `%get.people[X]%` returned the headcount in room X. The
-- runtime exposes `room.actor_count` (every located actor —
-- mobs + players) so an idle merchant in a 1-actor room
-- (himself only) resumes normal posture.
if self.room.actor_count == 1 then
    self:emote("calms down, and reverts to his normal self.")
    self.room:spawn_mobile(625, 6)
    world.destroy(self)
end
