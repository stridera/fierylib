-- Trigger: warrior_death_spawn_red
-- Zone: 410, ID: 4
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41004
-- On warrior's death, spawn the red queen (410:8) in room 410:15 if she
-- is not already loaded. Either way, broadcast the warrior's apology.

self.room:send(tostring(self.name) .. " shouts, 'I'm sorry, my Queen!'")
if world.count_mobiles(410, 8) < 1 then
    get_room(410, 15):at(function()
        self.room:spawn_mobile(410, 8)
    end)
end