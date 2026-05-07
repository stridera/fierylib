-- Trigger: reload_helpers
-- Zone: 533, ID: 3
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #53303
--
-- 50% per-tick chance while taking damage to summon a baby dragon helper
-- (capped at 6 baby dragons in the world) which attacks the current
-- attacker.

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
wait(1)
if random(1, 10) < 2 then
    self:emote("roars in pain and tries to locate more children.")
    wait(1)
    if world.count_mobiles(533, 1) < 6 then
        self.room:spawn_mobile(533, 1)
        local baby = self.room:find_actor("baby-dragon")
        if baby then
            baby:emote("scampers in and attacks!")
            baby:command("kill " .. tostring(actor.name))
        end
    end
end