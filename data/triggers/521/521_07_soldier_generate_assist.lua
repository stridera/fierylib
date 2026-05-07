-- Trigger: Soldier_Generate_Assist
-- Zone: 521, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #52107
-- TODO: Original DG used `loaded`/`kids` counters that aren't preserved here.
-- Intent appears to be: cap total soldier spawns globally. Replaced ad-hoc
-- counter with world.count_mobiles to enforce a soft cap of 6 instances of
-- the assist soldier (mob 521,18). Verify cap matches design intent.

-- 6% chance to trigger
if not percent_chance(6) then
    return true
end
if world.count_mobiles(521, 18) < 6 then
    local rnd = room.actors[random(1, #room.actors)]
    self.room:send("The Platinum Knight lets out a horrid SCREAM!")
    wait(2)
    self:emote("starts to hum a strange mantra.")
    wait(2)
    self.room:send("A Bright flash of light fills the room and two soldiers crawl forth through it.")
    self.room:spawn_mobile(521, 18)
    self.room:spawn_mobile(521, 18)
    local soldier = self.room:find_actor("soldier")
    if soldier then
        local target = rnd.is_player and rnd or actor
        if target then
            soldier:command("hit " .. tostring(target.name))
        end
    end
end