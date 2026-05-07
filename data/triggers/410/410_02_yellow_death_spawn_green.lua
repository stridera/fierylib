-- Trigger: yellow_death_spawn_green
-- Zone: 410, ID: 2
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #41002
-- On yellow queen's death, spawn the green queen (410:10) in room 410:30
-- if she is not already loaded. Either way, broadcast her dying threat.

self.room:send(tostring(self.name) .. " moans, 'My green sister will make you sorry!'")
if world.count_mobiles(410, 10) < 1 then
    get_room(410, 30):at(function()
        self.room:spawn_mobile(410, 10)
    end)
end